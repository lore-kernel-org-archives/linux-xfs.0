Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 682F47CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 16:45:16 -0500 (CDT)
Message-ID: <515CA2EE.605@sgi.com>
Date: Wed, 03 Apr 2013 16:45:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't free EFIs before the EFDs are committed
References: <1364958561-12440-1-git-send-email-david@fromorbit.com>
	<515C7F09.2080201@sgi.com> <515C8732.3000902@sandeen.net>
	<515C98E1.2010700@sandeen.net>
In-Reply-To: <515C98E1.2010700@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 04/03/13 16:02, Eric Sandeen wrote:
> On 4/3/13 2:46 PM, Eric Sandeen wrote:
>> On 4/3/13 2:12 PM, Mark Tinguely wrote:
>>> On 04/02/13 22:09, Dave Chinner wrote:
>>>> From: Dave Chinner<dchinner@redhat.com>
>>>>
>>>> Filesystems are occasionally being shut down with this error:
>>>>
>>>> xfs_trans_ail_delete_bulk: attempting to delete a log item that is
>>>> not in the AIL.
>>>>
>>>> It was diagnosed to be related to the EFI/EFD commit order when the
>>>> EFI and EFD are in different checkpoints and the EFD is committed
>>>> before the EFI here:
>>>>
>>>> http://oss.sgi.com/archives/xfs/2013-01/msg00082.html
>>>>
>>>> The real problem is that a single bit cannot fully describe the
>>>> states that the EFI/EFD processing can be in. These completion
>>>> states are:
>>>>
>>>> EFI            EFI in AIL    EFD        Result
>>>> committed/unpinned    Yes        committed    OK
>>>> committed/pinned    No        committed    Shutdown
>>>> uncommitted        No        committed    Shutdown
>>>>
>>>>
>>>> Note that the "result" field is what should happen, not what does
>>>> happen. The current logic is broken and handles the first two cases
>>>> correctly by luck.  That is, the code will free the EFI if the
>>>> XFS_EFI_COMMITTED bit is*not*  set, rather than if it is set. The
>>>> inverted logic "works" because if both EFI and EFD are committed,
>>>> then the first __xfs_efi_release() call clears the XFS_EFI_COMMITTED
>>>> bit, and the second frees the EFI item. Hence as long as
>>>> xfs_efi_item_committed() has been called, everything appears to be
>>>> fine.
>>>>
>>>> It is the third case where the logic fails - where
>>>> xfs_efd_item_committed() is called before xfs_efi_item_committed(),
>>>> and that results in the EFI being freed before it has been
>>>> committed. That is the bug that triggered the shutdown, d hence
>>>> keeping track of whether the EFI has been committed or not is
>>>> insufficient to correctly order the EFI/EFD operations w.r.t. the
>>>> AIL.
>>>>
>>>
>>> I think the exist xfs_efi routines are working correctly.
>>>
>>> the xfs_trans_committed_bulk() for the efi does the IOP_COMMITTED
>>> (sets the XFS_EFI_COMMITTED bit), add the entry to the AIL and then
>>> an IOP_UNPIN() which clears the XFS_EFI_COMMITTED since it is set, it
>>> should not release the efi and remove the entry from the AIL. It also
>>> correctly detects if the EFD is committed before the EFI by shutting
>>> down the filesystem.
>>
>> Well hang on, not everything can be cool in EFI-land here, if nothing
>> else this:
>>
>> __xfs_efi_release(
>>          struct xfs_efi_log_item *efip)
>> {
>>          struct xfs_ail          *ailp = efip->efi_item.li_ailp;
>>
>>          if (!test_and_clear_bit(XFS_EFI_COMMITTED,&efip->efi_flags)) {
>>                  spin_lock(&ailp->xa_lock);
>>                  /* xfs_trans_ail_delete() drops the AIL lock. */
>>                  xfs_trans_ail_delete(ailp,&efip->efi_item,
>>                                       SHUTDOWN_LOG_IO_ERROR);
>>                  xfs_efi_item_free(efip);
>>          }
>> }
>>
>> seems obviously broken.
>>
>>   * test_and_clear_bit - Clear a bit and return its old value
>>
>> so it is saying if XFS_EFI_COMMITED was *not* set, free the efi.
>> Which I think we must admit is broken.
>>
>> I have to get up to speed on this code, but it seems like at least
>> this much above is quite obviously broken, and the previously
>> proposed patch doesn't address it.  Am I missing something?
>
> Or are you saying that it's working as designed, so that the first
> caller finds it set, clears it and does nothing, and the 2nd caller
> finds it unset, and frees it?  help me out here ;)
>
> -Eric
>

Yes. The order is IOP_COMMITTED and then IOP_UNPIN:

The EFI IOP_COMMITTED:

xfs_efi_item_committed(
         struct xfs_log_item     *lip,
         xfs_lsn_t               lsn)
{
         struct xfs_efi_log_item *efip = EFI_ITEM(lip);

         set_bit(XFS_EFI_COMMITTED, &efip->efi_flags);
         return lsn;
}

then

The EFI IOP_UNPIN() ->

STATIC void
xfs_efi_item_unpin(
         struct xfs_log_item     *lip,
         int                     remove)
{
         struct xfs_efi_log_item *efip = EFI_ITEM(lip);

         if (remove) {
                 ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
                 if (lip->li_desc)
                         xfs_trans_del_item(lip);
                 xfs_efi_item_free(efip);
                 return;
         }
         __xfs_efi_release(efip);
}


and the the EFD's IOP_COMMITED:

STATIC xfs_lsn_t
xfs_efi_item_committed(
         struct xfs_log_item     *lip,
         xfs_lsn_t               lsn)
{
         struct xfs_efi_log_item *efip = EFI_ITEM(lip);

         set_bit(XFS_EFI_COMMITTED, &efip->efi_flags);
         return lsn;
}

The code makes sure the sequence EFI and then EFD are done in order.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
