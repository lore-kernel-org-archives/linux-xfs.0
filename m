Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E31BA7F54
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 17:13:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67520AC003
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 15:13:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id w2609HtfsoldjsOx for
	<xfs@oss.sgi.com>; Wed, 05 Feb 2014 15:13:49 -0800 (PST)
Message-ID: <52F2C5A9.7060803@redhat.com>
Date: Wed, 05 Feb 2014 18:13:45 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] restore: don't trash file capabilities
References: <1391564918-25524-1-git-send-email-david@fromorbit.com>
	<52F246BF.60302@redhat.com> <20140205215436.GF13997@dastard>
In-Reply-To: <20140205215436.GF13997@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/05/2014 04:54 PM, Dave Chinner wrote:
> On Wed, Feb 05, 2014 at 09:12:15AM -0500, Brian Foster wrote:
>> On 02/04/2014 08:48 PM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> xfsrestore fails to restore file capabilities correctly because it
>>> sets the owner on the file after it has restored the capability
>>> attributes. This results in the kernel stripping the capabilities
>>> when changing the owner of the file and hence the restored file is
>>> not complete.
>>>
>>> Fix this by changing the owner of the file when it is created rather
>>> than after it has been fully restored. This ensures we don't kill
>>> the caps as they are restored after the owner it appropriately set.
>>> This fixes the xfs/296 failure.
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>> ---
>>>  restore/content.c | 116 ++++++++++++++++++++++++++++++++++++------------------
>>>  1 file changed, 77 insertions(+), 39 deletions(-)
>>>
>>> diff --git a/restore/content.c b/restore/content.c
>>> index 54d933c..b655ed1 100644
>>> --- a/restore/content.c
>>> +++ b/restore/content.c
>> ...
>>> @@ -7442,6 +7509,12 @@ restore_reg( drive_t *drivep,
>>>  		}
>>>  	}
>>>  
>>> +	if (strctxp->sc_ownerset == BOOL_FALSE && persp->a.ownerpr) {
>>> +		rval = set_file_owner(path, fdp, strctxp);
>>> +		if (rval)
>>> +			return BOOL_TRUE;
>>> +	}
>>> +
>>
>> If this fails (rval == -1), we have unlinked the file and closed the fd
>> in set_file_owner(). Why return BOOL_TRUE? I've not gone through and
>> learned what dump/restore is doing, but this path looks like it's going
>> to continue on with the restore in that scenario. Even if that is what
>> we want to happen, it seems inconsistent with failure handling in
>> set_file_owner() and the fact that we skip the rest of this function.
> 
> If any of the rest of the operations in this function fail, then it
> keeps trying to do more operations and then finally it returns
> BOOL_TRUE even after errors have occurred. Because the file has been
> unlinked and the fd has been closed, we know all further operations
> are going to fail, so we may as well just return immediately.
> 
> And if we follow the caller path back, we get back to
> 
> 
> applynondirdump
>   for (;;) {
>     restore_file
>       treecb_link
>         restore_file_cb
>           restore_reg
>    if (not ok)
>      break;
>   }
> 
> So, returning BOOL_FALSE in the context above results in
> tree_cb_link() returning RV_NOT_OK, which results in the stream
> processing loop in applynondirdump() being aborted. i.e. returning
> an error restoring a file causes the entire dump stream to be
> aborted at that point.
> 
> IOWs, the dump image cannot be restored past that point, hence
> returning an error of any kind is a bad idea.  Mostly complete
> restores missing just a file (that were reported on during the
> restore) is much, much better than having restore stop half way
> through and refusing to go any further.
> 

Ok.. and we nuke the output file anyways if we can't set the owner, so
that makes sense. It kind of stinks we continue with the whole dance for
this file after this. On the other hand, perhaps there is value in still
reading through the source content. Anyways, it looks like it should
handle this scenario (aside from probably spewing the additional error
messages) but...

> The code is convoluted, obtuse and difficult to read. But we're not
> going to rewrite it from scratch any time soon so we just have to
> live with it's craziness.
> 

... that about sums it up. ;)

>>> -			if ( mode != (mode_t)bstatp->bs_mode ) {
>>> -				rval = fchmod( fd, mode );
>>> -				if ( rval ) {
>>> -					mlog( MLOG_VERBOSE | MLOG_ERROR,
>>> -					      _("unable to strip setuid/setgid "
>>> -					      "on %s, unlinking file.\n"),
>>> -					      path );
>>> -					unlink( path );
>>> -				}
>>> -			}
>>> -		}
>>> +	if (strcxtp->sc_ownerset == BOOL_FALSE && persp->a.ownerpr) {
>>> +		rval = set_file_owner(path, &fd, strcxtp);
>>> +		if (rval)
>>> +			return BOOL_TRUE;
>>>  	}
>>
>> Ok, so we handle both set_file_owner() situations because the ordering
>> here is really only important for regular files. IIUC, this particular
>> block is still required for that non-ifreg case. Though, in the failure
>> case, it looks like we're leaking the fd by returning now.
> 
> set_file_owner() closes the fd on error, immediately after unlinking
> the file. Hence there is no fd leak in the error path.
> 

Oops, right.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> And, again, we return BOOL_TRUE because that's what all the other
> paths return even on error. And, in fact, none of the callers even
> look at the error returned, so it's pretty much irrelevant in this
> function.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
