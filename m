Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 11:54:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39Is72b004491
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 11:54:09 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 328FB1211D2E
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 11:54:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id QkUQ7YZPDHLoGQtu for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 11:54:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1JjfRV-0001fn-AS
	for xfs@oss.sgi.com; Wed, 09 Apr 2008 18:54:45 +0000
Date: Wed, 9 Apr 2008 14:54:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Portability of libattr
Message-ID: <20080409185445.GA30834@infradead.org>
References: <20080409184103.GD20142@album.bayer.ipv6ia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409184103.GD20142@album.bayer.ipv6ia.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Apr 09, 2008 at 08:41:08PM +0200, petr.pisar@atlas.cz wrote:
> Hello,
> 
> I'm adding support for extended atributes into few applications.
> Unfortunatetally API for EA manipulation is not standartized and every
> operating system uses its own solution. I thought libattr from attr package
> could help me. However attr seems running on Linux (and maybe IRIX) only.
> 
> Therefore I've decided to use libc functions from every system directly. I've
> succesfully ported my code to Linux, IRIX and Darwin (Max OS X). Their AE
> syscalls are very similar. However FreeBSD API is more different. Because I'm
> extending more applications I need to share the code.
> 
> So, my qustions are: should I write my own library or should I extend libattr.
> As I can understand libattr code it's designed to port IRIX application on
> Linux. Am I right? Or are you going support more OS's in libattr? Or exists
> here some similar library providing unified interface fro more systems?

Note: I'm not the maintainer of libattr, so I'm not the one to decide.

I think adding more systems is an excellent idea as it's a bit of a
porting layer already.  Russell will have to add FreeBSD support anyway
once he ports xfsdump to FreeBSD :)
