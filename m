Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92D4A7F5A
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 17:29:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80040304043
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 15:29:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id x1SG8QtfZCCVFOnN for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 15:29:25 -0700 (PDT)
Message-ID: <55BFEB43.3030002@sandeen.net>
Date: Mon, 03 Aug 2015 15:29:23 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] libxfs: fix uuid check durign inode allocation
References: <1438587749-31597-1-git-send-email-david@fromorbit.com>
	<1438587749-31597-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1438587749-31597-3-git-send-email-david@fromorbit.com>
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

On 8/3/15 12:42 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Needs to check sb_meta_uuid now that we the sb_uuid can change on v5
> filesystems.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

ASSERTs are off in libxfs anyway right?  Still:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 719a5b7..f427d22 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -262,7 +262,7 @@ libxfs_ialloc(
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
