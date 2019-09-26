Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52EEC4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 18:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87035222C9
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 18:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfIZSSz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 14:18:55 -0400
Received: from sandeen.net ([63.231.237.45]:56534 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbfIZSSy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 14:18:54 -0400
Received: from Liberator-6.hsd1.mn.comcast.net (c-174-53-190-166.hsd1.mn.comcast.net [174.53.190.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CB51E544;
        Thu, 26 Sep 2019 13:18:44 -0500 (CDT)
Subject: Re: [PATCH 1/4] man: add documentation for v5 bulkstat ioctl
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <156944714720.297379.5532805895370082740.stgit@magnolia>
 <156944715322.297379.11660312603647624273.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <d54d3d82-145d-ab92-e923-40224152d747@sandeen.net>
Date:   Thu, 26 Sep 2019 13:18:52 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <156944715322.297379.11660312603647624273.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/25/19 4:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new manpage describing the V5 XFS_IOC_BULKSTAT ioctl.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man2/ioctl_xfs_bulkstat.2   |  330 +++++++++++++++++++++++++++++++++++++++
>  man/man2/ioctl_xfs_fsbulkstat.2 |    6 +
>  2 files changed, 336 insertions(+)
>  create mode 100644 man/man2/ioctl_xfs_bulkstat.2
> 

couple errors/typos and a nitpick below

> diff --git a/man/man2/ioctl_xfs_bulkstat.2 b/man/man2/ioctl_xfs_bulkstat.2
> new file mode 100644
> index 00000000..f687cfe8
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_bulkstat.2
> @@ -0,0 +1,330 @@
> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-BULKSTAT 2 2019-05-23 "XFS"
> +.SH NAME
> +ioctl_xfs_bulkstat \- query information for a batch of XFS inodes
> +.SH SYNOPSIS
> +.br
> +.B #include <xfs/xfs_fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_BULKSTAT, struct xfs_bulkstat_req *" arg );
> +.SH DESCRIPTION
> +Query stat information for a group of XFS inodes.
> +This ioctl uses
> +.B struct xfs_bulkstat_req
> +to set up a bulk transfer with the kernel:
> +.PP
> +.in +4n
> +.nf
> +struct xfs_bulkstat_req {
> +	struct xfs_bulk_ireq    hdr;
> +	struct xfs_bulkstat     bulkstat[];
> +};
> +
> +struct xfs_bulk_ireq {
> +	uint64_t                ino;
> +	uint32_t                flags;
> +	uint32_t                icount;
> +	uint32_t                ocount;
> +	uint32_t                agno;
> +	uint64_t                reserved[5];
> +};

maybe a "see below for the xfs_bulkstat structure definition?"

> +.fi
> +.in
> +.PP
> +.I hdr.ino
> +should be set to the number of the first inode for which the caller wants
> +information, or zero to start with the first inode in the filesystem

, or to a special value if XFS_BULK_IREQ_SPECIAL is set in the flags field.

> +Note that this is a different semantic than the
> +.B lastip
> +in the old
> +.B FSBULKSTAT
> +ioctl.
> +After the call, this value will be set to the number of the next inode for
> +which information could supplied.
> +This sets up the next call for an iteration loop.
> +.PP
> +If the
> +.B XFS_BULK_REQ_SPECIAL

XFS_BULK_IREQ_SPECIAL

> +flag is set, this field is interpreted as follows:
> +.RS 0.4i
> +.TP
> +.B XFS_BULK_IREQ_SPECIAL_ROOT
> +Return stat information for the root directory inode.

How about something like:

---

If the XFS_BULK_IREQ_SPECIAL flag is set in the flags field, then this ino field
is interpreted according to the following special values:

XFS_BULK_IREQ_SPECIAL_ROOT
    Return stat information for the root directory inode.

---

or

If the XFS_BULK_REQ_SPECIAL flag is set, this field is interpreted according
to the following special values:

XFS_BULK_IREQ_SPECIAL_ROOT
    Return stat information for the root directory inode.

----

> +.RE
> +.PP
> +.PP
> +.I hdr.flags
> +is a bit set of operational flags:
> +.RS 0.4i
> +.TP
> +.B XFS_BULK_REQ_AGNO

XFS_BULK_IREQ_AGNO

> +If this is set, the call will only return results for the allocation group (AG)
> +set in
> +.BR hdr.agno .
> +If
> +.B hdr.ino
> +is set to zero, results will be returned starting with the first inode in the
> +AG.
> +This flag may not be set at the same time as the
> +.B XFS_BULK_REQ_SPECIAL

XFS_BULK_IREQ_SPECIAL

> +flag.
> +.TP
> +.B XFS_BULK_REQ_SPECIAL

XFS_BULK_IREQ_SPECIAL ...

> +If this is set, results will be returned for only the special inode
> +specified in the
> +.B hdr.ino
> +field.
> +This flag may not be set at the same time as the
> +.B XFS_BULK_REQ_AGNO
> +flag.
> +.RE
> +.PP
> +.I hdr.icount
> +is the number of inodes to examine.
> +.PP
> +.I hdr.ocount
> +will be set to the number of records returned.
> +.PP
> +.I hdr.agno
> +is the number of the allocation group (AG) for which we want results.
> +If the
> +.B XFS_BULK_REQ_AGNO
> +flag is not set, this field is ignored.
> +.PP
> +.I hdr.reserved
> +must be set to zero.
> +
> +.PP
> +.I bulkstat
> +is an array of
> +.B struct xfs_bulkstat
> +which is described below.
> +The array must have at least
> +.I icount
> +elements.
> +.PP
> +.in +4n
> +.nf
> +struct xfs_bulkstat {
> +	uint64_t                bs_ino;
> +	uint64_t                bs_size;
> +
> +	uint64_t                bs_blocks;
> +	uint64_t                bs_xflags;
> +
> +	uint64_t                bs_atime;
> +	uint64_t                bs_mtime;
> +
> +	uint64_t                bs_ctime;
> +	uint64_t                bs_btime;
> +
> +	uint32_t                bs_gen;
> +	uint32_t                bs_uid;
> +	uint32_t                bs_gid;
> +	uint32_t                bs_projectid;
> +
> +	uint32_t                bs_atime_nsec;
> +	uint32_t                bs_mtime_nsec;
> +	uint32_t                bs_ctime_nsec;
> +	uint32_t                bs_btime_nsec;
> +
> +	uint32_t                bs_blksize;
> +	uint32_t                bs_rdev;
> +	uint32_t                bs_cowextsize_blks;
> +	uint32_t                bs_extsize_blks;
> +
> +	uint32_t                bs_nlink;
> +	uint32_t                bs_extents;
> +	uint32_t                bs_aextents;
> +	uint16_t                bs_version;
> +	uint16_t                bs_forkoff;
> +
> +	uint16_t                bs_sick;
> +	uint16_t                bs_checked;
> +	uint16_t                bs_mode;
> +	uint16_t                bs_pad2;
> +
> +	uint64_t                bs_pad[7];
> +};
> +.fi
> +.in
> +.PP
> +.I bs_ino
> +is the inode number of this record.
> +.PP
> +.I bs_size
> +is the size of the file, in bytes.
> +.PP
> +.I bs_blocks
> +is the number of filesystem blocks allocated to this file, including metadata.
> +.PP
> +.I bs_xflags
> +tell us what extended flags are set this inode.
> +These flags are the same values as those defined in the
> +.B XFS INODE FLAGS
> +section of the
> +.BR ioctl_xfs_fsgetxattr (2)
> +manpage.
> +.PP
> +.I bs_atime
> +is the last time this file was accessed, in seconds
> +.PP
> +.I bs_mtime
> +is the last time the contents of this file were modified, in seconds.
> +.PP
> +.I bs_ctime
> +is the last time this inode record was modified, in seconds.
> +.PP
> +.I bs_btime
> +is the time this inode record was created, in seconds.
> +.PP
> +.I bs_gen
> +is the generation number of the inode record.
> +.PP
> +.I bs_uid
> +is the user id.
> +.PP
> +.I bs_gid
> +is the group id.
> +.PP
> +.I bs_projectid
> +is the the project id.
> +.PP
> +.I bs_atime_nsec
> +is the nanoseconds component of the last time this file was accessed.
> +.PP
> +.I bs_mtime_nsec
> +is the nanoseconds component of the last time the contents of this file were
> +modified.
> +.PP
> +.I bs_ctime_nsec
> +is the nanoseconds component of the last time this inode record was modified.
> +.PP
> +.I bs_btime_nsec
> +is the nanoseconds component of the time this inode record was created.
> +.PP
> +.I bs_blksize
> +is the size of a data block for this file, in units of bytes.
> +.PP
> +.I bs_rdev
> +is the encoded device id if this is a special file.
> +.PP
> +.I bs_cowextsize_blks
> +is the Copy on Write extent size hint for this file, in units of data blocks.
> +.PP
> +.I bs_extsize_blks
> +is the extent size hint for this file, in units of data blocks.
> +.PP
> +.I bs_nlink
> +is the number of hard links to this inode.
> +.PP
> +.I bs_extents
> +is the number of storage mappings associated with this file's data.
> +.PP
> +.I bs_aextents
> +is the number of storage mappings associated with this file's extended
> +attributes.
> +.PP
> +.I bs_version
> +is the version of this data structure.
> +Currently, only 1 or 5 are supported.
> +.PP
> +.I bs_forkoff
> +is the offset of the attribute fork in the inode record, in bytes.
> +.PP
> +The fields
> +.IR bs_sick " and " bs_checked
> +indicate the relative health of various allocation group metadata.
> +Please see the section
> +.B XFS INODE METADATA HEALTH REPORTING
> +for more information.
> +.PP
> +.I bs_mode
> +is the file type and mode.
> +.PP
> +.I bs_pad[7]
> +is zeroed.
> +.SH RETURN VALUE
> +On error, \-1 is returned, and
> +.I errno
> +is set to indicate the error.
> +.PP
> +.SH XFS INODE METADATA HEALTH REPORTING
> +.PP
> +The online filesystem checking utility scans inode metadata and records what it
> +finds in the kernel incore state.
> +The following scheme is used for userspace to read the incore health status of
> +an inode:
> +.IP \[bu] 2
> +If a given sick flag is set in
> +.IR bs_sick ,
> +then that piece of metadata has been observed to be damaged.
> +The same bit should be set in
> +.IR bs_checked .
> +.IP \[bu]
> +If a given sick flag is set in
> +.I bs_checked
> +but is not set in
> +.IR bs_sick ,
> +then that piece of metadata has been checked and is not faulty.
> +.IP \[bu]
> +If a given sick flag is not set in
> +.IR bs_checked ,
> +then no conclusion can be made.
> +.PP
> +The following flags apply to these fields:
> +.RS 0.4i
> +.TP
> +.B XFS_BS_SICK_INODE
> +The inode's record itself.
> +.TP
> +.B XFS_BS_SICK_BMBTD
> +File data extent mappings.
> +.TP
> +.B XFS_BS_SICK_BMBTA
> +Extended attribute extent mappings.
> +.TP
> +.B XFS_BS_SICK_BMBTC
> +Copy on Write staging extent mappings.
> +.TP
> +.B XFS_BS_SICK_DIR
> +Directory information.
> +.TP
> +.B XFS_BS_SICK_XATTR
> +Extended attribute data.
> +.TP
> +.B XFS_BS_SICK_SYMLINK
> +Symbolic link target.
> +.TP
> +.B XFS_BS_SICK_PARENT
> +Parent pointers.
> +.RE
> +.SH ERRORS
> +Error codes can be one of, but are not limited to, the following:
> +.TP
> +.B EFAULT
> +The kernel was not able to copy into the userspace buffer.
> +.TP
> +.B EFSBADCRC
> +Metadata checksum validation failed while performing the query.
> +.TP
> +.B EFSCORRUPTED
> +Metadata corruption was encountered while performing the query.
> +.TP
> +.B EINVAL
> +One of the arguments was not valid.
> +.TP
> +.B EIO
> +An I/O error was encountered while performing the query.
> +.TP
> +.B ENOMEM
> +There was insufficient memory to perform the query.
> +.SH CONFORMING TO
> +This API is specific to XFS filesystem on the Linux kernel.
> +.SH SEE ALSO
> +.BR ioctl (2),
> +.BR ioctl_xfs_fsgetxattr (2)
> diff --git a/man/man2/ioctl_xfs_fsbulkstat.2 b/man/man2/ioctl_xfs_fsbulkstat.2
> index 8f880c5a..3f059942 100644
> --- a/man/man2/ioctl_xfs_fsbulkstat.2
> +++ b/man/man2/ioctl_xfs_fsbulkstat.2
> @@ -15,6 +15,12 @@ ioctl_xfs_fsbulkstat \- query information for a batch of XFS inodes
>  .BI "int ioctl(int " fd ", XFS_IOC_FSBULKSTAT_SINGLE, struct xfs_fsop_bulkreq *" arg );
>  .SH DESCRIPTION
>  Query stat information for a group of XFS inodes.
> +.PP
> +NOTE: This ioctl has been superseded.
> +Please see the
> +.BR ioctl_xfs_bulkstat (2)
> +manpage for information about its replacement.
> +.PP
>  These ioctls use
>  .B struct xfs_fsop_bulkreq
>  to set up a bulk transfer with the kernel:
> 
