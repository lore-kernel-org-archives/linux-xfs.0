Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 12:02:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LJ26qm024418
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 12:02:07 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F2DDFFD59E
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 12:02:39 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id moc0R0HaVzHKmsDK for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 12:02:39 -0700 (PDT)
Date: Fri, 21 Mar 2008 14:08:39 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] remove most calls to VN_RELE
Message-ID: <20080321180839.GD5433@josefsipek.net>
References: <20080319204914.GB24271@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319204914.GB24271@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Mar 19, 2008 at 09:49:14PM +0100, Christoph Hellwig wrote:
> Most VN_RELE calls either directly contain a XFS_ITOV or have the
> corresponding xfs_inode already in scope.  Use the IRELE helper instead
> of VN_RELE to clarify the code.  With a little more work we can kill
> VN_RELE altogether and define IRELE in terms of iput directly.

Looks good.

Josef 'Jeff' Sipek.

-- 
You measure democracy by the freedom it gives its dissidents, not the
freedom it gives its assimilated conformists.
		- Abbie Hoffman
