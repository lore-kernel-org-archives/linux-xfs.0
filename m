Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8483AC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Feb 2023 09:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjBBJy7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Feb 2023 04:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjBBJyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2023 04:54:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB98233D8
        for <linux-xfs@vger.kernel.org>; Thu,  2 Feb 2023 01:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675331603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/SByMCCSE7iGESK0C8jKYeU/Oz8Yx7hQvlLV9Zjs75M=;
        b=cJWh4XXH9T//iWrjecbca8h40KnRdiCBd1uHKnD2bxI3XwXsDS0IoShwDlnVJabrgH/mmr
        9g9efj4v/pZCzBDqjQf59gSPM19MtSq0n4sRQ/wgwQykc6MWg7V54t03O8M+CNDPNwfxtC
        Y2w3cviEaOiLyqq7dliR7Elg1i0vVtc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-86-yMdxTKXpOCWe-ODZcHHlsw-1; Thu, 02 Feb 2023 04:53:22 -0500
X-MC-Unique: yMdxTKXpOCWe-ODZcHHlsw-1
Received: by mail-pl1-f200.google.com with SMTP id ij3-20020a170902ab4300b001968158fa80so723242plb.2
        for <linux-xfs@vger.kernel.org>; Thu, 02 Feb 2023 01:53:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/SByMCCSE7iGESK0C8jKYeU/Oz8Yx7hQvlLV9Zjs75M=;
        b=1WOfysDf6Tm5ZTGR9jHihVLb1okQtZ0gIrq1vfAfSHkL2seLtR2gl4+Z96kXibF6qh
         XtWtYcguuW5tDcO6Yy+Dk4LxTxNBoRapB1CdHYpOjROuVphBBCs8ohJ9wZxPf0ONsvUB
         RTDsRSGuxESz+WFOEwj2UmvlD2WwlEyEIbivusS5CuD9Vh6uTd2UtcXw4SrpPVVTd8Lc
         q5vNnuxhym5Lnt1ybm4r/RsJa4rBgzxqTuURIhX13jP31OI5wnssPDUcKRYzdgBO7hPW
         l72JCi7kef30yOAm6s0ED10YwUQJiJmXHwdbS53XIZe7sYr/yRK6Dr6JQs0knfsilS4S
         /BCA==
X-Gm-Message-State: AO0yUKUDMh3nUbTC7Tu1o7G7k/QYXFFCfEqzEeF+Rejwrow+mGNLXS1d
        VmnvzDJyO0MtRBPaFYEiK/ALnNPBT3vJN1rIWSIBJyUtwjjfQeYX5lA8rjLjHeTQ8PeFynFT+j7
        cktCO/2Tu241ROFOH3zVI
X-Received: by 2002:a17:903:24c:b0:196:1678:3060 with SMTP id j12-20020a170903024c00b0019616783060mr1541828plh.0.1675331601048;
        Thu, 02 Feb 2023 01:53:21 -0800 (PST)
X-Google-Smtp-Source: AK7set8VH4oa3o+3DtXDJ8OeYIfGoSRKj1sBNnXS3pSnPtY6e8D3wlotGt6UjuIwNZkspQF6lerkhg==
X-Received: by 2002:a17:903:24c:b0:196:1678:3060 with SMTP id j12-20020a170903024c00b0019616783060mr1541818plh.0.1675331600719;
        Thu, 02 Feb 2023 01:53:20 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ab8100b00196629652efsm10158727plr.286.2023.02.02.01.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 01:53:20 -0800 (PST)
Date:   Thu, 2 Feb 2023 17:53:15 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/038: set a maximum runtime on this test
Message-ID: <20230202095315.l7f3vjv2hrcr3uou@zlang-mailbox>
References: <167521268927.2382722.13701066927653225895.stgit@magnolia>
 <167521269515.2382722.13790661033478617605.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167521269515.2382722.13790661033478617605.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 31, 2023 at 04:51:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test races multiple FITRIM calls against multiple programs creating
> 200k small files to ensure that there are no concurrency problems with
> the allocator and the FITRIM code.  This is not necessarily quick, and
> the test itself does not contain any upper bound on the runtime.  On my
> system that simulates storage with DRAM this takes ~5 minutes to run; on
> my cloud system with newly provided discard support, I killed the test
> after 27 hours.
> 
> Constrain the runtime to about the customary 30s * TIME_FACTOR.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/038 |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/tests/generic/038 b/tests/generic/038
> index 5c014ae389..e1176292fb 100755
> --- a/tests/generic/038
> +++ b/tests/generic/038
> @@ -100,6 +100,8 @@ nr_files=$((50000 * LOAD_FACTOR))
>  create_files()
>  {
>  	local prefix=$1
> +	local now=$(date '+%s')
> +	local end_time=$(( now + (TIME_FACTOR * 30) ))
>  
>  	for ((n = 0; n < 4; n++)); do
>  		mkdir $SCRATCH_MNT/$n
> @@ -113,6 +115,10 @@ create_files()
>  				echo "Failed creating file $n/${prefix}_$i" >>$seqres.full
>  				break
>  			fi
> +			if [ "$(date '+%s')" -ge $end_time ]; then
> +				echo "runtime exceeded @ $i files" >> $seqres.full
> +				break
> +			fi
>  		done
>  		) &
>  		create_pids[$n]=$!
> 

