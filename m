Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n13L5Xda092570 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 15:05:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B098518B7B3B
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 13:04:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eXhkv5IGmn5RcUTj for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 13:04:54 -0800 (PST)
Date: Tue, 3 Feb 2009 16:04:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reproducible xfs/vmap oops
Message-ID: <20090203210423.GA26628@infradead.org>
References: <20090201081224.GA22398@infradead.org>
	<20090201161458.GA5930@infradead.org>
	<20090203155147.GB21278@infradead.org>
	<200902040303.13933.nickpiggin@yahoo.com.au>
	<20090203160515.GA30986@infradead.org>
	<20090203184409.GA22204@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090203184409.GA22204@infradead.org>
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
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: xfs@oss.sgi.com

[ 3138.799436] XFS mounting filesystem vde
[ 3138.813184] va->va_start = 4290777088, va->va_end = 4096
[ 3138.834754] tmp->va_start = 4195352576, tmp->va_end = 4196401152
[ 3138.846352] ------------[ cut here ]------------
[ 3138.850332] kernel BUG at mm/vmalloc.c:298!
[ 3138.850332] invalid opcode: 0000 [#1] SMP 

The first va_end looks suspicious to me..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
