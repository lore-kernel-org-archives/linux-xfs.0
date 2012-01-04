Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04FC0Ih149423 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 09:12:00 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Lz2swJVW5JWa6Kcz for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 07:11:59 -0800 (PST)
Date: Wed, 4 Jan 2012 10:11:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_lsprojid: show quota project id for specified files
Message-ID: <20120104151158.GA4028@infradead.org>
References: <1323698792-25775-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323698792-25775-1-git-send-email-arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Mon, Dec 12, 2011 at 03:06:32PM +0100, Arkadiusz Mi??kiewicz wrote:
> There is no simple way for extracting quota project id for specified
> files, so here is a shell wrapper which makes this easy thing:
> 
> /home/something/aaa: 107919
> /home/something/bbb: 107923

Looks generally good, but is there any reason not to make it available
to normal users?  The only problem would be that we'd need to run
the original script through autoconf to generate one that contains
an absolute path to the xfs_io binary.

Also can you hack up a trivial man page for it, please?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
