Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A73D7CFB
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 07:31:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EADB4AC002
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 05:31:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xZfsr8ljxDtlRyZB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 05:31:28 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 6C3FE4AD7D
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 12:31:28 +0000 (UTC)
Date: Wed, 16 Mar 2016 08:31:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] io/mremap: modify argument errors of mremap command
Message-ID: <20160316123126.GC8096@bfoster.bfoster>
References: <1458120707-25219-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458120707-25219-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 16, 2016 at 05:31:47PM +0800, Zorro Lang wrote:
> There're 2 argument errors in mremap command:
> 1. If run "mremap 1024 8192", it won't return error and try to
> do "mremap 1024" silently.
> 
> 2. The "-f" option can't be used, due to it need a new address
> argument as the fifth argument of mremap() syscall(man mremap).
> 
> This patch try to fix above two problems.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

A couple nits...

> 
> Hi,
> 
> I'm not sure pass a address argument to mremap command is right or
> wrong. And maybe I should use strtoul() to instead of cvtnum() for
> address argument.
> 
> At least I did some simple test with this patch on my machine, results are:
> "mremap -f 139946004389888 2048"  PASS
> "mremap -f 4096k 2048"            PASS
> "mremap -f 1g 2048"               PASS
> "mremap -f 4096 2048"             FAIL as 'Permission denied'
> 
> What do you think of this patch?
> 
> Thanks,
> Zorro
> 
> 
>  io/mmap.c         | 22 +++++++++++++++-------
>  man/man8/xfs_io.8 |  5 ++++-
>  2 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/io/mmap.c b/io/mmap.c
> index 5970069..672ee61 100644
> --- a/io/mmap.c
> +++ b/io/mmap.c
> @@ -589,7 +589,7 @@ mremap_help(void)
>  "\n"
>  " Resizes the mappping, growing or shrinking from the current size.\n"
>  " The default stored value is 'X', repeated to fill the range specified.\n"
> -" -f -- use the MREMAP_FIXED flag\n"
> +" -f <new_address> -- use the MREMAP_FIXED flag to mremap on the new address\n"

Exceeds 80 chars.

>  " -m -- use the MREMAP_MAYMOVE flag\n"
>  "\n"));
>  }
> @@ -600,15 +600,18 @@ mremap_f(
>  	char		**argv)
>  {
>  	ssize_t		new_length;
> -	void		*new_addr;
> +	void		*new_addr = NULL;
>  	int		flags = 0;
>  	int		c;
>  	size_t		blocksize, sectsize;
>  
> -	while ((c = getopt(argc, argv, "fm")) != EOF) {
> +	init_cvtnum(&blocksize, &sectsize);
> +
> +	while ((c = getopt(argc, argv, "f:m")) != EOF) {
>  		switch (c) {
>  		case 'f':
>  			flags = MREMAP_FIXED|MREMAP_MAYMOVE;
> +			new_addr = (void *)cvtnum(blocksize, sectsize, optarg);
>  			break;
>  		case 'm':
>  			flags = MREMAP_MAYMOVE;
> @@ -618,7 +621,9 @@ mremap_f(
>  		}
>  	}
>  
> -	init_cvtnum(&blocksize, &sectsize);
> +	if (optind != argc - 1)
> +		return command_usage(&mremap_cmd);
> +
>  	new_length = cvtnum(blocksize, sectsize, argv[optind]);
>  	if (new_length < 0) {
>  		printf(_("non-numeric offset argument -- %s\n"),
> @@ -626,7 +631,10 @@ mremap_f(
>  		return 0;
>  	}
>  
> -	new_addr = mremap(mapping->addr, mapping->length, new_length, flags);
> +	if (!new_addr)
> +		new_addr = mremap(mapping->addr, mapping->length, new_length, flags);
> +	else
> +		new_addr = mremap(mapping->addr, mapping->length, new_length, flags, new_addr);

Both mremap() calls above exceed 80 chars. Otherwise, this looks Ok to
me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	if (new_addr == MAP_FAILED)
>  		perror("mremap");
>  	else {
> @@ -697,9 +705,9 @@ mmap_init(void)
>  	mremap_cmd.altname = "mrm";
>  	mremap_cmd.cfunc = mremap_f;
>  	mremap_cmd.argmin = 1;
> -	mremap_cmd.argmax = 2;
> +	mremap_cmd.argmax = 3;
>  	mremap_cmd.flags = CMD_NOFILE_OK | CMD_FOREIGN_OK;
> -	mremap_cmd.args = _("[-m|-f] newsize");
> +	mremap_cmd.args = _("[-m|-f <new_address>] newsize");
>  	mremap_cmd.oneline =
>  		_("alters the size of the current memory mapping");
>  	mremap_cmd.help = mremap_help;
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 33fbe6a..984b551 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -581,7 +581,7 @@ See the
>  .B mmap
>  command.
>  .TP
> -.BI "mremap [ \-f ] [ \-m ] " new_length
> +.BI "mremap [ \-f <new_address> ] [ \-m ] " new_length
>  Changes the current mapping size to
>  .IR new_length .
>  Whether the mapping may be moved is controlled by the flags passed;
> @@ -589,6 +589,9 @@ MREMAP_FIXED
>  .RB ( \-f ),
>  or MREMAP_MAYMOVE
>  .RB ( \-m ).
> +.IR new_length
> +specifies a page-aligned address to which the mapping must be moved. It
> +can be setted to 139946004389888, 4096k or 1g etc.
>  .TP
>  .B mrm
>  See the
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
