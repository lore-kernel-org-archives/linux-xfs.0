Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G76Dkb074339 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:06:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA2E61C44E9E
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 00:05:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9C0UBqmtDIFCCiKc for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 00:05:52 -0700 (PDT)
Date: Mon, 16 Mar 2009 03:05:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090316070550.GA628@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<20090304172727.GA21463@infradead.org>
	<200903081409.28808.agruen@suse.de>
	<200903101741.07043.agruen@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200903101741.07043.agruen@suse.de>
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
Cc: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 10, 2009 at 05:41:06PM +0100, Andreas Gruenbacher wrote:
> As it turns out, I was running into more trouble with libtoolize from libtool 
> 2.2.6. See this commit in attr.git:
> 
>   commit 604290f79a199eb0c73a0cd05a473e1801a00673
>   Author: Andreas Gruenbacher <agruen@suse.de>
>   Date:   Tue Mar 10 17:00:35 2009 +0100
> 
>     More libtoolize fixes

That patch breaks the commit for me:

hch@brick:~/work/attr$ make
libtoolize -c -i -f
libtoolize: unrecognized option `-i'
Try `libtoolize --help' for more information.
make: *** [include/builddefs] Error 1


This is on debian -testing with libtool 1.5.26

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
