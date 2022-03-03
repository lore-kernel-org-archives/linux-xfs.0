Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0647C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Mar 2022 09:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiCCJWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 04:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiCCJWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 04:22:10 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4CB16AA68
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 01:21:24 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id i8so6765697wrr.8
        for <linux-xfs@vger.kernel.org>; Thu, 03 Mar 2022 01:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DvPDduUxIuKL+yC0AJiEs10ttn/sVwtbIKSiINsPfck=;
        b=Whs7i/l7Ta41ISRWqYoptObsB6bgijpRsSUQ44ORzGWV0eiv3MSdzllcgvNtcbgOzV
         qEsNocRqROECrQoXT6nSFau837L0OZpiRLHG8FOGgmDtmMYRIkz6qn9o9QlYjnMQf/8J
         E6wtNZwzdQKTs8NxFcu6iseMmGML1DLObOb+bunR8gwBluzuLLJf3GELwctxeXkv5xu4
         d2gEUduPCFVu6XwxxjKDTnNrJLyiwvP4urthL0bZKFcDDV+q/rc89oPx3PNHFRQFdWey
         uCvmgVQ75ezYhb05odw7aZVpXf01MrhHlXimTlb1UQvYmIIXSAizC7fST9LoQrS12GYn
         uyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DvPDduUxIuKL+yC0AJiEs10ttn/sVwtbIKSiINsPfck=;
        b=RKH40gbt9Xy3jhb5wZO3cMpnKu083WeQoZmaDA1sFF0t0kKDrvXQcKZeUrmMV6hiLI
         MaBdpwNFclnQmyFem+1GnmJkOkTJuDJ5ml1CtR6GzUYTJe4fxp4p5DNMlHrnfaYB1oJU
         OKAzgXBkWOgIaFwaOrYXmKp0lkLqGZMd4XWiNBDT4OQDFP271Z4sl0tdtWvUTLc/qVeQ
         CQuUtBggo7hdb9gPToMe5eog8VhUw1pY86N55OeyrFx2knKYieVaS+3EpthYGCRFw1BT
         54aaqq3bys4UC1ntM6tImy9tQ1c8j56aad2JmMuvW/dtYUMcQ1wLtkxlxkUdLOk50YkG
         HdZw==
X-Gm-Message-State: AOAM5324RGyDX3+zLOBKRTcdYW7tHePnXXYmjSqbgXdmvmM5PnVuTBpn
        u1mUsLr2H4xUvF7iMGXYds7DGA==
X-Google-Smtp-Source: ABdhPJyr7pVJbeXlptM3psyRHARpgFUUaoaGjdJbuLZWvib+4ssC3GztiHJ961bWXmr+1LqoREKl5w==
X-Received: by 2002:a05:6000:1b0a:b0:1ef:7c04:9bad with SMTP id f10-20020a0560001b0a00b001ef7c049badmr20292282wrz.54.1646299283022;
        Thu, 03 Mar 2022 01:21:23 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p16-20020adff210000000b001f062b80091sm353137wro.34.2022.03.03.01.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 01:21:22 -0800 (PST)
Date:   Thu, 3 Mar 2022 09:21:20 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4] ext4: don't BUG if kernel subsystems dirty pages
 without asking ext4 first
Message-ID: <YiCIkNci2V3IBRme@google.com>
References: <Yg0m6IjcNmfaSokM@google.com>
 <Yhks88tO3Em/G370@mit.edu>
 <YhlBUCi9O30szf6l@sol.localdomain>
 <YhlFRoJ3OdYMIh44@mit.edu>
 <YhlIvw00Y4MkAgxX@mit.edu>
 <YiBDf7XLnTe4Gwis@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YiBDf7XLnTe4Gwis@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 02 Mar 2022, Theodore Ts'o wrote:

> [un]pin_user_pages_remote is dirtying pages without properly warning
> the file system in advance.  A related race was noted by Jan Kara in
> 2018[1]; however, more recently instead of it being a very hard-to-hit
> race, it could be reliably triggered by process_vm_writev(2) which was
> discovered by Syzbot[2].
> 
> This is technically a bug in mm/gup.c, but arguably ext4 is fragile in
> that if some other kernel subsystem dirty pages without properly
> notifying the file system using page_mkwrite(), ext4 will BUG, while
> other file systems will not BUG (although data will still be lost).
> 
> So instead of crashing with a BUG, issue a warning (since there may be
> potential data loss) and just mark the page as clean to avoid
> unprivileged denial of service attacks until the problem can be
> properly fixed.  More discussion and background can be found in the
> thread starting at [2].
> 
> [1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
> [2] https://lore.kernel.org/r/Yg0m6IjcNmfaSokM@google.com
> 
> Reported-by: syzbot+d59332e2db681cf18f0318a06e994ebbb529a8db@syzkaller.appspotmail.com
> Reported-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> ---
> v4 - only changes to the commit description to eliminate some inaccuracies
>      and clarify the text.
> 
>  fs/ext4/inode.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)

Thanks a bunch for sticking with this Ted.

I've been following along with great interest.

Sadly I am not in a position to provide a review.

Just wanted to pop by and say thank you.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
