Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC7F47F85
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 08:16:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA7BA304064
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 06:16:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id J1IJnAGFHlowgR4x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Aug 2014 06:16:07 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s75DG6sn021890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 5 Aug 2014 09:16:07 -0400
Date: Tue, 5 Aug 2014 09:16:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/6] xfs_io: free fshandlep in parent_check()
Message-ID: <20140805131604.GB53538@bfoster.bfoster>
References: <1406905159-12415-1-git-send-email-sandeen@redhat.com>
	<1406905159-12415-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406905159-12415-2-git-send-email-sandeen@redhat.com>
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

On Fri, Aug 01, 2014 at 09:59:14AM -0500, Eric Sandeen wrote:
> The allocated fshandle wasn't freed in either normal
> exit or error paths.
> 
> Do this, and consolidate cleanup into an out: target.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  io/parent.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/io/parent.c b/io/parent.c
> index ca989e9..56e126d 100644
> --- a/io/parent.c
> +++ b/io/parent.c
> @@ -258,9 +258,8 @@ parent_check(void)
>  	if (!bstatbuf || !parentbuf) {
>  		fprintf(stderr, _("unable to allocate buffers: %s\n"),
>  			strerror(errno));
> -		free(bstatbuf);
> -		free(parentbuf);
> -		return 1;
> +		err_status = 1;
> +		goto out;
>  	}
>  
>  	if (do_bulkstat(parentbuf, &parentbuf_size, bstatbuf, fsfd, fshandlep) != 0)
> @@ -272,8 +271,10 @@ parent_check(void)
>  		printf(_("succeeded checking %llu inodes\n"),
>  			(unsigned long long) inodes_checked);
>  
> +out:
>  	free(bstatbuf);
>  	free(parentbuf);
> +	free(fshandlep);
>  	return err_status;
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
