Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbfBGThe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 14:37:34 -0500
Date: Thu, 7 Feb 2019 14:37:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v4 6/8] xfs: use verifier magic field in dir2 leaf
 verifiers
Message-ID: <20190207193731.GB61958@bfoster>
References: <20190207184105.17064-1-bfoster@redhat.com>
 <20190207184105.17064-7-bfoster@redhat.com>
 <20190207191005.GJ7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207191005.GJ7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 11:10:06AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 07, 2019 at 01:41:03PM -0500, Brian Foster wrote:
> > The dir2 leaf verifiers share the same underlying structure
> > verification code, but implement six accessor functions to multiplex
> > the code across the two verifiers. Further, the magic value isn't
> > sufficiently abstracted such that the common helper has to manually
> > fix up the magic from the caller on v5 filesystems.
> > 
> > Use the magic field in the verifier structure to eliminate the
> > duplicate code and clean this all up. No functional change.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_dir2_leaf.c | 87 ++++++++---------------------------
> >  fs/xfs/xfs_ondisk.h           | 11 +++++
> >  2 files changed, 30 insertions(+), 68 deletions(-)
> > 
...
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index d3e04d20d8d4..0209f3e91254 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -125,6 +125,17 @@ xfs_check_ondisk_structs(void)
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
> > +
> > +	/*
> > +	 * Magic value offset checks. These are here because certain on-disk
> > +	 * structures are updated to include more information on v5 filesystems.
> > +	 * While different in-core data structures are used depending on fs
> > +	 * version, some buffer verifiers expect to be able to use either
> > +	 * structure to locate the magic value as it should always be in the
> > +	 * same place.
> > +	 */
> > +	XFS_CHECK_OFFSET(struct xfs_dir2_leaf, hdr.info.magic,		8);
> > +	XFS_CHECK_OFFSET(struct xfs_dir3_leaf_hdr, info.hdr.magic,	8);
> 
> Sorry for the nitpick, but why not
> 
> XFS_CHECK_OFFSET(struct xfs_dir3_leaf, hdr.info.hdr.magic, 8) ?
> 

I just used the structure(s) as used in the verifiers. I have no real
preference as to whether we use that or the higher/top level structures.

Brian

> --D
> 
> >  }
> >  
> >  #endif /* __XFS_ONDISK_H */
> > -- 
> > 2.17.2
> > 
