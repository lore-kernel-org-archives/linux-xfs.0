Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B625DC433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D18021897
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ab5mf4aO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgIAOnF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbgIAOQq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 10:16:46 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E5BC06124F;
        Tue,  1 Sep 2020 07:07:39 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t13so1267891ile.9;
        Tue, 01 Sep 2020 07:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NzYrrH8MqG1W9WvmESAQjiflUNBqSZCwQfZpzWxPnCY=;
        b=ab5mf4aOnI8uRd+jXamfptdbSLFpNGFxpRVnpYlYq1xHzv5PwsnoJCMY/vrTtjavc5
         ei5QSl/rLce/MaczldSDT5OyOgHHShwyUHbYtJlUea47bE2F/Ne7DYFmpWtBgnww3hq6
         cjrvl/NeJEoyLePswWXWSZPX3vCfmw8DISsXa6mGdEnIQACrD03UA9eToTlny582QCmI
         nDPaBlhCUiXBPmoCinjOpLRH7GxVRgECGPOAVsFItDdsaLGWvj/lMupR1oe+5R3CnUVX
         Ma4CsqPSRMxz8WO3WypahwgFJ+xdqhArYaqceB1t17+0E9x5FGnChZ1ZAx1CVJsTp/1E
         MULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NzYrrH8MqG1W9WvmESAQjiflUNBqSZCwQfZpzWxPnCY=;
        b=S5GmrXv8opXi4ZOdWV/LmS9m1wBnIOk2Nh/1h/CpRkBvZO+1PivTOlVsKQyle6xEaD
         xzx3GsxArj+Lnkojt0614Z/5PGVK0KgkrFpHtTjWLlq3BA4ztUu98R8XCODXWcKVTWiS
         nvAzIuHleL0f/IwvSzcw2/B2bhrSxWAFHl5a+iVX+kel0Ag6JwvBjgVG1TZVnIvcFNse
         FUTRFOhPxNf4yOltbAWVcJhLZ+QdkGrphVtg4xPmJDm3Fn+62xgARSVKFSiWjW5slrW+
         cHDB3EdPg3cZn/xfFKG0zkaBXJDYW2K79Cu+ttWOeEqD1SV3URjsdGmULZ+xSS0Q57WK
         FI7Q==
X-Gm-Message-State: AOAM531D1tk6Ws2/0gbNfEZnd+3j0V4jaMzpTEobl22D0P6x0hoqK0/y
        s7Sczkios923xOdVJZnBVlZH+w/J75ZReGj/HM4=
X-Google-Smtp-Source: ABdhPJznlWgoi+a/4skLlfmSItsHcltQxQXLIgZqN4AM798P1TFM/ix7zxfT2QN/vbhE0RDdqqfr+bBbg9Ow52Yhrao=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr1441222ilj.137.1598969258978;
 Tue, 01 Sep 2020 07:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200901134728.185353-1-bfoster@redhat.com> <20200901134728.185353-3-bfoster@redhat.com>
In-Reply-To: <20200901134728.185353-3-bfoster@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Sep 2020 17:07:27 +0300
Message-ID: <CAOQ4uxgr9B-5Wgx_H4qv0r74Wq4zONZjtae6fjeSCTq=WEzvZw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] generic/457: use thin volume for dmlogwrites
 target device
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 1, 2020 at 4:49 PM Brian Foster <bfoster@redhat.com> wrote:
>
> dmlogwrites support for XFS depends on discard zeroing support of
> the intended target device. Update the test to use a thin volume and
> allow it to run consistently and reliably on XFS.
>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

>  tests/generic/457 | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
>
> diff --git a/tests/generic/457 b/tests/generic/457
> index 82367304..42a064d8 100755
> --- a/tests/generic/457
> +++ b/tests/generic/457
> @@ -16,6 +16,7 @@ status=1      # failure is the default!
>  _cleanup()
>  {
>         _log_writes_cleanup
> +       _dmthin_cleanup
>  }
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>
> @@ -23,6 +24,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  . ./common/rc
>  . ./common/filter
>  . ./common/reflink
> +. ./common/dmthin
>  . ./common/dmlogwrites
>
>  # real QA test starts here
> @@ -32,6 +34,7 @@ _require_test
>  _require_scratch_reflink
>  _require_cp_reflink
>  _require_log_writes
> +_require_dm_target thin-pool
>
>  rm -f $seqres.full
>
> @@ -44,13 +47,12 @@ check_files()
>                 local filename=$(basename $i)
>                 local mark="${filename##*.}"
>                 echo "checking $filename" >> $seqres.full
> -               _log_writes_replay_log $filename $SCRATCH_DEV
> -               _scratch_mount
> +               _log_writes_replay_log $filename $DMTHIN_VOL_DEV
> +               _dmthin_mount
>                 local expected_md5=$(_md5_checksum $i)
>                 local md5=$(_md5_checksum $SCRATCH_MNT/$name)
>                 [ "${md5}" != "${expected_md5}" ] && _fail "$filename md5sum mismatched"
> -               _scratch_unmount
> -               _check_scratch_fs
> +               _dmthin_check_fs
>         done
>  }
>
> @@ -58,8 +60,16 @@ SANITY_DIR=$TEST_DIR/fsxtests
>  rm -rf $SANITY_DIR
>  mkdir $SANITY_DIR
>
> +devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
> +csize=$((1024*64 / 512))                # 64k cluster size
> +lowspace=$((1024*1024 / 512))           # 1m low space threshold
> +
> +# Use a thin device to provide deterministic discard behavior. Discards are used
> +# by the log replay tool for fast zeroing to prevent out-of-order replay issues.
> +_dmthin_init $devsize $devsize $csize $lowspace
> +
>  # Create the log
> -_log_writes_init $SCRATCH_DEV
> +_log_writes_init $DMTHIN_VOL_DEV
>
>  _log_writes_mkfs >> $seqres.full 2>&1
>
> @@ -92,14 +102,13 @@ _log_writes_mark last
>  _log_writes_unmount
>  _log_writes_mark end
>  _log_writes_remove
> -_check_scratch_fs
> +_dmthin_check_fs
>
>  # check pre umount
>  echo "checking pre umount" >> $seqres.full
> -_log_writes_replay_log last $SCRATCH_DEV
> -_scratch_mount
> -_scratch_unmount
> -_check_scratch_fs
> +_log_writes_replay_log last $DMTHIN_VOL_DEV
> +_dmthin_mount
> +_dmthin_check_fs
>
>  for j in `seq 0 $((NUM_FILES-1))`; do
>         check_files testfile$j
> @@ -107,8 +116,8 @@ done
>
>  # Check the end
>  echo "checking post umount" >> $seqres.full
> -_log_writes_replay_log end $SCRATCH_DEV
> -_scratch_mount
> +_log_writes_replay_log end $DMTHIN_VOL_DEV
> +_dmthin_mount
>  for j in `seq 0 $((NUM_FILES-1))`; do
>         md5=$(_md5_checksum $SCRATCH_MNT/testfile$j)
>         [ "${md5}" != "${test_md5[$j]}" ] && _fail "testfile$j end md5sum mismatched"
> --
> 2.25.4
>
