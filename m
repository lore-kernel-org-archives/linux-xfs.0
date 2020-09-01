Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A3FC433E7
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B603215A4
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:43:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pHOhf8qo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgIAOnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbgIAOQo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 10:16:44 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A01EC061249;
        Tue,  1 Sep 2020 07:06:38 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g128so1310606iof.11;
        Tue, 01 Sep 2020 07:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SlcdSlLzZ6hPoD339tdXeJ72A7Nyi9kOiMrYaOpBy5U=;
        b=pHOhf8qoVh/AFXmH4TccYjS5k6OcqKrB7FttLc2BOuiibG46DtUBwjyk9rInCvNv3j
         z5v1mcQtwdNlqdube8aLR34xKOqXAu/iVVnCYV7SVwzkENtThq3lYUmGbTQD4+EKFijc
         kgHXHzJfbMMuavY6wAdp2yN+RKYQTivnT4Nzbdtb7QlJigTrE3w4iRikn5XgEO94r6wK
         IsSdg0qZrkDzuBOVL2EKZlUzLp1KiqW8vmjq1LIS/KxVnFDl4lLDvOPTR0nvfwUr30Eo
         0ULcidz9B4VXLuLjkuicTGVoKU4i8Xoz1b3MqR58imFp8nOm43SXwUWlk4hhdiZPlXaC
         Wx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SlcdSlLzZ6hPoD339tdXeJ72A7Nyi9kOiMrYaOpBy5U=;
        b=HUE+v2qUE0H4vwHyYytBLMtoMSKooHP9rZsjXKxqnjaVQUWncQVrD79SoTjF2wxZGc
         Q4hq4pTL7WCnTW/frz0ly4c5yHsgHmkTblt0Sfx9E926YMabqiV7cM7vyPkNoe2LSgUw
         JhbUEj2eZPjDED1b5CydDRAwvt4/teGZq8snXZv/jOArMNvy65iMpPZRj7WUS9nOt4LP
         lANwqdZrcYbrEec5+GmGpQ8gGJFjgYka0+N8ZoZubETLrB0jRZxQl7H/CI9V3G9UCG+o
         2HKqZT1q5CYPMWxDwIfmSN6tYKmkuSKqXOuxvhuRz49lTvXtMQYVln+SrCbXXglyWWoH
         snSA==
X-Gm-Message-State: AOAM530SurxTWca2qO5y+o3yJ/XJGqV9ceu99RejtIqPZPSlK2sha65h
        /7YMM2d2bp3xkvrNfP+6MF7ZMJQRjICW2ntWQrLzqX8WF5Q=
X-Google-Smtp-Source: ABdhPJxpcc+GxRAGWCYtALIphgwrRGKv7puf/8IeXL7vW8gJH3XwTM6vArnfJeKmRarcLFVM45mgN7UgWrm1mTzYLkw=
X-Received: by 2002:a05:6602:1d6:: with SMTP id w22mr1620315iot.64.1598969197660;
 Tue, 01 Sep 2020 07:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200901134728.185353-1-bfoster@redhat.com> <20200901134728.185353-2-bfoster@redhat.com>
In-Reply-To: <20200901134728.185353-2-bfoster@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Sep 2020 17:06:26 +0300
Message-ID: <CAOQ4uxiEW9LmftT5a-4RPgqj3v29Z+1Y7m_ZKELHf+uAz6xueA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] generic/455: use thin volume for dmlogwrites
 target device
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 1, 2020 at 4:48 PM Brian Foster <bfoster@redhat.com> wrote:
>
> dmlogwrites support for XFS depends on discard zeroing support of
> the intended target device. Update the test to use a thin volume and
> allow it to run consistently and reliably on XFS.
>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
Reviewed-by: Amir Goldstein <amir73il@gmail.com>


>  tests/generic/455 | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
>
> diff --git a/tests/generic/455 b/tests/generic/455
> index 05621220..72a44fda 100755
> --- a/tests/generic/455
> +++ b/tests/generic/455
> @@ -16,12 +16,14 @@ status=1    # failure is the default!
>  _cleanup()
>  {
>         _log_writes_cleanup
> +       _dmthin_cleanup
>  }
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>
>  # get standard environment, filters and checks
>  . ./common/rc
>  . ./common/filter
> +. ./common/dmthin
>  . ./common/dmlogwrites
>
>  # real QA test starts here
> @@ -30,6 +32,7 @@ _supported_os Linux
>  _require_test
>  _require_scratch_nocheck
>  _require_log_writes
> +_require_dm_target thin-pool
>
>  rm -f $seqres.full
>
> @@ -42,13 +45,12 @@ check_files()
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
> @@ -56,8 +58,16 @@ SANITY_DIR=$TEST_DIR/fsxtests
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
> @@ -88,14 +98,13 @@ _log_writes_mark last
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
> @@ -103,14 +112,13 @@ done
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
>  done
> -_scratch_unmount
> -_check_scratch_fs
> +_dmthin_check_fs
>
>  echo "Silence is golden"
>  status=0
> --
> 2.25.4
>
