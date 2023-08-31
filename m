Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820D6C83F2E
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Aug 2023 15:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbjHaPTq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 11:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjHaPTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 11:19:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED97E69
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 08:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693495124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lUHq4p8WyUaADW+y6zN13LIHDEVaKiPvW1UFaBUpk8A=;
        b=Q+ToXq1W2sLiwkxIbM4ixC2N4Vu4b5+//ykoAieTxT42CBFJV1clAXkSYza4FQGsD7T3L9
        CocImbyhAGZVoLQlU46lIIDL+P1AuHqsIeY0Pk1SPGsDjgKXDrpnz9U0rScr1jVfuRrObV
        g0CAmwRx+bTNa+AgR0g0q21rJrlrtnA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-RiR2sRS5P8uCRH8IMhW_aQ-1; Thu, 31 Aug 2023 11:18:42 -0400
X-MC-Unique: RiR2sRS5P8uCRH8IMhW_aQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-26f3fce5b45so1157840a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 08:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693495121; x=1694099921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUHq4p8WyUaADW+y6zN13LIHDEVaKiPvW1UFaBUpk8A=;
        b=PjiWDr3iE1b52iZxjfX87fvUvKk8G4EhWdQLhOD0S2ThdiSk8kVNjFdh+NQw+PB/Zy
         +QGbhr0H2bAp46aQ4WixlUoFzuAe/IKBPaObFi2lRstHbiDVZXLFq12zbQpmRFWVM05w
         Gnry9zXwp3FaieV4aEX+JdlSCR9dh98JPQeHPb2FJJCHS3SfAZtokon9pdxv5dNPZo35
         qeithBN/Bb907JVIHu40WzVoZXDUs701950sLOi0+EW/5kxKDxW3oe0685uE8hkiSf61
         qArVjBo3F9qTcK/nioqgy7Qo8h8KOtN4jMkd6f0NbQ7I+8Ra2s2bzYzAyXyBblge6JGn
         KZYA==
X-Gm-Message-State: AOJu0Yw2oCkOJbE0yfNtegVBw6f8s/TO03p9pwoxTjrXwJkhDEedcqeA
        kZG5zQpQ965Y01WXGUka7Ca9WRT8zrkI4v/aUcfc1c97yNETM4meTCkdiVQLOzp9XFHYwIg1Hsx
        zXGLJH/3n5epkFNBQSIgb
X-Received: by 2002:a17:90a:8a02:b0:271:c314:a591 with SMTP id w2-20020a17090a8a0200b00271c314a591mr5520821pjn.47.1693495121350;
        Thu, 31 Aug 2023 08:18:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWQ1K1mpStk+Vmix+Wwh3ISNL7II5qDaTlhYcspae2vJIf0S1dO6X7uHGUNOISE20iqh0Wkw==
X-Received: by 2002:a17:90a:8a02:b0:271:c314:a591 with SMTP id w2-20020a17090a8a0200b00271c314a591mr5520795pjn.47.1693495121014;
        Thu, 31 Aug 2023 08:18:41 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a005a00b0025dc5749b4csm3311301pjb.21.2023.08.31.08.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 08:18:40 -0700 (PDT)
Date:   Thu, 31 Aug 2023 23:18:37 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] generic: only enable io_uring in fsstress explicitly
Message-ID: <20230831151837.qexyqjgvrllqaz26@zlang-mailbox>
References: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
 <169335095953.3534600.16325849760213190849.stgit@frogsfrogsfrogs>
 <ZO/MSIMQulh8A+Mr@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZO/MSIMQulh8A+Mr@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 31, 2023 at 09:10:00AM +1000, Dave Chinner wrote:
> On Tue, Aug 29, 2023 at 04:15:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Don't enable io_uring in fsstress unless someone asks for it explicitly,
> > just like fsx.  I think both tools should require explicit opt-in to
> > facilitate A/B testing between the old IO paths and this new one.
> > 
> > While I was playing with fstests+io_uring, I noticed quite a few
> > regressions in fstests, which fell into two classes:
> > 
> > The first class is umount failing with EBUSY.  Apparently this is due to
> > the kernel uring code hanging on to file references even after the
> > userspace program exits.  Tests that run fsstress and immediately
> > unmount now fail sporadically due to the EBUSY.  Unfortunately, the
> > metadata update stress tests, the recovery loop tests, the xfs online
> > fsck functional tests, and the xfs fuzz tests make heavy use of
> > "fsstress; umount" and they fail all over the place now.
> > 
> > Something's broken, Jens and Christian said it should get fixed, but in
> > the meantime this is getting in the way of me testing my own code.
> 
> I'm not seeing regular problems with io_uring on my test machines.

Me neither.

> Occasionally there will be a filesystem unmount issue, but that's
> not causing anything but a single test here or there to fail. It's
> not a big deal.
> 
> > The second problem I noticed is that fsstress now lodges complaints
> > about sporadic heap corruption.  I /think/ this is due to some kind of
> > memory mishandling bug when uring is active but IO requests fail, but I
> > haven't had the time to go figure out what's up with that.
> 
> Yes, I've seen that happen in ~6.4 kernels, but current TOT doesn't
> seem to do that anymore on my test machines.
> 
> Regardless, I don't think turning off io_uring support by default is
> the right thing to do. That's just shooting the messenger. We really

Agree, we'd better to give io_uring a test by default. I've found
several regression issues on io_uring by fsstress. If someone feels
io_uring breaks his testing, remove the liburing and liburing-devel
package, then fsstress won't build io_uring things. Or export
FSSTRESS_AVOID="-f uring_read=0 -f uring_write=0". Sometimes, I even
removed the IO_URING kernel config then rebuild kernel, to avoid
the effection of io_uring code totally.

Thanks,
Zorro

> do need this code to be exercised as much as possible because it is
> so full of bugs. Sure, add a flag to turn it off if you need it off
> (and add it to FSSTRESS_AVOID for your test environments), but
> otherwise we really should be exercising io_uring. Ignorance doesn't
> prevent bugs or CVEs....
> 
> Realistically, what we actually need is to require io_uring
> developers to focus on testing io_uring functionality with
> filesystems and fsstress and *to fix the regressions* rather than
> endlessly adding more features and complexity that create more bugs. 
> Turning the code off certainly won't help us acheive that....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

