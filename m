Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F3677CBD
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 16:51:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8390EAC005
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 14:51:52 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9BWIiW1prnVHB0Zg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2016 14:51:49 -0700 (PDT)
Date: Tue, 20 Sep 2016 14:51:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Excessive xfs_inode allocations trigger OOM killer
Message-ID: <20160920215147.GA31614@infradead.org>
References: <87a8f2pd2d.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87a8f2pd2d.fsf@mid.deneb.enyo.de>
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
To: Florian Weimer <fw@deneb.enyo.de>
Cc: xfs@oss.sgi.com

Hi Florian,

can you check if you have CONFIG_COMPACTION enabled in your kernel
config?  There have been some regressions in the VM code lately that
made me see similar OOM killer rampage runs, which went away after I
followed some linux-mm advise to turn it on.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
