Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD49C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 17:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiGMREh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 13:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGMREg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 13:04:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD67F12AFD
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657731874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CCci69TtY53EFmxT7HIOfZ7UTC+DxKU2a7B4N1++xlg=;
        b=SsSKzg2pe2vcM3cFcV156Az+r5yMsVF66cGt7Tjwveh31x+RjHF1ZVOOXmWxuyhhqpaU3D
        /LgQ9IgvAx8D5BYHpemjprVAZzsEOhGkjW1/rLSHHSX2+b/8GMFKqDIrYEof8xecGsa+xx
        K/SjTPiyNJ2ebf4uKX8n9zx4gkqpYLo=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-1yfpb4cWNo-UXbgeXQ8sag-1; Wed, 13 Jul 2022 13:04:33 -0400
X-MC-Unique: 1yfpb4cWNo-UXbgeXQ8sag-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-fdc4b531bfso6155922fac.13
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CCci69TtY53EFmxT7HIOfZ7UTC+DxKU2a7B4N1++xlg=;
        b=ttCyOIJxJeb4c95krouVRZjPIoQa2nkrxIJtjVElFx1XD5qxpxziyZC1RkndAU5OT5
         v5XcaaxDIQHxTYn0kFT16uamyfjPDXLznMGlYPY1mKg2KLb47nUhVOGpg8KH5LWdCRGY
         shHiBX0vgG4bj+MlFZDgIzCeTadV3ZG9DVWOs/6DEfwBHd2Y1JuuzmxV9mrekebj0Pha
         k65/1HJh61zOPrEqm1Q6pINtmpm7S2o0v+APmYAAQfc9I1o+nGh9RXgQM3nKpPhy4PBX
         AbJ38lVAplOa+YRqjC8vNpQn4hWc4KlIVqKBGUsexnMwoSe619G4fiZHmTe/2ExLeqR+
         mfUg==
X-Gm-Message-State: AJIora8AP8ksQEehrcQL54bNsWEK7FHPdlcWbhBWb76G4OiINuNEDlLS
        SgO/WIfxq3py6KxRhztpyO1Pq7YGvmyaOYjUUEd0F9c//kVHwOA9Eaidz1kwAqgrkLyDDxKpBDA
        I3XSscsR5nr9RLhqN51rf
X-Received: by 2002:a05:6808:1312:b0:337:ac7d:3a1b with SMTP id y18-20020a056808131200b00337ac7d3a1bmr5336538oiv.279.1657731872901;
        Wed, 13 Jul 2022 10:04:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tOln6FxCvKPxLYXRAspfKYOpYVDo00dahyJCbit6/f/7UEXDp3HV+MSPUM1oOmeKiENQpvXw==
X-Received: by 2002:a05:6808:1312:b0:337:ac7d:3a1b with SMTP id y18-20020a056808131200b00337ac7d3a1bmr5336518oiv.279.1657731872619;
        Wed, 13 Jul 2022 10:04:32 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s2-20020a4aa382000000b0042859bebfebsm3934661ool.45.2022.07.13.10.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 10:04:32 -0700 (PDT)
Date:   Thu, 14 Jul 2022 01:04:26 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 6/8] punch: skip fpunch tests when op length not
 congruent with file allocation unit
Message-ID: <20220713170426.n5kwuvplsdlabr5l@zlang-mailbox>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
 <165767382771.869123.12118961152998727124.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165767382771.869123.12118961152998727124.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 12, 2022 at 05:57:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Skip the generic fpunch tests on a file when the file's allocation unit
> size is not congruent with the proposed testing operations.
> 
> This can be the case when we're testing reflink and fallocate on the XFS
> realtime device.  For those configurations, the file allocation unit is
> a realtime extent, which can be any integer multiple of the block size.
> If the request length isn't an exact multiple of the allocation unit
> size, reflink and fallocate will fail due to alignment issues, so
> there's no point in running these tests.
> 
> Assuming this edgecase configuration of an edgecase feature is
> vanishingly rare, let's just _notrun the tests instead of rewriting a
> ton of tests to do their integrity checking by hand.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/punch |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/common/punch b/common/punch
> index 4d16b898..7560edf8 100644
> --- a/common/punch
> +++ b/common/punch
> @@ -250,6 +250,7 @@ _test_generic_punch()
>  	_8k="$((multiple * 8))k"
>  	_12k="$((multiple * 12))k"
>  	_20k="$((multiple * 20))k"
> +	_require_congruent_file_oplen $TEST_DIR $((multiple * 4096))

Should the $TEST_DIR be $testfile, or $(dirname $testfile) ?

>  
>  	# initial test state must be defined, otherwise the first test can fail
>  	# due ot stale file state left from previous tests.
> 

