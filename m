Return-Path: <SRS0=K+Ru=YY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161DDC47E49
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 01:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA07F20874
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 01:52:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ofcnm6K1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfJaBwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 21:52:01 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33676 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfJaBwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 21:52:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so1927726plk.0;
        Wed, 30 Oct 2019 18:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MGX5Ucb9Cpm/KMlEmvHD3o9LB8fk6d2RPL1BxAKuSlI=;
        b=ofcnm6K1qu+i501QRkoh6J1bFbVMp7ncyUcBE1+z6BjtmxpQ67P8eW58YfZbED+2Lq
         nKrl8n/MSYANHYPauQexnIsbznOLy3jpJMFNkkX4DybG4of0OQwD7S+FQrVDvJDefw8G
         0pCSrGdnecYZqLFK6QUiEzeQbMHoY29x4ub7jt87cIe5EkEsKNkdDngQKzEWENExiSa0
         St4lbBtcKMAU2f60iNHru/CIL8XmXcIPaEp463F3syJ2mdmoG3jprRmoiB/fozIDtUGR
         Po8p67g4xMUnvchPs6UHR9Q2IX6DCqJmY1L+M4DrKLuOnmm3XLeazL3HZJfudvlGaNW4
         OPyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MGX5Ucb9Cpm/KMlEmvHD3o9LB8fk6d2RPL1BxAKuSlI=;
        b=jM9rOYQryGd/aa0qU16Kk6LFxC4YyF4nlhiF5UEwKwtOL24H8Xx/X4hGrS1hNxNJqi
         dZwL4Vag/5IaaqAZhLjMIuKJPIS3kyUHWIr3B3fRnp/wjSvBdaiKX1+b/K+22DCCzlZ3
         X/foX+QxR8RALKFIfML6bS86avFwLRpaOVBMQZr44SLkUZfLBsxFgZ9z99eFmzp/A6pe
         1KYEAZ2HAeIZqHZrEN8AKV1iamLnzX1tZRVe5qUnTey56C2Vgd9yaeJSrWG/qH/65kWN
         LoexXUqV3NLL4BOj1h9OFPEqIVnRuJ4mLBR0ryWFHaL/CPM5Tuclelngf2P882s6v/Xb
         3Jpg==
X-Gm-Message-State: APjAAAWOTQcF/KZmA0727N86UMv/ut0TryYVwJA042dGLDXpot4ucs6n
        sd9IqgeuMNaMy1bT8BLhCg==
X-Google-Smtp-Source: APXvYqyJoyBjyP1m68BIvBHPoHj5VXWze+BH47w4zwG6AKPVIyLrSBlL/ugdClbTlyeCPgoSBHmO2Q==
X-Received: by 2002:a17:902:788d:: with SMTP id q13mr3449746pll.41.1572486719306;
        Wed, 30 Oct 2019 18:51:59 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id e26sm1105829pgb.48.2019.10.30.18.51.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 18:51:58 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] fsstress: add EXCHANGE renameat2 support
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
References: <cover.1572057903.git.kaixuxia@tencent.com>
 <8e8cf5e50bc3c26c90d2677d3194d36346ef0c24.1572057903.git.kaixuxia@tencent.com>
 <20191029134010.GF41131@bfoster>
 <8b5f167b-2d7c-a387-c440-80cfe6f95c42@gmail.com>
 <20191030124047.GA46856@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <fe23f099-956d-40dd-b45e-29a7a9cba220@gmail.com>
Date:   Thu, 31 Oct 2019 09:51:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191030124047.GA46856@bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/10/30 20:40, Brian Foster wrote:
> On Wed, Oct 30, 2019 at 11:17:04AM +0800, kaixuxia wrote:
>> On 2019/10/29 21:40, Brian Foster wrote:
>>> On Sat, Oct 26, 2019 at 07:18:37PM +0800, kaixuxia wrote:
>>>> Support the EXCHANGE renameat2 syscall in fsstress.
>>>>
>>>> In order to maintain filelist/filename integrity, we restrict
>>>> rexchange to files of the same type.
>>>>
>>>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>>>> ---
>>>
>>> While this looks pretty good to me at this point, I do notice instances
>>> of the following in a quick test:
>>>
>>> 0/29: rename(EXCHANGE) d3/d9/dc/dd to d3/d9/dc/dd/df 22
>>> ...
>>> 0/43: rename(EXCHANGE) d3 to d3/d9/dc/d18 22
>>> ...
>>>
>>> It looks like we're getting an EINVAL error on rexchange of directories.
>>> That same operation seems to work fine via the ./src/renameat2 tool. Any
>>> idea what's going on there?
>>
>> Hmm.. I am not sure if I understand what your mean. Seems like
>> this is because the special source and target parameters setting.
>> There are parameters check for RENAME_EXCHANGE in renameat2() call,
>>
>>  static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
>>                          const char __user *newname, unsigned int flags)
>>  {
>>   ...
>>          /* source should not be ancestor of target */
>>          error = -EINVAL;
>>          if (old_dentry == trap)
>>                  goto exit5;
>>          /* target should not be an ancestor of source */
>>          if (!(flags & RENAME_EXCHANGE))
>>                  error = -ENOTEMPTY;
>>          if (new_dentry == trap)
>>                  goto exit5;
>>  ...
>>  } 
>>
>> so we get the EINVAL error on rexchange of directories. I also tested it
>> via the ./src/renameat2 tool, and the strace result as below,
>>
> 
> Ah, I see. I wasn't aware of the restriction and didn't catch that quirk
> of these particular requests, so I thought it was failing arbitrary
> directory swaps (which is what I tested with renameat2). This makes
> sense, thanks for the explanation.
> 
>>  # src/renameat2 -x /xfs-bufdeadlock/d3 /xfs-bufdeadlock/d3/d9/dc/d18
>>   Invalid argument
>>
>>  syscall_316(0xffffff9c, 0x7ffe38930813, 0xffffff9c, 0x7ffe38930827, 0x2, 0) = -1 (errno 22)
>>  
>> Exchange looks a bit more tricky here.. Maybe we have two choices,
>> one is just leave the EINVAL there since the fsstress is stress
>> test and the EINVAL possibility is low. The other one is we should
>> do parameters check before invoking the renameat2() call, if the
>> source and target file fents are not suitable we will try more
>> until get the right file fents...
>>
> 
> Hmm.. I think it might be fine to ignore from a functional standpoint if
> the complexity is too involved to detect and skip. That said, I'm
> wondering if the filelist helps us enough here to implement similar
> checks as in the kernel VFS. On a quick look, it appears we walk up the
> dentry chain looking to see if one dentry is a parent of the other. See
> d_ancestor() (called via do_renameat2() -> lock_rename()) for example:
> 
> /*
>  * ...
>  * Returns the ancestor dentry of p2 which is a child of p1, if p1 is
>  * an ancestor of p2, else NULL.
>  */
> struct dentry *d_ancestor(struct dentry *p1, struct dentry *p2)
> {
>         struct dentry *p;
> 
>         for (p = p2; !IS_ROOT(p); p = p->d_parent) {
>                 if (p->d_parent == p1)
>                         return p;
>         }
>         return NULL;
> }
> 
> Any reason we couldn't do a couple similar checks on rexchange of two
> dirs and skip the rename if necessary?
> 
Yeah, sounds more reasonable, will add the couple checks
in next version.

Kaixu

> Brian
> 
>>>
>>> Brian
>>>
>>>>  ltp/fsstress.c | 92 ++++++++++++++++++++++++++++++++++++++++++++--------------
>>>>  1 file changed, 71 insertions(+), 21 deletions(-)
>>>>
>>>> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
>>>> index ecc1adc..83d6337 100644
>>>> --- a/ltp/fsstress.c
>>>> +++ b/ltp/fsstress.c
>>>> @@ -69,6 +69,9 @@ static int renameat2(int dfd1, const char *path1,
>>>>  #ifndef RENAME_NOREPLACE
>>>>  #define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
>>>>  #endif
>>>> +#ifndef RENAME_EXCHANGE
>>>> +#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
>>>> +#endif
>>>>  #ifndef RENAME_WHITEOUT
>>>>  #define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
>>>>  #endif
>>>> @@ -115,6 +118,7 @@ typedef enum {
>>>>  	OP_REMOVEFATTR,
>>>>  	OP_RENAME,
>>>>  	OP_RNOREPLACE,
>>>> +	OP_REXCHANGE,
>>>>  	OP_RWHITEOUT,
>>>>  	OP_RESVSP,
>>>>  	OP_RMDIR,
>>>> @@ -235,6 +239,7 @@ void	readv_f(int, long);
>>>>  void	removefattr_f(int, long);
>>>>  void	rename_f(int, long);
>>>>  void	rnoreplace_f(int, long);
>>>> +void	rexchange_f(int, long);
>>>>  void	rwhiteout_f(int, long);
>>>>  void	resvsp_f(int, long);
>>>>  void	rmdir_f(int, long);
>>>> @@ -296,6 +301,7 @@ opdesc_t	ops[] = {
>>>>  	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
>>>>  	{ OP_RENAME, "rename", rename_f, 2, 1 },
>>>>  	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
>>>> +	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
>>>>  	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
>>>>  	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
>>>>  	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
>>>> @@ -371,7 +377,7 @@ void	del_from_flist(int, int);
>>>>  int	dirid_to_name(char *, int);
>>>>  void	doproc(void);
>>>>  int	fent_to_name(pathname_t *, flist_t *, fent_t *);
>>>> -void	fix_parent(int, int);
>>>> +void	fix_parent(int, int, bool);
>>>>  void	free_pathname(pathname_t *);
>>>>  int	generate_fname(fent_t *, int, pathname_t *, int *, int *);
>>>>  int	generate_xattr_name(int, char *, int);
>>>> @@ -1118,7 +1124,7 @@ fent_to_name(pathname_t *name, flist_t *flp, fent_t *fep)
>>>>  }
>>>>  
>>>>  void
>>>> -fix_parent(int oldid, int newid)
>>>> +fix_parent(int oldid, int newid, bool swap)
>>>>  {
>>>>  	fent_t	*fep;
>>>>  	flist_t	*flp;
>>>> @@ -1129,6 +1135,8 @@ fix_parent(int oldid, int newid)
>>>>  		for (j = 0, fep = flp->fents; j < flp->nfiles; j++, fep++) {
>>>>  			if (fep->parent == oldid)
>>>>  				fep->parent = newid;
>>>> +			else if (swap && fep->parent == newid)
>>>> +				fep->parent = oldid;
>>>>  		}
>>>>  	}
>>>>  }
>>>> @@ -4256,6 +4264,7 @@ out:
>>>>  
>>>>  struct print_flags renameat2_flags [] = {
>>>>  	{ RENAME_NOREPLACE, "NOREPLACE"},
>>>> +	{ RENAME_EXCHANGE, "EXCHANGE"},
>>>>  	{ RENAME_WHITEOUT, "WHITEOUT"},
>>>>  	{ -1, NULL}
>>>>  };
>>>> @@ -4291,41 +4300,76 @@ do_renameat2(int opno, long r, int mode)
>>>>  		return;
>>>>  	}
>>>>  
>>>> -	/* get an existing directory for the destination parent directory name */
>>>> -	if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
>>>> -		parid = -1;
>>>> -	else
>>>> -		parid = dfep->id;
>>>> -	v |= v1;
>>>> +	/*
>>>> +	 * Both pathnames must exist for the RENAME_EXCHANGE, and in
>>>> +	 * order to maintain filelist/filename integrity, we should
>>>> +	 * restrict exchange operation to files of the same type.
>>>> +	 */
>>>> +	if (mode == RENAME_EXCHANGE) {
>>>> +		which = 1 << (flp - flist);
>>>> +		init_pathname(&newf);
>>>> +		if (!get_fname(which, random(), &newf, NULL, &dfep, &v)) {
>>>> +			if (v)
>>>> +				printf("%d/%d: rename - no target filename\n",
>>>> +					procid, opno);
>>>> +			free_pathname(&newf);
>>>> +			free_pathname(&f);
>>>> +			return;
>>>> +		}
>>>> +		v |= v1;
>>>> +		id = dfep->id;
>>>> +		parid = dfep->parent;
>>>> +	} else {
>>>> +		/*
>>>> +		 * Get an existing directory for the destination parent
>>>> +		 * directory name.
>>>> +		 */
>>>> +		if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
>>>> +			parid = -1;
>>>> +		else
>>>> +			parid = dfep->id;
>>>> +		v |= v1;
>>>>  
>>>> -	/* generate a new path using an existing parent directory in name */
>>>> -	init_pathname(&newf);
>>>> -	e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
>>>> -	v |= v1;
>>>> -	if (!e) {
>>>> -		if (v) {
>>>> -			(void)fent_to_name(&f, &flist[FT_DIR], dfep);
>>>> -			printf("%d/%d: rename - no filename from %s\n",
>>>> -				procid, opno, f.path);
>>>> +		/*
>>>> +		 * Generate a new path using an existing parent directory
>>>> +		 * in name.
>>>> +		 */
>>>> +		init_pathname(&newf);
>>>> +		e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
>>>> +		v |= v1;
>>>> +		if (!e) {
>>>> +			if (v) {
>>>> +				(void)fent_to_name(&f, &flist[FT_DIR], dfep);
>>>> +				printf("%d/%d: rename - no filename from %s\n",
>>>> +					procid, opno, f.path);
>>>> +			}
>>>> +			free_pathname(&newf);
>>>> +			free_pathname(&f);
>>>> +			return;
>>>>  		}
>>>> -		free_pathname(&newf);
>>>> -		free_pathname(&f);
>>>> -		return;
>>>>  	}
>>>>  	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
>>>>  	check_cwd();
>>>>  	if (e == 0) {
>>>>  		int xattr_counter = fep->xattr_counter;
>>>> +		bool swap = (mode == RENAME_EXCHANGE) ? true : false;
>>>>  
>>>>  		oldid = fep->id;
>>>>  		oldparid = fep->parent;
>>>>  
>>>> +		/*
>>>> +		 * Swap the parent ids for RENAME_EXCHANGE, and replace the
>>>> +		 * old parent id for the others.
>>>> +		 */
>>>>  		if (flp - flist == FT_DIR)
>>>> -			fix_parent(oldid, id);
>>>> +			fix_parent(oldid, id, swap);
>>>>  
>>>>  		if (mode == RENAME_WHITEOUT) {
>>>>  			fep->xattr_counter = 0;
>>>>  			add_to_flist(flp - flist, id, parid, xattr_counter);
>>>> +		} else if (mode == RENAME_EXCHANGE) {
>>>> +			fep->xattr_counter = dfep->xattr_counter;
>>>> +			dfep->xattr_counter = xattr_counter;
>>>>  		} else {
>>>>  			del_from_flist(flp - flist, fep - flp->fents);
>>>>  			add_to_flist(flp - flist, id, parid, xattr_counter);
>>>> @@ -4359,6 +4403,12 @@ rnoreplace_f(int opno, long r)
>>>>  }
>>>>  
>>>>  void
>>>> +rexchange_f(int opno, long r)
>>>> +{
>>>> +	do_renameat2(opno, r, RENAME_EXCHANGE);
>>>> +}
>>>> +
>>>> +void
>>>>  rwhiteout_f(int opno, long r)
>>>>  {
>>>>  	do_renameat2(opno, r, RENAME_WHITEOUT);
>>>> -- 
>>>> 1.8.3.1
>>>>
>>>
>>
>> -- 
>> kaixuxia
> 

-- 
kaixuxia
