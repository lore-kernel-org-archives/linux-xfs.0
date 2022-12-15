Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAE3C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Dec 2022 00:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiLOAUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Dec 2022 19:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiLOAUY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2022 19:20:24 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F1C2B1A4
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 16:19:48 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 79so3097266pgf.11
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 16:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rRpO3QnyU6ChdHPazl5zqgJFuB/om7CEHPWIzKyAGmw=;
        b=Uc2FAWV50Q/fgLz4Kz7Iz3qqqUvK/eUk42Ll9KWqr0gl6i2qOyWB+317FVLE2jTac1
         bIbzepGCO/N3nxywK3m74mwleAn2fKtycxVSS2rb0Xgj7xHXx3O1bbKZ5JYf6JDcCdGK
         aue79iEp4gj5T2M9MYgo3HxPyQ4WRsacGqxVfecpnOWZQCHelcifAPr6ZJSiF92Zhpws
         yNm3h6A4bresmGu09PV7G+MiubISp99oeqL/0chOl8EfTcMlmcIxwOY9NsFAH420VIPl
         lbEvdz502Q6/yhOsG2pQLCrL8aLQ+W4+HGQAxtUp6Ye637IVRE3a8ny8ZfpFzOr55NdV
         +jDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rRpO3QnyU6ChdHPazl5zqgJFuB/om7CEHPWIzKyAGmw=;
        b=N69G+MSejH3Dtx7JLHX3xCGlNzzpnyBzkD5883fnJI59gAT42QMVTtrhkr1v3p8NJp
         1ZfYssujZKWTTIbaV/8awdaowSuPUi9/FlkV8q9t8NHpwchGbKncALGXnSoaAzvEIi0q
         EGVpUKE4zgp7fLnTY16nuomEU1k9oJTmCgDhhXPMe32ngacvp5lXbr2iLJTU+ZjA2h18
         p1GW9FjEgjgvhKwbvb8hAh1YLqr3Odw9EyQt9KEcSZ1NXLQ9rgUHBsE4kK+5HIMrFL3H
         4Ynv+h4r0d7qpLCubgUHs9jGGj27qKHUoWOD0CAqSvpebKAZeFs3V4Yz93BU/ip8NmCg
         mAUw==
X-Gm-Message-State: ANoB5pkC69okpuYtaOIFccnMR/c/VoOIdAWPOOIoGOnC1Hj7E9y7H3aR
        vpQ2BVNtrRUJXYhh4V3FBR04kw==
X-Google-Smtp-Source: AA0mqf5/FJf+I6OMoKPqxw8Vu5oa5pdOexrWPhBqwuSiBZxvPhIailjRjQAynaVor/Gm5opVVMQDaA==
X-Received: by 2002:aa7:814f:0:b0:56c:232e:3b00 with SMTP id d15-20020aa7814f000000b0056c232e3b00mr23787141pfn.7.1671063587594;
        Wed, 14 Dec 2022 16:19:47 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id i11-20020aa796eb000000b005749f5d9d07sm429565pfq.99.2022.12.14.16.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 16:19:47 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5byS-008XDn-KN; Thu, 15 Dec 2022 11:19:44 +1100
Date:   Thu, 15 Dec 2022 11:19:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Suyash Mahar <smahar@ucsd.edu>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        tpkelly@eecs.umich.edu, Suyash Mahar <suyash12mahar@outlook.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
Message-ID: <20221215001944.GC1971568@dread.disaster.area>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com>
 <Y5i0ALbAdEf4yNuZ@magnolia>
 <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 08:47:03PM -0800, Suyash Mahar wrote:
> Hi Darrick,
> 
> Thank you for the response. I have replied inline.
> 
> -Suyash
> 
> Le mar. 13 déc. 2022 à 09:18, Darrick J. Wong <djwong@kernel.org> a écrit :
> >
> > [ugh, your email never made it to the list.  I bet the email security
> > standards have been tightened again.  <insert rant about dkim and dmarc
> > silent failures here>] :(
> >
> > On Sat, Dec 10, 2022 at 09:28:36PM -0800, Suyash Mahar wrote:
> > > Hi all!
> > >
> > > While using XFS's ioctl(FICLONE), we found that XFS seems to have
> > > poor performance (ioctl takes milliseconds for sparse files) and the
> > > overhead
> > > increases with every call.
> > >
> > > For the demo, we are using an Optane DC-PMM configured as a
> > > block device (fsdax) and running XFS (Linux v5.18.13).
> >
> > How are you using fsdax and reflink on a 5.18 kernel?  That combination
> > of features wasn't supported until 6.0, and the data corruption problems
> > won't get fixed until a pull request that's about to happen for 6.2.
> 
> We did not enable the dax option. The optane DIMMs are configured to
> appear as a block device.
> 
> $ mount | grep xfs
> /dev/pmem0p4 on /mnt/pmem0p4 type xfs
> (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota)
> 
> Regardless of the block device (the plot includes results for optane
> and RamFS), it seems like the ioctl(FICLONE) call is slow.

Please define "slow" - is it actually slower than it should be
(i.e. a bug) or does it simply not perform according to your
expectations?

A few things that you can quantify to answer these questions.

1. What is the actual rate it is cloning extents at? i.e. extent count
/ clone time?  Is this rate consistent/sustained, or is it dropping substantially
over time and/or increase in extent count?

3. How does clone speed of a given file compare to the actual data
copy speed of that file (please include fsync time in the data
copy results)? Is cloning faster or slower than copying
the data? What is the extent count of the file at the cross-over
point where cloning goes from being faster to slower than copying
the data?

3. How does it compare with btrfs running the same write/clone
workload? Does btrfs run faster? Does it perform better with
high extent counts than XFS? What about with high sharing counts
(e.g. after 500 or 1000 clones of the source file)?

Basically, I'm trying to understand what "slow" means in teh context
of the operations you are performing.  I haven't seen any recent
performance regressions in clone speed on XFS, so I'm trying to
understand what you are seeing and why you think it is slower than
it should be.

> > > We create a 1 GiB dense file, then repeatedly modify a tiny random
> > > fraction of it and make a clone via ioctl(FICLONE).
> >
> > Yay, random cow writes, that will slowly increase the number of space
> > mapping records in the file metadata.

Yup, the scripts I use do exactly this - 10,000 random 4kB writes to
a 8GB file between reflink clones. I then iterate a few thousand
times and measure the reflink time.

> > > The time required for the ioctl() calls increases from large to insane
> > > over the course of ~250 iterations: From roughly a millisecond for the
> > > first iteration or two (which seems high, given that this is on
> > > Optane and the code doesn't fsync or msync anywhere at all, ever) to 20
> > > milliseconds (which seems crazy).
> >
> > Does the system call runtime increase with O(number_extents)?  You might
> > record the number of extents in the file you're cloning by running this
> > periodically:
> >
> > xfs_io -c stat $path | grep fsxattr.nextents
> 
> The extent count does increase linearly (just like the ioctl() call latency).

As expected. Changing the sharing state a single extent has a
roughly constant overhead regardless of the number of extents in the
file. Hence clone time should scale linearly with the number of
extents that need to have their shared state modified.

> I used the xfs_bmap tool, let me know if this is not the right way. If
> it is not, I'll update the microbenchmark to run xfs_io.

xfs_bmap is the slow way - it has to iterate every extents and
format them out to userspace. the above mechanism just does a single
syscall to query the count of extents from the inode. Using the
fsxattr extent count query is much faster, especially when you have
files with tens of millions of extents in them....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
