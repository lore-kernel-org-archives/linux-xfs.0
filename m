Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QGsVaR153019 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 10:54:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB3D4294920
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 08:56:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id APU41NXFDNhpcxbX for
	<xfs@oss.sgi.com>; Wed, 26 Jan 2011 08:56:55 -0800 (PST)
Date: Wed, 26 Jan 2011 11:56:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Xfstests: make 014 only run on xfs
Message-ID: <20110126165654.GB27259@infradead.org>
References: <1296050729-17316-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1296050729-17316-1-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 26, 2011 at 09:05:29AM -0500, Josef Bacik wrote:
> This test relies on mounting with -o allocsize, which is an xfs specific mount
> option, so make the test only work on xfs.  Thanks,

Except for the recently added option it's fine for other filesystems.
Just conditionalize setting the option.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
