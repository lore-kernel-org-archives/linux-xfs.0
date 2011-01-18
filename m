Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ICkkI0128752 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 06:46:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7821271880
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 04:49:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xjJguCPlbB6pkqjU for
	<xfs@oss.sgi.com>; Tue, 18 Jan 2011 04:49:04 -0800 (PST)
Date: Tue, 18 Jan 2011 07:49:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Xfsprogs: add fiemap command to xfs_io
Message-ID: <20110118124904.GA21440@infradead.org>
References: <1295009501-17794-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295009501-17794-1-git-send-email-josef@redhat.com>
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

On Fri, Jan 14, 2011 at 07:51:41AM -0500, Josef Bacik wrote:
> When trying to add a test for hole punching I noticed that the "bmap" command
> only works on XFS, which makes testing hole punching on other fs's kind of
> difficult.  To fix this I've added an fiemap command that works almost exactly
> like bmap.  It is formatted similarly and takes similar flags, the only thing
> thats different is obviously it doesn't spit out AG info and it doesn't make
> finding prealloc space optional.  This is my first foray into all of this stuff
> so a good hard look would be appreciated.  I tested it with a few different
> files to make sure bmap and fiemap both looked the same.  Thanks,

Looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
