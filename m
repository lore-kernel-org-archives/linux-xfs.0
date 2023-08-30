Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C501BC83F15
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 23:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239367AbjH3XKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Aug 2023 19:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239347AbjH3XKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2023 19:10:07 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF8283
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 16:10:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c1e3a4a06fso1314685ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 16:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693437004; x=1694041804; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pY8RbnhSGlMiv7I3aFkTawjz67jUc9YTIpapEZLnNrI=;
        b=Fe28DdH+s6pW3uayHXyXJjFc4ZpZVRGFhQ1hSKCHJqXwfoa3zOxn2gvlsNO4IuTIR2
         B8xEIGZ2anbDyEMQUgqzHYBlJMozcBu6fKLCogsR5wJAQ9SIA0X5/vM+q+jUlYPEZSrp
         8uzDGqh8C42qJvUJtITFEihfdWS9qs/fCXBEzD/VvcrSL5k47FKyBMN2wO5wDPYgMMnj
         hvjy88/sJLqtAEKZpLgH8P8hG4V1b92rXHWI8jn5MNZGkchgFAJyr/ARJ19oDQkFm5Lr
         71zBR6E4N3y6zTJ8ycqguk4xMjqMXjTLY3p98r2htV2luuA9Krxw/6luZDCiOWmvAaS8
         8B9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693437004; x=1694041804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pY8RbnhSGlMiv7I3aFkTawjz67jUc9YTIpapEZLnNrI=;
        b=JoggvXuU5kZVbgdt9ukGAjuSEGraZjCQR5AmuQg5e9J/DFdNmXS15jfrwLAA9ioS2M
         ZGmrSOu6qsQKX6ke75MeKTnffwWsiTyYCa569RxnR63AAfgAUkPEX4ZEo2kMB9Itfkez
         LAdHVZapOU2liMZNPDTUGFsRqxRLvSEzrMKehb/SMVsh8OxsUx6jdqGw+uGOyL+XX3LH
         NpbUbp8/jhqcrXlndi2JRhN5OHUWphbdibINMEZ35bVuSIFlu66GByg3D/hDxZdvGLBY
         fQ4t6HWyiLnb0K049HqLmrukwRI0G8MxKXjgVMROA06FfHzLgIM6e40iRsJYlkEWgquv
         HNTw==
X-Gm-Message-State: AOJu0YxG7mnGPBvL9AS8OPqPQ2inQGhNiLKLfQm1Xy7sVIA/CpoWF4hY
        m0k+GPdlwgNgfKBNCsBg0GiMxA==
X-Google-Smtp-Source: AGHT+IH/kekC0GSQlZUGKo09NMAEckPgzzEnROIAm1WRV42FYGa4fZu0zCr9r+/SsFMApspPwx5Nvg==
X-Received: by 2002:a17:902:cec4:b0:1bf:feb:100f with SMTP id d4-20020a170902cec400b001bf0feb100fmr4251162plg.9.1693437004415;
        Wed, 30 Aug 2023 16:10:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001c0774d9327sm35530plb.91.2023.08.30.16.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 16:10:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qbUK0-008iPR-2Z;
        Thu, 31 Aug 2023 09:10:00 +1000
Date:   Thu, 31 Aug 2023 09:10:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] generic: only enable io_uring in fsstress explicitly
Message-ID: <ZO/MSIMQulh8A+Mr@dread.disaster.area>
References: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
 <169335095953.3534600.16325849760213190849.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335095953.3534600.16325849760213190849.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:15:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't enable io_uring in fsstress unless someone asks for it explicitly,
> just like fsx.  I think both tools should require explicit opt-in to
> facilitate A/B testing between the old IO paths and this new one.
> 
> While I was playing with fstests+io_uring, I noticed quite a few
> regressions in fstests, which fell into two classes:
> 
> The first class is umount failing with EBUSY.  Apparently this is due to
> the kernel uring code hanging on to file references even after the
> userspace program exits.  Tests that run fsstress and immediately
> unmount now fail sporadically due to the EBUSY.  Unfortunately, the
> metadata update stress tests, the recovery loop tests, the xfs online
> fsck functional tests, and the xfs fuzz tests make heavy use of
> "fsstress; umount" and they fail all over the place now.
> 
> Something's broken, Jens and Christian said it should get fixed, but in
> the meantime this is getting in the way of me testing my own code.

I'm not seeing regular problems with io_uring on my test machines.
Occasionally there will be a filesystem unmount issue, but that's
not causing anything but a single test here or there to fail. It's
not a big deal.

> The second problem I noticed is that fsstress now lodges complaints
> about sporadic heap corruption.  I /think/ this is due to some kind of
> memory mishandling bug when uring is active but IO requests fail, but I
> haven't had the time to go figure out what's up with that.

Yes, I've seen that happen in ~6.4 kernels, but current TOT doesn't
seem to do that anymore on my test machines.

Regardless, I don't think turning off io_uring support by default is
the right thing to do. That's just shooting the messenger. We really
do need this code to be exercised as much as possible because it is
so full of bugs. Sure, add a flag to turn it off if you need it off
(and add it to FSSTRESS_AVOID for your test environments), but
otherwise we really should be exercising io_uring. Ignorance doesn't
prevent bugs or CVEs....

Realistically, what we actually need is to require io_uring
developers to focus on testing io_uring functionality with
filesystems and fsstress and *to fix the regressions* rather than
endlessly adding more features and complexity that create more bugs. 
Turning the code off certainly won't help us acheive that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
