Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A75DECE588
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 15:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11F8120650
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 15:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ARwvRmLR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733252AbfJOPHS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 11:07:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732531AbfJOPHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 11:07:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FErv4k121461;
        Tue, 15 Oct 2019 15:05:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qTMw8rMV+A4eVQU3PeGmpKnjyFZWeOY6q8BEGhnh62I=;
 b=ARwvRmLRVw4FHKvVbxOftlV1G3jEwCoD0MqM234cX+Bv7Lyd5X+aGjwFUeQQ7qP+n0WC
 ccETjdug9erS/IylrZNiIAJfGBo49oVT57eBsVfeXeEqmGdtUsjjZUc/p5RoXJUmeN09
 uglUJifARZ4FnmJp00JjpX8228ebLLO2fGG7ceqc2/QZy7r1UHxcvnIE53Vgry3zArNf
 +X2l38QI7k6mc3J8oJeK2lFMU9DhAsl0cDTWqXaM8QgyvFaL6G+WOJzus5SYEQ40PeVW
 g+RP22scXcDzr/GuZABnhEfppIJKp2ThaR5wGPxpcRr3ShDZzy0SPqJbtm0H7FZUK7Bl FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vk7fr8kk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 15:05:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FEreYV159438;
        Tue, 15 Oct 2019 15:05:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vn8en9rxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 15:05:55 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9FF5rZQ021685;
        Tue, 15 Oct 2019 15:05:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 15:05:53 +0000
Date:   Tue, 15 Oct 2019 08:05:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] fsstress: add renameat2 support
Message-ID: <20191015150550.GC13108@magnolia>
References: <09bd0206-7460-a18f-990b-391fd1d2b361@gmail.com>
 <9b36578b-00da-2621-8fae-2359fe751a67@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b36578b-00da-2621-8fae-2359fe751a67@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 15, 2019 at 10:34:31AM +0800, kaixuxia wrote:
> According to the comments, after adding this fsstress renameat2 support,
> the deadlock between the AGI and AGF with RENAME_WHITEOUT can be reproduced
> by using customized parameters(limited to rename_whiteout and creates). If
> this patch is okay, I will send the fsstress test patch. 

/me looks forward to that, particularly because I asked weeks ago if the
xfs_droplink calls in xfs_rename() could try to lock the AGI after we'd
already locked the AGF for the directory expansion, but nobody sent an
answer...

> So, Eryu, Brian, comments? 
>
> On 2019/10/11 15:56, kaixuxia wrote:
> > Support the renameat2 syscall in fsstress.
> > 
> > Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> > ---
> >  ltp/fsstress.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 79 insertions(+), 11 deletions(-)
> > 
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index 51976f5..21529a2 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -44,6 +44,16 @@ io_context_t	io_ctx;
> >  #define IOV_MAX 1024
> >  #endif
> >  
> > +#ifndef RENAME_NOREPLACE
> > +#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
> > +#endif
> > +#ifndef RENAME_EXCHANGE
> > +#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
> > +#endif
> > +#ifndef RENAME_WHITEOUT
> > +#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
> > +#endif
> > +
> >  #define FILELEN_MAX		(32*4096)
> >  
> >  typedef enum {
> > @@ -85,6 +95,9 @@ typedef enum {
> >  	OP_READV,
> >  	OP_REMOVEFATTR,
> >  	OP_RENAME,
> > +	OP_RNOREPLACE,
> > +	OP_REXCHANGE,
> > +	OP_RWHITEOUT,
> >  	OP_RESVSP,
> >  	OP_RMDIR,
> >  	OP_SETATTR,
> > @@ -203,6 +216,9 @@ void	readlink_f(int, long);
> >  void	readv_f(int, long);
> >  void	removefattr_f(int, long);
> >  void	rename_f(int, long);
> > +void    rnoreplace_f(int, long);
> > +void    rexchange_f(int, long);
> > +void    rwhiteout_f(int, long);
> >  void	resvsp_f(int, long);
> >  void	rmdir_f(int, long);
> >  void	setattr_f(int, long);
> > @@ -262,6 +278,9 @@ opdesc_t	ops[] = {
> >  	/* remove (delete) extended attribute */
> >  	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
> >  	{ OP_RENAME, "rename", rename_f, 2, 1 },
> > +	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
> > +	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
> > +	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
> >  	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
> >  	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
> >  	/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
> > @@ -354,7 +373,7 @@ int	open_path(pathname_t *, int);
> >  DIR	*opendir_path(pathname_t *);
> >  void	process_freq(char *);
> >  int	readlink_path(pathname_t *, char *, size_t);
> > -int	rename_path(pathname_t *, pathname_t *);
> > +int	rename_path(pathname_t *, pathname_t *, int);
> >  int	rmdir_path(pathname_t *);
> >  void	separate_pathname(pathname_t *, char *, pathname_t *);
> >  void	show_ops(int, char *);
> > @@ -1519,7 +1538,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
> >  }
> >  
> >  int
> > -rename_path(pathname_t *name1, pathname_t *name2)
> > +rename_path(pathname_t *name1, pathname_t *name2, int mode)
> >  {
> >  	char		buf1[NAME_MAX + 1];
> >  	char		buf2[NAME_MAX + 1];
> > @@ -1528,14 +1547,14 @@ rename_path(pathname_t *name1, pathname_t *name2)
> >  	pathname_t	newname2;
> >  	int		rval;
> >  
> > -	rval = rename(name1->path, name2->path);
> > +	rval = syscall(__NR_renameat2, AT_FDCWD, name1->path, AT_FDCWD, name2->path, mode);

For the rename(..., 0) case, would we be crippling fsstress if the
kernel doesn't know about renameat2 and doesn't fall back to renameat()
or regular rename()?  I guess renameat2 showed up in 3.15 which was
quite a long time ago except in RHEL land. :)

--D

> >  	if (rval >= 0 || errno != ENAMETOOLONG)
> >  		return rval;
> >  	separate_pathname(name1, buf1, &newname1);
> >  	separate_pathname(name2, buf2, &newname2);
> >  	if (strcmp(buf1, buf2) == 0) {
> >  		if (chdir(buf1) == 0) {
> > -			rval = rename_path(&newname1, &newname2);
> > +			rval = rename_path(&newname1, &newname2, mode);
> >  			assert(chdir("..") == 0);
> >  		}
> >  	} else {
> > @@ -1555,7 +1574,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
> >  			append_pathname(&newname2, "../");
> >  			append_pathname(&newname2, name2->path);
> >  			if (chdir(buf1) == 0) {
> > -				rval = rename_path(&newname1, &newname2);
> > +				rval = rename_path(&newname1, &newname2, mode);
> >  				assert(chdir("..") == 0);
> >  			}
> >  		} else {
> > @@ -1563,7 +1582,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
> >  			append_pathname(&newname1, "../");
> >  			append_pathname(&newname1, name1->path);
> >  			if (chdir(buf2) == 0) {
> > -				rval = rename_path(&newname1, &newname2);
> > +				rval = rename_path(&newname1, &newname2, mode);
> >  				assert(chdir("..") == 0);
> >  			}
> >  		}
> > @@ -4215,8 +4234,18 @@ out:
> >  	free_pathname(&f);
> >  }
> >  
> > +struct print_flags renameat2_flags [] = {
> > +	{ RENAME_NOREPLACE, "NOREPLACE"},
> > +	{ RENAME_EXCHANGE, "EXCHANGE"},
> > +	{ RENAME_WHITEOUT, "WHITEOUT"},
> > +	{ -1, NULL}
> > +};
> > +
> > +#define translate_renameat2_flags(mode)	\
> > +	({translate_flags(mode, "|", renameat2_flags);})
> > +
> >  void
> > -rename_f(int opno, long r)
> > +do_renameat2(int opno, long r, int mode)
> >  {
> >  	fent_t		*dfep;
> >  	int		e;
> > @@ -4229,6 +4258,7 @@ rename_f(int opno, long r)
> >  	int		parid;
> >  	int		v;
> >  	int		v1;
> > +	int		fd;
> >  
> >  	/* get an existing path for the source of the rename */
> >  	init_pathname(&f);
> > @@ -4260,7 +4290,21 @@ rename_f(int opno, long r)
> >  		free_pathname(&f);
> >  		return;
> >  	}
> > -	e = rename_path(&f, &newf) < 0 ? errno : 0;
> > +	/* Both pathnames must exist for the RENAME_EXCHANGE */
> > +	if (mode == RENAME_EXCHANGE) {
> > +		fd = creat_path(&newf, 0666);
> > +		e = fd < 0 ? errno : 0;
> > +		check_cwd();
> > +		if (fd < 0) {
> > +			if (v)
> > +				printf("%d/%d: renameat2 - creat %s failed %d\n",
> > +					procid, opno, newf.path, e);
> > +			free_pathname(&newf);
> > +			free_pathname(&f);
> > +			return;
> > +		}
> > +	}
> > +	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
> >  	check_cwd();
> >  	if (e == 0) {
> >  		int xattr_counter = fep->xattr_counter;
> > @@ -4273,12 +4317,13 @@ rename_f(int opno, long r)
> >  		add_to_flist(flp - flist, id, parid, xattr_counter);
> >  	}
> >  	if (v) {
> > -		printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
> > +		printf("%d/%d: rename(%s) %s to %s %d\n", procid,
> > +			opno, translate_renameat2_flags(mode), f.path,
> >  			newf.path, e);
> >  		if (e == 0) {
> > -			printf("%d/%d: rename del entry: id=%d,parent=%d\n",
> > +			printf("%d/%d: rename source entry: id=%d,parent=%d\n",
> >  				procid, opno, fep->id, fep->parent);
> > -			printf("%d/%d: rename add entry: id=%d,parent=%d\n",
> > +			printf("%d/%d: rename target entry: id=%d,parent=%d\n",
> >  				procid, opno, id, parid);
> >  		}
> >  	}
> > @@ -4287,6 +4332,29 @@ rename_f(int opno, long r)
> >  }
> >  
> >  void
> > +rename_f(int opno, long r)
> > +{
> > +	do_renameat2(opno, r, 0);
> > +}
> > +void
> > +rnoreplace_f(int opno, long r)
> > +{
> > +	do_renameat2(opno, r, RENAME_NOREPLACE);
> > +}
> > +
> > +void
> > +rexchange_f(int opno, long r)
> > +{
> > +	do_renameat2(opno, r, RENAME_EXCHANGE);
> > +}
> > +
> > +void
> > +rwhiteout_f(int opno, long r)
> > +{
> > +	do_renameat2(opno, r, RENAME_WHITEOUT);
> > +}
> > +
> > +void
> >  resvsp_f(int opno, long r)
> >  {
> >  	int		e;
> > 
> 
> -- 
> kaixuxia
