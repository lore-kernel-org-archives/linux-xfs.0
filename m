Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B6B0B7CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 08:28:45 -0500 (CDT)
Message-ID: <51EFD68A.40400@sgi.com>
Date: Wed, 24 Jul 2013 08:28:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-45-git-send-email-david@fromorbit.com>
	<51EEF26F.5040001@sgi.com> <51EEF949.9020104@gmail.com>
In-Reply-To: <51EEF949.9020104@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 07/23/13 16:44, Michael L. Semon wrote:
> On 07/23/2013 05:15 PM, Mark Tinguely wrote:
>> On 07/19/13 01:25, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> Now that we have the size of the object before the formatting pass
>>> is called, we can allocation the log vector and it's buffer in a
>>> single allocation rather than two separate allocations.
>>>
>>> Store the size of the allocated buffer in the log vector so that
>>> we potentially avoid allocation for future modifications of the
>>> object.
>>>
>>> While touching this code, remove the IOP_FORMAT definition.
>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>
>> Looks good.
>>
>> Reviewed-by: Mark Tinguely<tinguely@sgi.com>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
> I'd like to register a gentle "test this well" protest on this patch.
> While trying to figure out the origin of an unrelated lockdep, I
> tried to copy 3 kernel gits from one 2k non-CRC XFS filesystem to
> another one.  With at least this patch used, the cp operatin stops,
> leading to not-umountable, not-syncable filesystems.  It might be
> while copying the 2nd git, or the 3rd git, while copying header files,
> or while copying those large *.pack files, but it will happen
> somewhere.
>
> A bisect of the issue ends on this patch, but its removal means that
> 45_49 and 46_49 cannot be applied without good knowledge of the code
> to be patched.
>
> This one's on me for not being able to get good information to Dave.
> If I can find a way to get trace-cmd to pipe over ssh or something
> like that, then maybe there's a chance to make a file that `trace-cmd
> report` can read.  Previous attempts to save to different filesystems
> or save over NFS and CIFS have all failed.  Will keep trying...
>
> For diagnosing this patch, is there an effective trace that is rather
> small?  And would you need more than just the XFS events?
>
> Thanks!
>
> Michael
>

Thanks for the heads up.

If you could please redo the test and get the stack traces with 
/proc/sysrq-trigger and if you kernel works with crash, a core dump. For 
the stack trace, I mostly want to know if it has several 
"xlog_grant_head_wait" entries in it, because ...

...I seemed to have triggered a couple log space reservation hangs with 
fsstress one XFS partition and a mega-copy on another partition, but 
will have to graft the new XFS tree onto a Linux 3.10 kernel to get 
crash (and one of my sata controllers) to work again.

Thanks.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
