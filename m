Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B1DAB7CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 16:02:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8038530405F
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 14:02:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KsHisKiDLk5L1F4D for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 14:02:26 -0700 (PDT)
Message-ID: <515C98E1.2010700@sandeen.net>
Date: Wed, 03 Apr 2013 16:02:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't free EFIs before the EFDs are committed
References: <1364958561-12440-1-git-send-email-david@fromorbit.com>
	<515C7F09.2080201@sgi.com> <515C8732.3000902@sandeen.net>
In-Reply-To: <515C8732.3000902@sandeen.net>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 4/3/13 2:46 PM, Eric Sandeen wrote:
> On 4/3/13 2:12 PM, Mark Tinguely wrote:
>> On 04/02/13 22:09, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> Filesystems are occasionally being shut down with this error:
>>>
>>> xfs_trans_ail_delete_bulk: attempting to delete a log item that is
>>> not in the AIL.
>>>
>>> It was diagnosed to be related to the EFI/EFD commit order when the
>>> EFI and EFD are in different checkpoints and the EFD is committed
>>> before the EFI here:
>>>
>>> http://oss.sgi.com/archives/xfs/2013-01/msg00082.html
>>>
>>> The real problem is that a single bit cannot fully describe the
>>> states that the EFI/EFD processing can be in. These completion
>>> states are:
>>>
>>> EFI            EFI in AIL    EFD        Result
>>> committed/unpinned    Yes        committed    OK
>>> committed/pinned    No        committed    Shutdown
>>> uncommitted        No        committed    Shutdown
>>>
>>>
>>> Note that the "result" field is what should happen, not what does
>>> happen. The current logic is broken and handles the first two cases
>>> correctly by luck.  That is, the code will free the EFI if the
>>> XFS_EFI_COMMITTED bit is*not*  set, rather than if it is set. The
>>> inverted logic "works" because if both EFI and EFD are committed,
>>> then the first __xfs_efi_release() call clears the XFS_EFI_COMMITTED
>>> bit, and the second frees the EFI item. Hence as long as
>>> xfs_efi_item_committed() has been called, everything appears to be
>>> fine.
>>>
>>> It is the third case where the logic fails - where
>>> xfs_efd_item_committed() is called before xfs_efi_item_committed(),
>>> and that results in the EFI being freed before it has been
>>> committed. That is the bug that triggered the shutdown, d hence
>>> keeping track of whether the EFI has been committed or not is
>>> insufficient to correctly order the EFI/EFD operations w.r.t. the
>>> AIL.
>>>
>>
>> I think the exist xfs_efi routines are working correctly.
>>
>> the xfs_trans_committed_bulk() for the efi does the IOP_COMMITTED
>> (sets the XFS_EFI_COMMITTED bit), add the entry to the AIL and then
>> an IOP_UNPIN() which clears the XFS_EFI_COMMITTED since it is set, it
>> should not release the efi and remove the entry from the AIL. It also
>> correctly detects if the EFD is committed before the EFI by shutting
>> down the filesystem.
> 
> Well hang on, not everything can be cool in EFI-land here, if nothing
> else this:
> 
> __xfs_efi_release(
>         struct xfs_efi_log_item *efip)
> {
>         struct xfs_ail          *ailp = efip->efi_item.li_ailp;
> 
>         if (!test_and_clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags)) {
>                 spin_lock(&ailp->xa_lock);
>                 /* xfs_trans_ail_delete() drops the AIL lock. */
>                 xfs_trans_ail_delete(ailp, &efip->efi_item,
>                                      SHUTDOWN_LOG_IO_ERROR);
>                 xfs_efi_item_free(efip);
>         }
> }
> 
> seems obviously broken.
> 
>  * test_and_clear_bit - Clear a bit and return its old value
> 
> so it is saying if XFS_EFI_COMMITED was *not* set, free the efi.
> Which I think we must admit is broken.
> 
> I have to get up to speed on this code, but it seems like at least
> this much above is quite obviously broken, and the previously
> proposed patch doesn't address it.  Am I missing something?

Or are you saying that it's working as designed, so that the first
caller finds it set, clears it and does nothing, and the 2nd caller
finds it unset, and frees it?  help me out here ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
