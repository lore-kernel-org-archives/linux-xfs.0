Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n73CNpBE090003 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 07:23:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C293339FD85
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2009 05:24:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nS2f7UYGg7nTEpEX for
	<xfs@oss.sgi.com>; Mon, 03 Aug 2009 05:24:41 -0700 (PDT)
Date: Mon, 3 Aug 2009 08:24:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: kernel BUG at lib/radix-tree.c:464
Message-ID: <20090803122440.GA11033@infradead.org>
References: <alpine.DEB.2.01.0908022321060.5831@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0908022321060.5831@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Sun, Aug 02, 2009 at 11:28:21PM -0700, Christian Kujau wrote:
> Hi,
> 
> while lots of I/O (read, write) was in progress, this was captured via 
> remote syslog:

Can you test the patch I posted in
http://bugzilla.kernel.org/show_bug.cgi?id=13375 ?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
