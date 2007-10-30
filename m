Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 17:26:06 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [74.0.229.162])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9U0PvBN006687
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 17:26:00 -0700
Date: Mon, 29 Oct 2007 18:25:59 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20071030002559.GH3042@webber.adilger.int>
References: <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk> <20070502000654.GK77450368@melbourne.sgi.com> <8464EA47-03AC-4162-A2D0-683517568640@cam.ac.uk> <20071029194507.GA8578@webber.adilger.int> <20071029205744.GB28607@ca-server1.us.oracle.com> <20071029221302.GD3042@webber.adilger.int> <20071030001126.GD28607@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030001126.GD28607@ca-server1.us.oracle.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, Anton Altaparmakov <aia21@cam.ac.uk>, Mike Waychison <mikew@google.com>, ocfs2-devel@oss.oracle.com

On Oct 29, 2007  17:11 -0700, Mark Fasheh wrote:
> On Mon, Oct 29, 2007 at 04:13:02PM -0600, Andreas Dilger wrote:
> > > Btrfs, Ocfs2, and Gfs2 pack small amounts of user data directly in inode
> > > blocks.
> > 
> > Hmm, but part of the issue would be how to request the extra data, and
> > what offset it would be given?  One could, for example, use negative
> > offsets to represent metadata or something, or add a FIEMAP_EXTENT_META
> > or similar, I hadn't given that much thought.
> 
> Well, fe_offset and fe_length are already expressed in bytes, so we could
> just put the byte offset to where the inline data starts in there. fe_length
> is just used as the length allocated for inline-data.
> 
> If fe_offset is required to be block aligned, then we could add a field to
> express an offset within the block where data would be found - say
> 'fe_data_start_offset'. In the non-inline case, we could guarantee that
> fe_data_start_offset is zero. That way software which doesn't want to care
> whether something is inline-data (for example, a backup program) or not
> could just blidly add it to fe_offset before looking at the data.

Oh, I was confused as to what you are asking.  Mapping in-inode data is
just fine using the existing interface.  The byte offset of the data is
given, and the "FIEMAP_EXTENT_NO_DIRECT" flag is set to indicate that it
isn't necessarily safe to do IO directly to that byte offset in the file
(e.g. tail packed, compressed data, etc).

I was thinking you were asking how to map metadata (e.g. indirect blocks).

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
