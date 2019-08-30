Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838DDC3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52A8721721
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfH3L4O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:56:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfH3L4O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Aug 2019 07:56:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CFEB62CD811;
        Fri, 30 Aug 2019 11:56:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DED6A5C28C;
        Fri, 30 Aug 2019 11:56:12 +0000 (UTC)
Date:   Fri, 30 Aug 2019 07:56:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 02/15] xfs: mount-api - add fs parameter description
Message-ID: <20190830115611.GA25927@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652196787.2607.5728754014477374931.stgit@fedora-28>
 <20190827123945.GA10636@bfoster>
 <382570ef63437dec56927a0d969890f686831310.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <382570ef63437dec56927a0d969890f686831310.camel@themaw.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 30 Aug 2019 11:56:13 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 06:31:58PM +0800, Ian Kent wrote:
> On Tue, 2019-08-27 at 08:39 -0400, Brian Foster wrote:
> > On Fri, Aug 23, 2019 at 08:59:27AM +0800, Ian Kent wrote:
> > > The new mount-api uses an array of struct fs_parameter_spec for
> > > parameter parsing, create this table populated with the xfs mount
> > > parameters.
> > > 
> > > The new mount-api table definition is wider than the token based
> > > parameter table and interleaving the option description comments
> > > between each table line is much less readable than adding them to
> > > the end of each table entry. So add the option description comment
> > > to each entry line even though it causes quite a few of the entries
> > > to be longer than 80 characters.
> > > 
> > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > ---
> > >  fs/xfs/xfs_super.c |   48
> > > +++++++++++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 45 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index f9450235533c..74c88b92ce22 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -38,6 +38,8 @@
> > >  
> > >  #include <linux/magic.h>
> > >  #include <linux/parser.h>
> > > +#include <linux/fs_context.h>
> > > +#include <linux/fs_parser.h>
> > >  
> > >  static const struct super_operations xfs_super_operations;
> > >  struct bio_set xfs_ioend_bioset;
> > > @@ -47,9 +49,6 @@ static struct kset *xfs_kset;		/* top-
> > > level xfs sysfs dir */
> > >  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs
> > > attrs */
> > >  #endif
> > >  
> > > -/*
> > > - * Table driven mount option parser.
> > > - */
> 
> You would rather it be kept?
> 

No, it just seems unrelated to this patch because you're leaving the
associated code around. Why not remove it when the rest of the code is
ripped out?

> Strictly speaking it's still a table driven parser so it
> could be kept.
> 
> I just thought it was a useles comment since it doesn't add
> value in terms of understanding what's going on, IOW I think
> it's just noise.
> 
> > 
> > Not sure why this is comment is removed here if the associated code
> > is
> > staying put in this patch..?
> > 
> > >  enum {
> > >  	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
> > >  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth,
> > > Opt_nouuid,
> > > @@ -109,6 +108,49 @@ static const match_table_t tokens = {
> > >  	{Opt_err,	NULL},
> > >  };
> > >  
> > > +static const struct fs_parameter_spec xfs_param_specs[] = {
> > > + fsparam_u32	("logbufs",    Opt_logbufs),   /* number of XFS
> > > log buffers */
> > > + fsparam_string ("logbsize",   Opt_logbsize),  /* size of XFS log
> > > buffers */
> > > + fsparam_string ("logdev",     Opt_logdev),    /* log device */
> > > + fsparam_string ("rtdev",      Opt_rtdev),     /* realtime I/O
> > > device */
> > > + fsparam_u32	("biosize",    Opt_biosize),   /* log2 of
> > > preferred buffered io size */
> > 
> > Hmm.. it looks like the difference between numerical values as
> > strings
> > vs. numeric types is whether we support things like unit suffixes
> > (i.e.
> > "64k"). That said, Opt_biosize uses suffix_kstrtoint() similar to
> > Opt_logbsize yet is defined here as a u32 (and Opt_allocsize falls
> > into
> > the same parsing code but is a string). Is that wrong or am I just
> > missing something wrt to the type specifiers here?
> 
> Dave Chinner (and IIRC Darrick) made roughly comments about the
> need for human unit values in the parser.
> 
> I know David has some patches to implement this but I hadn't
> seen anything posted, he's probably over loaded with higher
> priority work atm. so this is probably follow up patch fodder.
> 

Ok, but why are we using different types for Opt_biosize and
Opt_allocsize when they're backed by the same underlying field? I.e.,
from the current code:

		...
                case Opt_allocsize:
                case Opt_biosize:
                        if (suffix_kstrtoint(args, 10, &iosize))
                                return -EINVAL;
                        iosizelog = ffs(iosize) - 1;
                        break;
		...

Brian

> > 
> > Brian
> > 
> > > + fsparam_flag	("wsync",      Opt_wsync),     /* safe-mode nfs
> > > compatible mount */
> > > + fsparam_flag	("noalign",    Opt_noalign),   /* turn off
> > > stripe alignment */
> > > + fsparam_flag	("swalloc",    Opt_swalloc),   /* turn on
> > > stripe width allocation */
> > > + fsparam_u32	("sunit",      Opt_sunit),     /* data volume
> > > stripe unit */
> > > + fsparam_u32	("swidth",     Opt_swidth),    /* data volume
> > > stripe width */
> > > + fsparam_flag	("nouuid",     Opt_nouuid),    /* ignore
> > > filesystem UUID */
> > > + fsparam_flag_no("grpid",      Opt_grpid),     /* group-ID from
> > > parent directory (or not) */
> > > + fsparam_flag	("bsdgroups",  Opt_bsdgroups), /* group-ID from
> > > parent directory */
> > > + fsparam_flag	("sysvgroups", Opt_sysvgroups),/* group-ID from
> > > current process */
> > > + fsparam_string ("allocsize",  Opt_allocsize), /* preferred
> > > allocation size */
> > > + fsparam_flag	("norecovery", Opt_norecovery),/* don't run XFS
> > > recovery */
> > > + fsparam_flag	("inode64",    Opt_inode64),   /* inodes can be
> > > allocated anywhere */
> > > + fsparam_flag	("inode32",    Opt_inode32),   /* inode
> > > allocation limited to XFS_MAXINUMBER_32 */
> > > + fsparam_flag_no("ikeep",      Opt_ikeep),     /* do not free (or
> > > keep) empty inode clusters */
> > > + fsparam_flag_no("largeio",    Opt_largeio),   /* report (or do
> > > not report) large I/O sizes in stat() */
> > > + fsparam_flag_no("attr2",      Opt_attr2),     /* do (or do not)
> > > use attr2 attribute format */
> > > + fsparam_flag	("filestreams",Opt_filestreams), /* use
> > > filestreams allocator */
> > > + fsparam_flag_no("quota",      Opt_quota),     /* disk quotas
> > > (user) */
> > > + fsparam_flag	("usrquota",   Opt_usrquota),  /* user quota
> > > enabled */
> > > + fsparam_flag	("grpquota",   Opt_grpquota),  /* group quota
> > > enabled */
> > > + fsparam_flag	("prjquota",   Opt_prjquota),  /* project quota
> > > enabled */
> > > + fsparam_flag	("uquota",     Opt_uquota),    /* user quota
> > > (IRIX variant) */
> > > + fsparam_flag	("gquota",     Opt_gquota),    /* group quota
> > > (IRIX variant) */
> > > + fsparam_flag	("pquota",     Opt_pquota),    /* project quota
> > > (IRIX variant) */
> > > + fsparam_flag	("uqnoenforce",Opt_uqnoenforce), /* user quota
> > > limit enforcement */
> > > + fsparam_flag	("gqnoenforce",Opt_gqnoenforce), /* group quota
> > > limit enforcement */
> > > + fsparam_flag	("pqnoenforce",Opt_pqnoenforce), /* project
> > > quota limit enforcement */
> > > + fsparam_flag	("qnoenforce", Opt_qnoenforce),  /* same as
> > > uqnoenforce */
> > > + fsparam_flag_no("discard",    Opt_discard),   /* Do (or do not)
> > > not discard unused blocks */
> > > + fsparam_flag	("dax",	       Opt_dax),       /* Enable
> > > direct access to bdev pages */
> > > + {}
> > > +};
> > > +
> > > +static const struct fs_parameter_description xfs_fs_parameters = {
> > > +	.name		= "XFS",
> > > +	.specs		= xfs_param_specs,
> > > +};
> > >  
> > >  STATIC int
> > >  suffix_kstrtoint(const substring_t *s, unsigned int base, int
> > > *res)
> > > 
> 
