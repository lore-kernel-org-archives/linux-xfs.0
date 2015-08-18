Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B7847F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 19:38:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6431D304067
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 17:38:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HoZYp0qww5gXuffs for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 17:38:44 -0700 (PDT)
Date: Tue, 18 Aug 2015 10:30:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] v3 inodes are only valid on crc-enabled filesystems
Message-ID: <20150818003031.GG714@dastard>
References: <F80944E7-F176-450B-A98E-87A0F6DC196A@filmlight.ltd.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F80944E7-F176-450B-A98E-87A0F6DC196A@filmlight.ltd.uk>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

On Sun, Aug 16, 2015 at 12:34:24PM +0100, Roger Willcocks wrote:
> Fix an xfs_repair regression reported by Leslie Rhorer where a bad
> (v3) inode version number was not reset.
> 
> Signed-off-by: Roger Willcocks <roger@filmlight.ltd.uk>

Hi Roger,

Just a FYI - the patch has mangled whitespace:
in it.

> ---
> db/check.c             |  2 +-
> include/libxfs.h       |  2 +-
> include/xfs_dinode.h   | 10 +++++++++-
> libxfs/xfs_inode_buf.c |  2 +-
> repair/dinode.c        |  7 +++----
> repair/prefetch.c      |  2 +-
> 6 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/db/check.c b/db/check.c
> index c4c972f..b5c3b8e 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2637,7 +2637,7 @@ process_inode(
> 		error++;
> 		return;
> 	}
> -	if (!XFS_DINODE_GOOD_VERSION(idic.di_version)) {
> +	if (!xfs_dinode_good_version(mp, idic.di_version)) {
> 		if (isfree || v)
> 			dbprintf(_("bad version number %#x for inode %lld\n"),
> 				idic.di_version, ino);

All the patch hunks are missing the leading " " for non-modified
lines. I've fixed it manually, but can you make sure future patches
are not mangled?

> -- 
> 2.5.0.rc0

IMO, it's best not to use development versions of git for anything
other than testing.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
