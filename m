Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65625C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 04:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbiCVEwQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 00:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236498AbiCVEwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 00:52:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D295107098
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 21:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647924647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7GE5TTOJNSSl7mjMkfHrkTkFXYcSfvqrM2p+DPskOEI=;
        b=RbIMDv0oHj0vOqnxNWvNqHBOrNbYJun4rVpUQ/ylVU1SZAjaENfi0NQ5nxO38BDhkQgJN2
        D0z7EU0rOVHtHNgXXQoNOeJm5TEADuE0+0K5yno2otS1wXt/Q3LNlzT51vUWE+1QgLLQnj
        E1sDWyPfMQ8RyADt4a19RnIwPIBSXDg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-3X6hCQcgPtmG1Rn028kGeQ-1; Tue, 22 Mar 2022 00:50:45 -0400
X-MC-Unique: 3X6hCQcgPtmG1Rn028kGeQ-1
Received: by mail-wm1-f70.google.com with SMTP id r9-20020a1c4409000000b0038c15a1ed8cso504487wma.7
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 21:50:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=7GE5TTOJNSSl7mjMkfHrkTkFXYcSfvqrM2p+DPskOEI=;
        b=LzNSUOScBjcbd4H8wOwWSFL89hSIP2OqKb8mFsjW3cDn27pvjGOtHFK0/fOY+HGAfq
         NHOTNcCkWJiu7IOi/XmY5vHeCgQS9xIP90XcfcKZnIAbkrWMDcSPfzJlOlsCVJfLHt14
         EKNazgz6dl2t2jlMkDdK1XSa/iPVIt1OqFf1YGy8v3yDyksd8LB+5EbpQhSIHqs+8urb
         93MoeifyXwWujTLmjRCJA1akZ0nUN1e3FQo7XVQn2TuvTyAsSdSTjLprhUeSggN+43Kk
         1TLwiGbnykW3qFshev2gmjOJlQk/NodO9tKc0K202TuLS0az5Vw+5yaaHggIuv64YSqM
         yJVw==
X-Gm-Message-State: AOAM530pT8Qj5QNqUkEuikGAE/9jmJwAmHNovYOUaV8Uyp3Eom+EixGr
        irp+vaooxuAeJIdg/56gTJVsWEMhbcPh3lzX1AkOHBgpE6XhxFDEAU2nPONxY3X5barbXb4sdfs
        zriIf0q9351d7HKc8+pLP
X-Received: by 2002:a1c:2947:0:b0:38c:7910:d941 with SMTP id p68-20020a1c2947000000b0038c7910d941mr1951220wmp.41.1647924643996;
        Mon, 21 Mar 2022 21:50:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5YmJUtrnAmA75EeuNJ84bg6hSPz7qdgnaiDPypvbPDeyhikWgEASUfHt9DoUBncQRbN64jw==
X-Received: by 2002:a1c:2947:0:b0:38c:7910:d941 with SMTP id p68-20020a1c2947000000b0038c7910d941mr1951206wmp.41.1647924643783;
        Mon, 21 Mar 2022 21:50:43 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r65-20020a1c4444000000b0038c48dd23b9sm1678961wma.5.2022.03.21.21.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 21:50:43 -0700 (PDT)
Date:   Tue, 22 Mar 2022 12:50:38 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] generic/459: ensure that the lvm devices have been
 created
Message-ID: <20220322045038.3nj6bpx63lo4xz4i@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
 <164740140920.3371628.4554997239924071993.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164740140920.3371628.4554997239924071993.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 08:30:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Once in a /very/ long while this test fails because _mkfs_dev can't find
> the LVM thinp volume after it's been created.  Since the "solution" du
> jour seems to be to sprinkle udevadm settle calls everywhere, do that
> here in the hopes that will fix it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/459 |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/tests/generic/459 b/tests/generic/459
> index cda19e6e..57d58e55 100755
> --- a/tests/generic/459
> +++ b/tests/generic/459
> @@ -70,6 +70,7 @@ $LVM_PROG lvcreate  --virtualsize $virtsize \
>  		    -T $vgname/$poolname \
>  		    -n $lvname >>$seqres.full 2>&1
>  
> +$UDEV_SETTLE_PROG &>/dev/null
>  _mkfs_dev /dev/mapper/$vgname-$lvname >>$seqres.full 2>&1
>  
>  # Running the test over the original volume doesn't reproduce the problem
> 

