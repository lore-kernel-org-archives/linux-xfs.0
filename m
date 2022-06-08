Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36048C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 22:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiFHWYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 18:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiFHWYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 18:24:06 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E65024F15
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 15:24:06 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f9so8382825plg.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jun 2022 15:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ogntuR0OR9OK74KgQbp34dMbGjLbyjKe+6G9CzMZczw=;
        b=czC03vLkMVBQMgUyl5Isd2jGmRXjpCDkSk7IRhN1AxJq1MXgAAVMGVfu6pDg+eUXty
         QoY5yPwGE20cbSVRyShJe4Wfkk6EJD+2YBv5z3JVqlfGLT7JE/A1qA8RomV7132whL27
         Y4FJCBjSAzHHo4UaY4XtY4MKsEpF47UjizS1Ye93VFJoZjOafEXiZsjp4aHfusyyNx4Y
         ungUIgdGq4LDQD+GpewShM8svisq82rQElLsly1R2b7HzbLcapsZlRaVpuH/nBszwEEW
         pQmDkQzYNKNEdk76CeBdieM4V1TKlE+/hOpDFES7vJKdQKJ9HlV8TAv/CAIkvWj27Uq+
         aDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ogntuR0OR9OK74KgQbp34dMbGjLbyjKe+6G9CzMZczw=;
        b=4pDu9w1at7ws3OhzhyCCEq9Zmyj/cTFvXTDtoKvlliv5yeMY6qe4X5cbQdfOSXEG0f
         DaxY5Vgc1FgVS0OEBO6G9q0hIq+LEKFTZIUHtPKmKfdX8Yg90nCwAU1B+dsExi/RzIzH
         cyaYMUplnuCRX0VcKpY9EP9xo0t5QqzlkeLI+4CJ6XTmHaqEJ0+8bO1t4GNoQF6b7Yc9
         PmY0x5REYCUNiZsOiKRvkAKjmOAMZiWoq1TzrM2tijA13xGr7jq6Q+4K7vAh9cG9ktlb
         JuwcY9Zwh+KzsBYd4TMMe1vf9RrG4TRTxevOQTbhxiGnw7EN2gpbwNykDdn6+0HqfniV
         4A6w==
X-Gm-Message-State: AOAM533x5Q+4CkaAGqMSSLxc2HREgSoVcyKuBa6DDKnXmfldYeXGuFcN
        e0tMJuSF8y2Hms4kFwlEgw3wZuPVWETGXA==
X-Google-Smtp-Source: ABdhPJwuBxQiarBEcqhV1+Znh1K0R3K7WfOEy1pb7kOoVu0GlCdZKM5+oLQekR3lHDZNsKhHjmsNCQ==
X-Received: by 2002:a17:902:a502:b0:15e:c251:b769 with SMTP id s2-20020a170902a50200b0015ec251b769mr34903756plq.115.1654727045314;
        Wed, 08 Jun 2022 15:24:05 -0700 (PDT)
Received: from google.com ([2620:15c:2c1:200:7b7:e310:ec9d:18c6])
        by smtp.gmail.com with ESMTPSA id z20-20020a634c14000000b003fd8438db7bsm8401432pga.58.2022.06.08.15.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 15:24:04 -0700 (PDT)
Date:   Wed, 8 Jun 2022 15:24:02 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 5.15 00/15] xfs stable candidate patches for 5.15.y
Message-ID: <YqEhgoQg8c9ZHDMR@google.com>
References: <20220603184701.3117780-1-leah.rumancik@gmail.com>
 <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com>
 <Yp48nGoE0cbdbteU@google.com>
 <CAOQ4uxhJfcZQcy0xNBi2Fp7e+z4V9CAqEW26f8ZxctruN0tFFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhJfcZQcy0xNBi2Fp7e+z4V9CAqEW26f8ZxctruN0tFFQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 10:56:17AM +0300, Amir Goldstein wrote:
> On Mon, Jun 6, 2022 at 8:42 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> >
> > On Sat, Jun 04, 2022 at 11:38:35AM +0300, Amir Goldstein wrote:
> > > On Sat, Jun 4, 2022 at 6:53 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> > > >
> > > > From: Leah Rumancik <lrumancik@google.com>
> > > >
> 
> FWIW, the following subset of your 5.15 patches (or backported version thereof)
> have been sitting in my xfs-5.10.y-8 tag since Saturday and have been
> spinning in kdevops since (~20 auto runs) with no regressions observed
> from v5.10.y baseline:
> 
> xfs: punch out data fork delalloc blocks on COW writeback failure
> xfs: remove all COW fork extents when remounting readonly
> xfs: prevent UAF in xfs_log_item_in_current_chkpt
> xfs: only bother with sync_filesystem during readonly remount
> xfs: use setattr_copy to set vfs inode attributes
> xfs: check sb_meta_uuid for dabuf buffer recovery
> xfs: use kmem_cache_free() for kmem_cache objects
> xfs: Fix the free logic of state in xfs_attr_node_hasname
> 
> So perhaps you could use that as the smaller subset for first posting.
> To reduce review burden on xfs maintainers, I could break out of the
> chronological patches order and use the same subset for my next set
> of candidates for 5.10 after testing them in isolation on top of xfs-5.10.y-3
> (at least the ones that apply out of order).
> 
> Thanks,
> Amir.

Sure, good idea! I was going to split it into a smaller batch anyways,
so this selection works for me.

Best,
Leah
