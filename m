Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2M9vSRG011487
	for <linux-xfs@oss.sgi.com>; Tue, 22 Mar 2011 04:57:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED42E13EC162
	for <linux-xfs@oss.sgi.com>; Tue, 22 Mar 2011 03:00:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id z1YXD3TCXyE93GWX for
	<linux-xfs@oss.sgi.com>; Tue, 22 Mar 2011 03:00:18 -0700 (PDT)
Date: Tue, 22 Mar 2011 06:00:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110322100017.GA3532@infradead.org>
References: <081DDE43F61F3D43929A181B477DCA95639B52E8@MSXAOA6.twosigma.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B52E8@MSXAOA6.twosigma.com>
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
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Martin Bligh <Martin.Bligh@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>

> We started testing with 2.6.38-rc7 and have seen this bug through to the .0 release.  This does not appear to be present in 2.6.33, but we have not done testing in between.  We have tested with ext4 and do not encounter this bug.

Does reverting commit aea1b9532143218f8599ecedbbd6bfbf812385e1 fix the
issue for you?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
