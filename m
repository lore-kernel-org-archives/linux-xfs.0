Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC5AC43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 17:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95F60218AC
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 17:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfLRRUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 12:20:43 -0500
Received: from sandeen.net ([63.231.237.45]:33454 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727025AbfLRRUm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Dec 2019 12:20:42 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id EEEAA11718;
        Wed, 18 Dec 2019 11:20:26 -0600 (CST)
Subject: Re: [PATCH] man: list xfs_io lsattr inode flag letters
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20191218170951.GN12765@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <61bbca8d-a145-3ad1-cb64-9bdd1d78f452@sandeen.net>
Date:   Wed, 18 Dec 2019 11:20:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191218170951.GN12765@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/18/19 11:09 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The section of the xfs_io manpage for the 'chattr' command says to refer
> to xfsctl(3) for information on the flags.  The inode flag information
> was moved to ioctl_xfs_fssetxattr(2) ages ago, and it never actually
> mapped the inode flag letters to inode flag bits, so add those to the
> xfs_io manpage.

Hm, ok.  The info is in the command's help output but I suppose it's useful
enough to have it in the (a?) manpage, too.

OTOH this cuts & pastes quite a lot from the ioctl_xfs_fsgetxattr and I get
nervous when we do that because it /will/ get out of sync.

I wonder if we can just say "refer to help output for flag mappings, and to
ioctl_xfs_fsgetxattr for flag descriptions?"

Or would it suffice to just fix up the existing text:

The mapping between each
letter and the inode flags (refer to
.BR ioctl_xfs_fssetxattr (2)
for the full list) is available via the
.B help
command.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man8/xfs_io.8 |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 117 insertions(+), 6 deletions(-)
> 
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 2f17c64c..26523ab8 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -794,18 +794,129 @@ for all directory entries below the currently open file
>  can be used to restrict the output to directories only).
>  This is a depth first descent, it does not follow symlinks and
>  it also does not cross mount points.
> +
> +The current inode flag letters are:
> +
> +.PD 0
> +.RS
> +.TP 0.5i
> +.SM "r (XFS_XFLAG_REALTIME)"
> +The file is a realtime file.
> +
> +.TP
> +.SM "p (XFS_XFLAG_PREALLOC)"
> +The file has preallocated space.
> +
> +.TP
> +.SM "i (XFS_XFLAG_IMMUTABLE)"
> +The file is immutable - it cannot be modified, deleted or renamed, no link can
> +be created to this file and no data can be written to the file.
> +Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability
> +can set or clear this flag.
> +
> +.TP
> +.SM "a (XFS_XFLAG_APPEND)"
> +The file is append-only - it can only be open in append mode for writing.
> +Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability
> +can set or clear this flag.
> +
> +.TP
> +.SM "s (XFS_XFLAG_SYNC)"
> +All writes to the file are synchronous.
> +
> +.TP
> +.SM "A (XFS_XFLAG_NOATIME)"
> +When the file is accessed, its atime record is not modified.
> +
> +.TP
> +.SM "d (XFS_XFLAG_NODUMP)"
> +The file should be skipped by backup utilities.
> +
> +.TP
> +.SM "t (XFS_XFLAG_RTINHERIT)"
> +New files created in this directory will be automatically flagged as realtime.
> +New directories created in the directory will inherit the inheritance bit.
> +
> +.TP
> +.SM "P (XFS_XFLAG_PROJINHERIT)"
> +New files and directories created in the directory will inherit the parent's
> +project ID.
> +New directories also inherit the project ID and project inheritance bit.
> +
> +.TP
> +.SM "n (XFS_XFLAG_NOSYMLINKS)"
> +Can only be set on a directory and disallows creation of symbolic links in the
> +directory.
> +
> +.TP
> +.SM "e (XFS_XFLAG_EXTSIZE)"
> +Extent size hint - if a basic extent size value is set on the file then the
> +allocator will try allocate in multiples of the set size for this file.
> +This only applies to non-realtime files.
> +See
> +.BR ioctl_xfs_fsgetxattr "(2)"
> +for more information.
> +
> +.TP
> +.SM "E (XFS_XFLAG_EXTSZINHERIT)"
> +New files and directories created in the directory will inherit the parent's
> +basic extent size value (see above).
> +Can only be set on a directory.
> +
> +.TP
> +.SM "f (XFS_XFLAG_NODEFRAG)"
> +The file should be skipped during a defragmentation operation.
> +When applied to a directory, new files and directories created will
> +inherit the no\-defrag state.
> +
> +.TP
> +.SM "S (XFS_XFLAG_FILESTREAM)"
> +Filestream allocator - allows a directory to reserve an allocation group for
> +exclusive use by files created within that directory.
> +Files being written in other directories will not use the same allocation group
> +and so files within different directories will not interleave
> +extents on disk.
> +The reservation is only active while files are being created and written into
> +the directory.
> +
> +.TP
> +.SM "x (XFS_XFLAG_DAX)"
> +If the filesystem lives on directly accessible persistent memory, reads and
> +writes to this file will go straight to the persistent memory, bypassing the
> +page cache.
> +A file with this flag set cannot share blocks.
> +If set on a directory, new files and directories created will inherit the
> +persistent memory capability.
> +
> +.TP
> +.SM "C (XFS_XFLAG_COWEXTSIZE)"
> +Copy on Write Extent size hint - if a CoW extent size value is set on the file,
> +the allocator will allocate extents for staging a copy on write operation
> +in multiples of the set size for this file.
> +See
> +.BR ioctl_xfs_fsgetxattr "(2)"
> +for more information.
> +If the CoW extent size is set on a directory, then new file and directories
> +created in the directory will inherit the parent's CoW extent size value.
> +
> +.TP
> +.SM "X (XFS_XFLAG_HASATTR)"
> +The file has extended attributes associated with it.
> +This flag cannot be changed via chattr.
> +.RE
> +
>  .TP
>  .BR chattr " [ " \-R " | " \-D " ] [ " + / \-riasAdtPneEfSxC " ]"
>  Change extended inode flags on the currently open file. The
>  .B \-R
>  and
>  .B \-D
> -options have the same meaning as above. The mapping between each
> -letter and the inode flags (refer to
> -.BR xfsctl (3)
> -for the full list) is available via the
> -.B help
> -command.
> +options have the same meaning as above.
> +
> +See the
> +.B lsattr
> +command above for the list of inode flag letters.
> +
>  .TP
>  .BI "flink " path
>  Link the currently open file descriptor into the filesystem namespace.
> 
