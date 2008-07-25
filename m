Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 22:19:44 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6P5JeVw016801
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:19:41 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0882B19257EB
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:20:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id s3WK1NOScCHeSHGC for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:20:51 -0700 (PDT)
Date: Fri, 25 Jul 2008 01:20:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Corruption of in-memory data detected - on heavy  hard linking
Message-ID: <20080725052051.GA26367@infradead.org>
References: <48876D03.8010804@stepping-stone.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48876D03.8010804@stepping-stone.ch>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Affolter <christian.affolter@stepping-stone.ch>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 07:40:19PM +0200, Christian Affolter wrote:
> Kernel-Error:
> Filesystem "sdc1": XFS internal error xfs_trans_cancel at line 1163 of  
> file fs/xfs/xfs_trans.c.  Caller 0xffffffff803a4fcf
> Pid: 22816, comm: cp Not tainted 2.6.24-gentoo-r8 #1

2.6.24 is pretty old.  Did you try with a recent kernel?  We had some
fixes for in-core memory corruption although I don't remember one in
this area.
