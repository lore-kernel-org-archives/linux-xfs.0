Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4A1C83F17
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Aug 2023 03:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjHZDtN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 23:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjHZDs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 23:48:57 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0E22683
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 20:48:52 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6bee392fe9dso1143189a34.1
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 20:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693021732; x=1693626532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nDF8d2t+PB9TDhA2YUisHypTvbNGV3J6q2uUMrytCfQ=;
        b=G2G81NJg6AY4tnXLuj641gsQSoFc6T6ye/kbn2X5Er9GE1rvdD9d0qrO59JgIQq2OK
         0TsZmukmN7FX3P5QjdO/KPZNVG9GM98QQNeZMBHai8VALEGlYh/W6yz0cofNf9pkyPzC
         J2BpW6DRVnlZBb4BR+vkYafoBf1XieWEPDVjPhIb4PszLubWzAdlsos//IeB480lZHGR
         hkJqyI0cm+0Ek7Es6mJlkNxL1O7IZPqlvp2t2e+ji71VrujgxP/xK23wsuVhelOsQI8e
         lIL2g5df66Mi0fVmAL0K0PYQw8NnaMJw73MRNTy2v5Q9+N4njWe4nUO0twjNwAOCUJ6Y
         rOpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693021732; x=1693626532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDF8d2t+PB9TDhA2YUisHypTvbNGV3J6q2uUMrytCfQ=;
        b=QpytBxBSGtU4VB5wvdJYmNOeLDw1EBvfzagFGUNIuHrpWqRkCb/SCAzKofpLGxjYk3
         xISD7GvDNyqTVcH4ZPhCfpk9TdUutGobnV6lTtdRhlHqFXh5xXiNilYqu7w5zOsGhpBz
         y7+b/mGLdXvi/QZxmKpqBBt0g+nkgp2Mme5moQo+Q34QiMBdSE7S0N0mXmZIfSWEHIRd
         L2i7o3Ea+pCZ6lnlVPnRZcWyntImUg6Zm3WJq/KIrmFIOsyD+wuT0aZEFquSPpJTp4+7
         BltpmWoypRAQ8KhlIhtEv3XsFD3+yJvdI+GT905Qa203CiG43l6hJx33oHkXdTxyC2/d
         3ycA==
X-Gm-Message-State: AOJu0YzeXVQAse1Q04NP8t/D5EXxpGFTJmbwmNln2yeCbFRJFoph3Bmr
        zTYzcEjpOsrZTGUulzQOP859Tg==
X-Google-Smtp-Source: AGHT+IHovT0vgwxf1OM7Nv4iC4zviRrv4Eox4nwyejCdU7PdDR0X/SFRsEUsFT3n5omvQr1s4clyQA==
X-Received: by 2002:a9d:73c7:0:b0:6bd:ba2c:fbbd with SMTP id m7-20020a9d73c7000000b006bdba2cfbbdmr7884208otk.20.1693021732001;
        Fri, 25 Aug 2023 20:48:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id l1-20020a170902ec0100b001bb889530adsm2563359pld.217.2023.08.25.20.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 20:48:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZkI4-006bjY-2K;
        Sat, 26 Aug 2023 13:48:48 +1000
Date:   Sat, 26 Aug 2023 13:48:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Shawn <neutronsharc@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
Message-ID: <ZOl2IHacyqSUFgfi@dread.disaster.area>
References: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
 <20221129213436.GG3600936@dread.disaster.area>
 <CAB-bdyQw7hRpRPn9JTnpyJt1sA9vPDTVsUTmrhke-EMmGfaHBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-bdyQw7hRpRPn9JTnpyJt1sA9vPDTVsUTmrhke-EMmGfaHBA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 21, 2023 at 12:01:27PM -0700, Shawn wrote:
> Hello Dave,
> Thank you for your detailed reply.  That fallocate() thing makes a lot of sense.
> 
> I want to figure out the default extent size in my evn.  But
> "xfs_info" doesn't seem to output it? (See below output)

extent size hints are an inode property, not a filesystem geometry
property.  xfs_info only queries the later, it knows nothing about
the former.

# xfs_io -c 'stat' </path/to/mnt>

will tell you what the default extent size hint that will be
inherited by newly created sub-directories and files
(fsxattr.extsize).

> 
> Also, I want to use this cmd to set the default extent size hint, is
> this correct?
> $ sudo mkfs.xfs -d extszinherit=256    <== the data block is 4KB,  so
> 256 is 1MB.

Yes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
