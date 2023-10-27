Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB196C25B6E
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Oct 2023 12:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345802AbjJ0MKd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 08:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345761AbjJ0MKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 08:10:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D2B192
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 05:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698408581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PIsSQcxBWH4imPJLQcWr1rbAXRjTfWDiFKroo0jDRbo=;
        b=FDRcxUE0hDZde4Zmk9z8IycXU9ltIM8okwtees8Du2P8c5hI5mVWzsDgi/tL5O2iZx9OTB
        xZRWUW9+2UfEUGXlOFuctaGR+HEqPT5PNOnfpbJHpPYqMompE6mh0fwUTxC3N/zQki4Wrf
        q8uIZEDnK4tgjUwNvlHXHnGMpvwER8o=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-ZVFPtJqfOXqsY0IaIz_E1w-1; Fri, 27 Oct 2023 08:09:39 -0400
X-MC-Unique: ZVFPtJqfOXqsY0IaIz_E1w-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1cc274dbbc6so3046105ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 05:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698408578; x=1699013378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PIsSQcxBWH4imPJLQcWr1rbAXRjTfWDiFKroo0jDRbo=;
        b=J9oLvpJgDlKV0fw/k1IQhQ6aZVdrEEGMQkSD7tXb6Q2mPoNbc4p/7wXGK7mS33FfLH
         uHBySdpRKHQMXZvHf/9hontXS19Nyq+1XohySGOZZDXMUqS976QbDeOBkKprbBy7UNze
         GBpJexbx2Pmt5tdeOP88vVS2cQNiuRnaLzpffVHow6jYyoRAMk19k92QTNAc9LIx+GBi
         ppoPT0vn9tQI1ZyWLiZWhTT1oOX7TP3CVkvwPGyaSTzwDLawIQfwpw3WPz+9qsqaNadX
         /nOiBknZ2fn7Ly935Ktn7h3xcHvpx6+hP+OcKjKKnV0nqofhWBL16+q8/hM1qU6gH7GE
         R3gA==
X-Gm-Message-State: AOJu0Yw/e/UhpYgzYrzWeMjsH8fbJJKwiWTbH9gM3+VUYTslu6ueRqu5
        QIYOdZU2H9+lzJyvny7UXQKZ+fyLl43qK6MJ2xmAD/vFFdKF22yBkJSlpMJ55Zpig87O17wdhwy
        4RyETwyHNSutkA8IUSLmT
X-Received: by 2002:a17:902:da83:b0:1c9:cf1e:f907 with SMTP id j3-20020a170902da8300b001c9cf1ef907mr2917006plx.57.1698408578431;
        Fri, 27 Oct 2023 05:09:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJvG3G40HrjsdZ6GuUlPRLgU+AOYMIoAwBUNsoWNOlJ/JAYX/j/7zcy8egLqN+1tDZBwW9LA==
X-Received: by 2002:a17:902:da83:b0:1c9:cf1e:f907 with SMTP id j3-20020a170902da8300b001c9cf1ef907mr2916989plx.57.1698408578090;
        Fri, 27 Oct 2023 05:09:38 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jw4-20020a170903278400b001c61e628e9dsm1413114plb.77.2023.10.27.05.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 05:09:37 -0700 (PDT)
Date:   Fri, 27 Oct 2023 20:09:34 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/251: don't snapshot $here during a test
Message-ID: <20231027120934.hs2d7d265rv3l5i4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231026031202.GM11391@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026031202.GM11391@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2023 at 08:12:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Zorro complained that the next patch caused him a regression:
> 
> generic/251 249s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/251.out.bad)
>     --- tests/generic/251.out   2022-04-29 23:07:23.263498297 +0800
>     +++ /root/git/xfstests/results//generic/251.out.bad 2023-10-22 14:17:07.248059405 +0800
>     @@ -1,2 +1,5 @@
>      QA output created by 251
>      Running the test: done.
>     +5838a5839
>     +> aa60581221897d3d7dd60458e1cca2fa  ./results/generic/251.full
>     +!!!Checksums has changed - Filesystem possibly corrupted!!!\n
>     ...
>     (Run 'diff -u /root/git/xfstests/tests/generic/251.out /root/git/xfstests/results//generic/251.out.bad'  to see the entire diff)
> Ran: generic/251
> Failures: generic/251
> Failed 1 of 1 tests
> 
> The next patch writes some debugging information into $seqres.full,
> which is a file underneat $RESULT_BASE.  If the test operator does not
> set RESULT_BASE, it will be set to a subdir of $here by default.  Since
> this test also snapshots the contents of $here before starting its loop,
> any logging to $seqres.full on such a system will cause the post-copy
> checksum to fail due to a mismatch.
> 
> Fix all this by copying $here to $SCRATCH_DEV and checksumming the copy
> before the FITRIM stress test begins to avoid problems with $seqres.full.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Thanks, it works for me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/251 |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/251 b/tests/generic/251
> index 8ee74980cc..3b807df5fa 100755
> --- a/tests/generic/251
> +++ b/tests/generic/251
> @@ -130,7 +130,13 @@ function run_process() {
>  }
>  
>  nproc=20
> -content=$here
> +
> +# Copy $here to the scratch fs and make coipes of the replica.  The fstests
> +# output (and hence $seqres.full) could be in $here, so we need to snapshot
> +# $here before computing file checksums.
> +content=$SCRATCH_MNT/orig
> +mkdir -p $content
> +cp -axT $here/ $content/
>  
>  mkdir -p $tmp
>  
> 

