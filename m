Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18Jdkp0155840 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 13:39:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76A271BA84B
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 11:40:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id H0t8Q6mX9vj2YEDc for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2010 11:40:59 -0800 (PST)
Date: Mon, 8 Feb 2010 14:40:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix up fs_perms test used by 126
Message-ID: <20100208194058.GC9527@infradead.org>
References: <4B6C4E81.6060201@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B6C4E81.6060201@sandeen.net>
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
Cc: Theodore Tso <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 05, 2010 at 10:59:45AM -0600, Eric Sandeen wrote:
> @@ -53,7 +53,8 @@ int main( int argc, char *argv[]) {
>                cgroupId = atoi(argv[3]);
>                userId = atoi(argv[4]);
>                groupId = atoi(argv[5]);
> -              fperm[0] = *argv[6];
> +              strncpy(fperm, argv[6], 3);
> +              fperm[2] = '\0';

This still looks rather weird to me.  What's the reason for copying
the string into a fixed length buffer?  Why not leave fperm as a pointer
to the original argument?

The rest of the patch looks fine, but a clean up pass on the whole
file wouldn't hurt either, it's a grotty mess..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
