Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF88E7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 17:55:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E03E304081
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 15:55:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xtbjIZDebPL0CLQa for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 15:55:39 -0700 (PDT)
Date: Sat, 19 Oct 2013 09:55:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/4] xfsprogs: v4 inode type in directory
Message-ID: <20131018225509.GZ4446@dastard>
References: <20131017152804.204045257@sgi.com> <52605FF8.2000301@sgi.com>
	<20131018031950.GT4446@dastard> <52613610.5090409@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52613610.5090409@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 18, 2013 at 08:22:24AM -0500, Mark Tinguely wrote:
> On 10/17/13 22:19, Dave Chinner wrote:
> >On Thu, Oct 17, 2013 at 05:08:56PM -0500, Mark Tinguely wrote:
> >>On 10/17/13 10:28, Mark Tinguely wrote:
> >>>Here are the patches that enable the inode in the directory
> >>>feature in v4 superblocks.
> >>>
> >>>Unchanged
> >>>  patch 1: add the entries to xfs_sb.h (sync with kernel)
> >>>  patch 2: add the XFS_FSOP_GEOM_FLAGS_FTYPE to xfs_fs.h (sync with kernel)
> >>>	  add the entry to repair so that xfs_info reports the feature
> >>>New
> >>>  patch 3: add feature to the xfs_db version command.
> >>>
> >>>Fixed
> >>>  patch 4: add the feature to mkfs.xfs and manual page.
> >>>           note: this new feature is ignored for superblock v5
> >>>		automatically turns on this feature.
> >>
> >>FYI.
> >>
> >>I saw the request for adding the filetype entry to block/leaf after posting.
> >>
> >>I have it displaying unconditionally, but am trying to figure out
> >>how to make it display only for filesytems that support the ftype
> >>feature. I am missing something in the field.count().
> >
> >The count function only tells the code whether a structure is
> >present or not, but it does not tell you what the format of the
> >structure is.
> >
> >if you look at db/dir2.c, you'll see that the difference between the
> >dir2_flds[] and the dir3_flds[] is mainly in the type, count and offset
> >fields. For example:
> >
> >const field_t   dir2_flds[] = {
> >         { "bhdr", FLDT_DIR2_DATA_HDR, OI(BOFF(magic)), dir2_block_hdr_count,
> >           FLD_COUNT, TYP_NONE }
> >...
> >
> >const field_t   dir3_flds[] = {
> >         { "bhdr", FLDT_DIR3_DATA_HDR, OI(B3OFF(hdr)), dir3_block_hdr_count,
> >           FLD_COUNT, TYP_NONE },
> >...
> >
> >if you look at dir[23]_block_hdr_count(), you'll see that they
> >return a boolean value based on a magic number check. Hence when the
> >code is trying to determine the type of the block that has been read
> >(i.e. what the field definition is), if the magic number matches we
> >know exactly what type of contents they contain.
> >
> >For decoding the dtype, you need too look at how to select the
> >correct structure for the FLDT_DIR2_DATA_UNION. If you don't have
> >the feature set, you need to select the FLDT_DIR2_DATA_UNION
> >structure type, and if it is set you need to select the
> >FLDT_DIR3_DATA_UNION type. Hence you need both these types defined
> >in the dir2_flds[] array, and some manner to ensure the correct
> >values are returned from the count functions.
> >
> >And just to make it hard, both the dir2 and dir3 data union count
> >functions use the same function (dir2_data_u_count) so you're going
> >to have to be careful that you don't break the v5 superblock
> >directory decoding....
> >
> >Cheers,
> >
> >Dave.
> 
> 
> Thanks Dave. I did some RTFS and found I was having problems with
> the field_t.flag.
> 
> Can't we add a filetype to the dir2 dir2_data_union_flds entry and
> use the count to turn it on/off? The problem I was having with this
> was the flag.

ISTR trying something like that previously when doing the dir3
changeover - I couldn't get it to work properly because parts of the
structure could not be easily discriminated and so both the v2 and
v3 count functions would return true because they were looking at
different locations in the structure due to the header size
differences.

In this case, because the structure itself doesn't have any child
dependencies and the format will always be considered a v2 directory
structure, I think what you propose should work. Did you test it
to see if it works?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
