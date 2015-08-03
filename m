Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D32A07F56
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 11:12:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B066D304039
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:12:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uBagNdILtn5EI5st for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 09:12:18 -0700 (PDT)
Message-ID: <55BF92DF.6080506@sandeen.net>
Date: Mon, 03 Aug 2015 09:12:15 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: fix sb_meta_uuid usage
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>
	<1438587625-31437-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1438587625-31437-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 8/3/15 12:40 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> After changing the UUID on a v5 filesystem, xfstests fails
> immediately on a debug kernel with:
> 
> XFS: Assertion failed: uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid), file: fs/xfs/xfs_inode.c, line: 799
> 
> This needs to check against the sb_meta_uuid, not the user visible
> UUID that was changed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

first of a few brown paper bags for me :(  I guess I didn't test on debug after all.  :(

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index fb52ff0..4156e37 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -796,7 +796,7 @@ xfs_ialloc(
>  
>  	if (ip->i_d.di_version == 3) {
>  		ASSERT(ip->i_d.di_ino == ino);
> -		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid));
> +		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
>  		ip->i_d.di_crc = 0;
>  		ip->i_d.di_changecount = 1;
>  		ip->i_d.di_lsn = 0;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
