Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B10467F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 08:29:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A295F304051
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 06:29:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CwDL42Qibyg1Z3zX for <xfs@oss.sgi.com>;
	Tue, 11 Mar 2014 06:29:52 -0700 (PDT)
Message-ID: <531F0FCF.2000807@sandeen.net>
Date: Tue, 11 Mar 2014 08:29:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] repair: ensure that unused superblock fields are zeroed
References: <1394518948-1506-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1394518948-1506-1-git-send-email-david@fromorbit.com>
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

On 3/11/14, 1:22 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we grab a superblock off disk via get_sb(), we don't know what
> the in-memory superblock we are filling out contained. We ned to
> ensure that the entire structure is returned in an initialised
> state regardless of which fields libxfs_sb_from_disk() populates
> from disk. In this case, it doesn't populate the sb_crc field,
> and so uninitialised values can escape through to disk on v4
> filesystems because of this. This causes xfs/031 to fail on v4
> filesystems.
> 
> Reported-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

cool, thanks for finding that "overnight."  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/sb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index b111aca..d928dc0 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -518,6 +518,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
>  		exit(1);
>  	}
>  	memset(buf, 0, size);
> +	memset(sbp, 0, sizeof(*sbp));
>  
>  	/* try and read it first */
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
