Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6FCC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 16:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7124622D6D
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 16:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfHUQmo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 12:42:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfHUQmn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Aug 2019 12:42:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 20BD47FDEC;
        Wed, 21 Aug 2019 16:42:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6707060126;
        Wed, 21 Aug 2019 16:42:42 +0000 (UTC)
Date:   Wed, 21 Aug 2019 12:42:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, chandan@linux.ibm.com,
        darrick.wong@oracle.com, hch@infradead.org, david@fromorbit.com
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before
 waiting for log space
Message-ID: <20190821164240.GD19646@bfoster>
References: <20190821110448.30161-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821110448.30161-1-chandanrlinux@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 21 Aug 2019 16:42:43 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 04:34:48PM +0530, Chandan Rajendra wrote:
> The following call trace is seen when executing generic/530 on a ppc64le
> machine,
> 

Could you provide xfs_info of the scratch device that reproduces this
problem? I'm curious because I don't recall seeing this, but I'm also
not sure I've run those iunlink tests on ppc64...

> INFO: task mount:7722 blocked for more than 122 seconds.
>       Not tainted 5.3.0-rc1-next-20190723-00001-g1867922e5cbf-dirty #6
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> mount           D 8448  7722   7490 0x00040008
> Call Trace:
> [c000000629343210] [0000000000000001] 0x1 (unreliable)
> [c0000006293433f0] [c000000000021acc] __switch_to+0x2ac/0x490
> [c000000629343450] [c000000000fbbbf4] __schedule+0x394/0xb50
> [c000000629343510] [c000000000fbc3f4] schedule+0x44/0xf0
> [c000000629343540] [c0000000007623b4] xlog_grant_head_wait+0x84/0x420
> [c0000006293435b0] [c000000000762828] xlog_grant_head_check+0xd8/0x1e0
> [c000000629343600] [c000000000762f6c] xfs_log_reserve+0x26c/0x310
> [c000000629343690] [c00000000075defc] xfs_trans_reserve+0x28c/0x3e0
> [c0000006293436e0] [c0000000007606ac] xfs_trans_alloc+0xfc/0x2f0
> [c000000629343780] [c000000000749ca8] xfs_inactive_ifree+0x248/0x2a0
> [c000000629343810] [c000000000749e58] xfs_inactive+0x158/0x300
> [c000000629343850] [c000000000758554] xfs_fs_destroy_inode+0x104/0x3f0
> [c000000629343890] [c00000000046850c] destroy_inode+0x6c/0xc0
> [c0000006293438c0] [c00000000074c748] xfs_irele+0x168/0x1d0
> [c000000629343900] [c000000000778c78] xlog_recover_process_one_iunlink+0x118/0x1e0
> [c000000629343960] [c000000000778e10] xlog_recover_process_iunlinks+0xd0/0x130
> [c0000006293439b0] [c000000000782408] xlog_recover_finish+0x58/0x130
> [c000000629343a20] [c000000000763818] xfs_log_mount_finish+0xa8/0x1d0
> [c000000629343a60] [c000000000750908] xfs_mountfs+0x6e8/0x9e0
> [c000000629343b20] [c00000000075a210] xfs_fs_fill_super+0x5a0/0x7c0
> [c000000629343bc0] [c00000000043e7fc] mount_bdev+0x25c/0x2a0
> [c000000629343c60] [c000000000757c48] xfs_fs_mount+0x28/0x40
> [c000000629343c80] [c0000000004956cc] legacy_get_tree+0x4c/0xb0
> [c000000629343cb0] [c00000000043d690] vfs_get_tree+0x50/0x160
> [c000000629343d30] [c0000000004775d4] do_mount+0xa14/0xc20
> [c000000629343db0] [c000000000477d48] ksys_mount+0xc8/0x180
> [c000000629343e00] [c000000000477e20] sys_mount+0x20/0x30
> [c000000629343e20] [c00000000000b864] system_call+0x5c/0x70
> 
> i.e. the mount task gets hung indefinitely due to the following sequence
> of events,
> 
> 1. Test creates lots of unlinked temp files and then shutsdown the
>    filesystem.
> 2. During mount, a transaction started in the context of processing
>    unlinked inode list causes several iclogs to be filled up. All but
>    the last one is submitted for I/O.

So the inactivation transaction commits should basically start to
populate the CIL. At some point we cross a threshold and a commit
triggers a background CIL push (see xlog_cil_push_background()). I'm
assuming that occurs somewhere in here because otherwise we wouldn't
have started filling iclogs..

> 3. After writing XLOG_COMMIT_TRANS record into the iclog, we will have
>    18532 bytes of free space in the last iclog of the transaction which is
>    greater than 2*sizeof(xlog_op_header_t). Hence
>    xlog_state_get_iclog_space() does not switch over to using a newer iclog.

Ok, so we've sent a bunch of iclogs to disk and the commit record for
the checkpoint ends up in the current iclog log, which remains active on
return from xlog_commit_record() -> xlog_write() etc.

> 4. Meanwhile, the endio code processing iclogs of the transaction do not
>    insert items into the AIL since the iclog containing XLOG_COMMIT_TRANS
>    hasn't been submitted for I/O yet. Hence a major part of the on-disk
>    log cannot be freed yet.

Ok, so that final (still active) iclog holding the commit record is also
holding the ctx.

> 5. A new request for log space (via xfs_log_reserve()) will now wait
>    indefinitely for on-disk log space to be freed.
> 
> To fix this issue, before waiting for log space to be freed, this commit
> now submits xlog->l_iclog for write I/O if iclog->ic_state is
> XLOG_STATE_ACTIVE and iclog has metadata written into it. This causes
> AIL list to be populated and a later call to xlog_grant_push_ail() will
> free up the on-disk log space.
> 

Interesting, so I think I follow the issue at least and what the code is
trying to do to fix it. I'm not totally clear on what the ideal approach
is as this code is complex and I'd need to think about it some more. My
first thought was perhaps whether we needed a checkpoint size limit or
to change the background push threshold or some such, but the more I
think about that the less I think that fixes anything.

A follow up thought is that it seems somewhat unfortunate that we can
build up and hold so much reservation on essentially a single commit
record and then just let it sit around in-core waiting for somebody else
to come along and ask for reservation for something unrelated. I think a
background log force should eventually come around and push that last
record out, so we're not in that state indefinitely, but IIUC that's a
lot of log consumption essentially unaccounted for until the associated
items land in the AIL.

I'm wondering if we should have some measure (if we don't already) of
how much reservation is tied into a single iclog and use that as an
additional metric to determine when to switch iclogs a bit more
aggressively (as opposed to only based on how much space is physically
left in the iclog buffer). For example, if we end a huge checkpoint with
a commit record in an active iclog that has a cil context attached
associated with a hundreds of MBs (handwaving) of log data, perhaps we
should just switch out of that iclog before the CIL push returns so that
consumption can be immediately reflected by the AIL.

Anyways, perhaps there are other thoughts/ideas on this..

Brian

> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/xfs_log.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00e9f5c388d3..dc785a6b9f47 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -236,11 +236,32 @@ xlog_grant_head_wait(
>  	int			need_bytes) __releases(&head->lock)
>  					    __acquires(&head->lock)
>  {
> +	struct xlog_in_core	*iclog;
> +
>  	list_add_tail(&tic->t_queue, &head->waiters);
>  
>  	do {
>  		if (XLOG_FORCED_SHUTDOWN(log))
>  			goto shutdown;
> +
> +		if (xfs_ail_min(log->l_ailp) == NULL) {
> +			spin_lock(&log->l_icloglock);
> +			iclog = log->l_iclog;
> +
> +			if (iclog->ic_state == XLOG_STATE_ACTIVE
> +				&& iclog->ic_offset) {
> +				atomic_inc(&iclog->ic_refcnt);
> +				xlog_state_want_sync(log, iclog);
> +				spin_unlock(&log->l_icloglock);
> +				xlog_state_release_iclog(log, iclog);
> +
> +				spin_lock(&log->l_icloglock);
> +				xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> +			} else {
> +				spin_unlock(&log->l_icloglock);
> +			}
> +		}
> +
>  		xlog_grant_push_ail(log, need_bytes);
>  
>  		__set_current_state(TASK_UNINTERRUPTIBLE);
> -- 
> 2.19.1
> 
