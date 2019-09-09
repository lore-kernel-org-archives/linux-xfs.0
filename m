Return-Path: <SRS0=Pnyc=XE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EAEC4740A
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 18:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B2EB21D6C
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 18:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfIISvy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 14:51:54 -0400
Received: from sandeen.net ([63.231.237.45]:40350 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732391AbfIISvy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Sep 2019 14:51:54 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4BC414507C1;
        Mon,  9 Sep 2019 13:51:53 -0500 (CDT)
Subject: Re: [PATCH 03/10] man: document the new allocation group geometry
 ioctl
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <156757182283.1838441.193482978701233436.stgit@magnolia>
 <156757184149.1838441.15095911482164413079.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <031a48ec-2066-89e0-f464-185cc15c40a5@sandeen.net>
Date:   Mon, 9 Sep 2019 13:51:52 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <156757184149.1838441.15095911482164413079.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/3/19 11:37 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Document the new ioctl to describe an allocation group's geometry.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok - it's kind of interesting to get back EFSCORRUPTED failure from an
ioctl that is designed to report corruption details, but that detail can
be fleshed out more later.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man2/ioctl_xfs_ag_geometry.2 |   82 ++++++++++++++++++++++++++++++++++++++
>  man/man3/xfsctl.3                |    6 +++
>  2 files changed, 88 insertions(+)
>  create mode 100644 man/man2/ioctl_xfs_ag_geometry.2
> 
> 
> diff --git a/man/man2/ioctl_xfs_ag_geometry.2 b/man/man2/ioctl_xfs_ag_geometry.2
> new file mode 100644
> index 00000000..ddd54265
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_ag_geometry.2
> @@ -0,0 +1,82 @@
> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-AG-GEOMETRY 2 2019-08-30 "XFS"
> +.SH NAME
> +ioctl_xfs_ag_geometry \- query XFS allocation group geometry information
> +.SH SYNOPSIS
> +.br
> +.B #include <xfs/xfs_fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_AG_GEOMETRY, struct xfs_ag_geometry *" arg );
> +.SH DESCRIPTION
> +This XFS ioctl retrieves the geometry information for a given allocation group.
> +The geometry information is conveyed in a structure of the following form:
> +.PP
> +.in +4n
> +.nf
> +struct xfs_ag_geometry {
> +	uint32_t  ag_number;
> +	uint32_t  ag_length;
> +	uint32_t  ag_freeblks;
> +	uint32_t  ag_icount;
> +	uint32_t  ag_ifree;
> +	uint32_t  ag_sick;
> +	uint32_t  ag_checked;
> +	uint32_t  ag_flags;
> +	uint64_t  ag_reserved[12];
> +};
> +.fi
> +.in
> +.TP
> +.I ag_number
> +The caller must set this field to the index of the allocation group that the
> +caller wishes to learn about.
> +.TP
> +.I ag_length
> +The length of the allocation group is returned in this field, in units of
> +filesystem blocks.
> +.TP
> +.I ag_freeblks
> +The number of free blocks in the allocation group is returned in this field, in
> +units of filesystem blocks.
> +.TP
> +.I ag_icount
> +The number of inode records allocated in this allocation group is returned in
> +this field.
> +.TP
> +.I ag_ifree
> +The number of unused inode records (of the space allocated) in this allocation
> +group is returned in this field.
> +.TP
> +.I ag_flags
> +The caller can set this field to change the operational behavior of the ioctl.
> +Currently no flags are defined, so this field must be zero.
> +.TP
> +.IR ag_reserved
> +All reserved fields will be set to zero on return.
> +.SH RETURN VALUE
> +On error, \-1 is returned, and
> +.I errno
> +is set to indicate the error.
> +.PP
> +.SH ERRORS
> +Error codes can be one of, but are not limited to, the following:
> +.TP
> +.B EFSBADCRC
> +Metadata checksum validation failed while performing the query.
> +.TP
> +.B EFSCORRUPTED
> +Metadata corruption was encountered while performing the query.
> +.TP
> +.B EINVAL
> +The specified allocation group number is not valid for this filesystem.
> +.TP
> +.B EIO
> +An I/O error was encountered while performing the query.
> +.SH CONFORMING TO
> +This API is specific to XFS filesystem on the Linux kernel.
> +.SH SEE ALSO
> +.BR ioctl (2)
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index 7e6588b8..dfebd12d 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -336,6 +336,12 @@ See
>  .BR ioctl_xfs_fsop_geometry (2)
>  for more information.
>  
> +.TP
> +.B XFS_IOC_AG_GEOMETRY
> +See
> +.BR ioctl_xfs_ag_geometry (2)
> +for more information.
> +
>  .TP
>  .BR XFS_IOC_FSBULKSTAT " or " XFS_IOC_FSBULKSTAT_SINGLE
>  See
> 
