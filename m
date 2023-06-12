Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C34AC7EE43
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 23:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbjFLXdi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 19:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjFLXdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 19:33:37 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C85D131
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 16:33:36 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b3db8f3d94so7473405ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 16:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686612816; x=1689204816;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3oW2wvanLNDVLi8SQKCLeldD3thr4auHckpgpMT2vwY=;
        b=iU1SiN80RF57itpqTfzAhf2LGYXkgNWcT0AxFOfSGbYj2FOFq4LeJc/zVfpYx2MvLR
         p8r+NytEBorFeRos4V3Yp9Ba9Ugh4t7Se0JWyiC9AqMoa8HLdWcYP6sWzZQ4Abnw3U3y
         PM5n/oatyapSXmSk6Ul2M2Lh2ZAyKR8IzyHVKPm0AJWLIZVbhAQubuqZtMDVtMNrI9ps
         lz8k0jp0nAzUeWoi1IST6+189pI+K4EmNeQzEDjemCWXpb2O/V8ftlPf4v0cTvgmFVoW
         yrQ8t0JM1kiEPmpHAS2HbCoCVMma+EhutmQwN1wYEPuaoDWaKkwnGccPrI5z9XCovVQR
         EZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686612816; x=1689204816;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3oW2wvanLNDVLi8SQKCLeldD3thr4auHckpgpMT2vwY=;
        b=Vmx96RfahxjX89o+K7M9PumjGiOmHXRtb6vJL4u/+YDLeN+pInH9BrMOGwvG0+ez+C
         HwwSBK4UMcrPkCDUqO1m09WWu1dtUAnta9HjfbXZQD9MyklrUcfUT6UpLPu6X6sMOBkf
         ESI+JCg50gdv7fvLDHluuZ8M+slXupbJ92GlAifGOwKv6cIKPLj17HYCMdI1zVyR8tKg
         SNGB51VxvLjwrDzm34Tr7YgU11WJyo27PoPcPyz+8jPZFVwrLxxapaV18yNBCdrxraaH
         ceh1/0MDaioXhiqKzfH2eOVWkXhAzrmUKU93GF+SnZCqbmRCjNLqQd4+LO0LM8eaxZrj
         a0Yg==
X-Gm-Message-State: AC+VfDxDdQhXrTl+ox+c8oo6Tj78r/iuNOyEaoMQKSyisyyOXTe8/j6F
        +x70oqWO8brZS8NUkz/uOBD5JA==
X-Google-Smtp-Source: ACHHUZ7IWhsllUiGaSXZTEgiYETMEZwPdTHQQgKWfq0KusizoUS3ojI+DXsx1M/Xb57G/h7YDc2dyw==
X-Received: by 2002:a17:902:da8b:b0:1b0:3742:e718 with SMTP id j11-20020a170902da8b00b001b03742e718mr8441406plx.25.1686612816031;
        Mon, 12 Jun 2023 16:33:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902d38c00b001b0f727bc44sm1845758pld.16.2023.06.12.16.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 16:33:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q8r2S-00B436-01;
        Tue, 13 Jun 2023 09:33:32 +1000
Date:   Tue, 13 Jun 2023 09:33:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
Message-ID: <ZIerS38zdUlU7zo3@dread.disaster.area>
References: <20230612153629.GA11427@frogsfrogsfrogs>
 <CAHk-=wiN-JcUh4uhDNmA4hp26Mg+c2DTuzgWY2fZ6hytDtOMCg@mail.gmail.com>
 <af31cadf-8c15-8d88-79fb-066dc87f0324@kernel.dk>
 <13d9e4f2-17c5-0709-0cc0-6f92bfe9f30d@kernel.dk>
 <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com>
 <212a190c-f81e-2876-cf14-6d1e37d47192@kernel.dk>
 <CAHk-=wh0hrFjcU5C8uHvLBThrT5vQsFHb7Jk6HRP3LAJqdNx1A@mail.gmail.com>
 <ff34a007-fdd0-8575-8482-919ead39fc88@kernel.dk>
 <CAHk-=whXt9+-YfhgjBYxT9_ATjHbMDZ0yJdK7umrJGU8zBVZ9w@mail.gmail.com>
 <CAHk-=wjqVEdigZWMoOUMr0J179vfA4G=MwafFh8UStsA-3mHBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wjqVEdigZWMoOUMr0J179vfA4G=MwafFh8UStsA-3mHBw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 11:34:28AM -0700, Linus Torvalds wrote:
> On Mon, Jun 12, 2023 at 10:51 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Ok, can you (and the fsstress people) confirm that this
> > whitespace-damaged patch fixes the coredump issue:
> 
> The proper patch from Jens is now in my tree, and I'm archiving this
> thread on the assumption that it's all good.
> 
> Dave/Zorro - if you still see any issues with that patch in place, holler.

The fix seems to work. The reproducer just ran through 50 times
without fail; it was previously always failing on the first or
second cycle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
