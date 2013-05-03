Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E69CE7F55
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 08:00:32 -0500 (CDT)
Message-ID: <5183B4F9.2000008@sgi.com>
Date: Fri, 3 May 2013 08:00:41 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests shared/298: various fixes
References: <517AE12C.2050902@redhat.com> <517FF548.1010309@sandeen.net>
In-Reply-To: <517FF548.1010309@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 04/30/2013 11:46 AM, Eric Sandeen wrote:
> fix shared/298:
>
> * don't include common/config, not needed and breaks
>    stuff when $SCRATCH_DEV_POOL is defined:
>      Error: $SCRATCH_DEV should be unset when $SCRATCH_DEV_POOL is set
> * make sure xfs_io has fiemap, we'll need it
> * add -F to the xfs_io invocation, again, for use on
>    old xfsprogs on non-xfs filesystems
> * ignore ENOSPC errors from "garbage" loop; the only goal
>    is to fill it, ENOSPC doesn't matter.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> V2: break out of copy loop when full

Dave, looks like Eric applied your suggestions, may I put your 
Reviewed-by on this one?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
