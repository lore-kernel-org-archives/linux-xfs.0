Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2LK9WQF011615 for <xfs@oss.sgi.com>; Sat, 21 Mar 2009 15:09:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE9A11B4F88
	for <xfs@oss.sgi.com>; Sat, 21 Mar 2009 13:09:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YCO1ybRfPC73aNBY for
	<xfs@oss.sgi.com>; Sat, 21 Mar 2009 13:09:14 -0700 (PDT)
Date: Sat, 21 Mar 2009 16:09:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: remove m_litino
Message-ID: <20090321200914.GB15245@infradead.org>
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094132.224487000@bombadil.infradead.org>
	<49C465AC.3010809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49C465AC.3010809@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 20, 2009 at 10:57:32PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> 
> > With the upcoming v3 inodes the inode data/attr area size needs to be
> > calculated for each specific inode, so we can't cache it in the superblock
> > anymore.
> 
> hm, ok, but why do this now?

It could be considered a cleanup as there's no point in caching a
constant expression in the superblock.  More importantly I want to get
as many of the CRC preparation patches upstream so that I don't have
to keep rebasing them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
