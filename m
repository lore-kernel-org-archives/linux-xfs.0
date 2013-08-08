Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5ED537F51
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 09:05:47 -0500 (CDT)
Message-ID: <5203A5B7.4020102@sgi.com>
Date: Thu, 08 Aug 2013 09:05:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsprogs/io: add readdir command
References: <1374669868-14075-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1374669868-14075-1-git-send-email-bfoster@redhat.com>
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

On 07/24/13 07:44, Brian Foster wrote:
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
> v2:
> - Convert from getdents to readdir.
> - Use configure mechanism for libc readdir() availability (zab).
> - Add extra dirent fields to verbose output (zab).
>

Just started to look at this.

Shouldn't there be a "closedir(dir);" to close the directory stream and 
release the directory structure?

Could we get a little info for the xfs_io man page?

Looks like a nice feature.

Thanks.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
