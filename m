Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48D1C001DB
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 21:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjHDVxC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 17:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjHDVxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 17:53:01 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4946106
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 14:53:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-686f38692b3so2452256b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 04 Aug 2023 14:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691185980; x=1691790780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WwllLJwO0eK9Z2Xh/j4/M+p0OGxZ6JVAcjMSM4y5LoI=;
        b=FkZeRTdQA5GLWgRXAdqmdnJrSnwzkWyv27bs9bhgl2PDu9ok9NKAql0xF/bAB3ZVui
         fM9rNXUCDje6vnmo/Iv7YmC2ypLLfmW8T8Cx3o/TG0It0DPQiCWtVJEmcPfllnQ2N5TB
         N9kgoIMJlJHl69ixjNLVHi+3sD5nnzyA9XpwsvWIKMJNoQiYQgvs7vWfZgzXGVKmGf6W
         6ju3TNDzpAcOJg3WYgyF2qfp0vUMXL71uM4/udKQq55dMPmVT6AEBmJdujffQ1d/5EaJ
         I+KVmnimOt0zVBBpgZlGUKFzfYP0x2ySuCvgIozaDmp4/7ALtUvDe1tOW2wAT72wEioy
         b17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691185980; x=1691790780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwllLJwO0eK9Z2Xh/j4/M+p0OGxZ6JVAcjMSM4y5LoI=;
        b=TpYZzJrl98ATVl13Yd+A+xwTit9w90scH+tsTkP40oGoyAmHWEpHMwE313Ei0La+JV
         w2tOTAwzynaAxVWEJcMykaVzWgiV3ESTVrYCT0CzNZbJO0nw8UsAzPxENTUlfC7NQaDW
         M2JteDq+h/Zm0qtSv2Ejj44rd0CC9NO079ABjHxb+EFDFLyWqNNYf2F9SdC3kM33uSbl
         ZF7chXrK1b4BY9ELENi0JSi2W31rLXg1HXgTdvqDel2YHhg+tCuQYmlEBCwaEKlXCeu+
         XnVYImCkp8L13M6kzrpH+r0kFV4D3N+e65RbS2OKgvsbZeSsrlycUd2wRbcbi9/IOt+J
         A62g==
X-Gm-Message-State: AOJu0Yxmu4BgxN1xyPXdufdj8TmoVxg2yhWhSRq1ksYy+rMQETABtSJx
        e6b2h6RlkiJAxzKEsAtsxosRus+U+X668ZOBcjM=
X-Google-Smtp-Source: AGHT+IF7ndmiSI/RrPVeQzz4FKM3jsZgjEUQuTjh8Mi/skhlgqs8Hr2VF/JJllBfTR3jF9Z0QXJGCQ==
X-Received: by 2002:a05:6a20:3242:b0:f3:33fb:a62b with SMTP id hm2-20020a056a20324200b000f333fba62bmr3148696pzc.9.1691185980189;
        Fri, 04 Aug 2023 14:53:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id d8-20020aa78688000000b00686bbf5c573sm1986892pfo.119.2023.08.04.14.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 14:52:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qS2jA-0018dJ-1x;
        Sat, 05 Aug 2023 07:52:56 +1000
Date:   Sat, 5 Aug 2023 07:52:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Corey Hickey <bugfood-ml@fatooh.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: read-modify-write occurring for direct I/O on RAID-5
Message-ID: <ZM1zOFWVm9lD8pNc@dread.disaster.area>
References: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
 <ZMyxp/Udved6l9F/@dread.disaster.area>
 <db157228-3687-57bf-d090-10517847404d@fatooh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db157228-3687-57bf-d090-10517847404d@fatooh.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 04, 2023 at 12:26:22PM -0700, Corey Hickey wrote:
> On 2023-08-04 01:07, Dave Chinner wrote:
> > If you want to force XFS to do stripe width aligned allocation for
> > large files to match with how MD exposes it's topology to
> > filesytsems, use the 'swalloc' mount option. The down side is that
> > you'll hotspot the first disk in the MD array....
> 
> If I use 'swalloc' with the autodetected (wrong) swidth, I don't see any
> unaligned writes.
> 
> If I manually specify the (I think) correct values, I do still get writes
> aligned to sunit but not swidth, as before.

Hmmm, it should not be doing that - where is the misalignment
happening in the file? swalloc isn't widely used/tested, so there's
every chance there's something unexpected going on in the code...

> -----------------------------------------------------------------------
> $ sudo mkfs.xfs -f -d sunit=1024,swidth=2048 /dev/md10
> mkfs.xfs: Specified data stripe width 2048 is not the same as the volume
> stripe width 546816
> log stripe unit (524288 bytes) is too large (maximum is 256KiB)
> log stripe unit adjusted to 32KiB
> meta-data=/dev/md10              isize=512    agcount=16, agsize=982912 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1
> nrext64=0
> data     =                       bsize=4096   blocks=15726592, imaxpct=25
>          =                       sunit=128    swidth=256 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> $ sudo mount -o swalloc /dev/md10 /mnt/tmp
> -----------------------------------------------------------------------
> 
> There's probably something else I'm doing wrong there.

Looks sensible, but it's likely still tripping over some non-obvious
corner case in the allocation code. The allocation code is not
simple (allocation alone has roughly 20 parameters that determine
behaviour), especially with all the alignment setup stuff done
before we even get to the allocation code...

One thing to try is to set extent size hints for the directories
these large files are going to be written to. That takes a lot of
the allocation decisions away from the size/shape of the individual
IO and instead does large file offset aligned/sized allocations
which are much more likely to be stripe width aligned. e.g. set a
extent size hint of 16MB, and the first write into a hole will
allocate a 16MB chunk around the write instead of just the size that
covers the write IO.

> Still, I'll heed your advice about not making a hotspot disk and allow XFS
> to allocate as default.
> 
> Now that I understand that XFS is behaving as intended and I can't/shouldn't
> necessarily aim for further alignment, I'll try recreating my real RAID,
> trust in buffered writes and the MD stripe cache, and see how that goes.

Buffered writes won't guarantee you alignment, either, In fact, it's
much more likely to do weird stuff than direct IO. If your
filesystem is empty, then buffered writes can look *really good*,
but once the filesystem starts being used and has lots of
discontiguous free space or the system is busy enough that writeback
can't lock contiguous ranges of pages, writeback IO will look a
whole lot less pretty and you have little control over what
it does....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
