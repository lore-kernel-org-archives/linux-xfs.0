Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n02I2ntG019019 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 12:02:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65E841BFA1EE
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 10:02:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mAy8SjPFogXXzh54 for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 10:02:48 -0800 (PST)
Date: Fri, 2 Jan 2009 13:02:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] create xfstests install target
Message-ID: <20090102180247.GC29506@infradead.org>
References: <495D42CE.6060806@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <495D42CE.6060806@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jan 01, 2009 at 04:25:18PM -0600, Eric Sandeen wrote:
> Not sure what the best location for this is in the end, but that's
> just a one-line change in builddefs.in if it should move.  Currently
> it goes to whatever configure thinks "libexecdir" is.

I think that's incorrect. libexecdir is /usr/lib for FHS or /usr/libexec
for BSDish filesystem layouts, but /use should be read-only mountable.

Maybe /var/lib/xfstests as a start?  That seems to be the dumping ground
for random stuff that needs write access.  Even better would be keeping
the scripts under /usr/lib and the output in /var/lib, but that might
be too much work.

> +PKG_SBIN_DIR    = @sbindir@

This one doesn't actually seem to be used.

Otherwise looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
