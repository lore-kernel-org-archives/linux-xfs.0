Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 23:16:03 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M7Fppv024968
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 23:15:55 -0800
Date: Fri, 22 Feb 2008 18:16:08 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Marking inode dirty latency > 1000 msec on XFS!
Message-ID: <20080222071608.GT155407@sgi.com>
References: <47B5DD9C.3080906@gmail.com> <47BE6C5C.2000605@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47BE6C5C.2000605@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, xfs@oss.sgi.com

On Fri, Feb 22, 2008 at 05:31:56PM +1100, Lachlan McIlroy wrote:
> Török Edwin wrote:
> >FWIW, this is a slow laptop hdd (5400 rpm, ST96812AS), but latency of 1
> >second is still big.
> >
> >Are there any settings I can tweak to reduce latency?
> Um, not that I am aware of.

Try using a filesystem that has lazy-count enabled.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
