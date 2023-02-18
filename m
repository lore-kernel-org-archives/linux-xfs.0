Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94289C636D7
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Feb 2023 06:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBRGQD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Feb 2023 01:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjBRGQC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Feb 2023 01:16:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871815828A
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676700913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tePxwdFb6rGy3Ct93LDisEzdkAz3oaeC2ahrzIHbkCg=;
        b=NOISZLkU7f0b7V3T4KLPngommWaZi+u9CZ8bif4FD+zKCoEg98aP1FApkXqGRG8CrN1+Mh
        aGR/D/dPp7zvTdRxO4ZSWyPo8tMAFy5G6bJB5K4+lxCzLw/ZhgovEL5HM5EMHL2mTzh6RQ
        1ythZltTfzFao7cBqGclMuLigc1YccM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-180-4DS1WUCmPb2UZ4RPVrjwzQ-1; Sat, 18 Feb 2023 01:15:12 -0500
X-MC-Unique: 4DS1WUCmPb2UZ4RPVrjwzQ-1
Received: by mail-pj1-f71.google.com with SMTP id p21-20020a17090a429500b002366abc850aso178811pjg.1
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tePxwdFb6rGy3Ct93LDisEzdkAz3oaeC2ahrzIHbkCg=;
        b=Wdkd9lvJBUxDaEBliWiyUdRa3euVjNBw1uxZvTzJKem1M6Z/SEkjFgAkbQ9Y3nU1ox
         ZhQ8VT1V0pMT3T1PFYNF3H9QKhkgSj9TY4WnPP82Z+HnzL5l+pkgMv7qj24R/F4ctRkj
         cXqk0/nQmmeQyMkO9jxkHgVJrUfGHy9rxoSPjNjsDnObK2vdSCEfeZcfQBbZn9XyO8ee
         pXWycbo0ctsqPENkBnX/+qgSBbiTifuvjF0idDsX2z9cT1b8K+fAFw61S+w9q3P6m+CY
         UvuHS+gbj7+oqME+E/35QxyGouMAVMeD393whQ/+pix5ZRWg0bdsA2T7Q3to/M9nT4ms
         YEiA==
X-Gm-Message-State: AO0yUKWmQd82/0P9hcSI3QE7wDgmWGw+YKNp69aNNCEnJvLBhzdTrgs1
        9maBpuSj8U0WeW02Z5Hr6jjY+0erltybqt10pdV467s1c00NhEizLeImPU7kA5jn5ClenkuuQv1
        xhoaGbAdqmFqXWGD6Mbe2
X-Received: by 2002:a17:903:11cd:b0:19a:aa0e:2d67 with SMTP id q13-20020a17090311cd00b0019aaa0e2d67mr412337plh.32.1676700911080;
        Fri, 17 Feb 2023 22:15:11 -0800 (PST)
X-Google-Smtp-Source: AK7set/cYqXqbA6s2hCtRubyEprrSlih1qaWXlIC7HD66XOXoaJjJyzfV5wIY4vWobj1DI8cWZO15Q==
X-Received: by 2002:a17:903:11cd:b0:19a:aa0e:2d67 with SMTP id q13-20020a17090311cd00b0019aaa0e2d67mr412322plh.32.1676700910681;
        Fri, 17 Feb 2023 22:15:10 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ju19-20020a170903429300b00198e7d97171sm540599plb.128.2023.02.17.22.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 22:15:10 -0800 (PST)
Date:   Sat, 18 Feb 2023 14:15:06 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] xfs/422: don't freeze while racing rmap repair and
 fsstress
Message-ID: <20230218061506.5dzeaigolrpsu57g@zlang-mailbox>
References: <167243877345.728215.12907289289488316002.stgit@magnolia>
 <167243877357.728215.3478300804915017773.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243877357.728215.3478300804915017773.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since we're moving away from freezing the filesystem for rmap repair,
> remove the freeze/thaw race from this test to make it more interesting.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/422 |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> 
> diff --git a/tests/xfs/422 b/tests/xfs/422
> index 995f612166..339f12976a 100755
> --- a/tests/xfs/422
> +++ b/tests/xfs/422
> @@ -5,8 +5,6 @@
>  # FS QA Test No. 422
>  #
>  # Race fsstress and rmapbt repair for a while to see if we crash or livelock.
> -# rmapbt repair requires us to freeze the filesystem to stop all filesystem
> -# activity, so we can't have userspace wandering in and thawing it.
>  #
>  . ./common/preamble
>  _begin_fstest online_repair dangerous_fsstress_repair freeze
> @@ -31,7 +29,7 @@ _require_xfs_stress_online_repair
>  _scratch_mkfs > "$seqres.full" 2>&1
>  _scratch_mount
>  _require_xfs_has_feature "$SCRATCH_MNT" rmapbt
> -_scratch_xfs_stress_online_repair -f -s "repair rmapbt %agno%"
> +_scratch_xfs_stress_online_repair -s "repair rmapbt %agno%"
>  
>  # success, all done
>  echo Silence is golden
> 

