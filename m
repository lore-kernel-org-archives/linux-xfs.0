Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7309C3A5A1
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 12:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 713DD23400
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 12:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfHVMim (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 08:38:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729052AbfHVMil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 08:38:41 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7MCZN5s101916
        for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2019 08:38:40 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uhsvdupww-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2019 08:38:40 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 22 Aug 2019 13:38:37 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 22 Aug 2019 13:38:35 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7MCcYqe59703342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 12:38:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E1DFA4066;
        Thu, 22 Aug 2019 12:38:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 459B0A405F;
        Thu, 22 Aug 2019 12:38:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.46.110])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 22 Aug 2019 12:38:33 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        hch@infradead.org
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before waiting for log space
Date:   Thu, 22 Aug 2019 18:10:15 +0530
Organization: IBM
In-Reply-To: <20190821221834.GQ1119@dread.disaster.area>
References: <20190821110448.30161-1-chandanrlinux@gmail.com> <20190821221834.GQ1119@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19082212-0016-0000-0000-000002A17FCE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082212-0017-0000-0000-00003301B8EF
Message-Id: <3307362.yyVt9CMRau@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, August 22, 2019 3:48 AM Dave Chinner wrote:
> On Wed, Aug 21, 2019 at 04:34:48PM +0530, Chandan Rajendra wrote:
> > The following call trace is seen when executing generic/530 on a ppc64le
> > machine,
> > 
> > INFO: task mount:7722 blocked for more than 122 seconds.
> >       Not tainted 5.3.0-rc1-next-20190723-00001-g1867922e5cbf-dirty #6
> 
> can you reproduce this on 5.3-rc5? There were bugs in log recovery
> IO in -rc1 that could result in things going wrong...

Yes, I was able to recreate this bug on v5.3-rc5.

> 
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > mount           D 8448  7722   7490 0x00040008
> > Call Trace:
> > [c000000629343210] [0000000000000001] 0x1 (unreliable)
> > [c0000006293433f0] [c000000000021acc] __switch_to+0x2ac/0x490
> > [c000000629343450] [c000000000fbbbf4] __schedule+0x394/0xb50
> > [c000000629343510] [c000000000fbc3f4] schedule+0x44/0xf0
> > [c000000629343540] [c0000000007623b4] xlog_grant_head_wait+0x84/0x420
> > [c0000006293435b0] [c000000000762828] xlog_grant_head_check+0xd8/0x1e0
> > [c000000629343600] [c000000000762f6c] xfs_log_reserve+0x26c/0x310
> > [c000000629343690] [c00000000075defc] xfs_trans_reserve+0x28c/0x3e0
> > [c0000006293436e0] [c0000000007606ac] xfs_trans_alloc+0xfc/0x2f0
> > [c000000629343780] [c000000000749ca8] xfs_inactive_ifree+0x248/0x2a0
> > [c000000629343810] [c000000000749e58] xfs_inactive+0x158/0x300
> > [c000000629343850] [c000000000758554] xfs_fs_destroy_inode+0x104/0x3f0
> > [c000000629343890] [c00000000046850c] destroy_inode+0x6c/0xc0
> > [c0000006293438c0] [c00000000074c748] xfs_irele+0x168/0x1d0
> > [c000000629343900] [c000000000778c78] xlog_recover_process_one_iunlink+0x118/0x1e0
> > [c000000629343960] [c000000000778e10] xlog_recover_process_iunlinks+0xd0/0x130
> > [c0000006293439b0] [c000000000782408] xlog_recover_finish+0x58/0x130
> > [c000000629343a20] [c000000000763818] xfs_log_mount_finish+0xa8/0x1d0
> > [c000000629343a60] [c000000000750908] xfs_mountfs+0x6e8/0x9e0
> > [c000000629343b20] [c00000000075a210] xfs_fs_fill_super+0x5a0/0x7c0
> > [c000000629343bc0] [c00000000043e7fc] mount_bdev+0x25c/0x2a0
> > [c000000629343c60] [c000000000757c48] xfs_fs_mount+0x28/0x40
> > [c000000629343c80] [c0000000004956cc] legacy_get_tree+0x4c/0xb0
> > [c000000629343cb0] [c00000000043d690] vfs_get_tree+0x50/0x160
> > [c000000629343d30] [c0000000004775d4] do_mount+0xa14/0xc20
> > [c000000629343db0] [c000000000477d48] ksys_mount+0xc8/0x180
> > [c000000629343e00] [c000000000477e20] sys_mount+0x20/0x30
> > [c000000629343e20] [c00000000000b864] system_call+0x5c/0x70
> > 
> > i.e. the mount task gets hung indefinitely due to the following sequence
> > of events,
> > 
> > 1. Test creates lots of unlinked temp files and then shutsdown the
> >    filesystem.
> > 2. During mount, a transaction started in the context of processing
> >    unlinked inode list causes several iclogs to be filled up. All but
> >    the last one is submitted for I/O.
> > 3. After writing XLOG_COMMIT_TRANS record into the iclog, we will have
> >    18532 bytes of free space in the last iclog of the transaction which is
> >    greater than 2*sizeof(xlog_op_header_t). Hence
> >    xlog_state_get_iclog_space() does not switch over to using a newer iclog.
> > 4. Meanwhile, the endio code processing iclogs of the transaction do not
> >    insert items into the AIL since the iclog containing XLOG_COMMIT_TRANS
> >    hasn't been submitted for I/O yet. Hence a major part of the on-disk
> >    log cannot be freed yet.
> 
> So all those items are still pinned in memory.
> 
> > 5. A new request for log space (via xfs_log_reserve()) will now wait
> >    indefinitely for on-disk log space to be freed.
> 
> Because nothing has issued a xfs_log_force() for write the iclog to
> disk, unpin the objects that it pins in memory, and allow the tail
> to be moved forwards.
> 
> The xfsaild normally takes care of thisi - it gets pushed byt the
> log reserve when there's not enough space to in the log for the
> transaction before transaction reserve goes to sleep in
> xlog_grant_head_wait(). The AIL pushing code is then responsible for
> making sure log space is eventually freed. It will issue log forces
> if it isn't making progress and so this problem shouldn't occur.
> 
> So, why has it occurred?
> 
> The xfsaild kthread should be running at this point, so if it was
> pushed it should be trying to empty the journal to move the tail
> forward. Why hasn't it issue a log force?
> 
> 
> > To fix this issue, before waiting for log space to be freed, this commit
> > now submits xlog->l_iclog for write I/O if iclog->ic_state is
> > XLOG_STATE_ACTIVE and iclog has metadata written into it. This causes
> > AIL list to be populated and a later call to xlog_grant_push_ail() will
> > free up the on-disk log space.
> 
> hmmm.
> 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/xfs_log.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 00e9f5c388d3..dc785a6b9f47 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -236,11 +236,32 @@ xlog_grant_head_wait(
> >  	int			need_bytes) __releases(&head->lock)
> >  					    __acquires(&head->lock)
> >  {
> > +	struct xlog_in_core	*iclog;
> > +
> >  	list_add_tail(&tic->t_queue, &head->waiters);
> >  
> >  	do {
> >  		if (XLOG_FORCED_SHUTDOWN(log))
> >  			goto shutdown;
> > +
> > +		if (xfs_ail_min(log->l_ailp) == NULL) {
> 
> This is indicative of the situation. If the AIL is empty, and the
> log does not have room for an entire transaction reservation, then
> we need to be issuing synchronous transactions in recovery until
> such time the AIL pushing can actually function correctly to
> guarantee forwards progress for async transaction processing.

Yes, In the case of this bug, the AIL list was empty.

> 
> sync transactions call xfs_log_force(XFS_LOG_SYNC) immediately after
> writing the commit record, so this whole problem goes away.
> 
> perhaps in __xfs_trans_commit() we need somethign like this:
> 
>  	/*
>  	 * If the transaction needs to be synchronous, then force the
>  	 * log out now and wait for it.
> +	 *
> +	 * If we are in recovery and the AIL is empty, the log may only
> +	 * have enough room for a single transaction and the AIL
> +	 * cannot push the tail forwards. Hence while the AIL is
> +	 * empty and we are in recovery, do synchronous transactions
> +	 * to ensure the commit hits the journal and move into the
> +	 * AIL. Once there are items in the AIL, it can move the
> +	 * tail of the log forwards itself.
>  	 */
> -	if (sync) {
> +	if (sync || 
> +	    ((mp->m_flags & XFS_MOUNT_RECOVERY) && !xfs_ail_min(mp->m_ail)) {
>  		error = xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
>  		XFS_STATS_INC(mp, xs_trans_sync);
> 
> The other option is that this can be put into the
> xfs_trans_reserve() code to set the XFS_TRANS_SYNC flag to trigger
> the log force in __xfs_trans_commit().

I will implement the fixes, test and post the patch once again. Thanks for the
review comments.

> 
> > +			spin_lock(&log->l_icloglock);
> > +			iclog = log->l_iclog;
> > +
> > +			if (iclog->ic_state == XLOG_STATE_ACTIVE
> > +				&& iclog->ic_offset) {
> > +				atomic_inc(&iclog->ic_refcnt);
> > +				xlog_state_want_sync(log, iclog);
> > +				spin_unlock(&log->l_icloglock);
> > +				xlog_state_release_iclog(log, iclog);
> > +
> > +				spin_lock(&log->l_icloglock);
> > +				xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> 
> As I suspected, that's just an open coded, cut down log force. And
> it has a bug in it - you can't drop the l_icloglock, then pick it
> back up and sleep immediately without redoing all the state checks
> again. The log IO may have completed and run the wakeups before you
> get the spinlock back, and so this will simply hang forever here.
> 
> So, yeah, I think getting log forces into the right places are
> the right way to go here...
> 
> Cheers,
> 
> Dave.
> 


-- 
chandan



