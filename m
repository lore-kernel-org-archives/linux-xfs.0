Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63389 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750747AbcILX20 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2016 19:28:26 -0400
Date: Tue, 13 Sep 2016 09:28:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/71] xfs: log refcount intent items
Message-ID: <20160912232822.GL22388@dastard>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216802075.867.12945255918683675311.stgit@birch.djwong.org>
 <20160906152155.GJ24287@infradead.org>
 <20160908191404.GB8969@birch.djwong.org>
 <20160908231326.GA30056@dastard>
 <20160908231656.GC8969@birch.djwong.org>
 <20160911125246.GA1399@infradead.org>
 <20160912184054.GA23422@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160912184054.GA23422@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 12, 2016 at 11:40:54AM -0700, Darrick J. Wong wrote:
> On Sun, Sep 11, 2016 at 05:52:46AM -0700, Christoph Hellwig wrote:
> > On Thu, Sep 08, 2016 at 04:16:56PM -0700, Darrick J. Wong wrote:
> > > > Carfeul there - enums are not defined to have a fixed size and so
> > > > can change from compiler version to compiler version. IOWs, the
> > > > enum values can be written idirectly to an on-disk structure, but
> > > > the on-disk structure should not be using the enum as the type
> > > > definition for whatever gets stored on disk.
> > > 
> > > <nod>  I left the fields (and the #define flags) definitions alone,
> > > so it's only writing enum values indirectly into a fixed size (u32)
> > > variable on-disk.
> > > 
> > > i.e. I'm not using enums in the on-disk structure definitions.
> > 
> > now add a byte swap for the flags and everything should be fine.
> > The whole idea of architecture-dependent log items was a horrible
> > idea, and I still have hopes of fixing it eventually.
> 
> There are other fields in the CUI/BUI log items that would also
> need byte swapping.  Not so hard to fix now, though fixing the
> EFI/RUI/everythingelse will have to be part of that future patchset.
> 
> <shrug> I also have a vague memory of Dave telling me not to worry
> about making the log item fields arch-independent...

Yeah, I didn't want to have to worry about that complexity to begin
with given that we really need to change the log item infrastructure
to marshall log items into fixed endian formats sanely. And, really,
doing a host-to-fixed endian log format change all at once under
a single XFS_SB_FEAT_INCOMPAT_LOG flag makes more sense than doing
it piecemeal in drips and drabs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
