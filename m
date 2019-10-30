Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845D4C47E49
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 03:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C61D208C0
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 03:17:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KkxlCBU8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfJ3DRJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 23:17:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36773 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfJ3DRJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 23:17:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id j22so478303pgh.3;
        Tue, 29 Oct 2019 20:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gp8gdSutfHIwARAnhnkXdCV/dYJjL04B3d8bjAZgzSE=;
        b=KkxlCBU8mXC2VcRbpZk/fEtePwIYkRSpUgI7dO6akhFdcxGDUvqOKk16xpgDw83sFV
         v6KatqTf7mjx6ElsSoxERkVIXFX9bg85HxyGYmY5w4ipqbsYgbbUDGiX8REhlYt0LT6g
         5z5aNqKNvaAauCdEvxXN2O5vc9kvor2ehDqh5yAoYluFUA/t/f54IzmuFbCk9tU7FZfS
         ZCflkbHNJDSeQvT1FAVIMY+yBtN4F5jmTpooSCGhF3R1o0glz27tTbX6+RE5l42yjA2v
         6E/vZXL6RdH2qYU0IXGru8DLpJEPRPEtb89FsV54Q25a3UtFdIMtQdVjvXB0rCmpRSkh
         aZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gp8gdSutfHIwARAnhnkXdCV/dYJjL04B3d8bjAZgzSE=;
        b=UfEULSPFeZGPCffJK7tujIsJlzxBbwbowtoL24vG9lS7A9hMrucJW8j0wtqLfnvPd4
         eSrojn07pFHFR40ICndyCTlXogW78xNdZqLkQdqzNO0eaJdKaiYiRDMBNVhqratVNBS0
         IefsXEFotMOb16NcPtdWk2XJRw+VZcH59X3D11aYxu7fwoNTw25DK/WYMKL9DDcpPuMW
         nBz/YCITy+PqHUKTI+01FMQmmsdaDS06hhEMTqCHtmXGx+K2nx+lewY95+a3pUJSp2my
         47D5431bFgBGQpHhFhdczEIDzL4rq7KZI86YPm/VHdDWMbfE7lEtCOwSGPOKCZewHwPX
         uVSA==
X-Gm-Message-State: APjAAAWjmb7knWvtt0ohsUAJoBEHCRSpS4y6BAdCDnnDYmfle+lrcfw0
        q6sMdTT77Th1CiQIwn/Msw==
X-Google-Smtp-Source: APXvYqxwRLivhRa0c74/8zEsu1+4RbZtlBacneamie1XNBRwV8xxTykwo8IguB7OfNT6DWKwLvWc3Q==
X-Received: by 2002:a17:90a:d149:: with SMTP id t9mr10812396pjw.108.1572405428151;
        Tue, 29 Oct 2019 20:17:08 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id q26sm574827pgk.60.2019.10.29.20.17.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 20:17:07 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] fsstress: add EXCHANGE renameat2 support
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
References: <cover.1572057903.git.kaixuxia@tencent.com>
 <8e8cf5e50bc3c26c90d2677d3194d36346ef0c24.1572057903.git.kaixuxia@tencent.com>
 <20191029134010.GF41131@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <8b5f167b-2d7c-a387-c440-80cfe6f95c42@gmail.com>
Date:   Wed, 30 Oct 2019 11:17:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029134010.GF41131@bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2019/10/29 21:40, Brian Foster wrote:
> On Sat, Oct 26, 2019 at 07:18:37PM +0800, kaixuxia wrote:
>> Support the EXCHANGE renameat2 syscall in fsstress.
>>
>> In order to maintain filelist/filename integrity, we restrict
>> rexchange to files of the same type.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
> 
> While this looks pretty good to me at this point, I do notice instances
> of the following in a quick test:
> 
> 0/29: rename(EXCHANGE) d3/d9/dc/dd to d3/d9/dc/dd/df 22
> ...
> 0/43: rename(EXCHANGE) d3 to d3/d9/dc/d18 22
> ...
> 
> It looks like we're getting an EINVAL error on rexchange of directories.
> That same operation seems to work fine via the ./src/renameat2 tool. Any
> idea what's going on there?

Hmm.. I am not sure if I understand what your mean. Seems like
this is because the special source and target parameters setting.
There are parameters check for RENAME_EXCHANGE in renameat2() call,

 static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
                         const char __user *newname, unsigned int flags)
 {
  ...
         /* source should not be ancestor of target */
         error = -EINVAL;
         if (old_dentry == trap)
                 goto exit5;
         /* target should not be an ancestor of source */
         if (!(flags & RENAME_EXCHANGE))
                 error = -ENOTEMPTY;
         if (new_dentry == trap)
                 goto exit5;
 ...
 } 

so we get the EINVAL error on rexchange of directories. I also tested it
via the ./src/renameat2 tool, and the strace result as below,

 # src/renameat2 -x /xfs-bufdeadlock/d3 /xfs-bufdeadlock/d3/d9/dc/d18
  Invalid argument

 syscall_316(0xffffff9c, 0x7ffe38930813, 0xffffff9c, 0x7ffe38930827, 0x2, 0) = -1 (errno 22)
 
Exchange looks a bit more tricky here.. Maybe we have two choices,
one is just leave the EINVAL there since the fsstress is stress
test and the EINVAL possibility is low. The other one is we should
do parameters check before invoking the renameat2() call, if the
source and target file fents are not suitable we will try more
until get the right file fents...

> 
> Brian
> 
>>  ltp/fsstress.c | 92 ++++++++++++++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 71 insertions(+), 21 deletions(-)
>>
>> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
>> index ecc1adc..83d6337 100644
>> --- a/ltp/fsstress.c
>> +++ b/ltp/fsstress.c
>> @@ -69,6 +69,9 @@ static int renameat2(int dfd1, const char *path1,
>>  #ifndef RENAME_NOREPLACE
>>  #define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
>>  #endif
>> +#ifndef RENAME_EXCHANGE
>> +#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
>> +#endif
>>  #ifndef RENAME_WHITEOUT
>>  #define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
>>  #endif
>> @@ -115,6 +118,7 @@ typedef enum {
>>  	OP_REMOVEFATTR,
>>  	OP_RENAME,
>>  	OP_RNOREPLACE,
>> +	OP_REXCHANGE,
>>  	OP_RWHITEOUT,
>>  	OP_RESVSP,
>>  	OP_RMDIR,
>> @@ -235,6 +239,7 @@ void	readv_f(int, long);
>>  void	removefattr_f(int, long);
>>  void	rename_f(int, long);
>>  void	rnoreplace_f(int, long);
>> +void	rexchange_f(int, long);
>>  void	rwhiteout_f(int, long);
>>  void	resvsp_f(int, long);
>>  void	rmdir_f(int, long);
>> @@ -296,6 +301,7 @@ opdesc_t	ops[] = {
>>  	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
>>  	{ OP_RENAME, "rename", rename_f, 2, 1 },
>>  	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
>> +	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
>>  	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
>>  	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
>>  	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
>> @@ -371,7 +377,7 @@ void	del_from_flist(int, int);
>>  int	dirid_to_name(char *, int);
>>  void	doproc(void);
>>  int	fent_to_name(pathname_t *, flist_t *, fent_t *);
>> -void	fix_parent(int, int);
>> +void	fix_parent(int, int, bool);
>>  void	free_pathname(pathname_t *);
>>  int	generate_fname(fent_t *, int, pathname_t *, int *, int *);
>>  int	generate_xattr_name(int, char *, int);
>> @@ -1118,7 +1124,7 @@ fent_to_name(pathname_t *name, flist_t *flp, fent_t *fep)
>>  }
>>  
>>  void
>> -fix_parent(int oldid, int newid)
>> +fix_parent(int oldid, int newid, bool swap)
>>  {
>>  	fent_t	*fep;
>>  	flist_t	*flp;
>> @@ -1129,6 +1135,8 @@ fix_parent(int oldid, int newid)
>>  		for (j = 0, fep = flp->fents; j < flp->nfiles; j++, fep++) {
>>  			if (fep->parent == oldid)
>>  				fep->parent = newid;
>> +			else if (swap && fep->parent == newid)
>> +				fep->parent = oldid;
>>  		}
>>  	}
>>  }
>> @@ -4256,6 +4264,7 @@ out:
>>  
>>  struct print_flags renameat2_flags [] = {
>>  	{ RENAME_NOREPLACE, "NOREPLACE"},
>> +	{ RENAME_EXCHANGE, "EXCHANGE"},
>>  	{ RENAME_WHITEOUT, "WHITEOUT"},
>>  	{ -1, NULL}
>>  };
>> @@ -4291,41 +4300,76 @@ do_renameat2(int opno, long r, int mode)
>>  		return;
>>  	}
>>  
>> -	/* get an existing directory for the destination parent directory name */
>> -	if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
>> -		parid = -1;
>> -	else
>> -		parid = dfep->id;
>> -	v |= v1;
>> +	/*
>> +	 * Both pathnames must exist for the RENAME_EXCHANGE, and in
>> +	 * order to maintain filelist/filename integrity, we should
>> +	 * restrict exchange operation to files of the same type.
>> +	 */
>> +	if (mode == RENAME_EXCHANGE) {
>> +		which = 1 << (flp - flist);
>> +		init_pathname(&newf);
>> +		if (!get_fname(which, random(), &newf, NULL, &dfep, &v)) {
>> +			if (v)
>> +				printf("%d/%d: rename - no target filename\n",
>> +					procid, opno);
>> +			free_pathname(&newf);
>> +			free_pathname(&f);
>> +			return;
>> +		}
>> +		v |= v1;
>> +		id = dfep->id;
>> +		parid = dfep->parent;
>> +	} else {
>> +		/*
>> +		 * Get an existing directory for the destination parent
>> +		 * directory name.
>> +		 */
>> +		if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
>> +			parid = -1;
>> +		else
>> +			parid = dfep->id;
>> +		v |= v1;
>>  
>> -	/* generate a new path using an existing parent directory in name */
>> -	init_pathname(&newf);
>> -	e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
>> -	v |= v1;
>> -	if (!e) {
>> -		if (v) {
>> -			(void)fent_to_name(&f, &flist[FT_DIR], dfep);
>> -			printf("%d/%d: rename - no filename from %s\n",
>> -				procid, opno, f.path);
>> +		/*
>> +		 * Generate a new path using an existing parent directory
>> +		 * in name.
>> +		 */
>> +		init_pathname(&newf);
>> +		e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
>> +		v |= v1;
>> +		if (!e) {
>> +			if (v) {
>> +				(void)fent_to_name(&f, &flist[FT_DIR], dfep);
>> +				printf("%d/%d: rename - no filename from %s\n",
>> +					procid, opno, f.path);
>> +			}
>> +			free_pathname(&newf);
>> +			free_pathname(&f);
>> +			return;
>>  		}
>> -		free_pathname(&newf);
>> -		free_pathname(&f);
>> -		return;
>>  	}
>>  	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
>>  	check_cwd();
>>  	if (e == 0) {
>>  		int xattr_counter = fep->xattr_counter;
>> +		bool swap = (mode == RENAME_EXCHANGE) ? true : false;
>>  
>>  		oldid = fep->id;
>>  		oldparid = fep->parent;
>>  
>> +		/*
>> +		 * Swap the parent ids for RENAME_EXCHANGE, and replace the
>> +		 * old parent id for the others.
>> +		 */
>>  		if (flp - flist == FT_DIR)
>> -			fix_parent(oldid, id);
>> +			fix_parent(oldid, id, swap);
>>  
>>  		if (mode == RENAME_WHITEOUT) {
>>  			fep->xattr_counter = 0;
>>  			add_to_flist(flp - flist, id, parid, xattr_counter);
>> +		} else if (mode == RENAME_EXCHANGE) {
>> +			fep->xattr_counter = dfep->xattr_counter;
>> +			dfep->xattr_counter = xattr_counter;
>>  		} else {
>>  			del_from_flist(flp - flist, fep - flp->fents);
>>  			add_to_flist(flp - flist, id, parid, xattr_counter);
>> @@ -4359,6 +4403,12 @@ rnoreplace_f(int opno, long r)
>>  }
>>  
>>  void
>> +rexchange_f(int opno, long r)
>> +{
>> +	do_renameat2(opno, r, RENAME_EXCHANGE);
>> +}
>> +
>> +void
>>  rwhiteout_f(int opno, long r)
>>  {
>>  	do_renameat2(opno, r, RENAME_WHITEOUT);
>> -- 
>> 1.8.3.1
>>
> 

-- 
kaixuxia
