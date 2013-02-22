Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E82327F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 17:50:32 -0600 (CST)
Date: Fri, 22 Feb 2013 17:50:29 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/9] xfs: metadata CRCs, kernel, first batch
Message-ID: <20130222235029.GA30652@sgi.com>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<20130222151931.GU22182@sgi.com> <20130222231217.GA26081@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130222231217.GA26081@dastard>
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

Hi Dave,

On Sat, Feb 23, 2013 at 10:12:17AM +1100, Dave Chinner wrote:
> On Fri, Feb 22, 2013 at 09:19:31AM -0600, Ben Myers wrote:
> > Dave,
> > 
> > Dunno if you've seen this one:
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 00000000000000d0
> > [601393.932814] IP: [<ffffffffa06e5dcc>] xfs_dquot_buf_verify+0x1c/0xb0 [xfs]
> .....
> > [601393.932814] Call Trace:
> > [601393.932814]  [<ffffffffa06e7b89>] xfs_dquot_buf_write_verify+0x29/0x90 [xfs]
> > [601393.932814]  [<ffffffff811db523>] ? blk_finish_plug+0x13/0x50
> > [601393.932814]  [<ffffffffa0676058>] _xfs_buf_ioapply+0x68/0x360 [xfs]
> > [601393.932814]  [<ffffffff810696b0>] ? try_to_wake_up+0x2b0/0x2b0
> > [601393.932814]  [<ffffffffa0677b23>] xfs_buf_iorequest+0x53/0x70 [xfs]
> > [601393.932814]  [<ffffffffa0677e25>] xfs_bdstrat_cb+0x35/0x60 [xfs]
> > [601393.932814]  [<ffffffffa0677f98>] __xfs_buf_delwri_submit+0x148/0x1c0 [xfs]
> > [601393.932814]  [<ffffffffa067803b>] xfs_buf_delwri_submit+0x2b/0x90 [xfs]
> > [601393.932814]  [<ffffffffa06d1de1>] xlog_recover_commit_trans+0x111/0x120 [xfs]
> > [601393.932814]  [<ffffffffa06d1ff1>] xlog_recover_process_data+0x201/0x2b0 [xfs]
> > [601393.932814]  [<ffffffffa06d257c>] xlog_do_recovery_pass+0x4dc/0x760 [xfs]
> > [601393.932814]  [<ffffffff8103e3b5>] ? console_unlock+0x265/0x3a0
> > [601393.932814]  [<ffffffffa06d289c>] xlog_do_log_recovery+0x9c/0x110 [xfs]
> > [601393.932814]  [<ffffffffa06d2933>] xlog_do_recover+0x23/0x1e0 [xfs]
> 
> This is mentioned in the patch zero description:
> 
> "This series makes is through to 001-092 in xfstests - there is a
> problem in the dquot verifier that causes log recovery of dquot
> buffers to follow a NULL pointer."
>
> Basically, mp->m_quotainfo is not initialised until after log
> recovery occurs, so this has to be detected in the verify/crc
> routines otherwise it goes splat like above. My current patch series
> has this fixed.

Cool.  Sorry for the extra noise.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
