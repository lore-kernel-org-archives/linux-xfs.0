Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CF2E7F84
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 15:33:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC421AC007
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 13:33:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id zzgnGZK7yhNvLMKh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 13:33:21 -0700 (PDT)
Date: Tue, 15 Oct 2013 13:33:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: syslinux xfs support
Message-ID: <20131015203319.GA20191@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: pcacjr@zytor.com
Cc: xfs@oss.sgi.com

Hi Paulo,

just wondering what the state of the xfs support for syslinux is?  I
talked to Peter at Linuxcon and he thought it's merged, but looking at
the kernel.org tree I can't find the support.

Also when looking over your branches I noticed that you're using a free
sector in the first filesystem block to store the bootloader.  If we
want to go down that route we need to make sure to reserve this sector,
otherwise it might get taken up by newly added metadata.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
