Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 01:43:43 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBJ9hXD1021261
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 01:43:34 -0800
Date: Wed, 19 Dec 2007 10:32:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] [PATCH] XFS: don't expose sysv device encoding in inode->i_rdev
Message-ID: <20071219093209.GA8775@lst.de>
References: <200712190404.lBJ44IOf003182@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712190404.lBJ44IOf003182@agora.fsl.cs.sunysb.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-masters@oss.sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

I've sent Dave a patch yesterday that fixes the problem in an even nicer
way by just removing the assignment in xfs_vn_mknod because we're doing
the proper translation deeper down in the stack.  The patch should
already be on it's way to Linus.
