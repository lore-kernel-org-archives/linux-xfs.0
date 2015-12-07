Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A0BC7F37
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 10:46:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69974AC004
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 08:46:06 -0800 (PST)
Received: from mail-yk0-f169.google.com (mail-yk0-f169.google.com
	[209.85.160.169]) by cuda.sgi.com with ESMTP id
	8lMYUqZP9YKm2ApX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Dec 2015 08:46:02 -0800 (PST)
Received: by ykba77 with SMTP id a77so200767842ykb.2
	for <xfs@oss.sgi.com>; Mon, 07 Dec 2015 08:46:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+eFSM3r-=VvpFWfuhAuPkf-LZQaRtAdZmSWrunc8wTx5o7CAw@mail.gmail.com>
References: <CA+eFSM30A1V7j4CYJOyLSN7V7REHt0hrxteU1dVRw4HQZLmuxw@mail.gmail.com>
	<20150707233743.GZ7943@dastard>
	<CA+eFSM2eDRousxuYBOgwPxjcBg1gotsHB2K1JT-eG0uHKtOaWQ@mail.gmail.com>
	<20150829223156.GD26895@dastard>
	<CA+eFSM3r-=VvpFWfuhAuPkf-LZQaRtAdZmSWrunc8wTx5o7CAw@mail.gmail.com>
Date: Tue, 8 Dec 2015 00:46:01 +0800
Message-ID: <CA+eFSM0kx64FJZ6avSZDxQgbB2OqhmYYUHX-TJnTupEXSWteXQ@mail.gmail.com>
Subject: Re: Possible memory allocation deadlock in kmem_alloc and hung task
	in xfs_log_commit_cil and xlog_cil_push
From: Gavin Guo <gavin.guo@canonical.com>
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
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi Dave,

On Mon, Aug 31, 2015 at 3:33 PM, Gavin Guo <gavin.guo@canonical.com> wrote:
> On Sun, Aug 30, 2015 at 6:31 AM, Dave Chinner <david@fromorbit.com> wrote:
>> On Fri, Aug 28, 2015 at 08:54:04PM +0800, Gavin Guo wrote:
>>> On Wed, Jul 8, 2015 at 7:37 AM, Dave Chinner <david@fromorbit.com> wrote:
>>> > On Tue, Jul 07, 2015 at 05:29:43PM +0800, Gavin Guo wrote:
>>> >> Hi all,
>>> >>
>>> >> Recently, we observed that there is the error message in
>>> >> Ubuntu-3.13.0-48.80:
>>> >>
>>> >> "XFS: possible memory allocation deadlock in kmem_alloc (mode:0x8250)"
>>> >>
>>> >> repeatedly shows in the dmesg. Temporarily, our workaround is to tune the
>>> >> parameters, such as, vfs_cache_pressure, min_free_kbytes, and dirty_ratio.
>>> >>
>>> >> And we also found that there are different error messages regarding the
>>> >> hung tasks which happened in xfs_log_commit_cil and xlog_cil_push.
>>> >>
>>> >> The log is available at: http://paste.ubuntu.com/11835007/
>>> >>
>>> >> The following link seems the same problem we suffered:
>>> >>
>>> >> XFS hangs with XFS: possible memory allocation deadlock in kmem_alloc
>>> >> http://oss.sgi.com/archives/xfs/2015-03/msg00172.html
>>> >>
>>> >> I read the mail and found that there might be some modification regarding
>>> >> to move the memory allocation outside the ctx lock. And I also read the
>>> >> latest patch from February of 2015 to see if there is any new change
>>> >> about that. Unfortunately, I didn't find anything regarding the change (may
>>> >> be I'm not familiar with the XFS, so didn't find the commit). If it's
>>> >> possible for someone who is familiar with the code to point out the commits
>>> >> related to the bug if already exist or any status about the plan.
>>> >
>>> > No commits - the approach I thought we might be able to take to
>>> > avoid the problem didn't work out. I have another idea of how we
>>> > might solve the problem, but I haven't ad a chance to prototype it
>>> > yet.
>>>
>>> I have read the code for a while and still can't figure out how to fix.
>>> My current understanding is that the problem is Buddy system is running out
>>> of memory so the XFS kmem_alloc(),
>>>
>>>   called by xfs_log_commit_cil->
>>>                 xlog_cil_insert_items->
>>>                 xlog_cil_insert_format_items->
>>>                 kmem_zalloc,
>>>
>>> fail and stuck in the while loop and retry. There are also 2 other threads
>>> running in the same time:
>>>
>>> 1). xfs_log_commit_cil->down_read(&cil->xc_ctx_lock);
>>>
>>> 2). xlog_cil_push->down_write(&cil->xc_ctx_lock);
>>>
>>> So, the both threads are blocked and waiting for the first kmem_zalloc() to
>>> succeed.
>>>
>>> However, if there is a way to decrease the memory request or if it's
>>> possible to elaborate more on the idea you mentioned. I know it's a
>>> problem which cannot be solved in a short time. And I'd like to help if
>>> there is any possibility.
>>
>> This is the patch I'm currently working on. It doesn't work
>> completely yet, but it will give you an idea of how the problem
>> needs tobe solved (read the big comment in the patch).
>>
>> -Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>> ---
>>  fs/xfs/xfs_buf_item.c     |   1 +
>>  fs/xfs/xfs_dquot.c        |   1 +
>>  fs/xfs/xfs_dquot_item.c   |   2 +
>>  fs/xfs/xfs_extfree_item.c |   2 +
>>  fs/xfs/xfs_inode_item.c   |   1 +
>>  fs/xfs/xfs_log_cil.c      | 228 ++++++++++++++++++++++++++++++++++------------
>>  6 files changed, 177 insertions(+), 58 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
>> index 1816334..64cd236 100644
>> --- a/fs/xfs/xfs_buf_item.c
>> +++ b/fs/xfs/xfs_buf_item.c
>> @@ -831,6 +831,7 @@ xfs_buf_item_free(
>>         xfs_buf_log_item_t      *bip)
>>  {
>>         xfs_buf_item_free_format(bip);
>> +       kmem_free(bip->bli_item->li_lv_shadow);
>>         kmem_zone_free(xfs_buf_item_zone, bip);
>>  }
>>
>> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
>> index 4143dc7..b9e7dda 100644
>> --- a/fs/xfs/xfs_dquot.c
>> +++ b/fs/xfs/xfs_dquot.c
>> @@ -74,6 +74,7 @@ xfs_qm_dqdestroy(
>>  {
>>         ASSERT(list_empty(&dqp->q_lru));
>>
>> +       kmem_free(dqp->qli_item.li_lv_shadow);
>>         mutex_destroy(&dqp->q_qlock);
>>         kmem_zone_free(xfs_qm_dqzone, dqp);
>>
>> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
>> index 814cff9..2c7a162 100644
>> --- a/fs/xfs/xfs_dquot_item.c
>> +++ b/fs/xfs/xfs_dquot_item.c
>> @@ -370,6 +370,8 @@ xfs_qm_qoffend_logitem_committed(
>>         spin_lock(&ailp->xa_lock);
>>         xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
>>
>> +       kmem_free(qfs->qql_item.li_lv_shadow);
>> +       kmem_free(lip->li_lv_shadow);
>>         kmem_free(qfs);
>>         kmem_free(qfe);
>>         return (xfs_lsn_t)-1;
>> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
>> index adc8f8f..3842418 100644
>> --- a/fs/xfs/xfs_extfree_item.c
>> +++ b/fs/xfs/xfs_extfree_item.c
>> @@ -40,6 +40,7 @@ void
>>  xfs_efi_item_free(
>>         struct xfs_efi_log_item *efip)
>>  {
>> +       kmem_free(efip->efi_item.li_lv_shadow);
>>         if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
>>                 kmem_free(efip);
>>         else
>> @@ -329,6 +330,7 @@ static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
>>  STATIC void
>>  xfs_efd_item_free(struct xfs_efd_log_item *efdp)
>>  {
>> +       kmem_free(efdp->efd_item.li_lv_shadow);
>>         if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
>>                 kmem_free(efdp);
>>         else
>> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
>> index bf13a5a..39ca237 100644
>> --- a/fs/xfs/xfs_inode_item.c
>> +++ b/fs/xfs/xfs_inode_item.c
>> @@ -577,6 +577,7 @@ void
>>  xfs_inode_item_destroy(
>>         xfs_inode_t     *ip)
>>  {
>> +       kmem_free(ip->ili_item->li_lv_shadow);
>>         kmem_zone_free(xfs_ili_zone, ip->i_itemp);
>>  }
>>
>> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
>> index abc2ccb..ab4b98c 100644
>> --- a/fs/xfs/xfs_log_cil.c
>> +++ b/fs/xfs/xfs_log_cil.c
>> @@ -79,6 +79,145 @@ xlog_cil_init_post_recovery(
>>         log->l_cilp->xc_ctx->sequence = 1;
>>  }
>>
>> +static inline int
>> +xlog_cil_iovec_space(
>> +       uint    niovecs)
>> +{
>> +       return round_up((sizeof(struct xfs_log_vec) +
>> +                                       niovecs * sizeof(struct xfs_log_iovec)),
>> +                       sizeof(uint64_t));
>> +}
>> +
>> +/*
>> + * Allocate or pin log vector buffers for CIL insertion.
>> + *
>> + * The CIL currently uses disposable buffers for copying a snapshot of the
>> + * modified items into the log during a push. The biggest problem with this is
>> + * the requirement to allocate the disposable buffer during the commit if:
>> + *     a) does not exist; or
>> + *     b) it is too small
>> + *
>> + * If we do this allocation within xlog_cil_insert_format_items(), it is done
>> + * under the xc_ctx_lock, which means that a CIL push cannot occur during
>> + * the memory allocation. This means that we have a potential deadlock situation
>> + * under low memory conditions when we have lots of dirty metadata pinned in
>> + * the CIL and we need a CIL commit to occur to free memory.
>> + *
>> + * To avoid this, we need to move the memory allocation outside the
>> + * xc_ctx_lock(), but because the log vector buffers are disposable, that opens
>> + * up a TOCTOU race condition w.r.t. the CIL commiting and removing the log
>> + * vector buffers between the check and the formatting of the item into the
>> + * log vector buffer within the xc_ctx_lock.
>> + *
>> + * Because the log vector buffer needs to be unchanged during the CIL push
>> + * process, we cannot share the buffer between the transaction commit (which
>> + * modifies the buffer) and the CIL push context that is writing the changes
>> + * into the log. This means skipping preallocation of buffer space is
>> + * unreliable, but we most definitely do not want to be allocating and freeing
>> + * buffers unnecessarily during commits when overwrites can be done safely.
>> + *
>> + * The simplest solution to this problem is to allocate a shadow buffer when a
>> + * log item is committed for the second time, and then to only use this buffer
>> + * if necessary. The buffer can remain attached to the log item until such time
>> + * it is needed, and this is the buffer that is reallocated to match the size of
>> + * the incoming modification. Then during the formatting of the item we can swap
>> + * the active buffer with the new one if we can't reuse the existing buffer. We
>> + * don't free the old buffer as it may be reused on the next modification if
>> + * it's size is right, otherwise we'll free and reallocate it at that point.
>> + *
>> + * This function builds a vector for the changes in each log item in the
>> + * transaction. It then works out the length of the buffer needed for each log
>> + * item, allocates them and attaches the vector to the log item in preparation
>> + * for the formatting step which occurs under the xc_ctx_lock.
>> + *
>> + * While this means the memory footprint goes up, it avoids the repeated
>> + * alloc/free pattern that repeated modifications of an item would otherwise
>> + * cause, and hence minimises the CPU overhead of such behaviour.
>> + */
>> +static void
>> +xfs_cil_item_alloc_shadow_lvbufs(
>> +       struct xlog             *log,
>> +       struct xfs_trans        *tp)
>> +{
>> +       list_for_each_entry(lidp, &tp->t_items, lid_trans) {
>> +               struct xfs_log_item *lip = lidp->lid_item;
>> +               struct xfs_log_vec *lv;
>> +               struct xfs_log_vec *old_lv;
>> +               int     niovecs = 0;
>> +               int     nbytes = 0;
>> +               int     buf_size;
>> +               bool    ordered = false;
>> +
>> +               /* Skip items which aren't dirty in this transaction. */
>> +               if (!(lidp->lid_flags & XFS_LID_DIRTY))
>> +                       continue;
>> +
>> +               /* get number of vecs and size of data to be stored */
>> +               lip->li_ops->iop_size(lip, &niovecs, &nbytes);
>> +
>> +               /*
>> +                * Ordered items need to be tracked but we do not wish to write
>> +                * them. We need a logvec to track the object, but we do not
>> +                * need an iovec or buffer to be allocated for copying data.
>> +                */
>> +               if (niovecs == XFS_LOG_VEC_ORDERED) {
>> +                       ordered = true;
>> +                       niovecs = 0;
>> +                       nbytes = 0;
>> +               }
>> +
>> +               /*
>> +                * We 64-bit align the length of each iovec so that the start
>> +                * of the next one is naturally aligned.  We'll need to
>> +                * account for that slack space here. Then round nbytes up
>> +                * to 64-bit alignment so that the initial buffer alignment is
>> +                * easy to calculate and verify.
>> +                */
>> +               nbytes += niovecs * sizeof(uint64_t);
>> +               nbytes = round_up(nbytes, sizeof(uint64_t));
>> +
>> +               /* grab the old item if it exists for reservation accounting */
>> +               old_lv = lip->li_lv;
>> +
>> +               /*
>> +                * The data buffer needs to start 64-bit aligned, so round up
>> +                * that space to ensure we can align it appropriately and not
>> +                * overrun the buffer.
>> +                */
>> +               buf_size = nbytes + xlog_cil_iovec_space(niovecs);
>> +
>> +               /*
>> +                * if we have no shadow buffer, or it is too small, we need to
>> +                * reallocate it.
>> +                */
>> +               if (!lip->li_lv_shadow ||
>> +                   buf_size <= lip->li_lv_shadow->lv_size) {
>> +
>> +                       kmem_free(lip->li_lv_shadow);
>> +
>> +                       lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
>> +                       lv->lv_item = lip;
>> +                       lv->lv_size = buf_size;
>> +                       if (ordered)
>> +                               lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
>> +                       else
>> +                               lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
>> +                       lip->li_lv_shadow = lv;
>> +               } else {
>> +                       /* same or smaller, optimise common overwrite case */
>> +                       lv = lip->li_lv_shadow;
>> +               }
>> +
>> +               /* Ensure the lv is set up according to ->iop_size */
>> +               lv->lv_niovecs = niovecs;
>> +
>> +               /* The allocated data region lies beyond the iovec region */
>> +               lv->lv_buf_len = 0;
>> +               lv->lv_bytes = 0;
>> +               lv->lv_buf = (char *)lv + xlog_cil_iovec_space(niovecs);
>> +       }
>> +
>> +}
>>  /*
>>   * Prepare the log item for insertion into the CIL. Calculate the difference in
>>   * log space and vectors it will consume, and if it is a new item pin it as
>> @@ -101,7 +240,8 @@ xfs_cil_prepare_item(
>>         /*
>>          * If there is no old LV, this is the first time we've seen the item in
>>          * this CIL context and so we need to pin it. If we are replacing the
>> -        * old_lv, then remove the space it accounts for and free it.
>> +        * old_lv, then remove the space it accounts for and make it the shadow
>> +        * buffer for later freeing.
>>          */
>>         if (!old_lv)
>>                 lv->lv_item->li_ops->iop_pin(lv->lv_item);
>> @@ -110,7 +250,7 @@ xfs_cil_prepare_item(
>>
>>                 *diff_len -= old_lv->lv_bytes;
>>                 *diff_iovecs -= old_lv->lv_niovecs;
>> -               kmem_free(old_lv);
>> +               lip->li_lv_shadow = old_lv;
>>         }
>>
>>         /* attach new log vector to log item */
>> @@ -134,11 +274,13 @@ xfs_cil_prepare_item(
>>   * write it out asynchronously without needing to relock the object that was
>>   * modified at the time it gets written into the iclog.
>>   *
>> - * This function builds a vector for the changes in each log item in the
>> - * transaction. It then works out the length of the buffer needed for each log
>> - * item, allocates them and formats the vector for the item into the buffer.
>> - * The buffer is then attached to the log item are then inserted into the
>> - * Committed Item List for tracking until the next checkpoint is written out.
>> + * This function takes the prepared log vectors attached to each log item, and
>> + * formats the changes into the log vector buffer. The buffer it uses is
>> + * dependent on the current state of the vector in the CIL - the shadow lv is
>> + * guaranteed to be large enough for the current modification, but we will only
>> + * use that if we can't reuse the existing lv. If we can't reuse the existing
>> + * lv, then simple swap it out for the shadow lv. We don't free it - that is
>> + * done lazily either by th enext modification or the freeing of the log item.
>>   *
>>   * We don't set up region headers during this process; we simply copy the
>>   * regions into the flat buffer. We can do this because we still have to do a
>> @@ -171,7 +313,8 @@ xlog_cil_insert_format_items(
>>         list_for_each_entry(lidp, &tp->t_items, lid_trans) {
>>                 struct xfs_log_item *lip = lidp->lid_item;
>>                 struct xfs_log_vec *lv;
>> -               struct xfs_log_vec *old_lv;
>> +               struct xfs_log_vec *old_lv = NULL;
>> +               struct xfs_log_vec *shadow;
>>                 int     niovecs = 0;
>>                 int     nbytes = 0;
>>                 int     buf_size;
>> @@ -181,49 +324,19 @@ xlog_cil_insert_format_items(
>>                 if (!(lidp->lid_flags & XFS_LID_DIRTY))
>>                         continue;
>>
>> -               /* get number of vecs and size of data to be stored */
>> -               lip->li_ops->iop_size(lip, &niovecs, &nbytes);
>> -
>> -               /* Skip items that do not have any vectors for writing */
>> -               if (!niovecs)
>> -                       continue;
>> -
>>                 /*
>> -                * Ordered items need to be tracked but we do not wish to write
>> -                * them. We need a logvec to track the object, but we do not
>> -                * need an iovec or buffer to be allocated for copying data.
>> +                * The formatting size information is already attached to
>> +                * the shadow lv on the log item.
>>                  */
>> -               if (niovecs == XFS_LOG_VEC_ORDERED) {
>> +               if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED)
>>                         ordered = true;
>> -                       niovecs = 0;
>> -                       nbytes = 0;
>> -               }
>>
>> -               /*
>> -                * We 64-bit align the length of each iovec so that the start
>> -                * of the next one is naturally aligned.  We'll need to
>> -                * account for that slack space here. Then round nbytes up
>> -                * to 64-bit alignment so that the initial buffer alignment is
>> -                * easy to calculate and verify.
>> -                */
>> -               nbytes += niovecs * sizeof(uint64_t);
>> -               nbytes = round_up(nbytes, sizeof(uint64_t));
>> -
>> -               /* grab the old item if it exists for reservation accounting */
>> -               old_lv = lip->li_lv;
>> -
>> -               /*
>> -                * The data buffer needs to start 64-bit aligned, so round up
>> -                * that space to ensure we can align it appropriately and not
>> -                * overrun the buffer.
>> -                */
>> -               buf_size = nbytes +
>> -                          round_up((sizeof(struct xfs_log_vec) +
>> -                                    niovecs * sizeof(struct xfs_log_iovec)),
>> -                                   sizeof(uint64_t));
>> +               /* Skip items that do not have any vectors for writing */
>> +               if (!shadow->lv_niovecs && !ordered)
>> +                       continue;
>>
>>                 /* compare to existing item size */
>> -               if (lip->li_lv && buf_size <= lip->li_lv->lv_size) {
>> +               if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
>>                         /* same or smaller, optimise common overwrite case */
>>                         lv = lip->li_lv;
>>                         lv->lv_next = NULL;
>> @@ -237,29 +350,28 @@ xlog_cil_insert_format_items(
>>                          */
>>                         *diff_iovecs -= lv->lv_niovecs;
>>                         *diff_len -= lv->lv_bytes;
>> +
>> +                       /* Ensure the lv is set up according to ->iop_size */
>> +                       lv->lv_niovecs = shadow->lv_niovecs;
>> +
>> +                       /* reset the lv buffer information for new formatting */
>> +                       lv->lv_buf_len = 0;
>> +                       lv->lv_bytes = 0;
>> +                       lv->lv_buf = (char *)lv +
>> +                               xlog_cil_iovec_space(lv->lv_niovecs)
>>                 } else {
>> -                       /* allocate new data chunk */
>> -                       lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
>> +                       /* switch to shadow buffer! */
>> +                       lv = shadow;
>>                         lv->lv_item = lip;
>> -                       lv->lv_size = buf_size;
>> +                       old_lv = lip->li_lv;
>>                         if (ordered) {
>>                                 /* track as an ordered logvec */
>>                                 ASSERT(lip->li_lv == NULL);
>> -                               lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
>>                                 goto insert;
>>                         }
>> -                       lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
>>                 }
>>
>> -               /* Ensure the lv is set up according to ->iop_size */
>> -               lv->lv_niovecs = niovecs;
>> -
>> -               /* The allocated data region lies beyond the iovec region */
>> -               lv->lv_buf_len = 0;
>> -               lv->lv_bytes = 0;
>> -               lv->lv_buf = (char *)lv + buf_size - nbytes;
>>                 ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
>> -
>>                 lip->li_ops->iop_format(lip, lv);
>>  insert:
>>                 ASSERT(lv->lv_buf_len <= nbytes);
>
> Really thanks for your patch. I'll study the patch first to figure out the idea.
>
> Gavin

I'm keeping on watching the mailing list and seems that the patch is still
under development. Just want to confirm I didn't miss any information and
I am more than happy to give any help if needed. :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
