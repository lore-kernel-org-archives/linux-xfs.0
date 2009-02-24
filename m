Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OGcsbH153889 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 10:38:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63D9814A5CA
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 08:38:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JDdSPrxlD8ZXFg0P for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 08:38:24 -0800 (PST)
Date: Tue, 24 Feb 2009 11:38:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS and XEN
Message-ID: <20090224163823.GA19811@infradead.org>
References: <200902170959.55077@zmi.at> <200902241604.29566@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902241604.29566@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Feb 24, 2009 at 04:04:24PM +0100, Michael Monnerie wrote:
> if you don't have highly reliable hardware, with redundant channels and 
> battery backed caches, etc. stay away from XFS.
> 
> it's a pity, but XFS is only as reliable as the hardware you give it.  
> in other words: you can be really sure that a software issue won't trash 
> your XFS filesystem; but also that a hardware failure definitely will.
> 
> ext3, OTOH, might not have such an impressive record of correctness; but 
> it's designed with redundancy in mind.  almost all vital structures are 
> either replicated or reconstructable from other hints.  that makes fsck 
> slow but effective, and in most cases, the journal analysis done when 
> remounting after an unclean shutdown is enough to put it back on track.
> 
> i sure wish i could use XFS in more circumstances, but the needed 
> hardware is prohibitive.

It's the usual BS.  The difference is just that you actually see the
corruption on XFS while it's pretty silent on extN.  If your Hardware
(or Hypervisor) is not reliable you _will_ lose data.  Either silently
or with a spectacular blowup if the filesystem actually has consistency
checking (which XFS has a lot).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
