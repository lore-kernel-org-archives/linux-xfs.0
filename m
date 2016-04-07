Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E0017CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 21:53:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BFE7AC004
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 19:52:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8Rlc6RFgNR74AiVi for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 19:52:56 -0700 (PDT)
Received: from Liberator.local (erlite [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C82D116C152
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 21:52:54 -0500 (CDT)
Subject: Re: [PATCH 06/19] mkfs: validate logarithmic parameters sanely
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-7-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5705CB86.8090701@sandeen.net>
Date: Wed, 6 Apr 2016 21:52:54 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-7-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com



On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Testing logarithmic paramters like "-n log=<num>" shows that we do a
> terrible job of validating such input. e.g.:

<<<<<  >>>>>>>

This lost pat of Dave's original commit log, which said:

# mkfs.xfs -f -n log=456858480 /dev/vda

> .....
> naming   =version 2              bsize=65536  ascii-ci=0 ftype=0
> ....
> 
> Yeah, I just asked for a block size of 2^456858480, and it didn't
> get rejected. Great, isn't it?
> 
> So, factor out the parsing of logarithmic parameters, and pass in
> the maximum valid value that they can take. These maximum values
> might not be completely accurate (e.g. block/sector sizes will
> affect the eventual valid maximum) but we can get rid of all the
> overflows and stupidities before we get to fine-grained validity
> checking later in mkfs once things like block and sector sizes have
> been finalised.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

otherwise,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 79 +++++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 51 insertions(+), 28 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9394bd3..dda076d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1022,6 +1022,27 @@ getbool(
>  	return c ? true : false;
>  }
>  
> +static int
> +getnum_checked(
> +	const char	*str,
> +	long long	min_val,
> +	long long	max_val,
> +	const char	*illegal_str,
> +	char		reqval_char,
> +	char		*reqval_opts[],
> +	int		reqval_optind)
> +{
> +	long long	c;
> +
> +	if (!str || *str == '\0')
> +		reqval(reqval_char, reqval_opts, reqval_optind);
> +
> +	c = getnum(str, 0, 0, false);
> +	if (c < min_val || c > max_val)
> +		illegal(str, illegal_str);
> +	return c;
> +}
> +
>  int
>  main(
>  	int			argc,
> @@ -1179,16 +1200,16 @@ main(
>  
>  				switch (getsubopt(&p, (constpp)bopts, &value)) {
>  				case B_LOG:
> -					if (!value || *value == '\0')
> -						reqval('b', bopts, B_LOG);
>  					if (blflag)
>  						respec('b', bopts, B_LOG);
>  					if (bsflag)
>  						conflict('b', bopts, B_SIZE,
>  							 B_LOG);
> -					blocklog = getnum(value, 0, 0, false);
> -					if (blocklog <= 0)
> -						illegal(value, "b log");
> +					blocklog = getnum_checked(value,
> +							XFS_MIN_BLOCKSIZE_LOG,
> +							XFS_MAX_BLOCKSIZE_LOG,
> +							"b log", 'b', bopts,
> +							B_LOG);
>  					blocksize = 1 << blocklog;
>  					blflag = 1;
>  					break;
> @@ -1325,16 +1346,16 @@ main(
>  					nodsflag = 1;
>  					break;
>  				case D_SECTLOG:
> -					if (!value || *value == '\0')
> -						reqval('d', dopts, D_SECTLOG);
>  					if (slflag)
>  						respec('d', dopts, D_SECTLOG);
>  					if (ssflag)
>  						conflict('d', dopts, D_SECTSIZE,
>  							 D_SECTLOG);
> -					sectorlog = getnum(value, 0, 0, false);
> -					if (sectorlog <= 0)
> -						illegal(value, "d sectlog");
> +					sectorlog = getnum_checked(value,
> +							XFS_MIN_SECTORSIZE_LOG,
> +							XFS_MAX_SECTORSIZE_LOG,
> +							"d sectlog", 'd', dopts,
> +							D_SECTLOG);
>  					sectorsize = 1 << sectorlog;
>  					slflag = 1;
>  					break;
> @@ -1399,9 +1420,11 @@ main(
>  					if (isflag)
>  						conflict('i', iopts, I_SIZE,
>  							 I_LOG);
> -					inodelog = getnum(value, 0, 0, false);
> -					if (inodelog <= 0)
> -						illegal(value, "i log");
> +					inodelog = getnum_checked(value,
> +							XFS_DINODE_MIN_LOG,
> +							XFS_DINODE_MAX_LOG,
> +							"i log", 'i', iopts,
> +							I_LOG);
>  					isize = 1 << inodelog;
>  					ilflag = 1;
>  					break;
> @@ -1573,16 +1596,16 @@ main(
>  					lsflag = 1;
>  					break;
>  				case L_SECTLOG:
> -					if (!value || *value == '\0')
> -						reqval('l', lopts, L_SECTLOG);
>  					if (lslflag)
>  						respec('l', lopts, L_SECTLOG);
>  					if (lssflag)
>  						conflict('l', lopts, L_SECTSIZE,
>  							 L_SECTLOG);
> -					lsectorlog = getnum(value, 0, 0, false);
> -					if (lsectorlog <= 0)
> -						illegal(value, "l sectlog");
> +					lsectorlog = getnum_checked(value,
> +							XFS_MIN_SECTORSIZE_LOG,
> +							XFS_MAX_SECTORSIZE_LOG,
> +							"l sectlog", 'l', lopts,
> +							L_SECTLOG);
>  					lsectorsize = 1 << lsectorlog;
>  					lslflag = 1;
>  					break;
> @@ -1658,16 +1681,16 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  
>  				switch (getsubopt(&p, (constpp)nopts, &value)) {
>  				case N_LOG:
> -					if (!value || *value == '\0')
> -						reqval('n', nopts, N_LOG);
>  					if (nlflag)
>  						respec('n', nopts, N_LOG);
>  					if (nsflag)
>  						conflict('n', nopts, N_SIZE,
>  							 N_LOG);
> -					dirblocklog = getnum(value, 0, 0, false);
> -					if (dirblocklog <= 0)
> -						illegal(value, "n log");
> +					dirblocklog = getnum_checked(value,
> +							XFS_MIN_REC_DIRSIZE,
> +							XFS_MAX_BLOCKSIZE_LOG,
> +							"n log", 'n', nopts,
> +							N_LOG);
>  					dirblocksize = 1 << dirblocklog;
>  					nlflag = 1;
>  					break;
> @@ -1786,16 +1809,16 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  				switch (getsubopt(&p, (constpp)sopts, &value)) {
>  				case S_LOG:
>  				case S_SECTLOG:
> -					if (!value || *value == '\0')
> -						reqval('s', sopts, S_SECTLOG);
>  					if (slflag || lslflag)
>  						respec('s', sopts, S_SECTLOG);
>  					if (ssflag || lssflag)
>  						conflict('s', sopts, S_SECTSIZE,
>  							 S_SECTLOG);
> -					sectorlog = getnum(value, 0, 0, false);
> -					if (sectorlog <= 0)
> -						illegal(value, "s sectlog");
> +					sectorlog = getnum_checked(value,
> +							XFS_MIN_SECTORSIZE_LOG,
> +							XFS_MAX_SECTORSIZE_LOG,
> +							"s sectlog", 's', sopts,
> +							S_SECTLOG);
>  					lsectorlog = sectorlog;
>  					sectorsize = 1 << sectorlog;
>  					lsectorsize = sectorsize;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
