Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59IMO6L052192 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 13:22:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C25C62E23F9
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 11:22:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9jbZYa4j03Da2SHf for
	<xfs@oss.sgi.com>; Tue, 09 Jun 2009 11:22:45 -0700 (PDT)
Date: Tue, 9 Jun 2009 14:22:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: enable still more tests for generic filesystems
Message-ID: <20090609182245.GA8282@infradead.org>
References: <4A2EA474.7070401@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A2EA474.7070401@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Tue, Jun 09, 2009 at 01:05:40PM -0500, Eric Sandeen wrote:
> Make the following tests _supported_fs generic:
> 
> 088 - test out CAP_DAC_OVERRIDE and CAP_DAC_SEARCH code
> 089 - Emulate the way Linux mount manipulates /etc/mtab
> 113 - aio-stress (explicitly mark as generic)
> 126 - tests various file permission options
> 129 - looptests
> 
> These all pass on ext3, ext4, btrfs, and gfs2 as well
> as xfs.
> 
> Also remove "generic" group from "groups," which was 
> accidentally added.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
