Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C859F7CC5
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 16:54:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C1E1AC005
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 14:54:47 -0700 (PDT)
Received: from albireo.enyo.de (albireo.enyo.de [5.158.152.32]) by
	cuda.sgi.com with ESMTP id x7TVVTIZmCmT2aRc (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2016 14:54:45 -0700 (PDT)
From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: Excessive xfs_inode allocations trigger OOM killer
References: <87a8f2pd2d.fsf@mid.deneb.enyo.de>
	<20160920215147.GA31614@infradead.org>
Date: Tue, 20 Sep 2016 23:54:43 +0200
In-Reply-To: <20160920215147.GA31614@infradead.org> (Christoph Hellwig's
	message of "Tue, 20 Sep 2016 14:51:47 -0700")
Message-ID: <878tumme3g.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

* Christoph Hellwig:

> can you check if you have CONFIG_COMPACTION enabled in your kernel
> config?  There have been some regressions in the VM code lately that
> made me see similar OOM killer rampage runs, which went away after I
> followed some linux-mm advise to turn it on.

It's already turned on:

$ grep CONFIG_COMPACT /boot/config-4.7.1fw 
CONFIG_COMPACTION=y

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
