Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 556BE7F9A
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 08:21:15 -0500 (CDT)
Message-ID: <5204ECC7.2090502@sgi.com>
Date: Fri, 09 Aug 2013 08:21:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfsprogs/io: add readdir command
References: <1376051546-31578-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1376051546-31578-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 08/09/13 07:32, Brian Foster wrote:
> readdir reads the directory entries from an open directory from
> the provided offset (or 0 if not specified). On completion,
> readdir prints summary information regarding the number of
> operations and bytes transferred. Options are available to specify
> the starting offset, length and verbose mode to dump directory
> entry information.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---
>
> v3:
> - dup() file->fd and add corresponding closedir() (mark).
> - add readdir section to xfs_io manpage (mark).
>
> v2:
> - Convert from getdents to readdir.
> - Use configure mechanism for libc readdir() availability (zab).
> - Add extra dirent fields to verbose output (zab).

Thank-you, looks great. We can get it in right away.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
