Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB32E7F88
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 08:31:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C93FB8F8037
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 06:31:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id drid8jKrkJJTavRE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Aug 2014 06:31:43 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s75DVgTt021131
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 5 Aug 2014 09:31:42 -0400
Date: Tue, 5 Aug 2014 09:31:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] libhandle: Fix handle leak in path_to_fshandle error
	paths
Message-ID: <20140805133140.GE53538@bfoster.bfoster>
References: <1406905159-12415-1-git-send-email-sandeen@redhat.com>
	<1406905159-12415-5-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406905159-12415-5-git-send-email-sandeen@redhat.com>
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

On Fri, Aug 01, 2014 at 09:59:17AM -0500, Eric Sandeen wrote:
> path_to_fshandle calls obj_to_handle, which potentially
> allocates a handle, but the handle isn't freed on
> a subsequent error path.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  libhandle/handle.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/libhandle/handle.c b/libhandle/handle.c
> index 9f81483..3c1395a 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
> @@ -97,6 +97,7 @@ path_to_fshandle(
>  		/* new filesystem. add it to the cache */
>  		fdhp = malloc(sizeof(struct fdhash));
>  		if (fdhp == NULL) {
> +			free(*fshanp);

Might be a good idea to set *fshanp back to NULL here. It doesn't appear
to be an issue with current callers, however:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  			close(fd);
>  			errno = ENOMEM;
>  			return -1;
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
