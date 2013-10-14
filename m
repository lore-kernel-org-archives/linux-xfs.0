Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A31927F67
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 08:09:05 -0500 (CDT)
Message-ID: <525BED09.4090100@sgi.com>
Date: Mon, 14 Oct 2013 08:09:29 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfstests: improvements for generic/204
References: <1378167295-7566-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1378167295-7566-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 09/02/2013 07:14 PM, Dave Chinner wrote:
> Hi folks,
>
> These patches are fixes and improvements for generic/204.
>
> Firstly, it doesn't check the filesystem it works on, and so
> corruptions can go undetected. Secondly, _scratch_mkfs_sized doesn't
> handle different block sizes passed in on the command line via
> MKFS_OPTIONS at all well (i.e they get ignored) and so it has never
> run on small block size filesystems of any type.
>
> Finally, make it run on filesystems with different block sizes and
> inode sizes by scaling the file count appropriately. It detects
> block and inode size from the output of mkfs, so scaling only occurs
> if the underlying filesystem emits them.
>
> Cheers,
>
> Dave.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

This series has been commited.

Thanks
--Rich

commit a4d5b247b565307c7da05d7bf784f093ba3f5dad
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 3 00:14:55 2013 +0000

     xfstests: Make 204 work with different block and inode sizes.

commit f7433693f4198153900081dca01ab5cd940986b8
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 3 00:14:54 2013 +0000

     xfstests: Obey mkfs options for sized filesystems on XFS

commit f33d180335f13407df92c0dd642974a808d6b87f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 3 00:14:53 2013 +0000

     xfstests: generic/204 should call _check_scratch_fs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
