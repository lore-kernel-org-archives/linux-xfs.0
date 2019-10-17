Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64D7FA3733
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 11:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7D0A2089C
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 11:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfJQLtA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:49:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbfJQLs7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Oct 2019 07:48:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3AF2F3082DDD;
        Thu, 17 Oct 2019 11:48:59 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45E8919C68;
        Thu, 17 Oct 2019 11:48:58 +0000 (UTC)
Date:   Thu, 17 Oct 2019 07:48:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v3] fsstress: add renameat2 support
Message-ID: <20191017114856.GA20114@bfoster>
References: <b6fa2a70-a603-7ebc-f913-593a3731a4fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fa2a70-a603-7ebc-f913-593a3731a4fc@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 17 Oct 2019 11:48:59 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 17, 2019 at 09:47:19AM +0800, kaixuxia wrote:
> Support the renameat2 syscall in fsstress.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
> Changes in v3:
>  - Fix the rename(..., 0) case, avoide to cripple fsstress.
> 
>  ltp/fsstress.c | 158 +++++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 125 insertions(+), 33 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 51976f5..1a20358 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
...
> @@ -1528,14 +1569,17 @@ rename_path(pathname_t *name1, pathname_t *name2)
>  	pathname_t	newname2;
>  	int		rval;
>  
> -	rval = rename(name1->path, name2->path);
> +	if (mode == 0)
> +		rval = rename(name1->path, name2->path);
> +	else
> +		rval = renameat2(AT_FDCWD, name1->path, AT_FDCWD, name2->path, mode);

This adds a long line (> 80 characters) here and in several more places
below. I know there are other instances of this in the file, but we
probably shouldn't add new ones.

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
...
> @@ -4234,35 +4288,49 @@ rename_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_ANYm, r, &f, &flp, &fep, &v1)) {
>  		if (v1)
> -			printf("%d/%d: rename - no filename\n", procid, opno);
> +			printf("%d/%d: rename - no source filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> -
> -	/* get an existing directory for the destination parent directory name */
> -	if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
> -		parid = -1;
> -	else
> -		parid = dfep->id;
> -	v |= v1;
> -
> -	/* generate a new path using an existing parent directory in name */
> -	init_pathname(&newf);
> -	e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
> -	v |= v1;
> -	if (!e) {
> -		if (v) {
> -			(void)fent_to_name(&f, &flist[FT_DIR], dfep);
> -			printf("%d/%d: rename - no filename from %s\n",
> -				procid, opno, f.path);
> +	/* Both pathnames must exist for the RENAME_EXCHANGE */
> +	if (mode == RENAME_EXCHANGE) {
> +		init_pathname(&newf);
> +		if (!get_fname(FT_ANYm, random(), &newf, NULL, &dfep, &v1)) {
> +			if (v1)
> +				printf("%d/%d: rename - no target filename\n", procid, opno);
> +			free_pathname(&newf);
> +			free_pathname(&f);
> +			return;
> +		}

Need a v |= v1 here.

> +		id = dfep->id;
> +		parid = dfep->parent;
> +	} else {
> +		/* get an existing directory for the destination parent directory name */
> +		if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
> +			parid = -1;
> +		else
> +			parid = dfep->id;
> +		v |= v1;
> +
> +		/* generate a new path using an existing parent directory in name */
> +		init_pathname(&newf);
> +		e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
> +		v |= v1;
> +		if (!e) {
> +			if (v) {
> +				(void)fent_to_name(&f, &flist[FT_DIR], dfep);
> +				printf("%d/%d: rename - no filename from %s\n",
> +					procid, opno, f.path);
> +			}
> +			free_pathname(&newf);
> +			free_pathname(&f);
> +			return;
>  		}
> -		free_pathname(&newf);
> -		free_pathname(&f);
> -		return;
>  	}
> -	e = rename_path(&f, &newf) < 0 ? errno : 0;
> +
> +	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
>  	check_cwd();
> -	if (e == 0) {
> +	if (e == 0 && mode != RENAME_EXCHANGE) {

In the normal rename case, this block of code looks like it removes the
old entry from the global file list and adds the new one with an updated
parent. If the source was a directory, we also update the parent id of
the files within that directory.

Don't we need corresponding file list fixups for exchange and whiteout?
Whiteout leaves around a special device file that probably should be
accounted for in the list. Exchange looks a bit more tricky, but we
could be changing file types and/or parent inodes there too. I.e.,
consider an exchange of a regular file and symlink under two different
parent dirs.

Brian

>  		int xattr_counter = fep->xattr_counter;
>  
>  		if (flp - flist == FT_DIR) {
> @@ -4273,12 +4341,13 @@ rename_f(int opno, long r)
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
> @@ -4287,6 +4356,29 @@ rename_f(int opno, long r)
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
