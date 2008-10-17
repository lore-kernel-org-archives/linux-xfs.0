Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 10:08:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9HH8KHb009514
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 10:08:20 -0700
Date: Fri, 17 Oct 2008 19:10:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: XFS_ERROR use - was Re: [PATCH] prevent NULL returns from d_obtain_alias
Message-ID: <20081017171000.GC18582@lst.de>
References: <20081015192839.GA867@lst.de> <E1KqWzC-00087u-TG@pomaz-ex.szeredi.hu> <20081016180947.GA26285@lst.de> <48F7D814.2080705@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F7D814.2080705@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, xfs-oss <xfs@oss.sgi.com>

> 
> Fair enough.
> But XFS_ERROR is used throughout the function.

Can we leave it the simple way for now?  I have to revamp that whole
function anyway as it's extremly buggy in many ways, especially when
used to open directories (can lead to multiple dentries for a single
directory - ouch) and then I'll kill the other uses.
