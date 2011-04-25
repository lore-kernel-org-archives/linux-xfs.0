Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3P7xAqV106101 for <xfs@oss.sgi.com>; Mon, 25 Apr 2011 02:59:10 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EA641D5FBF2
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2011 01:02:41 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id rCqvTwNGKnp0wwPM for
	<xfs@oss.sgi.com>; Mon, 25 Apr 2011 01:02:41 -0700 (PDT)
Date: Mon, 25 Apr 2011 01:02:33 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110424234655.GC12436@dastard>
Message-ID: <alpine.DEB.2.01.1104250053590.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, 25 Apr 2011 at 09:46, Dave Chinner wrote:
> BTW, what are your mount options? If it is the problem I suspect it
> is, then using noatime with stop it from occurring....

When mounted with noatime, running du(1) accross the XFS volume still 
triggered the OOM killer, but the backtrace looked somewhat different 
this time:

 date invoked oom-killer: gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
 Call Trace:
 [ecda5c70] [c0009ce4] show_stack+0x70/0x1bc (unreliable)
 [ecda5cb0] [c008f508] T.528+0x74/0x1cc
 [ecda5d00] [c008f734] T.526+0xd4/0x2a0
 [ecda5d40] [c008fb7c] out_of_memory+0x27c/0x360
 [ecda5d90] [c0093b3c] __alloc_pages_nodemask+0x6f8/0x708
 [ecda5e30] [c0017e9c] pte_alloc_one+0x30/0x90
 [ecda5e40] [c00a9464] __pte_alloc+0x2c/0x100
 [ecda5e60] [c00a95a8] handle_mm_fault+0x70/0x110
 [ecda5e90] [c0016d78] do_page_fault+0x358/0x504
 [ecda5f40] [c0012938] handle_page_fault+0xc/0x80
 --- Exception: 401 at 0xffdd5e0
     LR = 0xffd8a04

Full dmesg & slabinfo & more on: 

http://nerdbynature.de/bits/2.6.39-rc4/oom/

(slabinfo-5.txt.bz2, messages-5.txt)

Christian.
-- 
BOFH excuse #176:

vapors from evaporating sticky-note adhesives

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
