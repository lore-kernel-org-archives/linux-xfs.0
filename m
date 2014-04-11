Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73F2B29DF7
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:03:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25C4FAC003
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 12:03:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 80DY8CGhe3zKh5IE for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 12:03:08 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3BJ38pW023167
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 15:03:08 -0400
Date: Fri, 11 Apr 2014 15:03:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/14] xfsprogs: trivial buffer frees on error paths
Message-ID: <20140411190304.GB16717@laptop.bfoster>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
	<1396999504-13769-4-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1396999504-13769-4-git-send-email-sandeen@redhat.com>
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

On Tue, Apr 08, 2014 at 06:24:53PM -0500, Eric Sandeen wrote:
> Lots of memory leaks on error paths etc, spotted by
> coverity.  This patch rolls up the super-straightforward
> fixes across xfsprogs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  db/addr.c    |   15 +++++++--------
>  db/check.c   |    4 +++-
>  db/write.c   |    2 ++
>  io/parent.c  |    2 ++
>  mkfs/proto.c |    3 ++-
>  5 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/db/addr.c b/db/addr.c
> index f74dd62..f9f760d 100644
> --- a/db/addr.c
> +++ b/db/addr.c
> @@ -85,16 +85,14 @@ addr_f(
>  	fl = flist_scan(argv[1]);
>  	if (fl == NULL)
>  		return 0;
> -	if (!flist_parse(fld, fl, iocur_top->data, 0)) {
> -		flist_free(fl);
> -		return 0;
> -	}
> +	if (!flist_parse(fld, fl, iocur_top->data, 0))
> +		goto out;
> +	

You've got some trailing whitespace here (tab in the empty line).

Brian

>  	flist_print(fl);
>  	for (tfl = fl; tfl->child != NULL; tfl = tfl->child) {
>  		if ((tfl->flags & FL_OKLOW) && tfl->low < tfl->high) {
>  			dbprintf(_("array not allowed for addr command\n"));
> -			flist_free(fl);
> -			return 0;
> +			goto out;
>  		}
>  	}
>  	fld = tfl->fld;
> @@ -103,7 +101,7 @@ addr_f(
>  		next = inode_next_type();
>  	if (next == TYP_NONE) {
>  		dbprintf(_("no next type for field %s\n"), fld->name);
> -		return 0;
> +		goto out;
>  	}
>  	fa = &ftattrtab[fld->ftyp];
>  	ASSERT(fa->ftyp == fld->ftyp);
> @@ -111,9 +109,10 @@ addr_f(
>  	if (adf == NULL) {
>  		dbprintf(_("no addr function for field %s (type %s)\n"),
>  			fld->name, fa->name);
> -		return 0;
> +		goto out;
>  	}
>  	(*adf)(iocur_top->data, tfl->offset, next);
> +out:
>  	flist_free(fl);
>  	return 0;
>  }
> diff --git a/db/check.c b/db/check.c
> index 4867698..baf7f9f 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -1136,7 +1136,7 @@ blocktrash_f(
>  	}
>  	if (blocks == 0) {
>  		dbprintf(_("blocktrash: no matching blocks\n"));
> -		return 0;
> +		goto out;
>  	}
>  	if (!sopt)
>  		dbprintf(_("blocktrash: seed %u\n"), seed);
> @@ -1161,6 +1161,7 @@ blocktrash_f(
>  			}
>  		}
>  	}
> +out:
>  	xfree(lentab);
>  	return 0;
>  }
> @@ -1907,6 +1908,7 @@ ncheck_f(
>  			break;
>  		default:
>  			dbprintf(_("bad option -%c for ncheck command\n"), c);
> +			xfree(ilist);
>  			return 0;
>  		}
>  	}
> diff --git a/db/write.c b/db/write.c
> index 7b34fc0..ca8bd0f 100644
> --- a/db/write.c
> +++ b/db/write.c
> @@ -233,6 +233,7 @@ bwrite_lrot(
>  	memcpy(hold_region, base, shift);
>  	memcpy(base, base+shift, len-shift);
>  	memcpy(base+(len-shift), hold_region, shift);
> +	free(hold_region);
>  }
>  
>  /* ARGSUSED */
> @@ -265,6 +266,7 @@ bwrite_rrot(
>  	memcpy(hold_region, base+(len-shift), shift);
>  	memmove(base+shift, base, len-shift);
>  	memcpy(base, hold_region, shift);
> +	free(hold_region);
>  }
>  
>  /* ARGSUSED */
> diff --git a/io/parent.c b/io/parent.c
> index 47faaa0..ca989e9 100644
> --- a/io/parent.c
> +++ b/io/parent.c
> @@ -258,6 +258,8 @@ parent_check(void)
>  	if (!bstatbuf || !parentbuf) {
>  		fprintf(stderr, _("unable to allocate buffers: %s\n"),
>  			strerror(errno));
> +		free(bstatbuf);
> +		free(parentbuf);
>  		return 1;
>  	}
>  
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index b7e0761..95583c9 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -49,7 +49,7 @@ char *
>  setup_proto(
>  	char	*fname)
>  {
> -	char		*buf;
> +	char		*buf = NULL;
>  	static char	dflt[] = "d--755 0 0 $";
>  	int		fd;
>  	long		size;
> @@ -85,6 +85,7 @@ setup_proto(
>  
>  out_fail:
>  	close(fd);
> +	free(buf);
>  	exit(1);
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
