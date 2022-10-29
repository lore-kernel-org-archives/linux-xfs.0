Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE64C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Oct 2022 21:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJ2VBY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 17:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJ2VBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 17:01:23 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68412B00
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 14:01:22 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 4so7724361pli.0
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 14:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ym69ejmQ6XidE88tX8ileHfQoWPZ8ETkeDIsm/obfSg=;
        b=tth30kylJYPKuxYWAzc8A1YjuPkkUe8a/ZonhYBBPMlCQfiOg+w7MHlFcmCFgwJp5m
         s2JtTmUZ1SpwFPrt1VtjEeHqOBn79ccya29yqAapOzGRS1N4EyVFjZqissbwjHyaJTnt
         fjNYcCJh9CQF5aotIWrhdFwLbLlLL8LNBD9gqBN6vXgbjDh+BXdTdR/Ifl1tA93ZHCq9
         U2pkpwkFTXDfMdFN9jvTIEOixm1GgkUcQDa9dgKSGjlUwH3UPwPkwADhNWXJDQNa2CeS
         FnJs3lqh9pnxqKOU+MQGx6W6L/bj69KJMXO9BlKPVpEt9nq5Dg1jUTVyuOC4TBYQsmAX
         U2Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ym69ejmQ6XidE88tX8ileHfQoWPZ8ETkeDIsm/obfSg=;
        b=kehJ2EhFP9Gxk53fl/CvqPo8Kz5LgjzTMAfmzBa9uZ4QpEFbgu3/XgFJ1bllL3chw2
         F3J00/05GgIKGh8eHd9ZD6LbhzEamnpy1xO006AtPMs32hYAYEJ8wgOFX7nN24XhRwO7
         YK1tZNmQk2k3GMFAd4GFkQ3mKgqYphAHpYwJuEnfRPIoAbGJ0zaAp8YDw+sOJJ+XBqNA
         tLXUyOnggeoxrJK/HKOmbgyTjNYgjMBoyFl9FRgzlXhUuA1mhIhL1U6zYmzAipFKEUq5
         uOPwLcJ/2KA/LGrpexedTfrPfLT08lJisPi7DIiwIm2K6V3BWt3j6xmZbJyvVcweCQlj
         41Vg==
X-Gm-Message-State: ACrzQf1ko2lD5nedM8MJq1GiUcCcbs6jTBHEAj1dirzVYfZMD8gpa5jX
        OZqvGe24ECJkRXXtXJpDlaJwazEvn9ih0Q==
X-Google-Smtp-Source: AMsMyM52ZqymjBX0yCtTSHPp/nu9SW4ubu0uvO4redbptJw8VJ94uI9H9tCol5Awu6H8bRSVcpCKZg==
X-Received: by 2002:a17:903:2d0:b0:183:ba7f:a67b with SMTP id s16-20020a17090302d000b00183ba7fa67bmr6117445plk.42.1667077281855;
        Sat, 29 Oct 2022 14:01:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id jf7-20020a170903268700b0017bb38e4588sm1696881plb.135.2022.10.29.14.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 14:01:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oosxB-007wU8-Mc; Sun, 30 Oct 2022 08:01:17 +1100
Date:   Sun, 30 Oct 2022 08:01:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Neutron Sharc <neutronsharc@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Fwd: does xfs support aio_fsync?
Message-ID: <20221029210117.GE3600936@dread.disaster.area>
References: <CAB-bdyRWCJLDde4izM_H-Bh9wPg-Enas+D4VvTROWEpVy0ZgZg@mail.gmail.com>
 <CAB-bdyTJjM7ju-ku6w1Tib06r70FbZ8r0y8mfBaKu4XQDuMeUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-bdyTJjM7ju-ku6w1Tib06r70FbZ8r0y8mfBaKu4XQDuMeUw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 03:11:15PM -0700, Neutron Sharc wrote:
> Hello all,
> I have a workload that benefits the most if I can issue async fsync
> after many async writes are completed. I was under the impression that
> xfs/ext4 both support async fsync so I can use libaio to submit fsync.
> When I tested with io_submit(fsync),  it always returned EINVAL.  So I
> browsed the linux source (both kernel 3.10,  4.14)  and I found
> xfs/xfs_file.c doesn't implement "aio_fsync", nor does ext4/file.c.

Generic support for IOCB_CMD_FSYNC and IOCB_CMD_FDSYNC was added
into 4.17. As a result it should be supported by almost all
filesystems, not just XFS....

> I found an old post which said aio_fsync was already included in xfs
> (https://www.spinics.net/lists/xfs/msg28408.html)

Yeah, the code that went into fs/aio.c was pretty much a generic
version of this.

> What xfs or kernel version should I use to get aio_fsync working?  Thanks all.

Just a kernel that isn't ancient. If you are looking for features,
always check latest code first, then go back and find when it was
merged (git log, git blame, etc). That's all I did....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
