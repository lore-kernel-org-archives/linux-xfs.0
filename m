Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1HE1FOm227149 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 08:01:16 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C43E1954A88
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 06:00:41 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id D7A4nBFBOmqYsrGL for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 06:00:41 -0800 (PST)
Received: from webmail.zmi.at (websrv1.zmi.at [212.69.162.199])
	by mailsrv1.zmi.at (Postfix) with ESMTP id D443B4050
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 15:00:40 +0100 (CET)
Date: Tue, 17 Feb 2009 15:00:39 +0100
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and XEN
Message-ID: <93532303b1bb223328b2aaf712e0022f@webmail.zmi.at>
In-Reply-To: <20090217091124.GA7118@infradead.org>
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
To: xfs@oss.sgi.com

"Christoph Hellwig" <hch@infradead.org> schrieb:
> I'm not even sure the Xen driver implements barriers.  I haven't done
> much with Xen, but with the default kvm/qemu config I can completely
> wreck ext3 and XFS filesystems.  If using these virtualization solutions
> make sure you do not cache the virtual block device in the host
> pagecache, and that in doubt the write cache of the disk is turned off
> as barriers most likely won't work through the virtualization stack.

How can I do that?

mfg zmi


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
