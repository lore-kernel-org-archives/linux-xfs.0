Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8ECECE59D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 02:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E390020873
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 02:47:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g61yUafQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388771AbfJPCrc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 22:47:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32864 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730117AbfJPCrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 22:47:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id i76so13352292pgc.0;
        Tue, 15 Oct 2019 19:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qK90CSQM8RWYVPTSj62VdzCGcd4lSruMOIDYTZkIkME=;
        b=g61yUafQ4+Yykq7DGfghY2Z2JBHOGrR8nGdSchcW/W61ZOLWo06XXfVNtxdFjhASnF
         ZcwPdLsont/zMYZhYEGh7xAVD6gtmqdNU5BhY2cj+dBl39k7l3bT+yvDwXJ5csPGI5Bj
         99h7KLLfywFul+xGLO0xfRJD2nNJUqxhqjvhqTpw1LjP4J2jgAtR/khdfK3OZtnvU77i
         rwW7v5y4pOO/cmEYqKeOTHaXPgPpEve9ot4jiov0Mksym1QdDABGPLmg81QT2dEPbXJT
         anLyY3Otf0b00Qd/ujQyaN0mftx0dZCN+No3LpQ5H24VRH3BcGeggwGqhI5Pjj86jUVf
         RxLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qK90CSQM8RWYVPTSj62VdzCGcd4lSruMOIDYTZkIkME=;
        b=hfrZndovR/Y3eVwpcV3agMbFdEhe9qJamg3UkVOLEUK1aeoU6y/UZE1CuIZQpE/9xz
         bDVTw589SJS+zwozMhRuIq531j6jaqG+VIkrthWJdiIhkqdab2nUAdZWQY9ind7UFKpd
         jRcKfTz9f/oMdTVU0sWctZcPqRLiPZvR+0OmE5NF204/cNFOsP0ZwOUeWZJ0T+rE5brL
         azpiLcb7T9UP7vCIRU8W0wprIXCQmiz+dZ5apgbyK/7oyrKCZwZ04edueJ0amS4jtUFO
         6bjzinWGIoKAWL9O4Yw2Cu59pTc2F+FVFMeLicxyAUYs4sn8/T9grCUOzaXdUzsxlDZm
         LIVw==
X-Gm-Message-State: APjAAAUriD5ZAjzKtCkwUCx/qyy6dojcp81Yp/WUoQOItaf997Lu6AEm
        G6BcaXA0nSVpc7PqCpK2cw==
X-Google-Smtp-Source: APXvYqy7iTuR9eNVgL51FkJxwDiHzW4SiYveanPaua/r3pQiFa3mC1bNkM8B1cuoXod3rdSUPOd0wQ==
X-Received: by 2002:aa7:8a97:: with SMTP id a23mr42156453pfc.76.1571194050687;
        Tue, 15 Oct 2019 19:47:30 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id d5sm36015005pfa.180.2019.10.15.19.47.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 19:47:29 -0700 (PDT)
Subject: Re: [PATCH] fsstress: add renameat2 support
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <09bd0206-7460-a18f-990b-391fd1d2b361@gmail.com>
 <20191015145539.GA36108@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <eb10f7fc-1616-a174-d04a-91791902998e@gmail.com>
Date:   Wed, 16 Oct 2019 10:47:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015145539.GA36108@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2019/10/15 22:55, Brian Foster wrote:
> On Fri, Oct 11, 2019 at 03:56:01PM +0800, kaixuxia wrote:
>> Support the renameat2 syscall in fsstress.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
>>  ltp/fsstress.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 79 insertions(+), 11 deletions(-)
>>
>> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
>> index 51976f5..21529a2 100644
>> --- a/ltp/fsstress.c
>> +++ b/ltp/fsstress.c
>> @@ -44,6 +44,16 @@ io_context_t	io_ctx;
>>  #define IOV_MAX 1024
>>  #endif
>>  
>> +#ifndef RENAME_NOREPLACE
>> +#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
>> +#endif
>> +#ifndef RENAME_EXCHANGE
>> +#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
>> +#endif
>> +#ifndef RENAME_WHITEOUT
>> +#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
>> +#endif
>> +
>>  #define FILELEN_MAX		(32*4096)
>>  
>>  typedef enum {
>> @@ -85,6 +95,9 @@ typedef enum {
>>  	OP_READV,
>>  	OP_REMOVEFATTR,
>>  	OP_RENAME,
>> +	OP_RNOREPLACE,
>> +	OP_REXCHANGE,
>> +	OP_RWHITEOUT,
>>  	OP_RESVSP,
>>  	OP_RMDIR,
>>  	OP_SETATTR,
>> @@ -203,6 +216,9 @@ void	readlink_f(int, long);
>>  void	readv_f(int, long);
>>  void	removefattr_f(int, long);
>>  void	rename_f(int, long);
>> +void    rnoreplace_f(int, long);
>> +void    rexchange_f(int, long);
>> +void    rwhiteout_f(int, long);
>>  void	resvsp_f(int, long);
>>  void	rmdir_f(int, long);
>>  void	setattr_f(int, long);
>> @@ -262,6 +278,9 @@ opdesc_t	ops[] = {
>>  	/* remove (delete) extended attribute */
>>  	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
>>  	{ OP_RENAME, "rename", rename_f, 2, 1 },
>> +	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
>> +	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
>> +	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
>>  	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
>>  	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
>>  	/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
>> @@ -354,7 +373,7 @@ int	open_path(pathname_t *, int);
>>  DIR	*opendir_path(pathname_t *);
>>  void	process_freq(char *);
>>  int	readlink_path(pathname_t *, char *, size_t);
>> -int	rename_path(pathname_t *, pathname_t *);
>> +int	rename_path(pathname_t *, pathname_t *, int);
>>  int	rmdir_path(pathname_t *);
>>  void	separate_pathname(pathname_t *, char *, pathname_t *);
>>  void	show_ops(int, char *);
>> @@ -1519,7 +1538,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
>>  }
>>  
>>  int
>> -rename_path(pathname_t *name1, pathname_t *name2)
>> +rename_path(pathname_t *name1, pathname_t *name2, int mode)
>>  {
>>  	char		buf1[NAME_MAX + 1];
>>  	char		buf2[NAME_MAX + 1];
>> @@ -1528,14 +1547,14 @@ rename_path(pathname_t *name1, pathname_t *name2)
>>  	pathname_t	newname2;
>>  	int		rval;
>>  
>> -	rval = rename(name1->path, name2->path);
>> +	rval = syscall(__NR_renameat2, AT_FDCWD, name1->path, AT_FDCWD, name2->path, mode);
> 
> Perhaps we should preserve the rename() call with an ifdef or something
> (similar to src/renameat2.c) in the event that renameat2 is not
> available. In fact, I suppose we'd want to compile out the new renameat2
> based ops as well so the user doesn't have to disable them where they
> aren't supported.

Right, will fix it in V2.
> 
>>  	if (rval >= 0 || errno != ENAMETOOLONG)
>>  		return rval;
>>  	separate_pathname(name1, buf1, &newname1);
>>  	separate_pathname(name2, buf2, &newname2);
>>  	if (strcmp(buf1, buf2) == 0) {
>>  		if (chdir(buf1) == 0) {
>> -			rval = rename_path(&newname1, &newname2);
>> +			rval = rename_path(&newname1, &newname2, mode);
>>  			assert(chdir("..") == 0);
>>  		}
>>  	} else {
>> @@ -1555,7 +1574,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
>>  			append_pathname(&newname2, "../");
>>  			append_pathname(&newname2, name2->path);
>>  			if (chdir(buf1) == 0) {
>> -				rval = rename_path(&newname1, &newname2);
>> +				rval = rename_path(&newname1, &newname2, mode);
>>  				assert(chdir("..") == 0);
>>  			}
>>  		} else {
>> @@ -1563,7 +1582,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
>>  			append_pathname(&newname1, "../");
>>  			append_pathname(&newname1, name1->path);
>>  			if (chdir(buf2) == 0) {
>> -				rval = rename_path(&newname1, &newname2);
>> +				rval = rename_path(&newname1, &newname2, mode);
>>  				assert(chdir("..") == 0);
>>  			}
>>  		}
>> @@ -4215,8 +4234,18 @@ out:
>>  	free_pathname(&f);
>>  }
>>  
>> +struct print_flags renameat2_flags [] = {
>> +	{ RENAME_NOREPLACE, "NOREPLACE"},
>> +	{ RENAME_EXCHANGE, "EXCHANGE"},
>> +	{ RENAME_WHITEOUT, "WHITEOUT"},
>> +	{ -1, NULL}
>> +};
>> +
>> +#define translate_renameat2_flags(mode)	\
>> +	({translate_flags(mode, "|", renameat2_flags);})
>> +
>>  void
>> -rename_f(int opno, long r)
>> +do_renameat2(int opno, long r, int mode)
>>  {
>>  	fent_t		*dfep;
>>  	int		e;
>> @@ -4229,6 +4258,7 @@ rename_f(int opno, long r)
>>  	int		parid;
>>  	int		v;
>>  	int		v1;
>> +	int		fd;
>>  
>>  	/* get an existing path for the source of the rename */
>>  	init_pathname(&f);
>> @@ -4260,7 +4290,21 @@ rename_f(int opno, long r)
>>  		free_pathname(&f);
>>  		return;
>>  	}
>> -	e = rename_path(&f, &newf) < 0 ? errno : 0;
>> +	/* Both pathnames must exist for the RENAME_EXCHANGE */
>> +	if (mode == RENAME_EXCHANGE) {
>> +		fd = creat_path(&newf, 0666);
>> +		e = fd < 0 ? errno : 0;
>> +		check_cwd();
>> +		if (fd < 0) {
>> +			if (v)
>> +				printf("%d/%d: renameat2 - creat %s failed %d\n",
>> +					procid, opno, newf.path, e);
>> +			free_pathname(&newf);
>> +			free_pathname(&f);
>> +			return;
>> +		}
>> +	}
>> +	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
> 
> It looks like the existing code looks up a source entry and a target
> directory and generates a new name to serve as the rename target entry.
> Here we create the entry so we can perform an exchange. Can we check
> mode earlier and instead look up another existing entry if this is an
> exchange, else run the existing code to generate a name?

Yeah, it is more reasonable, will fix it in V2.
> 
> Other than those couple things this looks pretty good to me.
> 
> Brian
> 
> 
>>  	check_cwd();
>>  	if (e == 0) {
>>  		int xattr_counter = fep->xattr_counter;
>> @@ -4273,12 +4317,13 @@ rename_f(int opno, long r)
>>  		add_to_flist(flp - flist, id, parid, xattr_counter);
>>  	}
>>  	if (v) {
>> -		printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
>> +		printf("%d/%d: rename(%s) %s to %s %d\n", procid,
>> +			opno, translate_renameat2_flags(mode), f.path,
>>  			newf.path, e);
>>  		if (e == 0) {
>> -			printf("%d/%d: rename del entry: id=%d,parent=%d\n",
>> +			printf("%d/%d: rename source entry: id=%d,parent=%d\n",
>>  				procid, opno, fep->id, fep->parent);
>> -			printf("%d/%d: rename add entry: id=%d,parent=%d\n",
>> +			printf("%d/%d: rename target entry: id=%d,parent=%d\n",
>>  				procid, opno, id, parid);
>>  		}
>>  	}
>> @@ -4287,6 +4332,29 @@ rename_f(int opno, long r)
>>  }
>>  
>>  void
>> +rename_f(int opno, long r)
>> +{
>> +	do_renameat2(opno, r, 0);
>> +}
>> +void
>> +rnoreplace_f(int opno, long r)
>> +{
>> +	do_renameat2(opno, r, RENAME_NOREPLACE);
>> +}
>> +
>> +void
>> +rexchange_f(int opno, long r)
>> +{
>> +	do_renameat2(opno, r, RENAME_EXCHANGE);
>> +}
>> +
>> +void
>> +rwhiteout_f(int opno, long r)
>> +{
>> +	do_renameat2(opno, r, RENAME_WHITEOUT);
>> +}
>> +
>> +void
>>  resvsp_f(int opno, long r)
>>  {
>>  	int		e;
>> -- 
>> 1.8.3.1
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
