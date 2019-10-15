Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229C8C10F14
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 14:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 053EB217D6
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 14:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732691AbfJOOzn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 10:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732567AbfJOOzn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Oct 2019 10:55:43 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7F87E18CB8FF;
        Tue, 15 Oct 2019 14:55:42 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A6742100EBA3;
        Tue, 15 Oct 2019 14:55:41 +0000 (UTC)
Date:   Tue, 15 Oct 2019 10:55:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] fsstress: add renameat2 support
Message-ID: <20191015145539.GA36108@bfoster>
References: <09bd0206-7460-a18f-990b-391fd1d2b361@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09bd0206-7460-a18f-990b-391fd1d2b361@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Tue, 15 Oct 2019 14:55:42 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 11, 2019 at 03:56:01PM +0800, kaixuxia wrote:
> Support the renameat2 syscall in fsstress.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
>  ltp/fsstress.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 79 insertions(+), 11 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 51976f5..21529a2 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -44,6 +44,16 @@ io_context_t	io_ctx;
>  #define IOV_MAX 1024
>  #endif
>  
> +#ifndef RENAME_NOREPLACE
> +#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
> +#endif
> +#ifndef RENAME_EXCHANGE
> +#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
> +#endif
> +#ifndef RENAME_WHITEOUT
> +#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
> +#endif
> +
>  #define FILELEN_MAX		(32*4096)
>  
>  typedef enum {
> @@ -85,6 +95,9 @@ typedef enum {
>  	OP_READV,
>  	OP_REMOVEFATTR,
>  	OP_RENAME,
> +	OP_RNOREPLACE,
> +	OP_REXCHANGE,
> +	OP_RWHITEOUT,
>  	OP_RESVSP,
>  	OP_RMDIR,
>  	OP_SETATTR,
> @@ -203,6 +216,9 @@ void	readlink_f(int, long);
>  void	readv_f(int, long);
>  void	removefattr_f(int, long);
>  void	rename_f(int, long);
> +void    rnoreplace_f(int, long);
> +void    rexchange_f(int, long);
> +void    rwhiteout_f(int, long);
>  void	resvsp_f(int, long);
>  void	rmdir_f(int, long);
>  void	setattr_f(int, long);
> @@ -262,6 +278,9 @@ opdesc_t	ops[] = {
>  	/* remove (delete) extended attribute */
>  	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
>  	{ OP_RENAME, "rename", rename_f, 2, 1 },
> +	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
> +	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
> +	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
>  	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
>  	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
>  	/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
> @@ -354,7 +373,7 @@ int	open_path(pathname_t *, int);
>  DIR	*opendir_path(pathname_t *);
>  void	process_freq(char *);
>  int	readlink_path(pathname_t *, char *, size_t);
> -int	rename_path(pathname_t *, pathname_t *);
> +int	rename_path(pathname_t *, pathname_t *, int);
>  int	rmdir_path(pathname_t *);
>  void	separate_pathname(pathname_t *, char *, pathname_t *);
>  void	show_ops(int, char *);
> @@ -1519,7 +1538,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
>  }
>  
>  int
> -rename_path(pathname_t *name1, pathname_t *name2)
> +rename_path(pathname_t *name1, pathname_t *name2, int mode)
>  {
>  	char		buf1[NAME_MAX + 1];
>  	char		buf2[NAME_MAX + 1];
> @@ -1528,14 +1547,14 @@ rename_path(pathname_t *name1, pathname_t *name2)
>  	pathname_t	newname2;
>  	int		rval;
>  
> -	rval = rename(name1->path, name2->path);
> +	rval = syscall(__NR_renameat2, AT_FDCWD, name1->path, AT_FDCWD, name2->path, mode);

Perhaps we should preserve the rename() call with an ifdef or something
(similar to src/renameat2.c) in the event that renameat2 is not
available. In fact, I suppose we'd want to compile out the new renameat2
based ops as well so the user doesn't have to disable them where they
aren't supported.

>  	if (rval >= 0 || errno != ENAMETOOLONG)
>  		return rval;
>  	separate_pathname(name1, buf1, &newname1);
>  	separate_pathname(name2, buf2, &newname2);
>  	if (strcmp(buf1, buf2) == 0) {
>  		if (chdir(buf1) == 0) {
> -			rval = rename_path(&newname1, &newname2);
> +			rval = rename_path(&newname1, &newname2, mode);
>  			assert(chdir("..") == 0);
>  		}
>  	} else {
> @@ -1555,7 +1574,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
>  			append_pathname(&newname2, "../");
>  			append_pathname(&newname2, name2->path);
>  			if (chdir(buf1) == 0) {
> -				rval = rename_path(&newname1, &newname2);
> +				rval = rename_path(&newname1, &newname2, mode);
>  				assert(chdir("..") == 0);
>  			}
>  		} else {
> @@ -1563,7 +1582,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
>  			append_pathname(&newname1, "../");
>  			append_pathname(&newname1, name1->path);
>  			if (chdir(buf2) == 0) {
> -				rval = rename_path(&newname1, &newname2);
> +				rval = rename_path(&newname1, &newname2, mode);
>  				assert(chdir("..") == 0);
>  			}
>  		}
> @@ -4215,8 +4234,18 @@ out:
>  	free_pathname(&f);
>  }
>  
> +struct print_flags renameat2_flags [] = {
> +	{ RENAME_NOREPLACE, "NOREPLACE"},
> +	{ RENAME_EXCHANGE, "EXCHANGE"},
> +	{ RENAME_WHITEOUT, "WHITEOUT"},
> +	{ -1, NULL}
> +};
> +
> +#define translate_renameat2_flags(mode)	\
> +	({translate_flags(mode, "|", renameat2_flags);})
> +
>  void
> -rename_f(int opno, long r)
> +do_renameat2(int opno, long r, int mode)
>  {
>  	fent_t		*dfep;
>  	int		e;
> @@ -4229,6 +4258,7 @@ rename_f(int opno, long r)
>  	int		parid;
>  	int		v;
>  	int		v1;
> +	int		fd;
>  
>  	/* get an existing path for the source of the rename */
>  	init_pathname(&f);
> @@ -4260,7 +4290,21 @@ rename_f(int opno, long r)
>  		free_pathname(&f);
>  		return;
>  	}
> -	e = rename_path(&f, &newf) < 0 ? errno : 0;
> +	/* Both pathnames must exist for the RENAME_EXCHANGE */
> +	if (mode == RENAME_EXCHANGE) {
> +		fd = creat_path(&newf, 0666);
> +		e = fd < 0 ? errno : 0;
> +		check_cwd();
> +		if (fd < 0) {
> +			if (v)
> +				printf("%d/%d: renameat2 - creat %s failed %d\n",
> +					procid, opno, newf.path, e);
> +			free_pathname(&newf);
> +			free_pathname(&f);
> +			return;
> +		}
> +	}
> +	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;

It looks like the existing code looks up a source entry and a target
directory and generates a new name to serve as the rename target entry.
Here we create the entry so we can perform an exchange. Can we check
mode earlier and instead look up another existing entry if this is an
exchange, else run the existing code to generate a name?

Other than those couple things this looks pretty good to me.

Brian


>  	check_cwd();
>  	if (e == 0) {
>  		int xattr_counter = fep->xattr_counter;
> @@ -4273,12 +4317,13 @@ rename_f(int opno, long r)
>  		add_to_flist(flp - flist, id, parid, xattr_counter);
>  	}
>  	if (v) {
> -		printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
> +		printf("%d/%d: rename(%s) %s to %s %d\n", procid,
> +			opno, translate_renameat2_flags(mode), f.path,
>  			newf.path, e);
>  		if (e == 0) {
> -			printf("%d/%d: rename del entry: id=%d,parent=%d\n",
> +			printf("%d/%d: rename source entry: id=%d,parent=%d\n",
>  				procid, opno, fep->id, fep->parent);
> -			printf("%d/%d: rename add entry: id=%d,parent=%d\n",
> +			printf("%d/%d: rename target entry: id=%d,parent=%d\n",
>  				procid, opno, id, parid);
>  		}
>  	}
> @@ -4287,6 +4332,29 @@ rename_f(int opno, long r)
>  }
>  
>  void
> +rename_f(int opno, long r)
> +{
> +	do_renameat2(opno, r, 0);
> +}
> +void
> +rnoreplace_f(int opno, long r)
> +{
> +	do_renameat2(opno, r, RENAME_NOREPLACE);
> +}
> +
> +void
> +rexchange_f(int opno, long r)
> +{
> +	do_renameat2(opno, r, RENAME_EXCHANGE);
> +}
> +
> +void
> +rwhiteout_f(int opno, long r)
> +{
> +	do_renameat2(opno, r, RENAME_WHITEOUT);
> +}
> +
> +void
>  resvsp_f(int opno, long r)
>  {
>  	int		e;
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
