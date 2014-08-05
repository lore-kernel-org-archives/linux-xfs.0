Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E74527F8C
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 08:16:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5446304064
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 06:16:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d6U9G9SyIBlO22Jy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Aug 2014 06:16:31 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s75DGUrQ003959
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 5 Aug 2014 09:16:30 -0400
Date: Tue, 5 Aug 2014 09:16:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/6] xfs_fsr: free handlep in fsrfs
Message-ID: <20140805131628.GD53538@bfoster.bfoster>
References: <1406905159-12415-1-git-send-email-sandeen@redhat.com>
	<1406905159-12415-4-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406905159-12415-4-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2014 at 09:59:16AM -0500, Eric Sandeen wrote:
> We leaked the fshandlep in both error returns and
> normal function exit.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Same thing in the 'if (endtime && endtime < time(0))' thing towards the
end of the for loop, but that ends with an exit(), so:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fsr/xfs_fsr.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 752d2db..580604c 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -702,6 +702,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>  	if ((fsfd = open(mntdir, O_RDONLY)) < 0) {
>  		fsrprintf(_("unable to open: %s: %s\n"),
>  		          mntdir, strerror( errno ));
> +		free(fshandlep);
>  		return -1;
>  	}
>  
> @@ -709,6 +710,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>  		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
>  			  mntdir);
>  		close(fsfd);
> +		free(fshandlep);
>  		return -1;
>  	}
>  
> @@ -774,6 +776,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>  out0:
>  	tmp_close(mntdir);
>  	close(fsfd);
> +	free(fshandlep);
>  	return 0;
>  }
>  
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
