Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbeGSPXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 11:23:07 -0400
Date: Thu, 19 Jul 2018 07:39:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: filefrag and reflink
Message-ID: <20180719143933.GE4813@magnolia>
References: <CAJCQCtSJUV-0LYCTS2mfeZWA812aqc5oQagsWZ5fi3xuXQ9ncA@mail.gmail.com>
 <20180718195940.GA4813@magnolia>
 <165c936c-7dc4-7336-3d7e-268ec6746b56@sandeen.net>
 <20180719113450.sbdlljklwkky7isv@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719113450.sbdlljklwkky7isv@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Thu, Jul 19, 2018 at 01:34:50PM +0200, Carlos Maiolino wrote:
> On Wed, Jul 18, 2018 at 01:27:40PM -0700, Eric Sandeen wrote:
> > 
> > 
> > On 7/18/18 12:59 PM, Darrick J. Wong wrote:
> > > On Wed, Jul 18, 2018 at 12:41:27PM -0600, Chris Murphy wrote:
> > >> xfsprogs 4.17.0 mkfs with reflink=1
> > >> kernel 4.17.6
> > >>
> > >> $ fallocate -l 1g tmp2
> > >> $ cp --reflink tmp2 tmp3
> > >> $ filefrag -v *
> > >> Filesystem type is: 58465342
> > >> File size of tmp2 is 1073741824 (262144 blocks of 4096 bytes)
> > >>  ext:     logical_offset:        physical_offset: length:   expected: flags:
> > >>    0:        0..  130136:         24..    130160: 130137:             unwritten
> > >>    1:   130137..  260280:     131082..    261225: 130144:     130161: unwritten
> > >>    2:   260281..  262143:     264714..    266576:   1863:     261226:
> > >> last,unwritten,eof
> > >> tmp2: 3 extents found
> > >> File size of tmp3 is 1073741824 (262144 blocks of 4096 bytes)
> > >> tmp3: 0 extents found
> > >> [chris@f28s xfs]$
> > >>
> > >>
> > >> Is this expected? When I do it on Btrfs, I see identical information
> > >> for the two files after reflink copy, with flags "unwritten,shared".
> > > 
> > > Yes.  xfs doesn't share unwritten extents; what would be the point?
> > > 
> > > --D
> > 
> > <materializes somewhere on a US western interstate>
> > 
> > Seems a little weird that bare cp will create a written file full of
> > zeros, while a cp --reflink will create a sparse file, though?
> 
> cp actually can have different behaviors when --reflink is specified, from the
> manpage (formatting slightly modified):
> 
> "
> By default, sparse SOURCE files are detected by a crude heuristic and the
> corresponding DEST file is made sparse  as  well. That  is  the  behavior
> selected  by  --sparse=auto.
> Specify --sparse=always  to  create  a  sparse DEST file whenever the SOURCE
> file contains a long enough sequence of zero bytes.  Use --sparse=never to
> inhibit creation of sparse files.

But it can't have different behaviors, because there's an (undocumented)
requirement that sparse=auto if reflink=always, which implies that if cp
succeeds at delegating the file copy to the kernel it won't do anything
else.  From coreutils 8.28 (Ubuntu 18.04):

  if (x.reflink_mode == REFLINK_ALWAYS && x.sparse_mode != SPARSE_AUTO)
    {
      error (0, 0, _("--reflink can be used only with --sparse=auto"));
      usage (EXIT_FAILURE);
    }


> When --reflink[=always] is specified, perform a lightweight copy,  where  the
> data  blocks  are copied  only  when  modified.   If  this is not possible the
> copy fails, or if --reflink=auto is specified, fall back to a standard copy.

Yep.  Here's the code that invokes FICLONE (the function clone_file is a
wrapper of the ioctl):

  /* --attributes-only overrides --reflink.  */
  if (data_copy_required && x->reflink_mode)
    {
      bool clone_ok = clone_file (dest_desc, source_desc) == 0;
      if (clone_ok || x->reflink_mode == REFLINK_ALWAYS)
        {
          if (!clone_ok)
            {
              error (0, errno, _("failed to clone %s from %s"),
                     quoteaf_n (0, dst_name), quoteaf_n (1, src_name));
              return_val = false;
              goto close_src_and_dst_desc;
            }
          data_copy_required = false;
        }
    }

>From my reading of that, if the kernel succeeds at the FICLONE, then cp
decides that the data copy is finished and moves on.  That heavily
implies that it's ok for the kernel to do what it wants as far as
unwritten vs. hole...

--D

> "
> 
> > 
> > -Eric
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
