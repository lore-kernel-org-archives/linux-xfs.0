Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A2017F47
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 10:26:44 -0500 (CDT)
Date: Thu, 9 Oct 2014 10:26:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/16] xfs: add a superblock feature bit to indicate
	UTF-8 support.
Message-ID: <20141009152640.GB1865@sgi.com>
References: <20141003214758.GY1865@sgi.com> <20141003215945.GH1865@sgi.com>
	<20141006212558.GF2301@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141006212558.GF2301@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Tue, Oct 07, 2014 at 08:25:58AM +1100, Dave Chinner wrote:
> On Fri, Oct 03, 2014 at 04:59:46PM -0500, Ben Myers wrote:
> > From: Olaf Weber <olaf@sgi.com>
> > 
> > When UTF-8 support is enabled, the xfs_dir_ci_inode_operations must be
> > installed. Add xfs_sb_version_hasci(), which tests both the borgbit and
> > the utf8bit, and returns true if at least one of them is set. Replace
> > calls to xfs_sb_version_hasasciici() as needed.
> > 
> > Signed-off-by: Olaf Weber <olaf@sgi.com>
> > ---
> >  fs/xfs/libxfs/xfs_sb.h | 24 +++++++++++++++++++++++-
> >  fs/xfs/xfs_fs.h        |  1 +
> >  fs/xfs/xfs_fsops.c     |  4 +++-
> >  fs/xfs/xfs_iops.c      |  4 ++--
> >  4 files changed, 29 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> > index 2e73970..525eacb 100644
> > --- a/fs/xfs/libxfs/xfs_sb.h
> > +++ b/fs/xfs/libxfs/xfs_sb.h
> > @@ -70,6 +70,7 @@ struct xfs_trans;
> >  #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
> >  #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
> >  #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
> > +#define XFS_SB_VERSION2_UTF8BIT		0x00000020      /* utf8 names */
> >  #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
> 
> Can you explain why this bit is safe to use?

I believe Olaf chose this value to match what was used in Barry's
implementation.

> I don't recall why
> XFS_SB_VERSION2_PROJID32BIT skipped several bits because there
> aren't any comments explaining why that value was chosen. Adding a
> comment about the 0x00000040 bit at the same time would be useful.

I'm not sure why we skipped.  I'll see what I can find in mail archives.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
