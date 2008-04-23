Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 21:18:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3N4I3pk018552
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 21:18:04 -0700
Message-ID: <480EB8BC.9010205@sgi.com>
Date: Wed, 23 Apr 2008 14:19:08 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Don't double count reserved block changes on UP.
References: <20080422110052.GY103491721@sgi.com>
In-Reply-To: <20080422110052.GY103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Makes sense.  Looks good to me.

David Chinner wrote:
> Don't double count reserved block changes on UP.
> 
> On uniprocessor machines, the incore superblock is used for
> all in memory accounting of free blocks. in this situation,
> changes to the reserved block count are accounted twice;
> once directly and once via xfs_mod_incore_sb(). Seeing as
> the modification on SMP is done via xfs_mod_incore_sb(),
> make this the only update mechanism that UP uses as well.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_fsops.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index d3a0f53..c4f7c93 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -552,11 +552,8 @@ retry:
>  			mp->m_resblks += free;
>  			mp->m_resblks_avail += free;
>  			fdblks_delta = -free;
> -			mp->m_sb.sb_fdblocks = XFS_ALLOC_SET_ASIDE(mp);
>  		} else {
>  			fdblks_delta = -delta;
> -			mp->m_sb.sb_fdblocks =
> -				lcounter + XFS_ALLOC_SET_ASIDE(mp);
>  			mp->m_resblks = request;
>  			mp->m_resblks_avail += delta;
>  		}
> @@ -587,7 +584,6 @@ out:
>  		if (error == ENOSPC)
>  			goto retry;
>  	}
> -
>  	return 0;
>  }
>  
> 
