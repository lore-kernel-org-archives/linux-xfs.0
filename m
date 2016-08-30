Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 685927CA0
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 14:10:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A167304039
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 12:10:02 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Xnu0JeCpsI7aHUAm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2016 12:09:58 -0700 (PDT)
Date: Tue, 30 Aug 2016 12:09:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] ioctl_xfs_ioc_getfsmap.2: document XFS_IOC_GETFSMAP
	ioctl
Message-ID: <20160830190949.GA8262@birch.djwong.org>
References: <147216758326.32321.8525481353986871349.stgit@birch.djwong.org>
	<147216760214.32321.8331561706153372268.stgit@birch.djwong.org>
	<32A3DAED-21FC-4252-B53E-3503764342E8@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <32A3DAED-21FC-4252-B53E-3503764342E8@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, xfs <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org, mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

[add a few more relevant lists to cc]

On Mon, Aug 29, 2016 at 03:34:11PM -0600, Andreas Dilger wrote:
> On Aug 25, 2016, at 5:26 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > Document the new XFS_IOC_GETFSMAP ioctl that returns the physical
> > layout of a (disk-based) filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > man2/ioctl_xfs_ioc_getfsmap.2 |  294 +++++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 294 insertions(+)
> > create mode 100644 man2/ioctl_xfs_ioc_getfsmap.2
> > 
> > 
> > diff --git a/man2/ioctl_xfs_ioc_getfsmap.2 b/man2/ioctl_xfs_ioc_getfsmap.2
> > new file mode 100644
> > index 0000000..0d9ed47
> > --- /dev/null
> > +++ b/man2/ioctl_xfs_ioc_getfsmap.2
> > @@ -0,0 +1,294 @@
> > +.\" Copyright (c) 2016, Oracle.  All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" This is free documentation; you can redistribute it and/or
> > +.\" modify it under the terms of the GNU General Public License as
> > +.\" published by the Free Software Foundation; either version 2 of
> > +.\" the License, or (at your option) any later version.
> > +.\"
> > +.\" The GNU General Public License's references to "object code"
> > +.\" and "executables" are to be interpreted as the output of any
> > +.\" document formatting or typesetting system, including
> > +.\" intermediate and printed output.
> > +.\"
> > +.\" This manual is distributed in the hope that it will be useful,
> > +.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +.\" GNU General Public License for more details.
> > +.\"
> > +.\" You should have received a copy of the GNU General Public
> > +.\" License along with this manual; if not, see
> > +.\" <http://www.gnu.org/licenses/>.
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS_IOC_GETFSMAP 2 2016-07-20 "Linux" "Linux Programmer's Manual"
> > +.SH NAME
> > +ioctl_xfs_ioc_getfsmap \- retrieve the physical layout of the filesystem
> > +.SH SYNOPSIS
> > +.br
> > +.B #include <sys/ioctl.h>
> > +.br
> > +.B #include <linux/fs.h>
> > +.sp
> > +.BI "int ioctl(int " fd ", XFS_IOC_GETFSMAP, struct getfsmap * " arg );
> > +.SH DESCRIPTION
> > +This
> > +.BR ioctl (2)
> > +retrieves physical extent mappings for a filesystem.
> > +This information can be used to discover which files are mapped to a physical
> > +block, examine free space, or find known bad blocks, among other things.
> > +
> > +The sole argument to this ioctl should be an array of the following
> > +structure:
> > +.in +4n
> > +.nf
> > +
> > +struct getfsmap {
> > +	__u32		fmv_device;	/* device id */
> > +	__u32		fmv_unused1;	/* future use, must be zero */
> > +	__u64		fmv_block;	/* starting block */
> > +	__u64		fmv_owner;	/* owner id */
> > +	__u64		fmv_offset;	/* file offset of segment */
> > +	__u64		fmv_length;	/* length of segment, blocks */
> > +	__u32		fmv_oflags;	/* mapping flags */
> > +	__u32		fmv_iflags;	/* control flags (1st structure) */
> > +	__u32		fmv_count;	/* # of entries in array incl. input */
> > +	__u32		fmv_entries;	/* # of entries filled in (output). */
> > +	__u64		fmv_unused2;	/* future use, must be zero */
> > +};
> > +
> > +.fi
> > +.in
> > +The array must contain at least two elements.
> > +The first two array elements specify the lowest and highest reverse-mapping
> > +keys, respectively, for which userspace would like physical mapping
> > +information.
> > +A reverse mapping key consists of the tuple (device, block, owner, offset).
> > +The owner and offset fields are part of the key because some filesystems
> > +support sharing physical blocks between multiple files and
> > +therefore may return multiple mappings for a given physical block.
> > +
> > +.SS Fields of struct getfsmap
> > +.PP
> > +The
> > +.I fmv_device
> > +field contains a 32-bit cookie to uniquely identify the underlying storage
> > +device.
> > +If the
> > +.B FMV_HOF_DEV_T
> > +flag is set in the header's
> > +.I fmv_oflags
> > +field, this field contains a dev_t from which major and minor numbers can
> > +be extracted.
> > +If the flag is not set, this field contains a value that must be unique
> > +for each storage device.
> > +
> > +.PP
> > +The
> > +.I fmv_unused1
> > +field must be zero in the first two array elements.
> > +
> > +.PP
> > +The
> > +.I fmv_block
> > +field contains the 512-byte sector address of the extent.
> 
> Why would you use 512-byte sectors in a new interface?

I started designing XFS GETFSMAP with the intent of making it feel
familiar to anyone who'd already used the XFS GETBMAP interface.
Hence you pass in an array of struct getfsmap[N] where the start of
the array are key fields and the rest are filled out by the kernel,
and the units are 512-byte blocks.  As a result, some things (special
owners in particular) are strongly influenced by XFS.

Ofc then LSF happened and the btrfs developers expressed a desire to
have a similar call, so now it's out for review on fsdevel.  Now
there's a question of whether or not we can create a generic enough
interface to fit the major filesystems so as not to expose a bunch of
balkanized fsmap ioctls to userspace.

I also haven't heard much from the btrfs list in previous review cycles.

(I say that more in reference to the 'special owners' below than any
other part of GETFSMAP.)

> I recall for FIEMAP that some filesystems may not have files aligned
> to sector offsets, and we just used byte offsets.  Storage like
> NVDIMMs are cacheline granular, so I don't think it makes sense to
> tie this to old disk sector sizes.  Alternately, the units could be
> in terms of fs blocks as returned by statvfs.st_bsize, but mixing
> units for fmv_block, fmv_offset, fmv_length is uneeded complexity.

Ugh.  I'd rather just change the units to bytes rather than force all
the users to multiply things. :)

> > +
> > +.PP
> > +The
> > +.I fmv_owner
> > +field contains the owner of the extent.
> > +This is generally an inode number, though if
> > +.B FMV_OF_SPECIAL_OWNER
> > +is set in the
> > +.I fmv_oflags
> > +field, then the owner value is one of the following special values:
> > +.TP
> > +.B FMV_OWN_FREE
> > +Free space.
> > +.TP
> > +.B FMV_OWN_UNKNOWN
> > +This extent has an unknown owner.
> > +.TP
> > +.B FMV_OWN_FS
> > +Static filesystem metadata.

"Static filesystem metadata.  This information must exist at this disk
address; on XFS, this is the AG superblock, AGF, AGI, and AGFL
headers."

> > +.TP
> > +.B FMV_OWN_LOG
> > +The filesystem journal.
> > +.TP
> > +.B FMV_OWN_AG
> > +Allocation group metadata.

"Allocation group metadata.  On XFS these are the free space btrees
and the reverse mapping btree."

> > +.TP
> > +.B FMV_OWN_INODES
> > +Inodes.
> > +.TP
> > +.B FMV_OWN_DEFECTIVE:
> > +This extent has been marked defective either by the filesystem or the
> > +underlying device.
> 
> These above ones are relatively clear what they are.  The next items
> are not very clear what they are,

These all are very XFS-specific special owner codes; most of them
correspond directly to the special owners in the XFS reverse-mapping
structure.

OWN_FS = AG superblock
OWN_AG = free space and rmap btrees
OWN_INODES = inode records
OWN_INOBT = inode btree pointing to inode record blocks
OWN_REFC = reference count btree
OWN_COW = extent being used for a copy-on-write
OWN_LOG = internal log

For ext4, we could probably reuse the owner codes:

OWN_FS = superblock + group descriptors
OWN_AG = block/inode bitmaps
OWN_INODES = inode table
OWN_LOG = journal

Granted, we could also just smush everything into OWN_METADATA such
that the only special owners would be FREE, METADATA, COW, and
DEFECTIVE.  I don't like that because now the kernel decides to throw
away information that userspace might be able to use, because I prefer
more expressive APIs.  Though I do see the counter-argument that
userspace should not have direct access to metadata and therefore
needn't know more than it's metadata.

I'd much rather just add more special owner codes for any other
filesystem that has distinguishable metadata types that are not
covered by the existing OWN_ codes.  We /do/ have 2^64 possible
values, so it's not like we're going to run out.

> and whether they need to be exported as specific items, or could
> they just be lumped under "FMV_OWN_FS"?  If they serve some specific
> purpose, at a minimum they need better descriptions.
> 
> > +.TP
> > +.B FMV_OWN_INOBT
> > +The inode index, if one is provided.

"Inode indexing information.  On XFS this is the inode btree and free
inode btree." ?

> > +.TP
> > +.B FMV_OWN_REFC
> > +Reference counting indexes.

"Reference count information.  On XFS this is the refcount btree." ?

> > +.TP
> > +.B FMV_OWN_COW
> > +This extent is being used to stage a copy-on-write.

I'm not sure if you found this description to be lacking; I think it's
fine.

> > +
> > +.PP
> > +The
> > +.I fmv_offset
> > +field contains the logical address of the reverse mapping record, in units
> > +of 512-byte blocks.
> > +This field has no meaning if the
> > +.BR FMV_OF_SPECIAL_OWNER " or " FMV_OF_EXTENT_MAP
> > +flags are set in
> > +.IR fmv_oflags "."
> > +
> > +.PP
> > +The
> > +.I fmv_length
> > +field contains the length of the extent, in units of 512-byte blocks.
> > +This field must be zero in the second array element.
> > +
> > +.PP
> > +The
> > +.I fmv_oflags
> > +field is a bitmask of extent state flags.
> > +In the header, the bits are:
> > +.TP
> > +.B FMV_HOF_DEV_T
> > +All
> > +.I fmv_device
> > +values will be in dev_t format.
> > +If this flag is not set, the value is merely a 32-bit cookie that will be
> > +unique for each physical device.
> > +.TP
> > +In a non-header, the bits are:
> > +.TP
> > +.B FMV_OF_PREALLOC
> > +The extent is allocated but not yet written.
> > +.TP
> > +.B FMV_OF_ATTR_FORK
> > +This extent contains extended attribute data.
> > +.TP
> > +.B FMV_OF_EXTENT_MAP
> > +This extent contains extent map information for the owner.
> > +.TP
> > +.B FMV_OF_SHARED
> > +Parts of this extent may be shared.
> > +.TP
> > +.B FMV_OF_SPECIAL_OWNER
> > +The
> > +.I fmv_owner
> > +field contains a special value instead of an inode number.
> > +.TP
> > +.B FMV_OF_LAST
> > +This is the last record in the filesystem.
> > +
> > +.PP
> > +The
> > +.I fmv_iflags
> > +field is a bitmask passed to the kernel to alter the output.
> > +There are no flags defined, so this value must be zero in the first
> > +two array elements.
> 
> It seems like there are several fields in the structure that are used for
> only input or only output?  Does it make more sense to have one structure
> used only for the input request, and then the array of values returned be
> in a different structure?  I'm not necessarily requesting that it be changed,
> but it definitely is something I noticed a few times while reading this doc.

I've been thinking about rearranging this a bit, since the flags
handling is very awkward with the current array structure.  Each
rmap has its own flags; we may someday want to pass operation flags
into the ioctl; and we currently have one operation flag to pass back
to userspace.  Each of those flags can be a separate field.  I think
people will get confused about FMV_OF_* and FMV_HOF_* being referenced
in oflags, and iflags has no meaning for returned records.

So, this instead?

struct getfsmap_rec {
	u32 device;		/* device id */
	u32 flags;		/* mapping flags */
	u64 block;		/* physical addr, bytes */
	u64 owner;		/* inode or special owner code */
	u64 offset;		/* file offset of mapping, bytes */
	u64 length;		/* length of segment, bytes */
	u64 reserved;		/* will be set to zero */
}; /* 48 bytes */

struct getfsmap_head {
	u32 iflags;		/* none defined yet */
	u32 oflags;		/* FMV_HOF_DEV_T */
	u32 count;		/* # entries in recs array */
	u32 entries;		/* # entries filled in (output) */
	u64 reserved[2]; 	/* must be zero */

	struct getfsmap_rec keys[2]; /* low and high keys for the mapping search */
	struct getfsmap_rec recs[0];
}; /* 32 bytes + 2*48 = 128 bytes */

#define XFS_IOC_GETFSMAP	_IOWR('X', 59, struct getfsmap_head)

This also means that userspace can set up for the next ioctl
invocation with memcpy(&head->keys[0], &head->recs[head->entries - 1]).

Yes, I think I like this better.  Everyone else, please chime in. :)

--D

> Cheers, Andreas
> 
> > +.PP
> > +The
> > +.I fmv_count
> > +field contains the number of elements in the array being passed to the
> > +kernel.
> > +This count must include the two control elements at the start of the
> > +array.
> > +The value must be specified in the first array element; in the second
> > +element this field must be zero.
> > +
> > +If this value is 2,
> > +.I fmv_entries
> > +will be set to the number of records that would have been returned had
> > +the array been large enough;
> > +no extent information will be returned.
> > +
> > +.PP
> > +The
> > +.I fmv_entries
> > +field contains the number of elements in the array that contain useful
> > +information if the ioctl returns a non-error value.
> > +This value does not include the two control elements at the start of the array.
> > +This value is only set in the first array element;
> > +in the second element, this field must be zero.
> > +
> > +.PP
> > +The
> > +.I fmv_unused2
> > +field must be zero in the first two array elements.
> > +
> > +.SS Array Elements
> > +.PP
> > +The key fields (fmv_device, fmv_block, fmv_owner, fmv_offset) of the first
> > +element of the array specify the lowest extent record in the keyspace that
> > +the caller wants returned.
> > +For example, if the key is set to (0, 36, 0, 0), the filesystem will
> > +only return records for extents starting at or above sector 36 on
> > +disk.
> > +For convenience, the
> > +.I fmv_length
> > +field will be added to the
> > +.IR fmv_block " and " fmv_offset
> > +fields as appropriate so that the (fmv_device, fmv_block, fmv_owner,
> > +fmv_offset, fmv_length) fields in the last array element can be copied
> > +into the first element to seed the next ioctl call.
> > +
> > +The key fields of the second element of the array specify the highest
> > +extent record in the keyspace that the caller wants returned.
> > +Returning to our example above, if that example key were instead
> > +passed in via the second array element, the filesystem will not return
> > +records for extents going past sector 36 on disk.
> > +For convenience, the four key fields can be set to ~0 (all ones) to
> > +signify "end of filesystem".
> > +
> > +If
> > +.I fmv_count
> > +in the first element of the array is 2, then
> > +.I fmv_entries
> > +in the first element of the array will be set to the number of extent
> > +records found in the filesystem.
> > +Otherwise,
> > +.I fmv_entries
> > +will be set to the number of extents actually returned, and the subsequent
> > +array elements will be filled out with extent information.
> > +In these
> > +subsequent array elements, the fields
> > +.IR fmv_iflags ", " fmv_count ", " fmv_entries ", and " fmv_unused1
> > +will be set to zero by the filesystem.
> > +
> > +.SH RETURN VALUE
> > +On error, \-1 is returned, and
> > +.I errno
> > +is set to indicate the error.
> > +.PP
> > +.SH ERRORS
> > +Error codes can be one of, but are not limited to, the following:
> > +.TP
> > +.B EINVAL
> > +The array is not long enough, or a non-zero value was passed in one of the
> > +fields that must be zero.
> > +.TP
> > +.B EFAULT
> > +The pointer passed in was not mapped to a valid memory address.
> > +.TP
> > +.B EBADF
> > +.IR fd
> > +is not open for reading.
> > +.TP
> > +.B EPERM
> > +This query is not allowed.
> > +.TP
> > +.B EOPNOTSUPP
> > +The filesystem does not support this command.
> > +
> > +.SH CONFORMING TO
> > +This API is Linux-specific.
> > +Not all filesystems support it.
> > +.fi
> > +.in
> > +.SH SEE ALSO
> > +.BR ioctl (2)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
