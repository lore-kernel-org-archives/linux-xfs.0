Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5BAD77F9B
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 17:00:26 -0500 (CDT)
Message-ID: <520AAC79.1030608@sgi.com>
Date: Tue, 13 Aug 2013 17:00:25 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 50/50] xfs: use reference counts to free clean buffer items
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-51-git-send-email-david@fromorbit.com>
	<520A4AB7.1080207@sgi.com> <20130813214648.GC6023@dastard>
In-Reply-To: <20130813214648.GC6023@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/13/13 16:46, Dave Chinner wrote:
> On Tue, Aug 13, 2013 at 10:03:19AM -0500, Mark Tinguely wrote:
>> On 08/12/13 05:50, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> When a transaction is cancelled and the buffer log item is clean in

...

>>
>> why is a clean buffer on the AIL? Racing with a completion handler?
>
> "clean" means that it wasn't dirtied in the transaction - it can be
> in the AIL and holding a reference count that way.

I am wondering because it should not have made it into the CIL if it was 
not dirtied in a transaction - at least according to the the log item 
descriptor flag at least.

>
>> rather than this:
>>
>> 	if (clean || aborted) {
>> 		if (atomic_dec_and_test(&bip->bli_refcount)) {
>> 			ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
>> 			xfs_buf_item_relse(bp);
>> 		}
>> 	} else
>> 		atomic_dec(&bip->bli_refcount);
>>
>> why not fold it into this:
>>
>> 	if (atomic_dec_and_test(&bip->bli_refcount)) {
>> 		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
>> 		xfs_buf_item_relse(bp);
>> 	}
>
> Basically, the code as it stands documents the different exit
> conditions of a transaction commit. If the item was logged, we
> expect it to continue existing and something else will free it.  If
> we change it, we lose awareness that there are different exit
> criteria, and it risks introducing a use after free if there is ever
> a race condition w.r.t. unpinning the item in an async CIL commit.
>
> I'm not saying that there is a problem here, just that the code as
> it stands will not free the item in this case. The stale buffer
> handling has similar requirements (i.e. decrement without freeing so
> the unpin on log IO completion will free it) and there's a comment in
> xfs_log_commit_cil() related to avoiding such race conditions.
>
> So I'd prefer to leave it as it stands...

okay with me.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
