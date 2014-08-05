Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 22B617F91
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 08:31:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FAD28F8037
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 06:31:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qo70brVD5BF2rJRs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Aug 2014 06:31:50 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s75DVnQq010181
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 5 Aug 2014 09:31:49 -0400
Date: Tue, 5 Aug 2014 09:31:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/6] xfs_io: fix leaks in parent_list()
Message-ID: <20140805133147.GF53538@bfoster.bfoster>
References: <1406905159-12415-1-git-send-email-sandeen@redhat.com>
	<1406905159-12415-6-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406905159-12415-6-git-send-email-sandeen@redhat.com>
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

On Fri, Aug 01, 2014 at 09:59:18AM -0500, Eric Sandeen wrote:
> parent_list() has instances where a handle is leaked,
> both by going out of scope, and on error paths.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  io/parent.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/io/parent.c b/io/parent.c
> index 56e126d..0313119 100644
> --- a/io/parent.c
> +++ b/io/parent.c
> @@ -293,7 +293,7 @@ print_parent_entry(parent_t *parent, int fullpath)
>  static int
>  parent_list(int fullpath)
>  {
> -	void *handlep;
> +	void *handlep = NULL;
>  	size_t handlen;
>  	int error, i;
>  	int retval = 1;
> @@ -313,6 +313,7 @@ parent_list(int fullpath)
>  				progname, path, strerror(errno));
>  			goto error;
>  		}
> +		free_handle(fshandle, fshlen);
>  	}
>  
>  	if (path_to_handle(path, &handlep, &handlen) != 0) {
> @@ -325,7 +326,7 @@ parent_list(int fullpath)
>  		if (!parentbuf) {
>  			fprintf(stderr, _("%s: unable to allocate parent buffer: %s\n"),
>  				progname, strerror(errno));
> -			return 1;
> +			goto error;
>  		}
>  
>  		if (fullpath) {
> @@ -365,6 +366,7 @@ parent_list(int fullpath)
>  
>  	retval = 0;
>  error:
> +	free(handlep);
>  	free(parentbuf);
>  	return retval;
>  }
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
