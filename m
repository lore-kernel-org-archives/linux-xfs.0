Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2DBB97CA2
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 19:46:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB2768F8049
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 17:46:11 -0800 (PST)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	iuL2AcHzymiUKyMp for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 17:46:11 -0800 (PST)
Date: Sun, 7 Feb 2016 18:46:01 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] dax: pass bdev argument to dax_clear_blocks()
Message-ID: <20160208014601.GB2343@linux.intel.com>
References: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
	<1454829553-29499-2-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4jOAKeTXt0EvZzfxzqcaf+ZWrtsFeN2JFP_sf1HcTpVOw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jOAKeTXt0EvZzfxzqcaf+ZWrtsFeN2JFP_sf1HcTpVOw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Feb 07, 2016 at 10:19:29AM -0800, Dan Williams wrote:
> On Sat, Feb 6, 2016 at 11:19 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > dax_clear_blocks() needs a valid struct block_device and previously it was
> > using inode->i_sb->s_bdev in all cases.  This is correct for normal inodes
> > on mounted ext2, ext4 and XFS filesystems, but is incorrect for DAX raw
> > block devices and for XFS real-time devices.
> >
> > Instead, have the caller pass in a struct block_device pointer which it
> > knows to be correct.
> >
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > ---
> >  fs/dax.c               | 4 ++--
> >  fs/ext2/inode.c        | 5 +++--
> >  fs/xfs/xfs_aops.c      | 2 +-
> >  fs/xfs/xfs_aops.h      | 1 +
> >  fs/xfs/xfs_bmap_util.c | 4 +++-
> >  include/linux/dax.h    | 3 ++-
> >  6 files changed, 12 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 227974a..4592241 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -83,9 +83,9 @@ struct page *read_dax_sector(struct block_device *bdev, sector_t n)
> >   * and hence this means the stack from this point must follow GFP_NOFS
> >   * semantics for all operations.
> >   */
> > -int dax_clear_blocks(struct inode *inode, sector_t block, long _size)
> > +int dax_clear_blocks(struct inode *inode, struct block_device *bdev,
> > +               sector_t block, long _size)
> 
> Since this is a bdev relative routine we should also resolve the
> sector, i.e. the signature should drop the inode:
> 
> int dax_clear_sectors(struct block_device *bdev, sector_t sector, long _size)

The inode is still needed because dax_clear_blocks() needs inode->i_blkbits.
Unless there is some easy way to get this from the bdev that I'm not seeing?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
