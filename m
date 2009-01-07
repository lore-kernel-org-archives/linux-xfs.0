Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07IuxD3023311 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 12:57:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32DFC6C3F8
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 10:56:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id W0cmKEEqvHOCGgiU for
	<xfs@oss.sgi.com>; Wed, 07 Jan 2009 10:56:59 -0800 (PST)
Date: Wed, 7 Jan 2009 13:56:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090107185628.GA19255@infradead.org>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107184420.GA15653@dth.net>
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
To: Danny ter Haar <dth@dth.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 07, 2009 at 07:44:20PM +0100, Danny ter Haar wrote:
> Quoting Christoph Hellwig (hch@infradead.org):
> > And error when compiling the kernel or you got the same error again?
> 
> same error while trying to boot (this time on sda (pata with libata))
> root filesystem of the OS partition.
> 
> > In case you can actually reproduce this error, I would be very
> > interested in a metadump of the filesystem that causes this error.
> 
> See the errorlog on: http://www.dth.net/kernel/c3/netconsole_2.6.28-git9-error.txt

This looks like pretty much the same corruption you saw in your first
report.  did you run xfs_repair before this one?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
