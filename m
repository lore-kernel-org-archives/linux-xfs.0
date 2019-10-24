Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5357CA9EBC
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 03:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A56D2086D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 03:00:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OKJ2gQoc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406423AbfJXDAn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 23:00:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37665 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405098AbfJXDAm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 23:00:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id u20so11114023plq.4;
        Wed, 23 Oct 2019 20:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gCLB1QEDKV5/Am8IKMlsv6oNwtn1xGoCZdIgT30GZNA=;
        b=OKJ2gQocs0sO+6/I7kTE+xytaR4/visRYMYgWW4pK97qt7ISVbBBtd2mSKdFjaapFC
         sbzZ20ZzbZh2uCH5o2rIroViLF7dUYILJ75q80ECnURYrzTCun9Xeo4pxANxoqmGPVfU
         ma3lwdI5FDiraCYxtNTUpXO+i5Vv+xdJuzqyZBVqednVOK1cxZ8yoICjZcI4rM1uMDQv
         Xigq/9nXoRz+u2f564FVrBv9RcQxKUpOBrOa3lmwzHsmu/Ek5tfDFEf2/W4A/W1nSsJQ
         BKXu5KsH7+1VQDVZxoI9jY0SQp3x6MFL4kB5pezCW26t0+dq2wnrYfzjo17e3EZRSPlp
         nXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gCLB1QEDKV5/Am8IKMlsv6oNwtn1xGoCZdIgT30GZNA=;
        b=kb83VMxFN4Sm/DAvla0BfO3NWGaaZ9LYtSsRBxYLxfhoYEnw9n9DRwovesQhGD+mfE
         7+/Rb26Ie2tOG8GCKLOu05lRChFJLYRJxR4UQu5O2UaQSnuSo2S0qj67FxKfsp3nQLNj
         gAOGXxB0Kbwtm0br9zncj7GOhlounjjeCYH70qcO35DQMS2iNg9M98J4NfaJT2I30qKk
         Xna1r3uRdboVmwjqITA1rGBsrVmKThDLcZ4Sm+ACGor38rBgIo4ox0h7pb9OMeMtlt+x
         LOVS8fV2lsYgTjaxsRXAe3g1ZeYawY6P+92rxeHfDqSfsSHLW3toOfXYnYkX19zuhgvI
         +RtQ==
X-Gm-Message-State: APjAAAVkrulcWzG/yso9TgSeNh/VFrV2lyNAv1zQkq7AWEuLq1DOZA+g
        R/XLOl9hs1rG5WJQKgQVmg==
X-Google-Smtp-Source: APXvYqy0UadDSz3sjeJF1Hc20YKBmG1x9Dif0wJmjyjzdxrx/U4UPZXSG9xKmyzxU/FOwhlEIOi8Ag==
X-Received: by 2002:a17:902:36a:: with SMTP id 97mr13576001pld.83.1571886041848;
        Wed, 23 Oct 2019 20:00:41 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id f15sm24066527pfd.141.2019.10.23.20.00.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 20:00:41 -0700 (PDT)
Subject: Re: [PATCH v5] fsstress: add renameat2 support
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <a602433c-ec36-a607-e1bc-6e532e3ebaca@gmail.com>
 <20191023130132.GC59518@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <33b5d5d4-b5f8-37f5-01c7-a3702534dce1@gmail.com>
Date:   Thu, 24 Oct 2019 11:00:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191023130132.GC59518@bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/10/23 21:01, Brian Foster wrote:
> On Tue, Oct 22, 2019 at 08:19:37PM +0800, kaixuxia wrote:
>> Support the renameat2 syscall in fsstress.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
>> Changes in v5:
>>  - Fix the RENAME_EXCHANGE flist fents swap problem.
>>
>>  ltp/fsstress.c | 202 +++++++++++++++++++++++++++++++++++++++++++++++----------
>>  1 file changed, 169 insertions(+), 33 deletions(-)
>>
>> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
>> index 51976f5..7c59f2d 100644
>> --- a/ltp/fsstress.c
>> +++ b/ltp/fsstress.c
> ...
>> @@ -4269,16 +4367,31 @@ rename_f(int opno, long r)
>>  			oldid = fep->id;
>>  			fix_parent(oldid, id);
>>  		}
>> -		del_from_flist(flp - flist, fep - flp->fents);
>> -		add_to_flist(flp - flist, id, parid, xattr_counter);
>> +
>> +		if (mode == RENAME_WHITEOUT) {
>> +			add_to_flist(FT_DEV, fep->id, fep->parent, 0);
>> +			del_from_flist(flp - flist, fep - flp->fents);
>> +			add_to_flist(flp - flist, id, parid, xattr_counter);
>> +		} else if (mode == RENAME_EXCHANGE) {
>> +			if (dflp - flist == FT_DIR) {
>> +				oldid = dfep->id;
>> +				fix_parent(oldid, fep->id);
>> +			}
>> +			swap_flist_fents(flp - flist, fep - flp->fents,
>> +					 dflp - flist, dfep - dflp->fents);
> 
> Hmm.. sorry, but this is still a little confusing. One thing I realized
> when running this is that the id correlates with filename and the
> filename correlates to type (i.e., fN for files, cN for devs, dN for
> dirs, etc.). This means that we can now end up doing something like
> this:
> 
> 0/8: rename(EXCHANGE) c4 to f5 0
> 0/8: rename source entry: id=5,parent=-1
> 0/8: rename target entry: id=5,parent=-1
> 
I think the source entry id and parentid here are overwritten by
del_from_flist() call above for all kinds of rename operations,
we should show the actually values. 

> ... which leaves an 'f5' device node and 'c4' regular file. Because of
> this, I'm wondering if we should just restrict rexchange to files of the
> same type and keep this simple. That means we would use the file type of
> the source file when looking up a destination to exchange with (instead
> of FT_ANY).
>Sounds reasonable, will do this in next version.

> With regard to fixing up the flist, this leaves two general cases:
> 
> - Between two non-dirs: REXCHANGE f0 <-> d3/f5
> 
> The id -> parent relationship actually hasn't changed because both file
> entries still exist just as before the call. We've basically just
> swapped inodes from the directory tree perspective. This means
> xattr_count needs to be swapped between the entries.
> 
> - Between two dirs: REXCHANGE d1 <-> d2/d3
> 
> I think the same thing applies as above with regard to the parent ids of
> the directories themselves. E.g., d3 is still under d2, it just now
> needs the xattr_count from the old d1 and vice versa. Additionally, all
> of the children of d2/d3 are now under d1 and vice versa, so those
> parent ids need to be swapped. That said, we can't just call
> fix_parent() to swap all parentid == 1 to 3 and then repeat for 3 -> 1
> because that would put everything under 1. Instead, it seems like we
> actually need a single fix_parent() sweep to change all 1 -> 3 and 3 ->
> 1 parent ids in a single pass.
> 
Sure.

> Moving on to RWHITEOUT, the above means that we leave a dev node around
> with whatever the name of the source file was. That implies we should
> restrict RWHITEOUT to device nodes if we want to maintain
> filelist/filename integrity. The immediate question is: would that allow
> the associated fstest to still reproduce the deadlock problem? I think
> it should, but we should confirm that (i.e., the test now needs to do
> '-fmknod=NN' instead of '-fcreat=NN').
> 
Yeah, I have tested this on my vm when restricting RWHITEOUT to device
nodes, the associated fstest still can reproduced the deadlock problem,
and the run time is very short. 

> Thoughts? Does that all sound reasonable/correct or have I
> misinterpreted things?
> 
> Finally, given the complexity disparity between the two operations, at
> this point I'd suggest to split this into two patches (one for general
> renameat2 support + rwhiteout, another for rexchange support on top).

Thanks for your comments, will do it in next version. 

> > Brian
> 
>> +		} else {
>> +			del_from_flist(flp - flist, fep - flp->fents);
>> +			add_to_flist(flp - flist, id, parid, xattr_counter);
>> +		}
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
>> @@ -4287,6 +4400,29 @@ rename_f(int opno, long r)
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
> 

-- 
kaixuxia
