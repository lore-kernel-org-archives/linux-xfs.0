Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2PJ4QKN111795 for <xfs@oss.sgi.com>; Wed, 25 Mar 2009 14:04:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38E381C6EBA2
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2009 12:03:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jRSdHWtiYzinrTX5 for
	<xfs@oss.sgi.com>; Wed, 25 Mar 2009 12:03:40 -0700 (PDT)
Date: Wed, 25 Mar 2009 15:03:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090325190334.GA18742@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<20090316210249.GA2641@infradead.org>
	<20090324131249.GA6964@infradead.org>
	<200903241918.39649.agruen@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200903241918.39649.agruen@suse.de>
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
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 24, 2009 at 07:18:39PM +0100, Andreas Gruenbacher wrote:
> It would seem so but the build system simply ignores files in the file list 
> that don't exist. This is all rather ugly, but at least the result works...

Oh well.  I've now pushed these patches to xfsprogs, xfsdump and dmapi
as authored by you and reviewed by me as they were straight-forward
ports.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
