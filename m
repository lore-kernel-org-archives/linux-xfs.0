Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8364EC00140
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Aug 2022 09:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiHOJSg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Aug 2022 05:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbiHOJS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Aug 2022 05:18:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6DFE222B1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 02:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660555104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YzEAatXqK5JK8Pdw/RfxQTXvV1F1gOUlndcdx4iLrdU=;
        b=YfJvHNPx4HjZ/23YrAVz+Za7sqiQPKG9qw98hvTFBPmOHMuF37WmjUGojPay/lAqdlSMEQ
        cQQ4n/nb5ahEPpjoGzxsKnvFf3O6xZ/hFcLLqxSyjscK9ZR/QvyynLbMlhq+HoelMAzkNP
        b10mEmB4qPeRix+XUK7XjeN14rCAoPA=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-446-4s5j3hCVPDimMZSLQoWatg-1; Mon, 15 Aug 2022 05:18:21 -0400
X-MC-Unique: 4s5j3hCVPDimMZSLQoWatg-1
Received: by mail-pg1-f200.google.com with SMTP id z18-20020a63d012000000b0041b3478e9a9so2446738pgf.17
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 02:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=YzEAatXqK5JK8Pdw/RfxQTXvV1F1gOUlndcdx4iLrdU=;
        b=Wk7u05ymSNRmbzt7FRV/47qkLif6lXIsOq0QHZVHbctJASCVO0bOb6ZfehZIKt/DvN
         INQiO27w3WAMfIEaZJIx8OlqJ2ZzBjLD3KsI1R3MjHE1bY6v3x12Xxa71qgb5dS0c/4E
         qyQ9nSBCPs+WDCMsfH17ZqYjvWDek3FRsW1gd1BSlXMQbQjrlpnbFEAlsO2yuoSgectN
         D2MakzhKkbnx3KRWc3PpZ6WH0nugF+zBD6N6VgTHwkdb594BPXWDw3G/9cu0GFwVxT+w
         cxvrvH0Dn8SdIWIgIK0zlqhFWA1Cr7DCeRVFQBN2ECvNKGx7PY89soRNw/1yVks4sfVM
         J7xA==
X-Gm-Message-State: ACgBeo2zA3eMCMY+daJo6xz5YmXnKoxGXWZYzXGYVGWCa+e5GSZ001r3
        kPnJVpkvP330Zq/g2IQTq3GCvNbHZZ3BDyH9xJoCd7hTf1Cqb/sq20MKW6VybVErwV4biUHrBn/
        BUOkxw2nsiYi6AVayh/39
X-Received: by 2002:a63:5f86:0:b0:41c:f1:f494 with SMTP id t128-20020a635f86000000b0041c00f1f494mr13512006pgb.51.1660555100406;
        Mon, 15 Aug 2022 02:18:20 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4YDWquTXSOMm1jdVzubIv7EShj6C0xfymKBr/e9wAjBfj/MNhGAfZ1BvMKB3jFHoKLk6gs+w==
X-Received: by 2002:a63:5f86:0:b0:41c:f1:f494 with SMTP id t128-20020a635f86000000b0041c00f1f494mr13511990pgb.51.1660555100054;
        Mon, 15 Aug 2022 02:18:20 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d2-20020a631d02000000b0041b823d4179sm5478507pgd.22.2022.08.15.02.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 02:18:19 -0700 (PDT)
Date:   Mon, 15 Aug 2022 17:18:14 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCHSET v2 0/3] fstests: refactor ext4-specific code
Message-ID: <20220815091814.eybgwyf4bjg6m4dx@zlang-mailbox>
References: <166007884125.3276300.15348421560641051945.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166007884125.3276300.15348421560641051945.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 09, 2022 at 02:00:41PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series aims to make it so that fstests can install device mapper
> filters for external log devices.  Before we can do that, however, we
> need to change fstests to pass the device path of the jbd2 device to
> mount and mkfs.  Before we can do /that/, refactor all the ext4-specific
> code out of common/rc into a separate common/ext4 file.
> 
> v2: fix _scratch_mkfs_sized for ext4, don't clutter up the outputs
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

Two weeks passed, this patchset is good to me, I'd like to merge this patchset
with "[PATCH 1/1] dmerror: support external log and realtime devices" together
this week.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> --D
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=refactor-ext4-helpers
> ---
>  common/config |    4 +
>  common/ext4   |  193 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc     |  186 ++++---------------------------------------------------
>  common/xfs    |   23 +++++++
>  4 files changed, 233 insertions(+), 173 deletions(-)
>  create mode 100644 common/ext4
> 

