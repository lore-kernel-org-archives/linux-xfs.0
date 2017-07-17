Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbdGQRLb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jul 2017 13:11:31 -0400
Date: Mon, 17 Jul 2017 13:11:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170717171129.GA57771@bfoster.bfoster>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
 <20170706232803.GF17762@dastard>
 <20170707135009.68c22182@harpe.intellique.com>
 <20170707153633.GG4103@magnolia>
 <20170711152340.4cd5dff9@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170711152340.4cd5dff9@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

On Tue, Jul 11, 2017 at 03:23:52PM +0200, Emmanuel Florac wrote:
> Le Fri, 7 Jul 2017 08:36:33 -0700
> "Darrick J. Wong" <darrick.wong@oracle.com> écrivait:
> 
> > > fatal error -- name create failed in lost+found (28), filesystem
> > > may be out of space  
> > 
> > Would be helpful to have a metadump of this goobered-up lost+found
> > fs...
> > 
> 
> The metadump is here for anyone who would like to have a look:
> 
> http://update2.intellique.com/pub/bign.metadump.xz
> 
> The filesystem is about 115 TiB.
> 

Thanks for posting this. The first thing to note is that this filesystem
is severely corrupted. Nonetheless, I've been playing around with trying
to get the latest for-next xfs_repair to run through this fs (via gdb)
and have definitely hit a few issues:

- xfs_sb_verify() was changed to use bp->b_maps[0].bm_bn rather than
  bp->b_bn in libxfs commit 85428dd23f ("xfs: fix superblock inprogress
  check"). b_maps isn't allocated if the buffer was initialized with
  libxfs_initbuf() (rather than libxfs_initbuf_map()). This causes a
  sigsegv here, though only if I disable -O2 optimization for some
  reason that I haven't dug into yet.
- libxfs commit 0268fdc3fe ("xfs: remove xfs_trans_get_block_res")
  replaced the use of xfs_trans_get_block_res() in
  xfs_bmbt_alloc_block() which causes the -ENOSPC error. The previous
  function was hardcoded to return 1 such that this would never occur.
- The recently added directory sf format verifier (xfs_iformat_fork() ->
  xfs_dir2_sf_verify()) seems to cause a premature repair failure in at
  least one case.

I was able to eventually get repair to complete with some quick hacks to
bypass those issues. I did have to run repair two or three times to get
the fs to a clean state. The fs mounts and otherwise appears clean to
xfs_repair, but it's not clear to me how usable the resulting fs really
is (repair is for fs consistency after all, not necessarily data
recovery). Note that lost+found appears to be loaded with 18T of data
across almost 2 million inodes. :/

Brian

> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------


