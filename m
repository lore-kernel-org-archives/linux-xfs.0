Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED1DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 17:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B1EB205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 17:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0c8PYhpw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389715AbgEMRGy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 13:06:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59720 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEMRGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 13:06:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DH3B8O024607;
        Wed, 13 May 2020 17:06:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mkg1wHCY1P50OMIMn32ocwGwZb7EXvdTbBODlUiDKJI=;
 b=0c8PYhpwiU+sain05RPIcLY8VEOVMpR7JdZ66O9q9RD2S3p8cFwMReZ55LWyOBp1/65D
 1+Q0/t6DpsMpZW9IyCTcOZPmLXNtZeB3Hf6615jm+8BqKYjH3cGrslyueDOJ1z38qJ1u
 6a3TXxN5UP5R9seT809MpVZ2oenn+kij0caTMVXxDVut8PO5nSjkdEZoxpwFJzF4dBmC
 91BtLqS3lttaLBTzwMU/SUOe596bRg1J3QGHMTjUUN2TFdNHeqBSDttMPnAL7w0JZumo
 K7ngYoKN1oPuGvW6q+JuveR9IPDRrBLvQByJOQYE4T/osMZYMIPA6E7hrqbAfetkPowz 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3100xwdfnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 17:06:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DH43wW161455;
        Wed, 13 May 2020 17:06:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3100yeybnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 17:06:49 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04DH6mGH003946;
        Wed, 13 May 2020 17:06:48 GMT
Received: from localhost (/10.159.244.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 10:06:48 -0700
Date:   Wed, 13 May 2020 10:06:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: use ordered buffers to initialize dquot buffers
 during quotacheck
Message-ID: <20200513170647.GE1984748@magnolia>
References: <20200512210033.GL6714@magnolia>
 <20200513131415.GC44225@bfoster>
 <20200513152628.GV6714@magnolia>
 <20200513161223.GA45326@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513161223.GA45326@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=1 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 12:12:23PM -0400, Brian Foster wrote:
> On Wed, May 13, 2020 at 08:26:28AM -0700, Darrick J. Wong wrote:
> > On Wed, May 13, 2020 at 09:14:15AM -0400, Brian Foster wrote:
> > > On Tue, May 12, 2020 at 02:00:33PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > While QAing the new xfs_repair quotacheck code, I uncovered a quota
> > > > corruption bug resulting from a bad interaction between dquot buffer
> > > > initialization and quotacheck.  The bug can be reproduced with the
> > > > following sequence:
> > > > 
> > > > # mkfs.xfs -f /dev/sdf
> > > > # mount /dev/sdf /opt -o usrquota
> > > > # su nobody -s /bin/bash -c 'touch /opt/barf'
> > > > # sync
> > > > # xfs_quota -x -c 'report -ahi' /opt
> > > > User quota on /opt (/dev/sdf)
> > > >                         Inodes
> > > > User ID      Used   Soft   Hard Warn/Grace
> > > > ---------- ---------------------------------
> > > > root            3      0      0  00 [------]
> > > > nobody          1      0      0  00 [------]
> > > > 
> > > > # xfs_io -x -c 'shutdown' /opt
> > > > # umount /opt
> > > > # mount /dev/sdf /opt -o usrquota
> > > > # touch /opt/man2
> > > > # xfs_quota -x -c 'report -ahi' /opt
> > > > User quota on /opt (/dev/sdf)
> > > >                         Inodes
> > > > User ID      Used   Soft   Hard Warn/Grace
> > > > ---------- ---------------------------------
> > > > root            1      0      0  00 [------]
> > > > nobody          1      0      0  00 [------]
> > > > 
> > > > # umount /opt
> > > > 
> > > > Notice how the initial quotacheck set the root dquot icount to 3
> > > > (rootino, rbmino, rsumino), but after shutdown -> remount -> recovery,
> > > > xfs_quota reports that the root dquot has only 1 icount.  We haven't
> > > > deleted anything from the filesystem, which means that quota is now
> > > > under-counting.  This behavior is not limited to icount or the root
> > > > dquot, but this is the shortest reproducer.
> > > > 
> > > > I traced the cause of this discrepancy to the way that we handle ondisk
> > > > dquot updates during quotacheck vs. regular fs activity.  Normally, when
> > > > we allocate a disk block for a dquot, we log the buffer as a regular
> > > > (dquot) buffer.  Subsequent updates to the dquots backed by that block
> > > > are done via separate dquot log item updates, which means that they
> > > > depend on the logged buffer update being written to disk before the
> > > > dquot items.  Because individual dquots have their own LSN fields, that
> > > > initial dquot buffer must always be recovered.
> > > > 
> > > > However, the story changes for quotacheck, which can cause dquot block
> > > > allocations but persists the final dquot counter values via a delwri
> > > > list.  Because recovery doesn't gate dquot buffer replay on an LSN, this
> > > > means that the initial dquot buffer can be replayed over the (newer)
> > > > contents that were delwritten at the end of quotacheck.  In effect, this
> > > > re-initializes the dquot counters after they've been updated.  If the
> > > > log does not contain any other dquot items to recover, the obsolete
> > > > dquot contents will not be corrected by log recovery.
> > > > 
> > > > Because quotacheck uses a transaction to log the setting of the CHKD
> > > > flags in the superblock, we skip quotacheck during the second mount
> > > > call, which allows the incorrect icount to remain.
> > > > 
> > > > Fix this by changing the ondisk dquot initialization function to use
> > > > ordered buffers to write out fresh dquot blocks if it detects that we're
> > > > running quotacheck.  If the system goes down before quotacheck can
> > > > complete, the CHKD flags will not be set in the superblock and the next
> > > > mount will run quotacheck again, which can fix uninitialized dquot
> > > > buffers.  This requires amending the defer code to maintaine ordered
> > > > buffer state across defer rolls for the sake of the dquot allocation
> > > > code.
> > > > 
> > > > For regular operations we preserve the current behavior since the dquot
> > > > items require properly initialized ondisk dquot records.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_defer.c |   10 ++++++++-
> > > >  fs/xfs/xfs_dquot.c        |   51 ++++++++++++++++++++++++++++++++++-----------
> > > >  2 files changed, 47 insertions(+), 14 deletions(-)
> > > > 
> > > ...  
> > > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > > index 7f39dd24d475..cf8b2f4de587 100644
> > > > --- a/fs/xfs/xfs_dquot.c
> > > > +++ b/fs/xfs/xfs_dquot.c
> > > ...
> > > > @@ -277,11 +279,34 @@ xfs_qm_init_dquot_blk(
> > > >  		}
> > > >  	}
> > > >  
> > > > -	xfs_trans_dquot_buf(tp, bp,
> > > > -			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
> > > > -			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
> > > > -			     XFS_BLF_GDQUOT_BUF)));
> > > > -	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
> > > > +	if (type & XFS_DQ_USER) {
> > > > +		qflag = XFS_UQUOTA_CHKD;
> > > > +		blftype = XFS_BLF_UDQUOT_BUF;
> > > > +	} else if (type & XFS_DQ_PROJ) {
> > > > +		qflag = XFS_PQUOTA_CHKD;
> > > > +		blftype = XFS_BLF_PDQUOT_BUF;
> > > > +	} else {
> > > > +		qflag = XFS_GQUOTA_CHKD;
> > > > +		blftype = XFS_BLF_GDQUOT_BUF;
> > > > +	}
> > > > +
> > > > +	xfs_trans_dquot_buf(tp, bp, blftype);
> > > > +
> > > > +	/*
> > > > +	 * If the CHKD flag isn't set, we're running quotacheck and need to use
> > > > +	 * ordered buffers so that the logged initialization buffer does not
> > > > +	 * get replayed over the delwritten quotacheck buffer.  If we crash
> > > > +	 * before the end of quotacheck, the CHKD flags will not be set in the
> > > > +	 * superblock and we'll re-run quotacheck at next mount.
> > > > +	 *
> > > > +	 * Outside of quotacheck, dquot updates are logged via dquot items and
> > > > +	 * we must use the regular buffer logging mechanisms to ensure that the
> > > > +	 * initial buffer state is recovered before dquot items.
> > > > +	 */
> > > > +	if (mp->m_qflags & qflag)
> > > > +		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
> > > > +	else
> > > > +		xfs_trans_ordered_buf(tp, bp);
> > > 
> > > Ok, I think I follow what's going on here. quotacheck runs and allocates
> > > a dquot block and inits it in a transaction. Some time later quotacheck
> > > updates dquots in said block and queues the buffer in its own delwri
> > > list. Quotacheck completes, the buffer is written back and then the
> > > filesystem immediately crashes. We replay the content of the alloc/init
> > > transaction over the updated content in the block on disk. This isn't a
> > > problem outside of quotacheck because a subsequent dquot update would
> > > have also been logged instead of directly written back.
> > 
> > Correct.
> > 
> > > Therefore, the purpose of the change above is primarily to avoid logging
> > > the init of the dquot buffer during quotacheck. That makes sense, but
> > > what about the integrity of this particular transaction? For example,
> > > what happens if this transaction commits to the on-disk log and we crash
> > > before quotacheck completes and the buffer is written back? I'm assuming
> > > recovery would replay the dquot allocation but not the initialization,
> > > then quotacheck would run again and find the buffer in an unknown state
> > > (perhaps failing a read verifier?). Hm?
> > 
> > Yes, the read verifier can fail in quotacheck, but quotacheck reacts to
> > that by re-trying the buffer read with a NULL buffer ops (in
> > xfs_qm_reset_dqcounts_all).  Next, it calls xfs_qm_reset_dqcounts, which
> > calls xfs_dqblk_repair to reinitialize the dquot records.  After that,
> > xfs_qm_reset_dqcounts resets even more of the dquot state (counters,
> > timers, flags, warns).
> > 
> 
> Ok, I was thinking we might get back to this "read or allocate" path but
> it sounds like the earlier reset phase reads every chunk, does this
> verifier dance and reinits if necessary. It's somewhat unfortunate that
> we can create those conditions intentionally, but I suppose that's
> better than the current state in that we at least recover from it. We
> should probably document that somewhere to explain why ordering the
> buffer like this is safe in quotacheck context.

Yeah, I was trying to get everyone there in the comment above, but maybe
this ought to be more explicitly stated in the comment.  The current
version of that looks like:

	/*
	 * When quotacheck runs, we use delayed writes to update all the
	 * dquots on disk in an efficient manner instead of logging the
	 * individual dquot changes as they are made.
	 *
	 * Hence if we log the buffer that we allocate here, then crash
	 * post-quotacheck while the logged initialisation is still in
	 * the active region of the log, we can lose the information
	 * quotacheck wrote directly to the buffer. That is, log
	 * recovery will replay the dquot buffer initialisation over the
	 * top of whatever information quotacheck had written to the
	 * buffer.
	 *
	 * To avoid this problem, dquot allocation during quotacheck
	 * needs to avoid logging the initialised buffer, but we still
	 * need to have writeback of the buffer pin the tail of the log
	 * so that it is initialised on disk before we remove the
	 * allocation transaction from the active region of the log.
	 * Marking the buffer as ordered instead of logging it provides
	 * this behaviour.
	 *
	 * If we crash before quotacheck completes, a subsequent
	 * quotacheck run will re-allocate and re-initialize the dquot
	 * records as needed.
	 */
	if (!(mp->m_qflags & qflag))
		xfs_trans_ordered_buf(tp, bp);
	else
		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);


--D

> Brian
> 
> > In short, quotacheck will fix anything it doesn't like about the dquot
> > buffers that are attached to the quota inodes.
> > 
> > --D
> > 
> > > Brian
> > > 
> > > >  }
> > > >  
> > > >  /*
> > > > 
> > > 
> > 
> 
