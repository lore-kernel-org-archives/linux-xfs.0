Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931A8C76195
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Mar 2023 02:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjC1C6Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Mar 2023 22:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjC1C6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2023 22:58:15 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C282717
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2023 19:58:13 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so11063875pjl.4
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2023 19:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679972293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLyr4+am2V6lTxnJ8lU/XXtylgWPWBoWpTubGjemSVQ=;
        b=kmDKU3gH92RhdilP0wGx1LLk9gbqJfyl3gqvqUqlbrmn20ntkJNvBrQGFm6f4lBZYg
         cM9JO2XR2Geh7dy2LXv0AAuie7zc9tegJ1y9sDZf69TvmRqw6z3b2xLcgf1yZ1WdoWmT
         nYTNQVjIiSwPQCDP+UOj/Rl33mUVo9VJFIvXl1DnWt5WZdjDcecayQrnpdkWDTB98EHw
         7ReeVUrj0Ih2stNsmEU0h9e5LslOc2jCuCRCVA1mnBuSk4XHigKIOBsqyxcgNGrff4U2
         UCSoTt5fr1i74hcrVfjvVCww8u6KQGYrueDnomWZhk+jwy5TqbQ0ifKTahln9k0gjfrg
         ssAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679972293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLyr4+am2V6lTxnJ8lU/XXtylgWPWBoWpTubGjemSVQ=;
        b=7Qa7koS+lfVYgeLWuvnk/AMDwXuaiRW6MuFKocyB0nI93kuWuax4Tzk2yTk5WrkNLt
         cdQxrUdXL2qw1yKIj3Sbc4cYyL2og06/Wc3R/Qz6sQs69Qk3v0r9gOiEjnbdcIWw9bZo
         CMc+jYcQdlsqe7amWkbPJD98nZNiR0IBYJXpdHP/s31+FBDUxms0K8kumC/4KORYq9nK
         df6hsElNfLSqWfQJrDcDXy9fj2KbAfpUczuBGHffDcnFyXj5GxNS75w7suf45Du7FLa8
         MaIk1cbCYYm7CCRtgad+UWtDybpHI/sqvwJ6xB800TDntf9kblpwA0O8LdiR2SZOg1Gp
         XXtg==
X-Gm-Message-State: AAQBX9fSBwZuR7BfqwWcYDH7sicFFcqexn6EmmupNnJ1CTqxUtLC3xEr
        698e+ZQCsqf56dUMLGih7r6s5Q==
X-Google-Smtp-Source: AKy350boePZL/k+e/5zgAUJHntZnkIfcpGxyEqAU4SoJTANNN1+CWs53DamuoB1Xse9ssD99/kivLA==
X-Received: by 2002:a17:902:d2ce:b0:19c:e664:5e64 with SMTP id n14-20020a170902d2ce00b0019ce6645e64mr18220668plc.2.1679972292889;
        Mon, 27 Mar 2023 19:58:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id p23-20020a1709027ed700b0019ee0ad15b4sm19719243plb.191.2023.03.27.19.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 19:58:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pgzXF-00E0yH-R0; Tue, 28 Mar 2023 13:58:09 +1100
Date:   Tue, 28 Mar 2023 13:58:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "yebin (H)" <yebin10@huawei.com>, Ye Bin <yebin@huaweicloud.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix BUG_ON in xfs_getbmap()
Message-ID: <20230328025809.GC3223426@dread.disaster.area>
References: <20230327140218.4154709-1-yebin@huaweicloud.com>
 <20230327151524.GC16180@frogsfrogsfrogs>
 <64224406.5090106@huawei.com>
 <20230328014328.GG16180@frogsfrogsfrogs>
 <ZCJHSsqk4SJEDOTC@infradead.org>
 <20230328020341.GH16180@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328020341.GH16180@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 27, 2023 at 07:03:41PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 27, 2023 at 06:47:54PM -0700, Christoph Hellwig wrote:
> > On Mon, Mar 27, 2023 at 06:43:28PM -0700, Darrick J. Wong wrote:
> > > <shrug> Seeing as the data fork mappings can change the instant the
> > > ILOCK drops, I'm not /that/ worried about users seeing a delalloc
> > > mapping even if the user requested a flush.  The results are already
> > > obsolete when they get to userspace, unless the application software has
> > > found another means to lock out access to the file.
> > 
> > That is true, but then again the users asked to not see delalloc
> > mappings, so we really shouldn't report one, right?
> 
> Yeah, I suppose so.  I wonder how many programs there are out there that
> don't pass in BMV_IF_DELALLOC /and/ can't handle that?  But I suppose
> taking MMAP_EXCL is good enough to shut up the obvious assertion vector.

Why not just skip it? Take the flush completion as being a
point-in-time snapshot where there are no delalloc extents, and if
any new ones have been created racily, just skip them as being
"after" the flush and so don't get reported...

> The COW implementation probably ought to be doing the flush too.

Yup, and then just skip any delalloc extents found after that, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
