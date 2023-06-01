Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B55C77B73
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 00:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjFAAIM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 20:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjFAAIL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 20:08:11 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C27124
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 17:08:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64d4e4598f0so372171b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 17:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685578086; x=1688170086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4NfftCMHJ2mk2OAzr3g365CO6p8zdsBKQyeSDPsEjLk=;
        b=1cS8E7NNFagubSxA6dYeteaqccqiSFCqJEZEIdfqw7uDJrPInABblpuqtGet8rWGyK
         UJe1SRVfnm0baJCLNj22nRBXT4D1+yShn3N6ESslolhGf2M+DNZELa5ecmVraylz1/0k
         hHQ65S0r+QWouIQC7VuN1V2eS1/2tHqgaW0Z34kU/hr2ERDyakRRGznPoYCNw+Odxeko
         FLc6DxZQ42mDsYZZ0BZIRr3bvHiUjbVo5Stijn2QXVqHQ8yw4UyQg2wa6K5UOF66nWYA
         GY5Jo516m+bPpg9F0ynMxjR59+Ofx/hkreHnV0nOVFFANZMXR2dXVDL/Q4pV8lP/3xpj
         lNCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685578086; x=1688170086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4NfftCMHJ2mk2OAzr3g365CO6p8zdsBKQyeSDPsEjLk=;
        b=H+lX0YcbUT0h9Z8qK8FUytS3vKgYFO5l7gXHx241W2HfO43uYzn1QgMY5Y20DXCT3r
         EWmnmIdjVOixPo8xrKlWn2gEb6Y6LXBbogwKk4rxuSmmF38EULzeOXCLMJUcbRGrrI6Z
         YVlPy75pUJCJzsj5MSsDvAQujUXFsCF3y+nrou5coIl5IWOwUJwM3FfW+us3XHnuWfAd
         QhGu5a/FjUwobU6oAYJOkwRPuFRPtgtjF2x4ILw3tpA4KtPkV8CYxLy0wOQBondkE0Du
         k20igiJVsLV+Ow2WWlkXyjdlOPl9xx3QMI8oFmExG+WMWviFAZPho30v7UO2L4gZm/PM
         oBnQ==
X-Gm-Message-State: AC+VfDwoa7ynmElhhFu1TodNwNx69TgjmQ1hTcBr/duWGh2YDzWucG+G
        LfmsYU1LF6UBY7Hz0aE+WTb64LxblLpit52qkzg=
X-Google-Smtp-Source: ACHHUZ6WiVURACzwkvMsWWWblYL8OvI6oSMTR9rPt04stDvq3hb4DE0EaACPojDVZhadUv2oI3jtoA==
X-Received: by 2002:a05:6a00:2e05:b0:64f:4197:8d93 with SMTP id fc5-20020a056a002e0500b0064f41978d93mr10270159pfb.24.1685578086385;
        Wed, 31 May 2023 17:08:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id k184-20020a6324c1000000b0052cbd854927sm1862772pgk.18.2023.05.31.17.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 17:08:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q4VrG-006IoG-2c;
        Thu, 01 Jun 2023 10:08:02 +1000
Date:   Thu, 1 Jun 2023 10:08:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jianan Wang <wangjianan.zju@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question on the xfs inode slab memory
Message-ID: <ZHfhYsqln68N1HyO@dread.disaster.area>
References: <CAMj1M42L6hH9weqroQNaWu_SG+Yg8NrAuzgNO1b8jiWPJ2M-5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1M42L6hH9weqroQNaWu_SG+Yg8NrAuzgNO1b8jiWPJ2M-5A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 31, 2023 at 02:29:52PM -0700, Jianan Wang wrote:
> Hi all,
> 
> I have a question regarding the xfs slab memory usage when operating a
> filesystem with 1-2 billion inodes (raid 0 with 6 disks, totally
> 18TB). On this partition, whenever there is a high disk io operation,
> like removing millions of small files, the slab kernel memory usage
> will increase a lot, leading to many OOM issues happening for the
> services running on this node. You could check some of the stats as
> the following (only includes the xfs related):

You didn't include all the XFS related slabs. At minimum, the inode
log item slab needs to be shown (xfs_ili) because that tells us how
many of the inodes in the cache have been dirtied.

As it is, I'm betting the problem is the disk subsystem can't write
back dirty inodes fast enough to keep up with memory demand and so
reclaim is declaring OOM faster than your disks can clean inodes to
enable them to be reclaimed.

> #########################################################################
> Active / Total Objects (% used):  281803052 / 317485764 (88.8%)
> Active / Total Slabs (% used): 13033144 / 13033144 (100.0%)
> Active / Total Caches (% used): 126 / 180 (70.0%)
> Active / Total Size (% used): 114671057.99K / 127265108.19K (90.1%)
> Minium / Average / Maximum Object : 0.01K / 0.40K / 16.75K
> 
> OBJS               ACTIVE      USE     OBJ SIZE     SLABS
> OBJ/SLAB    CACHE SIZE    NAME
> 78207920      70947541      0%       1.00K           7731010
>  32            247392320K     xfs_inode
> 59945928      46548798      0%       0.19K           1433102
>  42              11464816K     dentry
> 25051296      25051282      0%       0.38K           599680
>   42            9594880K         xfs_buf

Ok, that's from slabtop. Please don't autowrap stuff you've pasted
in - it makes it really hard to read. (reformatted so I can read
it).

OBJS           ACTIVE      USE     OBJ SIZE     SLABS OBJ/SLAB    CACHE SIZE    NAME
78207920      70947541      0%       1.00K     7731010   32       247392320K     xfs_inode
59945928      46548798      0%       0.19K     1433102   42        11464816K     dentry
25051296      25051282      0%       0.38K      599680   42         9594880K         xfs_buf

So, 70 million cached inodes, with a cache size of 240GB. There are
7.7 million slabs, 32 objects per slab, and that's roughly 240GB.

But why does the slab report only 78 million objects in the slab
when at 240GB there should be 240 million objects in the slab?

It looks like theres some kind of accounting problem here, likely in
the slabtop program. I have always found slabtop to be unreliable
like this....

Can you attach the output of 'cat /proc/slabinfo' and 'cat
/proc/meminfo' when you have a large slab cache in memory?

> #########################################################################
> 
> The peak slab memory usage could spike all the way to 100GB+.

Is that all? :)

> We are using Ubuntu 18.04 and the xfs version is 4.9, kernel version is 5.4

Ah, I don't think there's anything upstream can do for you. We
rewrote large portions of the XFS inode reclaim in 5.9 (3 years ago)
to address the issues with memory reclaim getting stuck on dirty XFS
inodes, so inode reclaim behaviour in modern kernels is completely
different to old kernels.

I'd suggest that you need to upgrade your systems to run a more
modern kernel and see if that fixes the issues you are seeing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
