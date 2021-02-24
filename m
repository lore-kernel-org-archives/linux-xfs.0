Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043F8C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 08:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A4F64EC9
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 08:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhBXIBz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:01:55 -0500
Received: from eu-shark1.inbox.eu ([195.216.236.81]:48122 "EHLO
        eu-shark1.inbox.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbhBXIBC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 03:01:02 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2021 03:00:57 EST
Received: from eu-shark1.inbox.eu (localhost [127.0.0.1])
        by eu-shark1-out.inbox.eu (Postfix) with ESMTP id D071F6C00845;
        Wed, 24 Feb 2021 09:52:26 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=inbox.eu; s=20140211;
        t=1614153146; bh=i6XzsxUiiixkPEYsZXDt75ho/uHfHk6hEj1eySDDMfA=;
        h=References:From:To:Cc:Cc:Subject:In-reply-to:Date;
        b=kPvwT46KVV9488BkmCWmmYPNZ4RDKkKCiSnXriNlohqTNNL5fX/FNpxZP4DRIQQok
         WGcrwVk4L636ajyFs3iOF276nwXIXaihB6n1c3SKfK6ZeBJlx9sW04mHxxuyRKONp5
         1KOdSBYWSw1H4DhVvzapfzeoBnBnTIcJq3aS6ifk=
Received: from localhost (localhost [127.0.0.1])
        by eu-shark1-in.inbox.eu (Postfix) with ESMTP id C145B6C00835;
        Wed, 24 Feb 2021 09:52:26 +0200 (EET)
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "Cc"
Received: from eu-shark1.inbox.eu ([127.0.0.1])
        by localhost (eu-shark1.inbox.eu [127.0.0.1]) (spamfilter, port 35)
        with ESMTP id sv9yHIxd4ueq; Wed, 24 Feb 2021 09:52:26 +0200 (EET)
Received: from mail.inbox.eu (eu-pop1 [127.0.0.1])
        by eu-shark1-in.inbox.eu (Postfix) with ESMTP id 315B96C00842;
        Wed, 24 Feb 2021 09:52:26 +0200 (EET)
Received: from nas (unknown [45.87.95.231])
        (Authenticated sender: l@damenly.su)
        by mail.inbox.eu (Postfix) with ESMTPA id 281F71BE00D9;
        Wed, 24 Feb 2021 09:52:22 +0200 (EET)
References: <20210223134042.2212341-1-cgxu519@mykernel.net>
User-agent: mu4e 1.4.13; emacs 27.1
From:   Su Yue <l@damenly.su>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org
Cc:     nborisov@suse.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/473: fix expectation properly in out file
In-reply-to: <20210223134042.2212341-1-cgxu519@mykernel.net>
Message-ID: <4ki1rjgu.fsf@damenly.su>
Date:   Wed, 24 Feb 2021 15:52:17 +0800
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Virus-Scanned: OK
X-ESPOL: 885mkI9QEjm6g1u/QXjfGWREoi9VL57ogYemsmlUnX36MCyMfUkJVgzE42E2Ejyk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Cc to the author and linux-xfs, since it's xfsprogs related.

On Tue 23 Feb 2021 at 21:40, Chengguang Xu <cgxu519@mykernel.net> 
wrote:

> It seems the expected result of testcase of "Hole + Data"
> in generic/473 is not correct, so just fix it properly.
>

But it's not proper...

> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  tests/generic/473.out | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/generic/473.out b/tests/generic/473.out
> index 75816388..f1ee5805 100644
> --- a/tests/generic/473.out
> +++ b/tests/generic/473.out
> @@ -6,7 +6,7 @@ Data + Hole
>  1: [256..287]: hole
>  Hole + Data
>  0: [0..127]: hole
> -1: [128..255]: data
> +1: [128..135]: data
>
The line is produced by `$XFS_IO_PROG -c "fiemap -v 0 65k" $file | 
_filter_fiemap`.
0-64k is a hole and 64k-128k is a data extent.
fiemap ioctl always returns *complete* ranges of extents.

You may ask why the ending hole range is not aligned to 128 in 
473.out. Because
fiemap ioctl returns nothing of querying holes. xfs_io does the 
extra
print work for holes.

xfsprogs-dev/io/fiemap.c:
for holes:
 153     if (lstart > llast) {
 154         print_hole(0, 0, 0, cur_extent, lflag, true, llast, 
 lstart);
 155         cur_extent++;
 156         num_printed++;
 157     }

for the ending hole:
  381     if (cur_extent && last_logical < range_end)
  382         print_hole(foff_w, boff_w, tot_w, cur_extent, lflag, 
  !vflag,
  383                BTOBBT(last_logical), BTOBBT(range_end));

>  Hole + Data + Hole
>  0: [0..127]: hole
>  1: [128..255]: data
