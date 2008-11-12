Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 01:37:42 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC9bZul031593
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:37:36 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25DAC154A7B7
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:37:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 6XOU2aPSSFwbh96D for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:37:35 -0800 (PST)
Date: Wed, 12 Nov 2008 04:37:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] kill xfs_dinode_core_t
Message-ID: <20081112093734.GG8896@infradead.org>
References: <20081027133912.GF1109@infradead.org> <20081031040205.GV17077@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031040205.GV17077@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 03:02:05PM +1100, Dave Chinner wrote:
> There's a problem with this patch somewhere. I haven't had it in my
> test stack for the last couple of days, and when I re-added it
> a couple of hours back after updating the base kernel and master
> branch I'm now getting shortform directory corruption from 
> xfsqa test 001. Platform is x86_64 UML:

Still can't reproduce it on either x86 or ppc64.  I'll give x86_64 a go
in the next days.
