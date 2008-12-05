Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB5HgH1l001276 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 11:42:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 282CC16BE727
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2008 09:42:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QQeFMrokfpPACqZo for
	<xfs@oss.sgi.com>; Fri, 05 Dec 2008 09:42:17 -0800 (PST)
Date: Fri, 5 Dec 2008 12:37:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix up xfs-cmds build after the parallel-fest
Message-ID: <20081205173716.GA8216@infradead.org>
References: <49396528.1090700@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49396528.1090700@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Fri, Dec 05, 2008 at 11:30:16AM -0600, Eric Sandeen wrote:
> My big parallel build patch lost the "make configure" target.
> This broke Makepkgs...
> 
> Now, IMHO, running configure from make is a little bass-ackwards;
> I'd probably prefer to have Makepkgs explicitly run:
> 
>  autoconf; configure --myoptions; make
> 
> but for now, this adds back in a workable "make configure" target.
> 
> Also fixed "make install-lib" for acl, which was failing
> in the man subdir.

Thanks, this fixes the dpkg build for me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
