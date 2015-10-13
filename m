Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 527D97F3F
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 17:40:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 40D9D8F8064
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 15:40:18 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id XaLj5175H4tFaX9o (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 15:40:12 -0700 (PDT)
Date: Tue, 13 Oct 2015 15:39:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/51] libxcmd: provide a common function to report
	command runtimes
Message-ID: <20151013223943.GH10397@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050520.1504.59073.stgit@birch.djwong.org>
	<20151013174827.GA31669@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151013174827.GA31669@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Oct 13, 2015 at 10:48:27AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 06, 2015 at 10:05:20PM -0700, Darrick J. Wong wrote:
> > Refactor the open-coded runtime stats reporting into a library
> > command, then update xfs_io commands to use it.
> 
> We need to pass the actual operation that we summarize, otherwise
> various tests are very unhappy:
> 
> diff --git a/include/command.h b/include/command.h
> index 51dae6a..fb86f7a 100644
> --- a/include/command.h
> +++ b/include/command.h
> @@ -58,8 +58,8 @@ extern void		command_loop(void);
>  extern int		command_usage(const cmdinfo_t *ci);
>  extern int		command(const cmdinfo_t *ci, int argc, char **argv);
>  
> -extern void		report_io_times(struct timeval *t2, long long offset,
> -				     long long count, long long total,
> -				     int ops, int condensed);
> +extern void		report_io_times(const char *op, struct timeval *t2,
> +				long long offset, long long count,
> +				long long total, int ops, int condensed);
>  
>  #endif	/* __COMMAND_H__ */
> diff --git a/io/pread.c b/io/pread.c
> index 66ea945..f16c86c 100644
> --- a/io/pread.c
> +++ b/io/pread.c
> @@ -487,7 +487,7 @@ pread_f(
>  	gettimeofday(&t2, NULL);
>  	t2 = tsub(t2, t1);
>  
> -	report_io_times(&t2, (long long)offset, count, total, c, Cflag);
> +	report_io_times("read", &t2, (long long)offset, count, total, c, Cflag);

Aha!  I knew I'd forgotten to send out an updated patch for _something_.
Thank you for catching this!

--D

>  	return 0;
>  }
>  
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 81f6abe..f354de3 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -384,7 +384,7 @@ pwrite_f(
>  	gettimeofday(&t2, NULL);
>  	t2 = tsub(t2, t1);
>  
> -	report_io_times(&t2, (long long)offset, count, total, c, Cflag);
> +	report_io_times("wrote", &t2, (long long)offset, count, total, c, Cflag);
>  done:
>  	if (infile)
>  		close(fd);
> diff --git a/io/reflink.c b/io/reflink.c
> index 3572728..20007bf 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -161,7 +161,7 @@ dedupe_f(
>  	gettimeofday(&t2, NULL);
>  	t2 = tsub(t2, t1);
>  
> -	report_io_times(&t2, (long long)doffset, count, total, ops, condensed);
> +	report_io_times("linked", &t2, (long long)doffset, count, total, ops, condensed);
>  done:
>  	close(fd);
>  	return 0;
> @@ -284,7 +284,7 @@ clone_all:
>  	gettimeofday(&t2, NULL);
>  	t2 = tsub(t2, t1);
>  
> -	report_io_times(&t2, (long long)doffset, count, total, ops, condensed);
> +	report_io_times("linked", &t2, (long long)doffset, count, total, ops, condensed);
>  done:
>  	close(fd);
>  	return 0;
> diff --git a/io/sendfile.c b/io/sendfile.c
> index ced6369..21ab444 100644
> --- a/io/sendfile.c
> +++ b/io/sendfile.c
> @@ -151,7 +151,7 @@ sendfile_f(
>  	gettimeofday(&t2, NULL);
>  	t2 = tsub(t2, t1);
>  
> -	report_io_times(&t2, (long long)offset, count, total, c, Cflag);
> +	report_io_times("sent", &t2, (long long)offset, count, total, c, Cflag);
>  done:
>  	if (infile)
>  		close(fd);
> diff --git a/libxcmd/command.c b/libxcmd/command.c
> index 5a5bb01..04f66de 100644
> --- a/libxcmd/command.c
> +++ b/libxcmd/command.c
> @@ -195,6 +195,7 @@ command_loop(void)
>  
>  void
>  report_io_times(
> +	const char		*op,
>  	struct timeval		*t2,
>  	long long		offset,
>  	long long		count,
> @@ -208,8 +209,8 @@ report_io_times(
>  	if (!condensed) {
>  		cvtstr((double)total, s1, sizeof(s1));
>  		cvtstr(tdiv((double)total, *t2), s2, sizeof(s2));
> -		printf(_("linked %lld/%lld bytes at offset %lld\n"),
> -			total, count, (long long)offset);
> +		printf(_("%s %lld/%lld bytes at offset %lld\n"),
> +			op, total, count, (long long)offset);
>  		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
>  			s1, ops, ts, s2, tdiv((double)ops, *t2));
>  	} else {/* bytes,ops,time,bytes/sec,ops/sec */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
