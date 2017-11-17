Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56421 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422775AbdKQVoC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 16:44:02 -0500
Date: Fri, 17 Nov 2017 14:44:00 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [xfsprogs PATCH 1/2] xfs_io: add MAP_SYNC support to mmap()
Message-ID: <20171117214400.GB3910@linux.intel.com>
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-2-ross.zwisler@linux.intel.com>
 <20171117204021.GO5119@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171117204021.GO5119@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>

On Fri, Nov 17, 2017 at 12:40:21PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 17, 2017 at 01:25:23PM -0700, Ross Zwisler wrote:
> > Add support for a new -S flag to xfs_io's mmap command.  This opens the
> > mapping with the (MAP_SYNC | MAP_SHARED_VALIDATE) flags instead of the
> > standard MAP_SHARED flag.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > ---
<>
> > diff --git a/include/linux.h b/include/linux.h
> > index 6ce344c..4ee03ed 100644
> > --- a/include/linux.h
> > +++ b/include/linux.h
> > @@ -327,4 +327,9 @@ fsmap_advance(
> >  #define HAVE_GETFSMAP
> >  #endif /* HAVE_GETFSMAP */
> >  
> > +#ifndef HAVE_MAP_SYNC
> > +#define MAP_SYNC 0x80000
> > +#define MAP_SHARED_VALIDATE 0x3
> > +#endif /* HAVE_MAP_SYNC */
> 
> Hmm, what's the point of ifndef/define if you have an configure.ac check?

I'm following the example of HAVE_GETFSMAP.  It does a check to see if the
headers have proper support in m4/package_libcdev.m4, then has code in this
file to provide defines if they aren't provided in the system.

> > diff --git a/io/mmap.c b/io/mmap.c
> > index 7a8150e..520b037 100644
> > --- a/io/mmap.c
> > +++ b/io/mmap.c
> > @@ -42,7 +42,7 @@ print_mapping(
> >  	int		index,
> >  	int		braces)
> >  {
> > -	unsigned char	buffer[8] = { 0 };
> > +	char		buffer[8] = { 0 };
> >  	int		i;
> >  
> >  	static struct {
> > @@ -57,6 +57,10 @@ print_mapping(
> >  
> >  	for (i = 0, p = pflags; p->prot != PROT_NONE; i++, p++)
> >  		buffer[i] = (map->prot & p->prot) ? p->mode : '-';
> > +
> > +	if (map->map_sync)
> > +		sprintf(&buffer[i], " S");
> 
> Does buffer need enlarging here?

Nope.  The buffer is 8 chars, and the 'rwx\0' string only uses 4.
"rwx S\0" uses 6, so we're still good to go.
