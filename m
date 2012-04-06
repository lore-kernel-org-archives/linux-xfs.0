Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q36GCCdb008263 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 11:12:12 -0500
Message-ID: <4F7F15D8.9050807@sgi.com>
Date: Fri, 06 Apr 2012 11:12:08 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: several 274 fixups
References: <4F271967.10308@sandeen.net> <4F593147.8050603@sandeen.net>
In-Reply-To: <4F593147.8050603@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 03/08/12 16:23, Eric Sandeen wrote:
> This changes quite a few things about 274 to make it more robust
> and useful.
>
> * More comments
> * Use xfs_io for falloc (not all systems have /usr/bin/fallocate)
> * use _require_xfs_io_falloc to be sure system&  fs support preallocation
> * Do not remove all of the files in $SCRATCH_MNT/ post-mkfs
> * Do not remove all of the files in $SCRATCH_MNT/ on completion
>    (this breaks e2fsck when lost+found/ goes missing)
> * Don't cd into $SCRATCH_MNT
> * Try harder to completely fill the fs
> * Use a larger preallocated space, and write into all of it (hopefully
>    avoid just accidentally succeeding by writing into fs reserved
>    space that may be there)
> * Save more output in $seq.full instead of /dev/null
> * Fill preallocated space diabolically
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

Looks very nice.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
