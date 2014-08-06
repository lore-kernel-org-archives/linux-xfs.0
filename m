Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 176147F6B
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 09:23:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8CDFAC005
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 07:23:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ROJALW84NlNxj7yV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Aug 2014 07:23:33 -0700 (PDT)
Date: Wed, 6 Aug 2014 10:23:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_bmbt_rec_64 leading to wrong blocks
Message-ID: <20140806142329.GA39990@bfoster.bfoster>
References: <CACyNnZM8D4ZdOAvbXNoiRUAGh1uZF8=9Gy34qS2XH7QUVjiGsQ@mail.gmail.com>
	<20140806113447.GA14820@bfoster.bfoster>
	<CACyNnZNwCPw8dsyRKSty7GPp4DxAd7ycHuztsC-VAdGEmjdnyw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACyNnZNwCPw8dsyRKSty7GPp4DxAd7ycHuztsC-VAdGEmjdnyw@mail.gmail.com>
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
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 06, 2014 at 02:31:11PM +0200, Felipe Monteiro de Carvalho wrote:
> Thanks! Indeed that's it =)
> 
> One strange thing however is that in my xfs_dir2_data.h there is:
> 
> #define XFS_DIR2_DATA_ALIGN_LOG 3 /* i.e., 8 bytes */
> #define XFS_DIR2_SPACE_SIZE (1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
> #define XFS_DIR2_LEAF_SPACE 1
> #define XFS_DIR2_LEAF_OFFSET (XFS_DIR2_LEAF_SPACE * XFS_DIR2_SPACE_SIZE)
> 
> That doesn't match the number that I am seeing here for the offset.
> Here I see 1 << 23, but according to the headers it should be 1 << 35
> 

We're talking about extent map data here right? If so, the offset on
disk is in filesystem block units. E.g., block 8388608 * 4096 == 32G ==
(1 << 35).

Brian

> --
> Felipe Monteiro de Carvalho
> 
> 
> On Wed, Aug 6, 2014 at 1:34 PM, Brian Foster <bfoster@redhat.com> wrote:
> > On Wed, Aug 06, 2014 at 12:12:12PM +0200, Felipe Monteiro de Carvalho wrote:
> >> Hello,
> >>
> >> I am writing a software which reads xfs partitions and it is working
> >> well so far, but, at in a particular folder with 10k files, only 7k
> >> files appear, the other ones don't.
> >>
> >> I read an inode which has di_core.di_format = XFS_DINODE_FMT_BTREE
> >>
> >> No problem here, the btree is trivial, it has only 1 element inside
> >> it, which leads to a list of 82 extends.
> >>
> >> Extends 0..52 aprox. are all great, and work fine.
> >>
> >> Extent 53 (and other ones after that) point to very wierd memory areas
> >> which don't match the pattern that I saw previously =(
> >>
> >> Here is the hex data of the extents, the selected extent in nr 53:
> >>
> >> http://magnifier.sourceforge.net/temp/xfs/extent_with_xfs_bmbt_rec_64.png
> >>
> >> And here is debug information showing which values I extracted from this table:
> >>
> >> i=0 FLocalExtent.StartOff=0 FLocalExtent.StartBlock=66748
> >> FLocalExtent.BlockCount=1 lStartBlock=65212
> >> i=1 FLocalExtent.StartOff=1 FLocalExtent.StartBlock=66758
> >> FLocalExtent.BlockCount=2 lStartBlock=65222
> >> i=2 FLocalExtent.StartOff=3 FLocalExtent.StartBlock=66772
> >> FLocalExtent.BlockCount=1 lStartBlock=65236
> >> ....
> >>
> >> i=51 FLocalExtent.StartOff=77 FLocalExtent.StartBlock=67468
> >> FLocalExtent.BlockCount=1 lStartBlock=65932
> >> i=52 FLocalExtent.StartOff=78 FLocalExtent.StartBlock=67479
> >> FLocalExtent.BlockCount=1 lStartBlock=65943
> >> i=53 FLocalExtent.StartOff=8388608 FLocalExtent.StartBlock=66749
> >> FLocalExtent.BlockCount=1 lStartBlock=65213
> >> i=54 FLocalExtent.StartOff=8388609 FLocalExtent.StartBlock=66783
> >> FLocalExtent.BlockCount=2 lStartBlock=65247
> >> ...
> >>
> >> Note how StartOff is suddenly so big! But I manually checked the bits
> >> comparing to xfs_bmbt_rec_64 and the value written is that one. But
> >> what sense does it make for StartOff to jump like that?
> >>
> >
> > Assuming 4k blocks, 8388608 is 32G, which is the offset interval used
> > for some internal sections of directories on XFS. If this is a
> > directory, it could be a node/leaf or freelist block. Looking at
> > xfs_da_format.h, it looks like XFS_DIR2_LEAF_OFFSET points to this
> > offset. This block basically points to a btree of hashed entry names for
> > lookup. See here for basics:
> >
> > http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/Directories.html
> >
> > ... and here for a diagram:
> >
> > http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/Node_Directories.html
> >
> >> And why are the blocks pointing to a non-XD2D block?
> >>
> >> Here is the block to which one of the valid extents point to:
> >>
> >> http://magnifier.sourceforge.net/temp/xfs/correct_block_xd2d.png
> >>
> >> And here is a block to which one of the extents that I cannot
> >> interpretate point to:
> >>
> >> http://magnifier.sourceforge.net/temp/xfs/wierd_block_xd2d.png
> >> and another one:
> >> http://magnifier.sourceforge.net/temp/xfs/wierd_xfs_dir2_data_entry.png
> >>
> >
> > The 0xFEBE magic seems to confirm the second one as a node block.
> >
> > Brian
> >
> >> Any ideas???
> >>
> >> I already worked so much on this, but I cannot figure out =(
> >>
> >> thanks,
> >> --
> >> Felipe Monteiro de Carvalho
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 
> 
> -- 
> Felipe Monteiro de Carvalho
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
