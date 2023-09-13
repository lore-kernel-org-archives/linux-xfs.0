Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41849EE01E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Sep 2023 16:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjIMQzM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 12:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjIMQzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2023 12:55:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69C8B1BD0
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 09:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694624069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8t37UtnRiozHhv5O+2zJx94SEMSuB1VWgYlIyW6lYPw=;
        b=Q/5VoujzfsNASX11b0ci5eeeufpg7DTNH4/kkqjsTOZJ9B1QSos7Y2k2/JeVg0jinMiq81
        L9t4SApEL2fRHPsC/Y+BXZVSML7eNv89XPlosl8mnoNvlFC4ePCxQsCnqUDNucqKGTa49S
        3QcggnOsoRgxmL8vqOJTC4y/ZKLE698=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-IZsEr3acM3qM7ylH6hjPIw-1; Wed, 13 Sep 2023 12:54:28 -0400
X-MC-Unique: IZsEr3acM3qM7ylH6hjPIw-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-68fbbe8a6d3so1008735b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 09:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694624067; x=1695228867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8t37UtnRiozHhv5O+2zJx94SEMSuB1VWgYlIyW6lYPw=;
        b=P6poMcLjmy3ebaWXSghr4ad6AeVUGHZkFTQkgHZyDDX+3DUwNYwwkWoC+7V8Hiijy1
         vANqWKFwpCCo3QgT3XlhH5UAp4oyhfknPi0mWbxOy5+iCGlE978cIt2TbD/tx5oP8uHK
         1ilEsxB2qOupuX35ljIc4cy0aG4eORqkaZuT4fENjxwzwMABrD0AjhRhtbaDAAh+prqN
         Ymv4VM6V/E95a4eJkVH6n/+Z0UQLhl8fLcgujLxuCNwiPnSAWEQBlwru4utSk2XQgKNm
         7+P7km9uBrQy5da1PABk68gF+9iL0pgPrqWf0JXKJDOaelUC3B4d6Yjpre9pTgRiHeHS
         jamg==
X-Gm-Message-State: AOJu0YyWpBBGSsmDHqtu+mmWqAXWHAflNGbbRkWC5Z6ivT/MDDVRIcr9
        fSURD/PEmDlpWOGvWg8ri1r3wzbKURJlQ7DQYe+Yo5a5JXqKgKeeeK4Gj8h9yk1KyzH3yZSTpYr
        rEY/ezex4zYBWKL/Pj4sZ
X-Received: by 2002:a05:6a00:178d:b0:68a:6d34:474b with SMTP id s13-20020a056a00178d00b0068a6d34474bmr10230802pfg.15.1694624067071;
        Wed, 13 Sep 2023 09:54:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcqtfSMXXFqB81E2xM71nxRMnTd6xi5FKly1lKu16+hofSFfsUbFSgs6YMeldIiE9GwS8utg==
X-Received: by 2002:a05:6a00:178d:b0:68a:6d34:474b with SMTP id s13-20020a056a00178d00b0068a6d34474bmr10230783pfg.15.1694624066796;
        Wed, 13 Sep 2023 09:54:26 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id fe10-20020a056a002f0a00b0064fde7ae1ffsm5532657pfb.38.2023.09.13.09.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 09:54:26 -0700 (PDT)
Date:   Thu, 14 Sep 2023 00:54:23 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/270: actually test file readability
Message-ID: <20230913165423.msata7yyzxoe66o7@zlang-mailbox>
References: <169335058807.3526409.15604604578540143202.stgit@frogsfrogsfrogs>
 <169335059383.3526409.15894917295629170268.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335059383.3526409.15894917295629170268.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:09:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we can actually read files off the ro mounted filesystem that
> has an unknown rocompat feature set.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/270 |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/tests/xfs/270 b/tests/xfs/270
> index 7447ce87be..511dfe9fcd 100755
> --- a/tests/xfs/270
> +++ b/tests/xfs/270
> @@ -23,6 +23,9 @@ _require_scratch_nocheck
>  _require_scratch_xfs_crc
>  
>  _scratch_mkfs_xfs >>$seqres.full 2>&1
> +_scratch_mount
> +echo moo > $SCRATCH_MNT/testfile
> +_scratch_unmount
>  
>  # set the highest bit of features_ro_compat, use it as an unknown
>  # feature bit. If one day this bit become known feature, please
> @@ -68,6 +71,7 @@ if [ $? -ne 0 ]; then
>  	_fail "ro mount test failed"
>  else
>  	# no hang/panic is fine
> +	cat $SCRATCH_MNT/testfile > /dev/null
>  	$FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 400 >>$seqres.full 2>&1
>  fi
>  
> 

