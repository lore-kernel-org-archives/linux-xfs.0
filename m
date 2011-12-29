Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBTB7Oo7000765
	for <linux-xfs@oss.sgi.com>; Thu, 29 Dec 2011 05:07:24 -0600
Received: from ppsw-52.csi.cam.ac.uk (ppsw-52.csi.cam.ac.uk [131.111.8.152])
	by cuda.sgi.com with ESMTP id j2ss7qiiwBpdpMrx for
	<linux-xfs@oss.sgi.com>; Thu, 29 Dec 2011 03:07:23 -0800 (PST)
Message-ID: <4EFC49E5.7050200@jeremysanders.net>
Date: Thu, 29 Dec 2011 11:07:17 +0000
From: Jeremy Sanders <jeremy@jeremysanders.net>
MIME-Version: 1.0
Subject: Re: bug in fs/xfs/xfs_aops.c:959! (kernel 3.1.5)
References: <jcn0ip$hsk$1@dough.gmane.org>
	<20111228171643.GA18895@infradead.org>
In-Reply-To: <20111228171643.GA18895@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com

On 28/12/11 17:16, Christoph Hellwig wrote:
> Something must have set the page dirty without going through the normal
> XFS codepath.  Did you use any interesting virtualization things, or
> utrace / systemtap or anything odd?

This is plain hardware running a Fedora 16 standard x86-64 kernel. The 
hardware has been fine running F14 a long time for a few years, though I 
got the same error when I tried to run a rebuilt F15 kernel on F14 
(2.6.38.8). See http://oss.sgi.com/archives/xfs/2011-07/msg00310.html

The problem happened very soon on upgrading from F14->F16.

Jeremy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
