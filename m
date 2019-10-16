Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55C7ECE58F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 03:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ACD9217F9
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 03:11:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rhzD9c2D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfJPDLh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 23:11:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34228 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfJPDLh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 23:11:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id b128so13775193pfa.1;
        Tue, 15 Oct 2019 20:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9KNhiy2FQ9z3m+zvnetenQ8X88h60iXNvUk2Hp1BOk8=;
        b=rhzD9c2DfiPrG8YQoKMcAkU6/80b885e6Q9iNKkJn0HJLiOvXuYRI/oj6rUGEiBCtV
         MYtGqaZ8GjqQcosxjTB0SkGr2332gMaIiMeL1gzTS/u7LyJyxQOh8DkRWJPugiaRyPAY
         6TLzgDs+hvqs6m4rTQ/UJikFLKpYFwUV0vZFlrnbguonmoj0D2ERYd8VhUFcvyR3ePt7
         /PXJI48x3oVzT9cnhtltzCeoNvXvNcazSC4ymbLKfGXKRkZDAlj6RPY/2bmYnGfF7qE6
         Yt1Pdfv/CJf2mHpFnp5jHC0BdjCkPCXRKZTmvns83roqNfCyZKnjk6a1RopB2BxiE4VT
         xLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9KNhiy2FQ9z3m+zvnetenQ8X88h60iXNvUk2Hp1BOk8=;
        b=ZxbcRyZGkmaO3cRhDPrMR8l84VHowclNOdLXCeUeuYyab3LFpfKKBccsHiRo3IP7td
         GFeSFeP5wdTj2irSyCHYsjyt0uIqLQ0ivCYbV+8kAmGbll0JwAE46uB+2Hp2BpNA+Q2p
         AgBsIT+/3zu36nCyWlUkkIEUTh5ahUVlaWQ0ARwW618sATJWWQlpYrSZ+eMcqAXu8HW9
         qABODnfNcZ0VsS803/2ur8WxEtlfLM2olZydS3kFXCtMES9fEi2VwFHLNUs5EygmAujY
         B8m+GRjSJWYogt2jQhgk5SVrbobC9HYbH+2Tqer6HkfQtHFurgUX2Rl4PRrx4HSq8unJ
         5+Qg==
X-Gm-Message-State: APjAAAX607o7HBKjlH0mjKQWDb3tVgxmu4/xr+pWGAstIfo6o9BWpV3z
        t7pT8m02hSgqcbPSxC9ZGg==
X-Google-Smtp-Source: APXvYqx/yIgnL8ksOJx6/0pRRD/Jru60gTndrEHsG15uXNa+aI56M0la2s+tzRUea5uFG3Tl4vVDbQ==
X-Received: by 2002:a17:90a:9104:: with SMTP id k4mr2100107pjo.39.1571195494954;
        Tue, 15 Oct 2019 20:11:34 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id n23sm20828762pff.137.2019.10.15.20.11.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 20:11:34 -0700 (PDT)
Subject: Re: [PATCH] fsstress: add renameat2 support
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <09bd0206-7460-a18f-990b-391fd1d2b361@gmail.com>
 <9b36578b-00da-2621-8fae-2359fe751a67@gmail.com>
 <20191015150550.GC13108@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <cf987e30-0103-700f-4f7d-92a1d44bfefa@gmail.com>
Date:   Wed, 16 Oct 2019 11:11:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015150550.GC13108@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/10/15 23:05, Darrick J. Wong wrote:
> On Tue, Oct 15, 2019 at 10:34:31AM +0800, kaixuxia wrote:
>> According to the comments, after adding this fsstress renameat2 support,
>> the deadlock between the AGI and AGF with RENAME_WHITEOUT can be reproduced
>> by using customized parameters(limited to rename_whiteout and creates). If
>> this patch is okay, I will send the fsstress test patch. 
> 
> /me looks forward to that, particularly because I asked weeks ago if the
> xfs_droplink calls in xfs_rename() could try to lock the AGI after we'd
> already locked the AGF for the directory expansion, but nobody sent an
> answer...

Yeah, It's been a long time since we talked this xfs_droplink() deadlock
problem. I already have the simple fix patch, now I'm trying to get a
xfstests test patch to reproduce this deadlock problem with high possibility.
I will send the fix patch ASAP.
 
> 
>> So, Eryu, Brian, comments? 
>>
>> On 2019/10/11 15:56, kaixuxia wrote:
>>> Support the renameat2 syscall in fsstress.
>>>
>>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>>> ---
>>>  ltp/fsstress.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>>>  1 file changed, 79 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
>>> index 51976f5..21529a2 100644
>>> --- a/ltp/fsstress.c
>>> +++ b/ltp/fsstress.c
>>> @@ -44,6 +44,16 @@ io_context_t	io_ctx;
>>>  #define IOV_MAX 1024
>>>  #endif
>>>  
>>> +#ifndef RENAME_NOREPLACE
>>> +#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
>>> +#endif
>>> +#ifndef RENAME_EXCHANGE
>>> +#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
>>> +#endif
>>> +#ifndef RENAME_WHITEOUT
>>> +#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
>>> +#endif
>>> +
>>>  #define FILELEN_MAX		(32*4096)
>>>  
>>>  typedef enum {
>>> @@ -85,6 +95,9 @@ typedef enum {
>>>  	OP_READV,
>>>  	OP_REMOVEFATTR,
>>>  	OP_RENAME,
>>> +	OP_RNOREPLACE,
>>> +	OP_REXCHANGE,
>>> +	OP_RWHITEOUT,
>>>  	OP_RESVSP,
>>>  	OP_RMDIR,
>>>  	OP_SETATTR,
>>> @@ -203,6 +216,9 @@ void	readlink_f(int, long);
>>>  void	readv_f(int, long);
>>>  void	removefattr_f(int, long);
>>>  void	rename_f(int, long);
>>> +void    rnoreplace_f(int, long);
>>> +void    rexchange_f(int, long);
>>> +void    rwhiteout_f(int, long);
>>>  void	resvsp_f(int, long);
>>>  void	rmdir_f(int, long);
>>>  void	setattr_f(int, long);
>>> @@ -262,6 +278,9 @@ opdesc_t	ops[] = {
>>>  	/* remove (delete) extended attribute */
>>>  	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
>>>  	{ OP_RENAME, "rename", rename_f, 2, 1 },
>>> +	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
>>> +	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
>>> +	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
>>>  	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
>>>  	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
>>>  	/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
>>> @@ -354,7 +373,7 @@ int	open_path(pathname_t *, int);
>>>  DIR	*opendir_path(pathname_t *);
>>>  void	process_freq(char *);
>>>  int	readlink_path(pathname_t *, char *, size_t);
>>> -int	rename_path(pathname_t *, pathname_t *);
>>> +int	rename_path(pathname_t *, pathname_t *, int);
>>>  int	rmdir_path(pathname_t *);
>>>  void	separate_pathname(pathname_t *, char *, pathname_t *);
>>>  void	show_ops(int, char *);
>>> @@ -1519,7 +1538,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
>>>  }
>>>  
>>>  int
>>> -rename_path(pathname_t *name1, pathname_t *name2)
>>> +rename_path(pathname_t *name1, pathname_t *name2, int mode)
>>>  {
>>>  	char		buf1[NAME_MAX + 1];
>>>  	char		buf2[NAME_MAX + 1];
>>> @@ -1528,14 +1547,14 @@ rename_path(pathname_t *name1, pathname_t *name2)
>>>  	pathname_t	newname2;
>>>  	int		rval;
>>>  
>>> -	rval = rename(name1->path, name2->path);
>>> +	rval = syscall(__NR_renameat2, AT_FDCWD, name1->path, AT_FDCWD, name2->path, mode);
> 
> For the rename(..., 0) case, would we be crippling fsstress if the
> kernel doesn't know about renameat2 and doesn't fall back to renameat()
> or regular rename()?  I guess renameat2 showed up in 3.15 which was
> quite a long time ago except in RHEL land. :)
> 
Yeah, will preserve the rename() call when it is not available in V2. 

> --D
> 
>>>  	if (rval >= 0 || errno != ENAMETOOLONG)
>>>  		return rval;
>>>  	separate_pathname(name1, buf1, &newname1);
>>>  	separate_pathname(name2, buf2, &newname2);
>>>  	if (strcmp(buf1, buf2) == 0) {
>>>  		if (chdir(buf1) == 0) {
>>> -			rval = rename_path(&newname1, &newname2);
>>> +			rval = rename_path(&newname1, &newname2, mode);
>>>  			assert(chdir("..") == 0);
>>>  		}
>>>  	} else {
>>> @@ -1555,7 +1574,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
>>>  			append_pathname(&newname2, "../");
>>>  			append_pathname(&newname2, name2->path);
>>>  			if (chdir(buf1) == 0) {
>>> -				rval = rename_path(&newname1, &newname2);
>>> +				rval = rename_path(&newname1, &newname2, mode);
>>>  				assert(chdir("..") == 0);
>>>  			}
>>>  		} else {
>>> @@ -1563,7 +1582,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
>>>  			append_pathname(&newname1, "../");
>>>  			append_pathname(&newname1, name1->path);
>>>  			if (chdir(buf2) == 0) {
>>> -				rval = rename_path(&newname1, &newname2);
>>> +				rval = rename_path(&newname1, &newname2, mode);
>>>  				assert(chdir("..") == 0);
>>>  			}
>>>  		}
>>> @@ -4215,8 +4234,18 @@ out:
>>>  	free_pathname(&f);
>>>  }
>>>  
>>> +struct print_flags renameat2_flags [] = {
>>> +	{ RENAME_NOREPLACE, "NOREPLACE"},
>>> +	{ RENAME_EXCHANGE, "EXCHANGE"},
>>> +	{ RENAME_WHITEOUT, "WHITEOUT"},
>>> +	{ -1, NULL}
>>> +};
>>> +
>>> +#define translate_renameat2_flags(mode)	\
>>> +	({translate_flags(mode, "|", renameat2_flags);})
>>> +
>>>  void
>>> -rename_f(int opno, long r)
>>> +do_renameat2(int opno, long r, int mode)
>>>  {
>>>  	fent_t		*dfep;
>>>  	int		e;
>>> @@ -4229,6 +4258,7 @@ rename_f(int opno, long r)
>>>  	int		parid;
>>>  	int		v;
>>>  	int		v1;
>>> +	int		fd;
>>>  
>>>  	/* get an existing path for the source of the rename */
>>>  	init_pathname(&f);
>>> @@ -4260,7 +4290,21 @@ rename_f(int opno, long r)
>>>  		free_pathname(&f);
>>>  		return;
>>>  	}
>>> -	e = rename_path(&f, &newf) < 0 ? errno : 0;
>>> +	/* Both pathnames must exist for the RENAME_EXCHANGE */
>>> +	if (mode == RENAME_EXCHANGE) {
>>> +		fd = creat_path(&newf, 0666);
>>> +		e = fd < 0 ? errno : 0;
>>> +		check_cwd();
>>> +		if (fd < 0) {
>>> +			if (v)
>>> +				printf("%d/%d: renameat2 - creat %s failed %d\n",
>>> +					procid, opno, newf.path, e);
>>> +			free_pathname(&newf);
>>> +			free_pathname(&f);
>>> +			return;
>>> +		}
>>> +	}
>>> +	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
>>>  	check_cwd();
>>>  	if (e == 0) {
>>>  		int xattr_counter = fep->xattr_counter;
>>> @@ -4273,12 +4317,13 @@ rename_f(int opno, long r)
>>>  		add_to_flist(flp - flist, id, parid, xattr_counter);
>>>  	}
>>>  	if (v) {
>>> -		printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
>>> +		printf("%d/%d: rename(%s) %s to %s %d\n", procid,
>>> +			opno, translate_renameat2_flags(mode), f.path,
>>>  			newf.path, e);
>>>  		if (e == 0) {
>>> -			printf("%d/%d: rename del entry: id=%d,parent=%d\n",
>>> +			printf("%d/%d: rename source entry: id=%d,parent=%d\n",
>>>  				procid, opno, fep->id, fep->parent);
>>> -			printf("%d/%d: rename add entry: id=%d,parent=%d\n",
>>> +			printf("%d/%d: rename target entry: id=%d,parent=%d\n",
>>>  				procid, opno, id, parid);
>>>  		}
>>>  	}
>>> @@ -4287,6 +4332,29 @@ rename_f(int opno, long r)
>>>  }
>>>  
>>>  void
>>> +rename_f(int opno, long r)
>>> +{
>>> +	do_renameat2(opno, r, 0);
>>> +}
>>> +void
>>> +rnoreplace_f(int opno, long r)
>>> +{
>>> +	do_renameat2(opno, r, RENAME_NOREPLACE);
>>> +}
>>> +
>>> +void
>>> +rexchange_f(int opno, long r)
>>> +{
>>> +	do_renameat2(opno, r, RENAME_EXCHANGE);
>>> +}
>>> +
>>> +void
>>> +rwhiteout_f(int opno, long r)
>>> +{
>>> +	do_renameat2(opno, r, RENAME_WHITEOUT);
>>> +}
>>> +
>>> +void
>>>  resvsp_f(int opno, long r)
>>>  {
>>>  	int		e;
>>>
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
