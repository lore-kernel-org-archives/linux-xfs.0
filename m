Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 17:40:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S0dttL002138
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 17:39:57 -0700
Date: Thu, 28 Jun 2007 10:39:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070628003921.GW989688@sgi.com>
References: <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626231431.GO31489@sgi.com> <20070627034915.GR6652@schatzie.adilger.int> <20070627133657.GQ989688@sgi.com> <1182986916.15488.88.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182986916.15488.88.camel@edge.yarra.acx>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, xfs-oss <xfs@oss.sgi.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, Jun 28, 2007 at 09:28:36AM +1000, Nathan Scott wrote:
> On Wed, 2007-06-27 at 23:36 +1000, David Chinner wrote:
> > .... Allows setup_swap_extents() to use preallocated files on XFS
> > filesystems for swap files without ever needing to convert them.
> 
> Using unwritten extents (as opposed to the MKSWAP flag mentioned
> earlier) has the unfortunate down side of requiring transactions,
> possibly additional IO, and memory allocation during swap.  (but,
> this patch should probably go in regardless, as teaching generic
> code about unwritten extents is not a bad idea).

I don't think it does - swapfile I/O looks like it goes direct to
bio without passing through the filesystem.  When the swapfile is
mapped, it scans and records the extent map of the entire swapfile
in a separate structure and AFAICT the swap code uses that built map
without touching the filesystem at all.

If that is true then the written/unwritten state of the extents is
irrelevant; all we need is allocated disk space for the file and
swapping should work. And it's not like anyone should be reading
the contents of that swapfile through the filesystem, either. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
