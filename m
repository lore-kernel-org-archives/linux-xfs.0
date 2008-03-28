Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Mar 2008 08:46:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2SFk1BJ025905
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 08:46:01 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50BD98A6773
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 08:46:35 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id EO1oOSBnRyFPWUt1 for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 08:46:35 -0700 (PDT)
Date: Fri, 28 Mar 2008 11:46:05 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] do not test return value of xfs_bmap_*_count_leaves
Message-ID: <20080328154605.GA28322@josefsipek.net>
References: <1206719011.8339.6.camel@marzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206719011.8339.6.camel@marzo>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <ruben.porras@linworks.de>
Cc: xfs@oss.sgi.com

On Fri, Mar 28, 2008 at 04:43:31PM +0100, Ruben Porras wrote:
> These functions, xfs_bmap_count_leaves and xfs_bmap_disk_count_leaves,
> return always 0. Therefore it is not necessary to test the return value.
 
If it always returns 0, why not make it void?

Josef 'Jeff' Sipek.

-- 
Hegh QaQ law'
quvHa'ghach QaQ puS
