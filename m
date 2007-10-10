Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 14:57:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9ALvfFL031487
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 14:57:43 -0700
Date: Thu, 11 Oct 2007 07:57:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: running xfs_repair on large partitions
Message-ID: <20071010215733.GL995458@sgi.com>
References: <20071010143337.GA2815@apartia.fr> <20071010191452.1fdad848@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071010191452.1fdad848@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@free.fr>
Cc: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 10, 2007 at 07:14:52PM +0200, Emmanuel Florac wrote:
> Le Wed, 10 Oct 2007 16:33:38 +0200 vous écriviez:
> 
> > 1) it would be nice to have a way to know xfs_repair's version (-V ?),
> > when using it from a rescue disk I'm never sure if I should get a newer
> > one.
> 
> Did you try "xfs_repair -V" as you suggest? On my system, it replies with
> the version...
> 
> > 2) on a 32bit system, using xfsprogs version 2.9.0 , it seems xfs_repair
> > will fail if its process exceeds 4G. Is that right? Is there a way to
> > circumvent that limitation?
> 
> No, this is precisely what 32 bits mean. A 32 bits process can't address
> more than 2^32 bits, which is 4GB.

I think it's 2GB for a process by default on linux, because the other 2GB
is used by the kernel. The split is configurable IIRC.

> However I'm surprised you have this
> problem; I've xfs_repaired up to 16TB filesystem (maximum manageable with a
> 32 bits kernel ) without such problem.

Memory usage depends on the number of inodes in the filesystem as well.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
