Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FF6C7EE25
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 05:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbjFLFuL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 01:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbjFLFtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 01:49:13 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F0910D3
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 22:49:12 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b3d29cfb17so4398905ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 22:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686548951; x=1689140951;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NOjT3kFEBS5OQNHw58+RCjy2pREgfJy/T9HBw6SYqdQ=;
        b=j2Liob38MVU/aNvJXnDtjyfvdpYpQvVJc0WwYjA8/a2zhKJA3VktzBDwSwOwuFL9e8
         vCOQhL8fF2taAzIAj0iiCbLV0gDco/8jkM8a8aGAL9cNyvmpQaUN9+I/E01Tu77jfQyD
         rJYTn+fp4LLXSzKEmbemwcahuC2MbHdNKA4lSxu/Umv90/tCC8vHqP6h1H7geMi8xyaH
         BO60yV/LZyH0t44Q4ohwgx5JJyHKIzH2jHGnbLh+fhS/cfk7qzqoO9gLPIEPX/19vSW+
         HDuybHRTpsJQveSC3EGqzlrAbJaTqTzj9xTNl+uF24l49/DzdsOz/LqTmPd5Rpv13bes
         YqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686548951; x=1689140951;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOjT3kFEBS5OQNHw58+RCjy2pREgfJy/T9HBw6SYqdQ=;
        b=Adu8RclEmY1T1Db4yHzI122v2WMECUEju34JAy6ZUar9A+kaQmcNDAWMoa7LJ+DO2+
         9qcBNjTu4Q8GvzjTZNVTVUyNQHkMKLfEY35Fbr07z3g5/pRNO5vn1ZoMTD3SwqPoQRnH
         vn7+ItDPsk/LYDy2EStEAQR+6rN7if9jH726vRUQST4EMUXvUOHqEFkixD8K4qLIXcyA
         ROIYp1N+k9zHFzhNQcpqh2hZuMRJnbHdRX555l6uk1zvP2IaCec9VbK/U5uYW5/hLUWl
         LYLOnDGZ2+2mTViYNxpMm3D1CwsIWBbBC6SgjL7IS45D+zLxDQQNPU7ipsMutkuUZVx5
         6kXA==
X-Gm-Message-State: AC+VfDxkNQuXRmeVAsL3EwSfqrmZy9Rs4fIwBDpriJ6C3Ufj1jpLxmRI
        WSoFUGlDthmPk2f4YntlMYLFzA==
X-Google-Smtp-Source: ACHHUZ5d5jC3sa0YBA9xrKGXBPG7fdfc9xdIKadlPGz0lbdIz163Ijnty4tHm3U5Uux7Faso9SsL4A==
X-Received: by 2002:a17:902:ce8a:b0:1b2:a63:95aa with SMTP id f10-20020a170902ce8a00b001b20a6395aamr6351219plg.54.1686548951300;
        Sun, 11 Jun 2023 22:49:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b001b03f208323sm7274749pll.64.2023.06.11.22.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 22:49:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q8aQO-00AlOI-1G;
        Mon, 12 Jun 2023 15:49:08 +1000
Date:   Mon, 12 Jun 2023 15:49:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
Message-ID: <ZIax1FLfNajWk25A@dread.disaster.area>
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area>
 <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area>
 <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <ZIaqMpGISWKgHLK6@dread.disaster.area>
 <CAHk-=wgwJptCbaHwt+TpGgh04fTVAHd60AY3Jj1rX+Spf0fVyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wgwJptCbaHwt+TpGgh04fTVAHd60AY3Jj1rX+Spf0fVyg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 11, 2023 at 10:34:29PM -0700, Linus Torvalds wrote:
> On Sun, Jun 11, 2023 at 10:16 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > > +             /* vhost workers don't participate in core dups */
> > > +             if ((current->flags & (PF_IO_WORKER | PF_USER_WORKER)) != PF_USER_WORKER)
> > > +                     goto out;
> > > +
> >
> > That would appear to make things worse. mkfs.xfs hung in Z state on
> > exit and never returned to the shell.
> 
> Well, duh, that's because I'm a complete nincompoop who just copied
> the condition from the other cases, but those other cases were for
> testing the "this is *not* a vhost worker".
> 
> Here the logic - as per the comment I added - was supposed to be "is
> this a vhost worker".
> 
> So that "!=" should obviously have been a "==".

Same as without the condition - all the fsstress tasks hang in
do_coredump().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
