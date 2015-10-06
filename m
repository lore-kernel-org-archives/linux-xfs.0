Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A542B29DF5
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 12:00:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9BA87304039
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 10:00:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OtiVKKccVcNLVQKZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 10:00:41 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 34378344ED3
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 17:00:41 +0000 (UTC)
Date: Tue, 6 Oct 2015 13:00:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs_io: add inode -l argument to return largest
	inode number
Message-ID: <20151006170039.GC63205@bfoster.bfoster>
References: <1443186467-20110-1-git-send-email-cmaiolino@redhat.com>
	<1443186467-20110-3-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1443186467-20110-3-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 25, 2015 at 03:07:46PM +0200, Carlos Maiolino wrote:
> Implements '-l' argument in inode command, returning to the user, the largest
> inode allocated and used in the filesystem.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  io/open.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/io/open.c b/io/open.c
> index 6a794ba..57ff0bf 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -759,6 +759,7 @@ inode_help(void)
>  "\n"
>  "Query physical information about the inode"
>  "\n"
> +" -l	-- Returns the largest inode number in the filesystem\n"
>  " -s	-- Returns the physical size (in bits) of the\n"
>  "	   largest inode number in the filesystem\n"
>  "\n"));
> @@ -777,23 +778,27 @@ inode_f(
>  	struct xfs_fsop_bulkreq	bulkreq;
>  	int			c;
>  	int			ret_lsize = 0;
> +	int			ret_largest = 0;
>  
>  	bulkreq.lastip = &last;
>  	bulkreq.icount = 1024; /* maybe an user-defined value!? */
>  	bulkreq.ubuffer = &igroup;
>  	bulkreq.ocount = &count;
>  
> -	while ((c = getopt(argc, argv, "s")) != EOF) {
> +	while ((c = getopt(argc, argv, "sl")) != EOF) {
>  		switch (c) {
>  		case 's':
>  			ret_lsize = 1;
>  			break;
> +		case 'l':
> +			ret_largest = 1;
> +			break;
>  		default:
>  			return command_usage(&inode_cmd);
>  		}
>  	}
>  
> -	if (ret_lsize) {
> +	if (ret_lsize || ret_largest) {
>  		for (;;) {
>  			if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
>  					&bulkreq)) {
> @@ -811,8 +816,11 @@ inode_f(
>  		lastino = igroup[lastgrp].xi_startino +
>  			  xfs_highbit64(igroup[lastgrp].xi_allocmask);
>  
> -		printf (_("Largest inode size: %d\n"),
> -			 lastino > XFS_MAXINUMBER_32 ? 64 : 32);
> +		if (ret_lsize)
> +			printf (_("Largest inode size: %d\n"),
> +				lastino > XFS_MAXINUMBER_32 ? 64 : 32);
> +		else
> +			printf(_("Largest inode: %llu\n"), lastino);

Hmm, do we need the -s option if we have -l to print the actual largest
inode number?

Brian

>  
>  	}
>  
> @@ -887,7 +895,7 @@ open_init(void)
>  
>  	inode_cmd.name = "inode";
>  	inode_cmd.cfunc = inode_f;
> -	inode_cmd.args = _("[-s]");
> +	inode_cmd.args = _("[-s | -l]");
>  	inode_cmd.argmin = 1;
>  	inode_cmd.argmax = 1;
>  	inode_cmd.flags = CMD_NOMAP_OK;
> -- 
> 2.4.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
