Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F51DC7EE2E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 11:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbjFLLjC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 07:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjFLLiM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 07:38:12 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA107EE2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 04:27:28 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-25baf2120d7so1594842a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 04:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686569248; x=1689161248;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HOWI21B75ASkWGO+WORn/+w003EKs+yAHQxQRLz4/zA=;
        b=h2SWT9IgOYJwvSX7kRGbSjVvLXchJCdbCghd+9UWoHqN5kDlF3Z+vH8G8uD7qxx2nr
         wLQO+cWxgM5Fu1SC6jqElX/ca+4rWDILjJBU63cW/B68yCQwicZWS6UqjsyT7mZlvXLg
         5Ce9TkMAYb2xUvVvMKru/CC04TtTDu4jxoroFtYJQgOqOfuuytZOtow1oGT6L+dtn4Qe
         D/zb5Uwdr2AOYiyy68HgKEpAICDETjN1rU04PYW8ghEVa30T3TIOdPyD1rmAvsi/TPwr
         c2DDRJxihHhe0fDH+xf5+aLRKMhhYGmNxWK7RnJWLeCJNV6m9Hgi5v6YQTFS9dO8L++P
         D34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686569248; x=1689161248;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HOWI21B75ASkWGO+WORn/+w003EKs+yAHQxQRLz4/zA=;
        b=C84UmB/z3v7jkQJWj7z3cXjkMQ278PQzIzJPYw25iCF1R1DzajQDmhqdC35JcgH/p/
         4BhW5X2+1qpFg/zPKSljP5dsaEUUbhX4styDjPHh0rD0MrYfNTbAFo6Lm2iLDiw6xoe8
         F9DAT10VVualHyN2kG7P6W9y8lkRIoqvHwxjJJgwyCcQCr07JJAaMfiTMdxRRm1dKXcV
         EH/mqAnaschWk+BAHa/G1PmBCXwxASuzwm3E/mVuInMW0eflcpbgqFK4o+/I5VNSE/+8
         lqnTtgELqy/k2d96ocH9g3uKrYgrTAjiAU9mmVeeP+vJjh+nMz6HKl5PYWiRcPv0t+VK
         VIpQ==
X-Gm-Message-State: AC+VfDwhoa67cYK5wt0EEn8cHRsD3JNw6rdqdkBThwcUVMP7MEkrkoDS
        PqE5TMM/47DuF3Hh9Tbgqz8TRgkgjnwsHWkcbGQ=
X-Google-Smtp-Source: ACHHUZ5RVvZVxaTBU4dEGCYOtfmPsR3k6Ij3e1NSvGy23zMOAWhLHFiKqksmr3WxtOS0bQJ6AVem1w==
X-Received: by 2002:a17:90a:f312:b0:250:9e7b:2798 with SMTP id ca18-20020a17090af31200b002509e7b2798mr7962839pjb.18.1686569247771;
        Mon, 12 Jun 2023 04:27:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id ij14-20020a17090af80e00b002502161b063sm9011135pjb.54.2023.06.12.04.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 04:27:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q8fhk-00ArMQ-0U;
        Mon, 12 Jun 2023 21:27:24 +1000
Date:   Mon, 12 Jun 2023 21:27:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
Message-ID: <ZIcBHH4ITLiQNCqK@dread.disaster.area>
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area>
 <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area>
 <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <ZIaqMpGISWKgHLK6@dread.disaster.area>
 <CAHk-=wgwJptCbaHwt+TpGgh04fTVAHd60AY3Jj1rX+Spf0fVyg@mail.gmail.com>
 <ZIax1FLfNajWk25A@dread.disaster.area>
 <CAHk-=wj0NuJaRNC4o6FVAJgKAFJ5HWcBV5VJw6RGV0ZahqOOZA@mail.gmail.com>
 <87r0qhrrvr.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r0qhrrvr.fsf@email.froward.int.ebiederm.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 03:45:12AM -0500, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Sun, Jun 11, 2023 at 10:49 PM Dave Chinner <david@fromorbit.com> wrote:
> >>
> >> On Sun, Jun 11, 2023 at 10:34:29PM -0700, Linus Torvalds wrote:
> >> >
> >> > So that "!=" should obviously have been a "==".
> >>
> >> Same as without the condition - all the fsstress tasks hang in
> >> do_coredump().
> >
> > Ok, that at least makes sense. Your "it made things worse" made me go
> > "What?" until I noticed the stupid backwards test.
> >
> > I'm not seeing anything else that looks odd in that commit
> > f9010dbdce91 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps
> > regression").
> >
> > Let's see if somebody else goes "Ahh" when they wake up tomorrow...

....

> About the only thing I can image is if io_uring is involved.  Some of
> the PF_IO_WORKER code was changed, and the test
> "((t->flags & (PF_USER_WORKER | PF_IO_WORKER)) != PF_USER_WORKER)"
> was sprinkled around.
> 
> That is the only code outside of vhost specific code that was changed.
> 
> 
> Is io_uring involved in the cases that hang?

Yes. fsstress randomly uses io_uring for the ops that it runs.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
