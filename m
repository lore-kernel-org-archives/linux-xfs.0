Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A94C001B0
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Aug 2023 22:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjHFWiz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Aug 2023 18:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjHFWiy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Aug 2023 18:38:54 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D040FA
        for <linux-xfs@vger.kernel.org>; Sun,  6 Aug 2023 15:38:53 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bc63ef9959so9024985ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 06 Aug 2023 15:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691361532; x=1691966332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cYsSn3cCK3EJnEI451xZvecqInTy0kcOHhqtjgp+evQ=;
        b=eSHOzcsou+RZS9UjAMpg6e9mz1nbHsOAmE89Cnu8hzYM8Hbgn983d3yBSd7zCeHSvq
         aWd9nphdqwlhodL/y+ShA5UWq/8KZXa32EtPDtl+pF4k0Dx/PORG+IxvMzYPql4k/XWJ
         NsT1KgwpxUip6Iy6V+RI4Nu39O/U7Sowt5oYAaoEWS+yPf6iumQoctMC99y20QqJA/Hl
         s0/is66Lt7N1mz7D8XtX/3qy5GPlScKKH7CD4+3/M0xQx7OB4iVYv4CJOhVFbqrBjf6I
         qQsV8oH49//9R7YZXKeCYhSZ5hNsQ3Ui2AgsLmY0FKvgdDrqznf/RPFFj7x++1ATVa4P
         CnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691361532; x=1691966332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYsSn3cCK3EJnEI451xZvecqInTy0kcOHhqtjgp+evQ=;
        b=W3sA602tdiiUmj2t2ao4uyQFJ3hS3IwOZDET8CiNAXLq0TgT4s6c7Dqc5FUr33FuW+
         5VFtIxrDmL9Vdz/Gd7BnpQkSggz91jDeZzG/kIgkYuzicC61dLnR4UD8zNbO2X/wpofS
         cMXub4lZvnuz09DHgRqPP148XSjQCgpTe2RTxEZ/atas0hVG2tsS6R9jp2L8cfxGmZxy
         QAQlcnnkAGNSZ1BMLeVWxfXNnAQ31CE8KvGUNYGAiKNu9d1vPv0wcIHbbyVcq/Smtwh8
         ducSR4rrneZuEFiOa/+p4L31lE5oga0m1uHQS170cBD64iJ1OkQE7N5d0VzFq+ozLp5l
         RIfw==
X-Gm-Message-State: AOJu0Yz5Vua1wPKKF9s1pgM7idXdG4kwWP3Qfm89UdZMtEpj8TqFn3nx
        FM6pCawDgyjFJDp+HwwX8pVBFIjIgj+YQsu6088=
X-Google-Smtp-Source: AGHT+IFbOeUDxLffvXXfeiT9SRyH3Py0ch3ewYFxYPaXwNcIEbm8t0Pdxp1FylavhCQNYTPBpLGcRg==
X-Received: by 2002:a17:903:456:b0:1b7:ffb9:ea85 with SMTP id iw22-20020a170903045600b001b7ffb9ea85mr7417777plb.29.1691361532415;
        Sun, 06 Aug 2023 15:38:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id je19-20020a170903265300b001b9dab0397bsm5342402plb.29.2023.08.06.15.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Aug 2023 15:38:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qSmOe-0021ei-2C;
        Mon, 07 Aug 2023 08:38:48 +1000
Date:   Mon, 7 Aug 2023 08:38:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Corey Hickey <bugfood-ml@fatooh.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: read-modify-write occurring for direct I/O on RAID-5
Message-ID: <ZNAg+K+eFjaVt6+y@dread.disaster.area>
References: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
 <ZMyxp/Udved6l9F/@dread.disaster.area>
 <db157228-3687-57bf-d090-10517847404d@fatooh.org>
 <ZM1zOFWVm9lD8pNc@dread.disaster.area>
 <0f21f5eb-803f-c8d1-503a-bb0addeef01f@fatooh.org>
 <ZM7PHRsOqfJ71fMN@dread.disaster.area>
 <6ac1f404-2cd2-42db-87b3-e1c7d5933a2d@fatooh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ac1f404-2cd2-42db-87b3-e1c7d5933a2d@fatooh.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 06, 2023 at 11:21:38AM -0700, Corey Hickey wrote:
> On 2023-08-05 15:37, Dave Chinner wrote:
> > On Fri, Aug 04, 2023 at 06:44:47PM -0700, Corey Hickey wrote:
> > > On 2023-08-04 14:52, Dave Chinner wrote:
> > > > On Fri, Aug 04, 2023 at 12:26:22PM -0700, Corey Hickey wrote:
> > > > > On 2023-08-04 01:07, Dave Chinner wrote:
> > > > > > If you want to force XFS to do stripe width aligned allocation for
> > > > > > large files to match with how MD exposes it's topology to
> > > > > > filesytsems, use the 'swalloc' mount option. The down side is that
> > > > > > you'll hotspot the first disk in the MD array....
> > > > > 
> > > > > If I use 'swalloc' with the autodetected (wrong) swidth, I don't see any
> > > > > unaligned writes.
> > > > > 
> > > > > If I manually specify the (I think) correct values, I do still get writes
> > > > > aligned to sunit but not swidth, as before.
> > > > 
> > > > Hmmm, it should not be doing that - where is the misalignment
> > > > happening in the file? swalloc isn't widely used/tested, so there's
> > > > every chance there's something unexpected going on in the code...
> > > 
> > > I don't know how to tell the file position, but I wrote a one-liner for
> > > blktrace that may help. This should tell the position within the block
> > > device of writes enqueued.
> > 
> > xfs_bmap will tell you the file extent layout (offset to lba relationship).
> > (`xfs_bmap -vvp <file>` output is prefered if you are going to paste
> > it into an email.)
> Ah, nice; the flags even show the alignment.
> 
> Here are the results for a filesystem on a 2-data-disk RAID-5 with 128 KB
> chunk size.

....

> $ sudo xfs_bmap -vvp /mnt/tmp/test.bin
> /mnt/tmp/test.bin:
>  EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET          TOTAL FLAGS
>    0: [0..7806975]:         512..7807487        0 (512..7807487)   7806976 000000
>    1: [7806976..15613951]:  7864576..15671551   1 (512..7807487)   7806976 000011
>    2: [15613952..20971519]: 15728640..21086207  2 (512..5358079)   5357568 000000

Thanks for that, I think it points out the problem quite clearly.
The stripe width allocation alignment looks to be working as
intended - the "AG-OFFSET" column has the same values in each extent
so within the AG address space everything is correctly "stripe
width" aligned.

What we see here is a mkfs.xfs "anti hotspot" behaviour with striped
layouts. That is, it automagically sizes the AGs such that each AG
header sits on a different stripe unit within the stripe so that the
AG headers don't end up all on the same physical stripe unit.

That results in the entire AG being aligned to the stripe unit
rather than the stripe width. And so when we do stripe width aligned
allocation within the AG, it assumes that the AG itself is stripe
width aligned, which it isn't....

So, if you were to do something like this:

# mkfs.xfs -d agsize=1048576b ....

To force the AG size to be a multiple of stripe width, mkfs will
issue a warning that it is going to place all the AG headers on the
same stripe unit, but then go and do what you asked it to do.

That should work around the problem you are seeing, meanwhile I
suspect the swalloc mechanism might need a tweak to do physical LBA
alignment, not AG offset alignment....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
