Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o81AOIKI128172 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 05:24:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A82DE179B80F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 03:24:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3H3AhRDIi3VG01Tp for
	<xfs@oss.sgi.com>; Wed, 01 Sep 2010 03:24:58 -0700 (PDT)
Date: Wed, 1 Sep 2010 06:24:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS Quota Check OOM
Message-ID: <20100901102457.GG31648@infradead.org>
References: <4C7BA0A0.5090202@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C7BA0A0.5090202@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: xfs@oss.sgi.com

On Mon, Aug 30, 2010 at 02:14:24PM +0200, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> on one of our systems i want to activate prjquota support. The
> relevant disk is the root disk so i added prjquota to rootflags
> kernel line.
> 
> But when i do so i always get OOM out of Memory while checking
> quota's. I also upgraded the system from 8GB to 16GB RAM but still
> the same. Kernel is vanilla 2.6.32.19.

Can you post your kernel log with the OOM messages and if existing
any messages from XFS before that?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
