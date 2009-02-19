Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1JJaPCx125265 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 13:36:25 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8061E196B5BF
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 11:35:53 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ey6ysIoCyVALzX7K for
	<xfs@oss.sgi.com>; Thu, 19 Feb 2009 11:35:53 -0800 (PST)
Date: Thu, 19 Feb 2009 14:35:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS and XEN
Message-ID: <20090219193552.GB22736@infradead.org>
References: <20090217091124.GA7118@infradead.org>
	<93532303b1bb223328b2aaf712e0022f@webmail.zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <93532303b1bb223328b2aaf712e0022f@webmail.zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Feb 17, 2009 at 03:00:39PM +0100, Michael Monnerie wrote:
> "Christoph Hellwig" <hch@infradead.org> schrieb:
> > I'm not even sure the Xen driver implements barriers.  I haven't done
> > much with Xen, but with the default kvm/qemu config I can completely
> > wreck ext3 and XFS filesystems.  If using these virtualization solutions
> > make sure you do not cache the virtual block device in the host
> > pagecache, and that in doubt the write cache of the disk is turned off
> > as barriers most likely won't work through the virtualization stack.
> 
> How can I do that?

Barriers are disabled using hdparm.  To make sure qemu/kvm doesn't
cache your image file specify cache=off on the command line specifying
that virtual disk.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
