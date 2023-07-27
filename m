Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C84C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 13:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbjG0N6h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 09:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjG0N6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 09:58:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D7730C0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 06:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690466271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5nEvv7chgyvMCWh3hGhvwnuUtz0kp+RYlbx94w8oY90=;
        b=PK24vUw8qm+Xgn2FmhYKvKsfnpo+Kk10Vi60DiZY9nEl4WxQefz7AXR/YA1VndkU0OOIWT
        IxSLaxNG2qTY3C0NtyttQEI76x/bDwukLMSPVPF5Uvpa2KgD0INAkN9sr/JsZUNeCrMHG5
        AUXl3Tby/ffQDqZkyJCjeWyA+/iyMBs=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-agpiptQ2MCqm8N_79iay0A-1; Thu, 27 Jul 2023 09:57:50 -0400
X-MC-Unique: agpiptQ2MCqm8N_79iay0A-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1bb893e61d5so6074735ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 06:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690466269; x=1691071069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nEvv7chgyvMCWh3hGhvwnuUtz0kp+RYlbx94w8oY90=;
        b=demwKeXirDKLUXa8NPVUr098NGcqODMyVQaF3QLAYXUDgjSvsXmD4AXc2IB79ghfBD
         q093F+APTkXZFALd/E4loUbUDn5ZpBRGyFlDHIbYpByuv3B1hd1FvWE5LEzKeHY18461
         +XpYkjXVNLr+3aoCmB86eBfiw8JrxIqDucneC73+lhoDjB904qFakGgxjFSqVqBWP+nz
         ltDF3g/N8O9ZYeSSiJbAJtnqxrNQbX6oN+bFyNSnJO/o9tdcmi5JOFc2vpEUJU0PqZSj
         9ToOj9h3wS5pREV+HtGBsqqlGEmxTcwRSquGq/QgaypOSXaCa36KK2Cstnbe+f8w8kG2
         oJYg==
X-Gm-Message-State: ABy/qLZ2yFc8aRFYbecfSjON/34SbWKD8HPHRsZM3/x08LyiaK69x3Jh
        y8Tb+BvNQXZA8KhwIZLni+hpV6ltXXv2YFF+yiwNhjA/VytdJK0aC18bvkzRw8AXMHuKHZMEawb
        fclIumMl/4RduQvArDCwl
X-Received: by 2002:a17:902:e80f:b0:1b8:9ecd:8b86 with SMTP id u15-20020a170902e80f00b001b89ecd8b86mr4848719plg.5.1690466269059;
        Thu, 27 Jul 2023 06:57:49 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHqb3NPuiFjRG7z/G61xsVJ9OWrjesEHJh81WnYqkQ4ayhfGV3wUAd5/pw9boa1gjwKmGJR9Q==
X-Received: by 2002:a17:902:e80f:b0:1b8:9ecd:8b86 with SMTP id u15-20020a170902e80f00b001b89ecd8b86mr4848702plg.5.1690466268741;
        Thu, 27 Jul 2023 06:57:48 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902ee8900b001bbd8cf6b57sm1658993pld.230.2023.07.27.06.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 06:57:48 -0700 (PDT)
Date:   Thu, 27 Jul 2023 21:57:44 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: adjust test for flexarray conversions in 6.5
Message-ID: <20230727135744.nhmwpv7dxt5nvshd@zlang-mailbox>
References: <169033661482.3222297.18190312289773544342.stgit@frogsfrogsfrogs>
 <169033662042.3222297.14047592154027443561.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169033662042.3222297.14047592154027443561.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 25, 2023 at 06:57:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Adjust the output of this test to handle the conversion of flexarray
> declaration conversions in 6.5.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks like it's about a49bbce58ea9 ("xfs: convert flex-array declarations
in xfs attr leaf blocks"). If you don't mind, I'd like to mention it in commit
log when I merge it :) This patch looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

>  tests/xfs/122 |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index e616f1987d..ba927c77c4 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -26,13 +26,21 @@ _wants_kernel_commit 03a7485cd701 \
>  _type_size_filter()
>  {
>  	# lazy SB adds __be32 agf_btreeblks - pv960372
> +	# flexarray conversion of the attr structures in Linux 6.5 changed
> +	# the sizeof output
>  	if [ "$($MKFS_XFS_PROG 2>&1 | grep -c lazy-count )" == "0" ]; then
>  		perl -ne '
>  s/sizeof\( xfs_agf_t \) = 60/sizeof( xfs_agf_t ) = <SIZE>/;
> +s/sizeof\(struct xfs_attr3_leafblock\) = 80/sizeof(struct xfs_attr3_leafblock) = 88/;
> +s/sizeof\(struct xfs_attr_shortform\) = 4/sizeof(struct xfs_attr_shortform) = 8/;
> +s/sizeof\(xfs_attr_leafblock_t\) = 32/sizeof(xfs_attr_leafblock_t) = 40/;
>  		print;'
>  	else
>  		perl -ne '
>  s/sizeof\( xfs_agf_t \) = 64/sizeof( xfs_agf_t ) = <SIZE>/;
> +s/sizeof\(struct xfs_attr3_leafblock\) = 80/sizeof(struct xfs_attr3_leafblock) = 88/;
> +s/sizeof\(struct xfs_attr_shortform\) = 4/sizeof(struct xfs_attr_shortform) = 8/;
> +s/sizeof\(xfs_attr_leafblock_t\) = 32/sizeof(xfs_attr_leafblock_t) = 40/;
>  		print;'
>  	fi
>  }
> 

