Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BCEC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 23:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiKCXGU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 19:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiKCXFr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 19:05:47 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9539F2098B
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 16:05:46 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id i3so2978849pfc.11
        for <linux-xfs@vger.kernel.org>; Thu, 03 Nov 2022 16:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tJCllttmibhNCQwFie0bmyQKbcw2MJMVuYNYg2R4nSQ=;
        b=qY3h4Wywx9Wo8pVZzQ7E5PW8geOq2iu8o+/eGAhHImnpweZIe9KY7MEgtyVLhiKa5i
         fR4Tvnzhk50GT34N3gDB4Md3BLroyExtPxU1Q4pSc0OT6p3GD7BLfzNKg3CbZXEbDXW+
         DOIifTvFBPBTvhrmh/AClhVvoyFafSyezQC4cgUN6e4az4p86l3iF5y02jqdzBrblAbs
         Ccn7cS17Wy5chnfuI0FSWRoP6gHhfboK4sEi3eS9649Kr7xjTu6igXU31Ana0lcNi7JH
         xpUSlDYcSrpzkRkQco/ZzklIdzEPQsCShPQoViGZqccdnyGFkl5uCtvswTdFWqQ1p4UX
         LY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJCllttmibhNCQwFie0bmyQKbcw2MJMVuYNYg2R4nSQ=;
        b=7syqFLkf3REBVvXFuOclWFHlgX6o5gTJ/mMsG+UxOVOuhoRwP+g//dsHY/XhZxGkTP
         fKeTiD6XOYztJ5/uf8nOVoBsN9ZzwTHJYQOwmex1Qr5BoPPVrmY+qSd5QwZs9YyU6Ix5
         X6BVZe+JCQiwGewU4d2NgJPxGeKdkQnENAfOKkWyAs+Uh04so87X7ly00sdrGcWM1FaB
         liDkIfT0FuVADox9HfFprcZk/8aIN66QbQHviOlhS8KkNrf/8+R6jr32FWZA1Y5GwGZB
         SbYJevwuuuBakkQHTGEFgKZ3QED1tSvr9zLJs+XO17YiPxjOtSeUMOIR0txAYCxOBzPI
         JpqQ==
X-Gm-Message-State: ACrzQf0qcT1CwpYWSqp9XyYFMLHuCrnnuLBPNdaN1c1cIDcDfWg6wkmk
        9mM+9bO2qcgqa1FtJaREyMVbrg==
X-Google-Smtp-Source: AMsMyM4qIElnDr/QXrW9Mu4E7RvNkDW74UaI2QPCWjYc+9r2+0hWK8p5CJ3N/cbcQvosAf5N6zyNGg==
X-Received: by 2002:a63:ef48:0:b0:470:3fc:c475 with SMTP id c8-20020a63ef48000000b0047003fcc475mr10881922pgk.333.1667516746123;
        Thu, 03 Nov 2022 16:05:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id n7-20020a056a00212700b00561b3ee73f6sm1302502pfj.144.2022.11.03.16.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 16:05:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqjHK-009wxE-Nq; Fri, 04 Nov 2022 10:05:42 +1100
Date:   Fri, 4 Nov 2022 10:05:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Zirong Lang <zlang@redhat.com>
Subject: Re: [PATCH v2] xfs: extend the freelist before available space check
Message-ID: <20221103230542.GK3600936@dread.disaster.area>
References: <20221103094639.39984-1-hsiangkao@linux.alibaba.com>
 <20221103131025.40064-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103131025.40064-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2022 at 09:10:25PM +0800, Gao Xiang wrote:
> There is a long standing issue which could cause fs shutdown due to
> inode extent to btree conversion failure right after an extent
> allocation in the same AG, which is absolutely unexpected due to the
> proper minleft reservation in the previous allocation.  Brian once
> addressed one of the root cause [1], however, such symptom can still
> occur after the commit is merged as reported [2], and our cloud
> environment is also suffering from this issue.
> 
> From the description of the commit [1], I found that Zirong has an
> in-house stress test reproducer for this issue, therefore I asked him
> to reproduce again and he confirmed that such issue can still be
> reproducable on RHEL 9.
> 
> Thanks to him, after dumping the transaction log items, I think
> the root cause is as below:
>  1. Allocate space with the following condition:
>     freeblks: 18304 pagf_flcount: 6
>     reservation: 18276 need (min_free): 6
>     args->minleft: 1
>     available = freeblks + agflcount - reservation - need - minleft
>               = 18304 + min(6, 6) - 18276 - 6 - 1 = 27
> 
>     The first allocation check itself is ok;
> 
>  2. At that time, the AG state is
>     AGF Buffer: (XAGF)
>         ver:1  seq#:3  len:2621424
>         root BNO:9  CNT:7
>         level BNO:2  CNT:2
>         1st:64  last:69  cnt:6  freeblks:18277  longest:6395
                                  ^^^^^^^^^^^^^^

Hold on - pag->pagf_freeblks != agf->freeblks, and if we start with
the agf freeblocks:

	available = 18277 + 6 - 18276 - 6 - 1 = 0

IOWs, the allocation should never selected this AG in the first
place.

So why is pag->pagf_freeblks not equal to agf->freeblks when this
allocation was first checked? It's clearly not because the AGFL is
unpopulated - both the perag and the agf indicate it has the minimum
6 blocks already allocated....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
