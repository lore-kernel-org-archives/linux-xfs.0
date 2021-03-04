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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2137C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 15:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6436164F31
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 15:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhCDPnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 10:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbhCDPmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 10:42:52 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F9BC061574;
        Thu,  4 Mar 2021 07:42:12 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id u12so7285330pjr.2;
        Thu, 04 Mar 2021 07:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=zDCl84l1pfbprhQJcxHixGTzYfgX44z2Ktu4yCwQGS8=;
        b=Z9KfIXxx9FdBcZJvFyWbWphWgfIW8bhe+VE1IuAdMc5n7+GM3+xa4dLH9HmIfKSlLf
         e4hnuAE65ad0Z2sgGKVlT1spne7ltS+O3WXwPDugF6lvGkjj95W3cBhuA/keKezzYXok
         MsMmafu1S3NFZXCTfsUd1GUzY+3P2RZE+XShslp91mdriJPjiIKVTulFYwP1zoLa/uox
         UWtFbZDkS1SbTMAFAHpvhLtkHOTBtWkoiRNrf2AdmsdDCQVzHceMjZKrBT6xUhrZYbvD
         M8j0gY5qO2fy4j3F6CftuO2HfDeaZ1vV3Vn+5V7ehX6INXRz5PwpoPHZ+FkXP4RtxVXv
         ZcXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=zDCl84l1pfbprhQJcxHixGTzYfgX44z2Ktu4yCwQGS8=;
        b=q/6wqmJRJAEIHO8kplfoQe3RRUCwMPxOGY06tBknxWUONQd+tgLS411nqDOMmjtGTM
         uO3yDbCcNgyMZcqXrmY2MnnpxZqNonzZ2KBn3hVsyirqELp9BKFekoKudj5r7X/Qh9Uu
         EQ6zIQquT48JCCpPg6oL6rdqgJKBYdo6mqhl6Ul2QwGGTDSaaaDD90fMHIVnb0DEaEpx
         CisuwtMU1Aqj615slkuO2FPHdVMuHIyth2ZxdXHZpdS5zb3LzeS8thtYw8LGEhmkrt9G
         UR4UjWBs9ec71On4XQo1m3kVcsOtBxA3hab2LNZTn+sGsA2MHxIbPWY+DfWT0fwVUKco
         m1TA==
X-Gm-Message-State: AOAM530XdVG9KDzhgXME1q9lHg5NP9qHDShTZt4RZ/E/xNB0ucAWHCEI
        ERi0rK0aQY28B7hWDNnlmV6MAdqyicQ=
X-Google-Smtp-Source: ABdhPJz3qhDiFgJ8G2upwyQD1sOH+VNPKNYbMbmKHZXWtD3JWTq2pglz5RsT1z1Vb41tb3WuvNf+Wg==
X-Received: by 2002:a17:90b:b0d:: with SMTP id bf13mr5144045pjb.7.1614872532068;
        Thu, 04 Mar 2021 07:42:12 -0800 (PST)
Received: from garuda ([122.179.119.194])
        by smtp.gmail.com with ESMTPSA id ml17sm12409249pjb.45.2021.03.04.07.42.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Mar 2021 07:42:11 -0800 (PST)
References: <161472735404.3478298.8179031068431918520.stgit@magnolia> <161472736521.3478298.1405183245326186350.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/4] xfs/271: fix test failure on non-reflink filesystems
In-reply-to: <161472736521.3478298.1405183245326186350.stgit@magnolia>
Date:   Thu, 04 Mar 2021 21:12:08 +0530
Message-ID: <87mtvjorhr.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Mar 2021 at 04:52, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> This test creates an empty filesystem with rmap btrees enabled, and then
> checks that GETFSMAP corresponds (roughly) with what we expect mkfs to
> have written to the filesystem.
>
> Unfortunately, the test's calculation for the number of "per-AG
> metadata" extents is not quite correct.  For a filesystem with a
> refcount btree, the rmapbt and agfl blocks will be reported separately,
> but for non-reflink filesystems, GETFSMAP merges the records.
>
> Since this test counts the number of records, fix the calculation.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>


> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/271 |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
>
> diff --git a/tests/xfs/271 b/tests/xfs/271
> index 48a3eb8f..35c23b84 100755
> --- a/tests/xfs/271
> +++ b/tests/xfs/271
> @@ -38,6 +38,16 @@ _scratch_mount
>  
>  agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
>  
> +# mkfs lays out btree root blocks in the order bnobt, cntbt, inobt, finobt,
> +# rmapbt, refcountbt, and then allocates AGFL blocks.  Since GETFSMAP has the
> +# same owner (per-AG metadata) for rmap btree blocks and blocks on the AGFL and
> +# the reverse mapping index merges records, the number of per-AG extents
> +# reported will vary depending on whether the refcount btree is enabled.
> +$XFS_INFO_PROG $SCRATCH_MNT | grep -q reflink=1
> +has_reflink=$(( 1 - $? ))
> +perag_metadata_exts=2
> +test $has_reflink -gt 0 && perag_metadata_exts=$((perag_metadata_exts + 1))
> +
>  echo "Get fsmap" | tee -a $seqres.full
>  $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT > $TEST_DIR/fsmap
>  cat $TEST_DIR/fsmap >> $seqres.full
> @@ -48,7 +58,7 @@ _within_tolerance "AG header count" $(wc -l < $TEST_DIR/testout) $agcount 0 -v
>  
>  echo "Check freesp/rmap btrees" | tee -a $seqres.full
>  grep 'per-AG metadata[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
> -_within_tolerance "freesp extent count" $(wc -l < $TEST_DIR/testout) $((agcount * 3)) 0 999999 -v
> +_within_tolerance "freesp extent count" $(wc -l < $TEST_DIR/testout) $((agcount * perag_metadata_exts)) 0 999999 -v
>  
>  echo "Check inode btrees" | tee -a $seqres.full
>  grep 'inode btree[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout


-- 
chandan
