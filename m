Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B6AC433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 10:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8987461A2C
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 10:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCYKJH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 06:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhCYKJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 06:09:01 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E255C06174A;
        Thu, 25 Mar 2021 03:09:00 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v186so1280646pgv.7;
        Thu, 25 Mar 2021 03:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=lLSFxEmIbL155ZDAgKp3ao3Ztt5yppEE6Roz8XB3Np8=;
        b=erthkXZNKsF4262/gcoBu1E1COw7lsYE4XG279MjU4gfdAToLhaOblOWSBazHagxas
         5LLr76LHj+jmRk2/vtNPfiKK9uRSVrNLPVPagkfO2iPe5T/+ZjQ6t+mkO719mb2Oyg7C
         7a9qCYciPvjpkKjp04CQPBw1Zipk/EdTTuy9m+yBWF6HG1W/qU7eEKRFQCbNmvm5RRUy
         HaipoCdYu6qYVn01PnlpHvbGw5fDmtB/rq2uafPgs3f4cqwswX2YzElpS0wGcA/nGvZ1
         2GELnZ7/ZwGWOrr3+mSZW6Y5RTBPTIXIsgUjO55DeSlwToqFEcFUUTodOicqxi0YrTea
         rBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=lLSFxEmIbL155ZDAgKp3ao3Ztt5yppEE6Roz8XB3Np8=;
        b=qebFpWUUSUdVYMWG1Ddcux1/GJl4ih0jnXTe2A7fkjGMb8flle+Uj7Ut4c0QmZggFw
         hMyALkYpIm0C/r3ji8oCq/Fy/K2HAPyl41WhuXRf2r5/4Fao7/Zk3oSWU/JvEzYpqC6e
         DpJ6YlND+Pi5I0YOodQUa44JqBKPEBDkYgDlHiVPdNznRmJNJaFJjC21X/QMBglEVsQU
         FIQOiPdG+RCSgMecu7drONgFiO7+0GqOCiL0AhqLQij3DDKD7NIJE1WS0neB6SnsrFg/
         LtHqZKfkbKTWsqqNF+5QA2xfAymnDffofYKjLjPTjFECuj+Io+YMh/qSSbh2AHtCHpmS
         uQQQ==
X-Gm-Message-State: AOAM532m+84fShn4sd113GY4cZqkh+jlZsYClL2nG2/FUMZymcOugonV
        EiGTLI8Af+vo+8KIHO11UBw=
X-Google-Smtp-Source: ABdhPJxN+uqEZCON/yHAJeJrx/jtx135Bi0XujKf1bFlSvrqmHbCwn/ba5Q+zNmqNGAtAggLy3ceYA==
X-Received: by 2002:aa7:9493:0:b029:1f8:a493:b747 with SMTP id z19-20020aa794930000b02901f8a493b747mr7552297pfk.41.1616666939669;
        Thu, 25 Mar 2021 03:08:59 -0700 (PDT)
Received: from garuda ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id j3sm5494526pfi.74.2021.03.25.03.08.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Mar 2021 03:08:59 -0700 (PDT)
References: <161647321880.3430916.13415014495565709258.stgit@magnolia> <161647322983.3430916.9402200604814364098.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] xfs: test the xfs_db ls command
In-reply-to: <161647322983.3430916.9402200604814364098.stgit@magnolia>
Date:   Thu, 25 Mar 2021 15:38:56 +0530
Message-ID: <87lfabo893.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Mar 2021 at 09:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Make sure that the xfs_db ls command works the way the author thinks it
> does.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/918     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/918.out |   27 +++++++++++++
>  tests/xfs/group   |    1
>  3 files changed, 137 insertions(+)
>  create mode 100755 tests/xfs/918
>  create mode 100644 tests/xfs/918.out
>
>
> diff --git a/tests/xfs/918 b/tests/xfs/918
> new file mode 100755
> index 00000000..7211df92
> --- /dev/null
> +++ b/tests/xfs/918
> @@ -0,0 +1,109 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 918
> +#
> +# Make sure the xfs_db ls command works the way the author thinks it does.
> +# This means that we can list the current directory, list an arbitrary path,
> +# and we can't list things that aren't directories.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
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
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_db_command "path"
> +_require_xfs_db_command "ls"
> +_require_scratch
> +
> +echo "Format filesystem and populate"
> +_scratch_mkfs > $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +$XFS_INFO_PROG $SCRATCH_MNT | grep -q ftype=1 || \
> +	_notrun "filesystem does not support ftype"
> +
> +filter_ls() {
> +	awk '
> +BEGIN { cookie = 0; }
> +{
> +	if (cookie == 0)
> +		cookie = $1;
> +	printf("+%d %s %s %s %s %s\n", $1 - cookie, $2, $3, $4, $5, $6);
> +	cookie = $1;
> +}' | \
> +	sed	-e "s/ $root_ino directory / root directory /g" \
> +		-e "s/ $a_ino directory / a_ino directory /g" \
> +		-e "s/ $b_ino directory / b_ino directory /g" \
> +		-e "s/ $c_ino regular / c_ino regular /g" \
> +		-e "s/ $d_ino symlink / d_ino symlink /g" \
> +		-e "s/ $e_ino blkdev / e_ino blkdev /g" \
> +		-e "s/ $f_ino chardev / f_ino chardev /g" \
> +		-e "s/ $g_ino fifo / g_ino fifo /g" \
> +		-e "s/ $big0_ino regular / big0_ino regular /g" \
> +		-e "s/ $big1_ino regular / big1_ino regular /g" \
> +		-e "s/ $h_ino regular / g_ino regular /g"
> +}
> +
> +mkdir $SCRATCH_MNT/a
> +mkdir $SCRATCH_MNT/a/b
> +$XFS_IO_PROG -f -c 'pwrite 0 61' $SCRATCH_MNT/a/c >> $seqres.full
> +ln -s -f b $SCRATCH_MNT/a/d

Similar to the previous patch, the symbolic link 'd' will refer to a
non-existing file. However, it shouldn't matter w.r.t to correctness of this
test.

> +mknod $SCRATCH_MNT/a/e b 0 0
> +mknod $SCRATCH_MNT/a/f c 0 0
> +mknod $SCRATCH_MNT/a/g p
> +touch $SCRATCH_MNT/a/averylongnameforadirectorysothatwecanpushthecookieforward
> +touch $SCRATCH_MNT/a/andmakethefirstcolumnlookmoreinterestingtopeoplelolwtfbbq
> +touch $SCRATCH_MNT/a/h
> +
> +root_ino=$(stat -c '%i' $SCRATCH_MNT)
> +a_ino=$(stat -c '%i' $SCRATCH_MNT/a)
> +b_ino=$(stat -c '%i' $SCRATCH_MNT/a/b)
> +c_ino=$(stat -c '%i' $SCRATCH_MNT/a/c)
> +d_ino=$(stat -c '%i' $SCRATCH_MNT/a/d)
> +e_ino=$(stat -c '%i' $SCRATCH_MNT/a/e)
> +f_ino=$(stat -c '%i' $SCRATCH_MNT/a/f)
> +g_ino=$(stat -c '%i' $SCRATCH_MNT/a/g)
> +big0_ino=$(stat -c '%i' $SCRATCH_MNT/a/avery*)
> +big1_ino=$(stat -c '%i' $SCRATCH_MNT/a/andma*)
> +h_ino=$(stat -c '%i' $SCRATCH_MNT/a/h)
> +
> +_scratch_unmount
> +
> +echo "Manually navigate to root dir then list"
> +_scratch_xfs_db -c 'sb 0' -c 'addr rootino' -c ls > /tmp/fuck0
> +cat /tmp/fuck0 | filter_ls > /tmp/fuck1

The two lines above are redundant.

> +_scratch_xfs_db -c 'sb 0' -c 'addr rootino' -c ls | filter_ls

--
chandan
