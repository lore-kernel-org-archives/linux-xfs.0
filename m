Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753249AbdGXOv1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jul 2017 10:51:27 -0400
Date: Mon, 24 Jul 2017 10:51:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170724145125.GA12097@bfoster.bfoster>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
 <20170706232803.GF17762@dastard>
 <20170707135009.68c22182@harpe.intellique.com>
 <20170707153633.GG4103@magnolia>
 <20170711152340.4cd5dff9@harpe.intellique.com>
 <20170717171129.GA57771@bfoster.bfoster>
 <20170724162728.2a77797a@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170724162728.2a77797a@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

On Mon, Jul 24, 2017 at 04:27:28PM +0200, Emmanuel Florac wrote:
> Le Mon, 17 Jul 2017 13:11:29 -0400
> Brian Foster <bfoster@redhat.com> écrivait:
> 
> > On Tue, Jul 11, 2017 at 03:23:52PM +0200, Emmanuel Florac wrote:
> > > Le Fri, 7 Jul 2017 08:36:33 -0700
> > > "Darrick J. Wong" <darrick.wong@oracle.com> écrivait:
> > >   
> > > > > fatal error -- name create failed in lost+found (28), filesystem
> > > > > may be out of space    
> > > > 
> > > > Would be helpful to have a metadump of this goobered-up lost+found
> > > > fs...
> > > >   
> > > 
> > > The metadump is here for anyone who would like to have a look:
> > > 
> > > http://update2.intellique.com/pub/bign.metadump.xz
> > > 
> > > The filesystem is about 115 TiB.
> > >   
> > 
> > Thanks for posting this. The first thing to note is that this
> > filesystem is severely corrupted.
> 
> This I have determined myself through the fact that many runs of
> xfs_repair (and different versions of it, v4.7, 4.9, 4.11...) can't get
> it into a stable (i.e. that won't crash while trying to access it)
> state.
> 
> > Nonetheless, I've been playing
> > around with trying to get the latest for-next xfs_repair to run
> > through this fs (via gdb) and have definitely hit a few issues:
> > 
> > - xfs_sb_verify() was changed to use bp->b_maps[0].bm_bn rather than
> >   bp->b_bn in libxfs commit 85428dd23f ("xfs: fix superblock
> > inprogress check"). b_maps isn't allocated if the buffer was
> > initialized with libxfs_initbuf() (rather than libxfs_initbuf_map()).
> > This causes a sigsegv here, though only if I disable -O2 optimization
> > for some reason that I haven't dug into yet.
> > - libxfs commit 0268fdc3fe ("xfs: remove xfs_trans_get_block_res")
> >   replaced the use of xfs_trans_get_block_res() in
> >   xfs_bmbt_alloc_block() which causes the -ENOSPC error. The previous
> >   function was hardcoded to return 1 such that this would never occur.
> > - The recently added directory sf format verifier (xfs_iformat_fork()
> > -> xfs_dir2_sf_verify()) seems to cause a premature repair failure in
> > at least one case.
> > 
> > I was able to eventually get repair to complete with some quick hacks
> > to bypass those issues. I did have to run repair two or three times
> > to get the fs to a clean state. The fs mounts and otherwise appears
> > clean to xfs_repair, but it's not clear to me how usable the
> > resulting fs really is (repair is for fs consistency after all, not
> > necessarily data recovery). Note that lost+found appears to be loaded
> > with 18T of data across almost 2 million inodes. :/
> 
> Thank you for your efforts, the loaded lost+found matches my own
> results, however some of the files there have been present for possibly
> years. In fact this filesystem has crashed several times in the past
> years but always went back online at some point, until... now.
> 
> So what could I do, at least to be able to mount it and copy everything
> elsewhere before mkfs'ing it all again? Do you have an xfs_repair
> binary at hand that I could use, or should I dig into the latest
> source?
> 

There are several fixes in-flight for the issues uncovered by this
metadump. I think you'll want to include the following 3 patches to
xfsprogs:

http://marc.info/?l=linux-xfs&m=150047977108174&w=2
http://marc.info/?l=linux-xfs&m=150040481220074&w=2
http://marc.info/?l=linux-xfs&m=150040481820076&w=2

Note that the last 2 patches are probably going to be reworked into a
different implementation. The idea here is ultimately to avoid running
the verifier in a case where it disrupts xfs_repair, so using this
intermediate patch series should be good enough to build a custom binary
that allows xfs_repair to eventually piece the fs back together. You
could alternatively just hack xfs_dir2_sf_verify() to return 0.

Note that I would highly recommend to test whatever you build against
your metadump before the original fs.

Brian

> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------


