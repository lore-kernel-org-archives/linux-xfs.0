Return-Path: <SRS0=0uIH=W3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3C5C3A59F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 06:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC9952343A
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 06:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfHaG5L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Aug 2019 02:57:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbfHaG5K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 31 Aug 2019 02:57:10 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7V6q8R1033226
        for <linux-xfs@vger.kernel.org>; Sat, 31 Aug 2019 02:57:09 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uqjgujgv9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 31 Aug 2019 02:57:09 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sat, 31 Aug 2019 07:57:07 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 31 Aug 2019 07:57:04 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7V6v3K124314132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 06:57:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD04711C04A;
        Sat, 31 Aug 2019 06:57:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2510E11C050;
        Sat, 31 Aug 2019 06:57:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.43.18])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 31 Aug 2019 06:57:01 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        hch@infradead.org
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before waiting for log space
Date:   Sat, 31 Aug 2019 12:28:47 +0530
Organization: IBM
In-Reply-To: <2367290.sgLJaTIShl@localhost.localdomain>
References: <20190821110448.30161-1-chandanrlinux@gmail.com> <20190830164750.GD26520@bfoster> <2367290.sgLJaTIShl@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19083106-0012-0000-0000-00000344E202
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19083106-0013-0000-0000-0000217F278F
Message-Id: <54049584.qczpgOBqR6@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-31_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908310078
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday, August 31, 2019 10:29 AM Chandan Rajendra wrote: 
> On Friday, August 30, 2019 10:17 PM Brian Foster wrote: 
> > On Fri, Aug 30, 2019 at 09:08:17AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 29, 2019 at 10:51:59AM +0530, Chandan Rajendra wrote:
> > > > On Monday, August 26, 2019 6:02 AM Dave Chinner wrote: 
> > > > > On Sun, Aug 25, 2019 at 08:35:17PM +0530, Chandan Rajendra wrote:
> > > > > > On Friday, August 23, 2019 7:08 PM Chandan Rajendra wrote:
> > > > > > 
> > > > > > Dave, With the above changes made in xfs_trans_reserve(), mount task is
> > > > > > deadlocking due to the following,
> > > > > > 1. With synchronous transactions, __xfs_trans_commit() now causes iclogs to be
> > > > > > flushed to the disk and hence log items to be ultimately moved to AIL.
> > > > > > 2. xfsaild task is woken up, which acts in items on AIL.
> > > > > > 3. After some time, we stop issuing synchronous transactions because AIL has
> > > > > >    log items in its list and hence !xfs_ail_min(tp->t_mountp->m_ail) evaluates to
> > > > > >    false. In xfsaild_push(), "XFS_LSN_CMP(lip->li_lsn, target) <= 0"
> > > > > >    evaluates to false on the first iteration of the while loop. This means we
> > > > > >    have a log item whose LSN is larger than xfs_ail->ail_target at the
> > > > > >    beginning of the AIL.
> > > > > 
> > > > > The push target for xlog_grant_push_ail() is to free 25% of the log
> > > > > space. So if all the items in the AIL are not within 25% of the tail
> > > > > end of the log, there's nothing for the AIL to push. This indicates
> > > > > that there is at least 25% of physical log space free.
> > > > 
> > > > Sorry for the late response. I was trying to understand the code flow.
> > > > 
> > > > Here is a snippet of perf trace explaining what is going on,
> > > > 
> > > > 	 760881:           mount  8654 [002]   216.813041:                         probe:xlog_grant_push_ail: (c000000000765864) comm="xfsaild/loop1" threshold_cycle_s32=3 threshold_block_s32=3970 need_bytes_s32=389328 last_sync_cycle_u32=2 last_sync_block_u32=19330 free_threshold_s32=5120 free_bytes_s32=383756 free_blocks_s32=749 l_logsize=10485760 reserve_cycle_s32=3 reserve_block_s32=9513204(~18580 blocks) tail_cycle_s32=2 tail_block_s32=19330
> > > 
> > > So this looks like last_sync_lsn is 2/19330, and the transaction
> > > reservation is ~380kB, or close on 3% of the log. The reserve grant
> > > head is at 3/18580, so we're ~700 * 512 = ~350kB of reservation
> > > remaining. Yup, so we are definitely in the "go to sleep and wait"
> > > situation here.
> > > 
> > > > 	 786576: kworker/4:1H-kb  1825 [004]   217.041079:                       xfs:xfs_log_assign_tail_lsn: dev 7:1 new tail lsn 2/19333, old lsn 2/19330, last sync 3/18501
> > > 
> > > 200ms later the tail has moved, and last_sync_lsn is now 3/18501.
> > > i.e. the iclog writes have made it to disk, and the items have been
> > > moved into the AIL. I don't know where that came from, but I'm
> > > assuming it's an IO completion based on it being run from a
> > > kworker context that doesn't have an "xfs-" name prefix(*).
> > > 
> > > As the tail has moved, this should have woken the anything sleeping
> > > on the log tail in xlog_grant_head_wait() via a call to
> > > xfs_log_space_wake(). The first waiter should wake, see that there
> > > still isn't room in the log (only 3 sectors were freed in the log,
> > > we need at least 60). That woken process should then run
> > > xlog_grant_push_ail() again and go back to sleep.
> > > 
> > > (*) I have a patch that shortens "s/kworker/kw/" so that you can
> > > actually see the name of the kworker in the 16 byte field we have
> > > for the task name. We really should just increase current->comm to
> > > 32 bytes.
> > > 
> > > > 	 786577: kworker/4:1H-kb  1825 [004]   217.041087:                       xfs:xfs_log_assign_tail_lsn: dev 7:1 new tail lsn 2/19333, old lsn 2/19330, last sync 3/18501
> > > > 	 793653:   xfsaild/loop1  8661 [004]   265.407708:                probe:xfsaild_push_last_pushed_lsn: (c000000000784644) comm="xfsaild/loop1" cycle_lsn_u32=0 block_lsn_u32=0 target_cycle_lsn_u32=2 target_block_lsn_u32=19330
> > > > 	 793654:   xfsaild/loop1  8661 [004]   265.407717:              probe:xfsaild_push_min_lsn_less_than: (c0000000007846a0) comm="xfsaild/loop1" less_than_s32=0 cycle_lsn_u32=2 block_lsn_u32=19333 lip_x64=0xc000000303fb4a48
> > > 
> > > Ans some 40s later the xfsaild is woken by something, sees there's
> > > nothing to do, and goes back to sleep. I don't see the process
> > > sleeping on the grant head being ever being woken and calling
> > > xlog_grant_push_ail(), which would see the new last_sync_lsn and
> > > move the push target....
> > > 
> > > From this trace, it looks like the problem here is a missing or
> > > incorrectly processed wakeup when the log tail moves.
> > > 
> > > Unfortunately, you haven't used the built in trace points for
> > > debugging log space hangs so I can't tell anything more than this.
> > > i.e the trace we need contains these build in tracepoints:
> > > 
> > > # trace-cmd record -e xfs_log\* -e xfs_ail\* sleep 120 &
> > > # <run workload that hangs within 120s>
> > > 
> > > <wait for trace-cmd to exit>
> > > # trace-cmd report | gzip > trace.txt.gz
> > > 
> > > as that will record all transaction reservations, grant head
> > > manipulations, changes to the tail lsn, when processes sleep on the
> > > grant head and are worken, AIL insert/move/delete, etc.
> > > 
> > > This will generate a -lot- of data. I often generate and analyse
> > > traces in the order of tens of GBs of events to track down issues
> > > like this, because the problem is often only seen in a single trace
> > > event in amongst the millions that are recorded....
> > > 
> > > And if we need more info, then we add the appropriate tracepoints
> > > into xlog_grant_push_ail, xfsaild_push, etc under those tracepoint
> > > namespaces, so next time we have a problem we don't ahve to write
> > > custom tracepoints.....
> > > 
> > > > i.e the log size was 2560 * 4096 = 10485760 bytes.
> > > 
> > > The default minimum size.
> > > 
> > > > > I suspect that this means the CIL is overruning it's background push
> > > > > target by more than expected probably because the log is so small. That leads
> > > > > to the outstanding CIL pending commit size (the current CIL context
> > > > > and the previous CIL commit that is held off by the uncommited
> > > > > iclog) is greater than the AIL push target, and so nothing will free
> > > > > up more log space and wake up the transaction waiting for grant
> > > > > space.
> > > > > 
> > > > > e.g. the previous CIL context commit might take 15% of the log
> > > > > space, and the current CIL has reserved 11% of the log space.
> > > > > Now new transactions reservations have run out of grant space and we
> > > > > push on the ail, but it's lowest item is at 26%, and so the AIL push
> > > > > does nothing and we're stuck because the CIL has pinned 26% of the
> > > > > log space.
> > > > > 
> > > > > As a test, can you run the test with larger log sizes? I think
> > > > > the default used was about ~3600 blocks, so it you step that up by
> > > > > 500 blocks at a time we should get an idea of the size of the
> > > > > overrun by the size of the log where the hang goes away. A
> > > > > trace of the transaction reservations and AIL pushing would also be
> > > > > insightful.
> > > > 
> > > > After increasing the log size to 4193 blocks (i.e. 4193 * 4k = 17174528
> > > > bytes) and also the patch applied, I don't see the dead lock happening.
> > > 
> > > Likely because now the 380k transaction reservation is only 2% of the
> > > log instead of close to 4% of the log, and so the overrun isn't
> > > large enough to trigger whatever wakeup issue we have....
> > > 
> > > > Meanwhile, I am planning to read more code to map the explaination
> > > > provided below.
> > > 
> > > Can you get a complete trace (as per above) of a hang? we're going
> > > to need that trace to validate any analysis you do yourself,
> > > anyway...
> > > 
> > 
> > FWIW, I finally managed to reproduce this (trace dump attached for
> > reference). I ultimately moved to another system, starting using loop
> > devices and bumped up the fstests LOAD_FACTOR. What I see is essentially
> > what looks like the lack of a wake up problem described above. More
> > specifically:
> > 
> > - Workload begins, background CIL push occurs for ~1.25MB context.
> > - While the first checkpoint is being written out, another background
> >   push is requested. By the time we can execute the next CIL push, the
> >   second context accrues to ~8MB in size, basically consuming the rest of
> >   the log.
> > 
> > So that essentially describes the delay. It's just a matter of timing
> > due to the amount of time it takes to complete the first checkpoint and
> > start the second vs. the log reservation consumption workload.
> > 
> > - The next CIL push executes, but all transaction waiters block before
> >   the iclog with the commit record for the first checkpoint hits the
> >   log.
> > 
> > So the AIL doesn't actually remain empty indefinitely here. Shortly
> > after the second CIL push starts doing I/O, the items from the first
> > checkpoint make it into the AIL. The problem is just that the AIL stays
> > empty long enough to absorb all of the AIL pushes that occur due to
> > log reservation pressure before everything stops.
> > 
> > I think the two extra AIL push patches Dave has posted are enough to
> > keep things moving. So far I haven't been able to reproduce with those
> > applied (though I applied a modified variant of the second)...
> > 
> 
> I am able to recreate the bug without the "synchronous transaction" patch. I
> am attaching the trace file with this mail.

I think it essentially boils down to the fact that without "synchronous
transactions" during log recovery, the last iclog containing the commit record
wouldn't be submitted for I/O since in the case of this bug we have more than
"2*sizeof(xlog_op_header_t)" space left in it.

Without the "synchronous transaction" change, the patch which initiates the
AIL push from the iclog endio function would be ineffective.

-- 
chandan



