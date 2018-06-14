Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50200 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935766AbeFNDRN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 23:17:13 -0400
Subject: Re: [PATCH 5/5] mkfs: generate mkfs config file in man page
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <152891834283.3968.15510112783863370484.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cf131331-c925-4688-547d-ee3b7b27ad17@sandeen.net>
Date: Wed, 13 Jun 2018 22:17:11 -0500
MIME-Version: 1.0
In-Reply-To: <152891834283.3968.15510112783863370484.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/13/18 2:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Generate the default mkfs config file in the man page.

Cool.  Minor things below.

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  Makefile               |    1 +
>  man/man8/Makefile      |   13 ++++++++++---
>  man/man8/mkfs.xfs.8.in |   35 +----------------------------------
>  mkfs/mkconfig.c        |   22 ++++++++++++++++------
>  4 files changed, 28 insertions(+), 43 deletions(-)
> 
> 
> diff --git a/Makefile b/Makefile
> index 7ddfa316..947eaaf5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -92,6 +92,7 @@ copy: libxlog
>  mkfs: libxcmd
>  spaceman: libxcmd
>  scrub: libhandle libxcmd
> +man: mkfs
>  
>  ifeq ($(HAVE_BUILDDEFS), yes)
>  include $(BUILDRULES)
> diff --git a/man/man8/Makefile b/man/man8/Makefile
> index 08e5e0d7..67a67cd2 100644
> --- a/man/man8/Makefile
> +++ b/man/man8/Makefile
> @@ -13,13 +13,20 @@ LSRCFILES	= $(MAN_PAGES)
>  
>  default : $(MAN_PAGES)
>  
> -LDIRT		= mkfs.xfs.8
> +LDIRT		= mkfs.xfs.8 cfg.8
>  
>  include $(BUILDRULES)
>  
> -mkfs.xfs.8: mkfs.xfs.8.in
> +cfg.8: ../../mkfs/mkconfig

+cfg.8: $(TOPDIR)/mkfs/mkconfig

> +	@echo "    [GENERATE] $@"
> +	$(Q) ../../mkfs/mkconfig -m > $@

+	$(Q) $(TOPDIR)/mkfs/mkconfig -m > $@

(when in Rome...)

> +
> +mkfs.xfs.8: mkfs.xfs.8.in cfg.8
>  	@echo "    [SED]    $@"
> -	$(Q)$(SED) -e "s|@sysconfdir@|$(PKG_ETC_DIR)|g" < $< > $@
> +	$(Q) $(SED) -e "s|@sysconfdir@|$(PKG_ETC_DIR)|g" \
> +		   -e "/@default_mkfs_cfg@/r cfg.8" \
> +		   -e "s/@default_mkfs_cfg@//g" \
> +		   < $< > $@

Just for kicks can we use a consistent sed delimiter?

Also ... meh, ok, that sed command works.

/@default_mkfs_cfg@/{
	s/@default_mkfs_cfg@//g
	r cfg.8
}
works too I think ;)  But ... eh, yours works, it's fine.

>  
>  install : default
>  	$(INSTALL) -m 755 -d $(MAN_DEST)
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index cf4bdf82..4a557910 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -970,40 +970,7 @@ Currently all default parameters can only be either enabled or disabled,
>  with a value of 1 to enable or 0 to disable.
>  See below for a list of all supported configuration parameters and their
>  current built-in default settings.
> -.PP
> -.BI [data]
> -.br
> -.BI noalign=0
> -.PP
> -.BI [inode]
> -.br
> -.BI align=1
> -.br
> -.BI projid32bit=1
> -.br
> -.BI sparse=0
> -.PP
> -.BI [log]
> -.br
> -.BI lazy-count=1
> -.PP
> -.BI [metadata]
> -.br
> -.BI crc=1
> -.br
> -.BI finobt=1
> -.br
> -.BI rmapbt=0
> -.br
> -.BI reflink=0
> -.PP
> -.BI [naming]
> -.br
> -.BI ftype=1
> -.PP
> -.BI [rtdev]
> -.br
> -.BI noalign=0
> +@default_mkfs_cfg@
>  .PP
>  .SH SEE ALSO
>  .BR xfs (5),
> diff --git a/mkfs/mkconfig.c b/mkfs/mkconfig.c
> index 3826b0bf..ef00f6d9 100644
> --- a/mkfs/mkconfig.c
> +++ b/mkfs/mkconfig.c
> @@ -124,9 +124,13 @@ main(
>  	struct subopt_map	*submap;
>  	int			c;
>  	unsigned int		i, j;
> +	bool			manpage = false;
>  
> -	while ((c = getopt(argc, argv, "")) != EOF) {
> +	while ((c = getopt(argc, argv, "m")) != EOF) {
>  		switch (c) {
> +		case 'm':
> +			manpage = true;
> +			break;
>  		case '?':
>  			fprintf(stderr, "Unknown option %c.\n", optopt);
>  			return 1;
> @@ -137,19 +141,25 @@ main(
>  		return 1;
>  	}
>  
> -	printf("# mkfs.xfs configuration file to collect settings.\n");
> -	printf("# See the mkfs.xfs(8) manpage for details.\n");
> -	printf("# Copy this file to %s/%s to override the built-in defaults.\n",
> -			MKFS_XFS_CONF_DIR, MKFS_XFS_DEFAULT_CONFIG);
> +	if (!manpage) {
> +		printf("# mkfs.xfs configuration file to collect settings.\n");
> +		printf("# See the mkfs.xfs(8) manpage for details.\n");
> +		printf("# Copy this file to %s/%s to override the built-in defaults.\n",
> +				MKFS_XFS_CONF_DIR, MKFS_XFS_DEFAULT_CONFIG);
> +	}
>  
>  	for (i = 0; i < ARRAY_SIZE(confopts_tab); i++, opts++) {
> -		if (i > 0)
> +		if (manpage)
> +			printf(".PP\n.B ");
> +		else if (i > 0)
>  			printf("\n");
>  		printf("[%s]\n", opts->name);
>  		submap = opts->subopts;
>  		for (j = 0;
>  		     j < ARRAY_SIZE(opts->subopts) && submap->suboptname;
>  		     j++, submap++) {
> +			if (manpage)
> +				printf(".br\n.B ");
>  			printf("%s = ", submap->suboptname);
>  			switch (submap->type) {
>  			case FV_BOOL:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
