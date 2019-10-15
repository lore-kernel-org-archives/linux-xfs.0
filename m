Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E08EC10F14
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 11:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C042217F9
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 11:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cp8ImfuJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfJOLlS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 07:41:18 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37298 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbfJOLlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 07:41:18 -0400
Received: by mail-pg1-f193.google.com with SMTP id p1so11988247pgi.4;
        Tue, 15 Oct 2019 04:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VKYhP9vz1hknSRySXBkEdKgQAWbhJL4Cx2KT+RcF0qU=;
        b=cp8ImfuJaF2YYMwGUOjrswscdr0lAeYM92FzWzasurRYwca0sWkYewsf52/mdatNCs
         lJI5QL3yUuPacHKH0xBBo6eXHUYE02IpM5laV9rPcv6ECAl4MetO5mTuosTM7A8EelCa
         981P9zwViw5Dawfa6uhCrto3nWMxw1l/Ko5I0J17yGozxBXVqgA7DAJijE9XK22OpDuJ
         2RU8tBkfhx/+kXUHRu7qCyGcptnUcnAyV4h1JYITfej88VNm+TtHmQsVNpILtbE9Ihfy
         tDc39lMYuDd3N9iJvVU84kGM9/mycwnbTUMK/ezY/7uZ6Z2lc7roIhQ2D3X6t61ubXpV
         Ig3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VKYhP9vz1hknSRySXBkEdKgQAWbhJL4Cx2KT+RcF0qU=;
        b=pCgfkzXlYeRa2yn3bXtaha2VZsfkTcX8uR+POeitmLvZWNRJ3EDIpaTLVi0tvc79sW
         IO3ipOr+c1SVfoeZLI8uB5WnlgY7t9eiI8DX+TdMFyB9emMx3SF3PmFOp89SHxzySJlh
         ARsvV198dFx5qzAlFnp7BMQ36H6s2ybAi8WeCzQZHZ/NA97tBEtlM1zO7dYZCreeoaZL
         KMsz4vEL3QXrAcbqozeJKlGoeGTJzKKSPHqaUfAw5tw/vj6pZuytGF0yjfHAIl8SKPFS
         I/qqj2sJEN7QqXp3WGtWiY/B/yEP52oz62cwuodzEGphp1BWeoGEJW3UrwEHJw1wrGHJ
         HMeA==
X-Gm-Message-State: APjAAAWavfaQrBwrDyNVFrQBf/iJp5KF/mIHddQ5UhBahffxhP9HDSVl
        4KAUeyCKCQO4VgNP7S9zH8oyeoM=
X-Google-Smtp-Source: APXvYqxGCqEa3xbUPgV+meE31MtzXVg1x75fsC3IzJMgFEpJv3/lVHiLHHo2C9OX2dfSaLg+o3/5Ng==
X-Received: by 2002:a62:8209:: with SMTP id w9mr38117154pfd.5.1571139676165;
        Tue, 15 Oct 2019 04:41:16 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id o11sm18212738pgp.13.2019.10.15.04.41.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 04:41:15 -0700 (PDT)
Subject: Re: [PATCH] fsstress: add renameat2 support
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <09bd0206-7460-a18f-990b-391fd1d2b361@gmail.com>
 <9b36578b-00da-2621-8fae-2359fe751a67@gmail.com>
 <20191015105148.GA18607@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <f7fb7d04-8d50-915a-a841-9b515c1a2b0a@gmail.com>
Date:   Tue, 15 Oct 2019 19:41:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015105148.GA18607@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2019/10/15 18:51, Brian Foster wrote:
> On Tue, Oct 15, 2019 at 10:34:31AM +0800, kaixuxia wrote:
>> According to the comments, after adding this fsstress renameat2 support,
>> the deadlock between the AGI and AGF with RENAME_WHITEOUT can be reproduced
>> by using customized parameters(limited to rename_whiteout and creates). If
>> this patch is okay, I will send the fsstress test patch. 
>> So, Eryu, Brian, comments? 
>>
> 
> I still need to take a closer look at the patch, but are you saying you
> have reproduced the deadlock using fsstress with this patch? Does
> it reproduce reliably and within a reasonable amount of time? If so, I
> think it's probably a good idea to post a test along with this patch so
> we can test it..

Actually, adding renameat2 support to fsstress is a good decision, since the
reproduce possibility is very high(nears to 100%) by using fsstress with this
patch, and the run time is in half a minute on my vm. The fsstress parameters
as follow:
	$FSSTRESS_PROG -z -n 100 -p 50 -v \
       	       -f creat=5 \
               -f rename=5 \
               -f rnoreplace=5 \
               -f rexchange=5 \
               -f rwhiteout=5 \
               -d $SCRATCH_MNT/fsstress

So maybe we can check this patch firstly to decide how to add renameat2 to 
fsstress, if the approach in this patch is okay, I will send the next test
patch. If the approach is not reasonable, I need to prepare the new patch 
to add renameat2 support and test the reproduce possibility.

> 
> Brian
> 
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
