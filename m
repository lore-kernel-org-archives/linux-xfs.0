Return-Path: <SRS0=tqf+=XD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5C3C4332F
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Sep 2019 12:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE0902081B
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Sep 2019 12:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N04+xI91"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbfIHMkA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Sep 2019 08:40:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43285 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbfIHMj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Sep 2019 08:39:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id d15so7427863pfo.10;
        Sun, 08 Sep 2019 05:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3Yw+fTX5gmOupxj038RvQxg0vhTdIy64Tv8ap1vJivE=;
        b=N04+xI91/i82IYhjsOejhkZJcs7oWrujMLAycnWa3AYoTvgnlKQq+hdSYky24EhPrs
         K/LPzwn3DFKmZS4MFxJlhi2/46iWyOnpIjS8UjaWWI4upsQmSGFvIaV4ONoRHYOQzUz5
         iHMsfHnbRYaWt1dZwJwcRwwxLsKz6LyN0L+Pb771uMGOsUVIDBLY5GGu5NoFe6heMfSi
         D84lR8vQjGyLs2FiSyThd6eIufH2GB4/3BSOVBryi0BkiAJABJvfqx6/znKI1BEW2d45
         GsxfOmF7JcItiQ3d1MfTKwRKBGX3yGUbVT3/oFJbsR7Ks3d1aVac7Z6Qbi+Rvyo2Ws4y
         MJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3Yw+fTX5gmOupxj038RvQxg0vhTdIy64Tv8ap1vJivE=;
        b=pgc4XMUMyP/V38hxYLFFC8hhdZuX4BSzhtYv92Eyyc9b6n+D5QE3zOAYgnQGP+jgKJ
         KyqXDlwVbPqmqfOd69dCe+Av8UtHq8BsI2IWrLOWD4Dwgb/72Tyz9HA13zOMi96j/xIG
         Je+7vpu84irfyVfr6mZ2B+35OkSmOAhjzfAp75KANpE4jlGJXS6BuRMFnY6AAsp/Tnmu
         GwPg2OZrchHvMmigvPRI8xEA46WajW4ihFwKOjMaVPnuzvvIiAa1MOls3l+iCHkd8NaF
         0S297Gpczz9PYh/yefgORV+nSJROisvUN4NPe8jwObyBB6Lv6/BUAs4Wb1kU+BdH8nzw
         /7lw==
X-Gm-Message-State: APjAAAVGXlEaYOZFKUYSDzcMYQ9zig7HzPAnm5HaW39NOb40YzQehP2N
        qpL2zQ06MmiCjHWymqLFSus=
X-Google-Smtp-Source: APXvYqxkAGCi55jBRZCV7BSmsVBorTLTI+VPq8CyDPsjBF1AbQMnZx9ZWEc1/2SM1yunQdVHa6dI8A==
X-Received: by 2002:a65:6713:: with SMTP id u19mr15893117pgf.403.1567946398600;
        Sun, 08 Sep 2019 05:39:58 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id q204sm11555099pfq.176.2019.09.08.05.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2019 05:39:54 -0700 (PDT)
Date:   Sun, 8 Sep 2019 20:39:39 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <20190908123939.GG2622@desktop>
References: <59006cf8-f825-d33f-c860-111189689e2e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59006cf8-f825-d33f-c860-111189689e2e@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 06:01:27PM +0800, kaixuxia wrote:
> There is ABBA deadlock bug between the AGI and AGF when performing
> rename() with RENAME_WHITEOUT flag, and add this testcase to make
> sure the rename() call works well.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
>  tests/xfs/512     | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/512.out |   2 ++
>  tests/xfs/group   |   1 +
>  3 files changed, 103 insertions(+)
>  create mode 100755 tests/xfs/512
>  create mode 100644 tests/xfs/512.out
> 
> diff --git a/tests/xfs/512 b/tests/xfs/512
> new file mode 100755
> index 0000000..0e95fb7
> --- /dev/null
> +++ b/tests/xfs/512
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Tencent.  All Rights Reserved.
> +#
> +# FS QA Test 512
> +#
> +# Test the ABBA deadlock case between the AGI and AGF When performing
> +# rename operation with RENAME_WHITEOUT flag.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch

Only _require_scratch_nocheck is suffiecient.

> +
> +# Single AG will cause default xfs_repair to fail. This test need a
> +# single AG fs, so ignore the check.
> +_require_scratch_nocheck

Also need to 

. ./common/rename
...

_requires_renameat2

Also, this test requires RENAME_WHITEOUT, I'd suggest enhance
src/renameat2.c to support check for if a given rename flag is supported
by kernel, and refactor the checks in generic/02[45] and generic/078
into _requires_renameat2 to use the new functionality. e.g.

# without option, behavior stays unchanged, check for renameat2 syscall
# support
_requires_renameat2

# check if renameat2 upports RENAME_WHITEOUT flag
_requires_renameat2 whiteout

# check if renameat2 upports RENAME_EXCHANGE flag
_requires_renameat2 exchange

> +
> +prepare_file()
> +{
> +	# create many small files for the rename with RENAME_WHITEOUT
> +	i=0
> +	while [ $i -le $files ]; do
> +		file=$SCRATCH_MNT/f$i
> +		$XFS_IO_PROG -f -d -c 'pwrite -b 4k 0 4k' $file >/dev/null 2>&1
> +		let i=$i+1

Creating 250000 4k files take a long time. Does file content really
matters? I guess racing RENAME_WHITEOUT with file creation is enough, is
it possible to just create many empty files? e.g.

		echo > $file

this saves a lot time.

> +	done
> +}
> +
> +rename_whiteout()
> +{
> +	# create the rename targetdir
> +	renamedir=$SCRATCH_MNT/renamedir
> +	mkdir $renamedir
> +
> +	# just get a random long name...
> +	longnamepre=FFFsafdsagafsadfagasdjfalskdgakdlsglkasdg

Better to explain why long file name is required.

> +
> +	# now try to do rename with RENAME_WHITEOUT flag
> +	i=0
> +	while [ $i -le $files ]; do
> +		src/renameat2 -w $SCRATCH_MNT/f$i $renamedir/$longnamepre$i >/dev/null 2>&1
> +		let i=$i+1
> +	done
> +}
> +
> +create_file()
> +{
> +	# create the targetdir
> +	createdir=$SCRATCH_MNT/createdir
> +	mkdir $createdir
> +
> +	# try to create file at the same time to hit the deadlock
> +	i=0
> +	while [ $i -le $files ]; do
> +		file=$createdir/f$i
> +		$XFS_IO_PROG -f -d -c 'pwrite -b 4k 0 4k' $file >/dev/null 2>&1
> +		let i=$i+1
> +	done

Same here, does creating empty files work?

> +}
> +
> +_scratch_mkfs_xfs -bsize=512 -dagcount=1 >> $seqres.full 2>&1 ||

This doesn't work because crc is on by default, as crc requires minimum
1k block size. Is 512 block size really needed?

> +	_fail "mkfs failed"
> +_scratch_mount
> +
> +files=250000

If we could reduce file number to create, test could run faster as well.
Running test with less than 250000 files couldn't reproduce the
deadlock?

Thanks,
Eryu

> +
> +prepare_file
> +rename_whiteout &
> +create_file &
> +
> +wait
> +echo Silence is golden
> +
> +# Failure comes in the form of a deadlock.
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
> new file mode 100644
> index 0000000..0aabdef
> --- /dev/null
> +++ b/tests/xfs/512.out
> @@ -0,0 +1,2 @@
> +QA output created by 512
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index a7ad300..ed250d6 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -509,3 +509,4 @@
>  509 auto ioctl
>  510 auto ioctl quick
>  511 auto quick quota
> +512 auto rename
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
