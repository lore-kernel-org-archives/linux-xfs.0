Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73357CA0EC7
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 01:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbjILBhY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Sep 2023 21:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbjILBhD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2023 21:37:03 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AA219046
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 15:31:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-68fbd31d9ddso1245753b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 15:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694471399; x=1695076199; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ok19BPXq/ZtE5Je9WteUjIQMcW5gGGmyf4q0shWhFBg=;
        b=u7/ql1ukhFXacxtlbTooLtjtjV/YLqbILhFDKWQm/DH4J9XtceDRrscxKAaW5248wV
         h2FLz8evkoCyxPItpNjw7BZQz5Jn7uAfzT2AtRf6g+iVEHSh+Nyx5prvfyf8su0fFrV+
         T634xqYPVJrEuh6vh79m17MjShltz0L388aMywNIuII3b5+Vl7T8SDwVnSwcEFIbj9eB
         eZAp0cJQEnxXVR9lgi169TJjstB8c95wsr0xUqRZSqfeWKeLs6iRSU6zdlZB0RJvSlVz
         54FG5d4xnbCi91MYnsFsaLx8U7k8c9bYUgzzDMX71U7zTEhlou2Gr/71UkaWNcZ7lw7A
         rkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694471399; x=1695076199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ok19BPXq/ZtE5Je9WteUjIQMcW5gGGmyf4q0shWhFBg=;
        b=nNyyl1JUAva4/Yfcmm45pw36pWyHSLsSjtTwcTH9/s5I01nAc86xxWswQeNGV/0Xmt
         2TFkuqJitlvVgctdU1H/f/zQ3dl8lvPBJiU0+egs6I/f2x+vmnOLBC30FdEWa6QLl9GV
         N2carvTd9G3E3gFwYloUQ3yV35a9Fz6QRloq+JzT/bbb1/IcbXs/aDl0WPHWdNxRrbuS
         bE9y6xdSQj0imF8zGBJDKYKKGMB7tT1WllfUsaHLh0rfPWJLXs8Ud1MT8vLhynee/4vI
         ys1INN2tXa2WG9+lAcOZ8+PHY4gybugNKOaj6zzIs8iooDmFHBJqbMsiMuEnqxQpl1JC
         WA1w==
X-Gm-Message-State: AOJu0YwSmEdpuVDpdM9KCfU3ER7KsbvkmlklSDxQVnIGKQ66BTdXu6bh
        oiBdNi3Wto6YcHW/XR0TiVD2oQ==
X-Google-Smtp-Source: AGHT+IE/LaOllEbOYogtobKnQv0RIkvkE2D1hgCfX1NOJa1hWXTzgr9ZPscNFI5RdpRx8ePwENieLg==
X-Received: by 2002:a05:6a21:6da9:b0:148:f16f:113f with SMTP id wl41-20020a056a216da900b00148f16f113fmr10528676pzb.12.1694471398931;
        Mon, 11 Sep 2023 15:29:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id g14-20020a056a001a0e00b0068fba4800cfsm2979220pfv.56.2023.09.11.15.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 15:29:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qfpPn-00Dy3W-0c;
        Tue, 12 Sep 2023 08:29:55 +1000
Date:   Tue, 12 Sep 2023 08:29:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] locking: Add rwsem_is_write_locked()
Message-ID: <ZP+U49yfkm0Fpfej@dread.disaster.area>
References: <20230907174705.2976191-2-willy@infradead.org>
 <20230907190810.GA14243@noisy.programming.kicks-ass.net>
 <ZPoift7B3UDQgmWB@casper.infradead.org>
 <20230907193838.GB14243@noisy.programming.kicks-ass.net>
 <ZPpV+MeFqX6RHIYw@dread.disaster.area>
 <20230908104434.GB24372@noisy.programming.kicks-ass.net>
 <ZP5JrYOge3tSAvj7@dread.disaster.area>
 <ZP5OfhXhPkntaEkc@casper.infradead.org>
 <ZP5llBaVrJteHQf3@dread.disaster.area>
 <70d89bf4-708b-f131-f90e-5250b6804d48@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70d89bf4-708b-f131-f90e-5250b6804d48@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 10, 2023 at 10:15:59PM -0400, Waiman Long wrote:
> 
> On 9/10/23 20:55, Dave Chinner wrote:
> > On Mon, Sep 11, 2023 at 12:17:18AM +0100, Matthew Wilcox wrote:
> > > On Mon, Sep 11, 2023 at 08:56:45AM +1000, Dave Chinner wrote:
> > > > On Fri, Sep 08, 2023 at 12:44:34PM +0200, Peter Zijlstra wrote:
> > > > > Agreed, and this is fine. However there's been some very creative
> > > > > 'use' of the _is_locked() class of functions in the past that did not
> > > > > follow 'common' sense.
> > > > > 
> > > > > If all usage was: I should be holding this, lets check. I probably
> > > > > wouldn't have this bad feeling about things.
> > > > So your argument against such an interface is essentially "we can't
> > > > have nice things because someone might abuse them"?
> > > Some people are very creative ...
> > Sure, but that's no reason to stop anyone else from making progress.
> > 
> > > I was thinking about how to handle this better.  We could have
> > > 
> > > static inline void rwsem_assert_locked(const struct rw_semaphore *sem)
> > > {
> > > 	BUG_ON(atomic_long_read(&sem->count) == 0);
> > > }
> > > 
> > > static inline void rwsem_assert_write_locked(const struct rw_semaphore *sem)
> > > {
> > > 	BUG_ON((atomic_long_read(&sem->count) & 1) != 1);
> > > }
> > We already have CONFIG_DEBUG_RWSEMS, so we can put these
> > introspection interfaces inside debug code, and make any attempt to
> > use them outside of debug builds break the build. e.g:
> > 
> > #if DEBUG_RWSEMS
> > /*
> >   * rwsem locked checks can only be used by conditionally compiled
> >   * subsystem debug code. It is not valid to use them in normal
> >   * production code.
> >   */
> > static inline bool rwsem_is_write_locked()
> > {
> > 	....
> > }
> > 
> > static inline bool rwsem_is_locked()
> > {
> > 	....
> > }
> > #else /* !DEBUG_RWSEMS */
> > #define rwsem_is_write_locked()		BUILD_BUG()
> > #define rwsem_is_locked()		BUILD_BUG()
> > #endif /* DEBUG_RWSEMS */
> > 
> > And now we simply add a single line to subsystem Kconfig debug
> > options to turn on rwsem introspection for their debug checks like
> > so:
> > 
> >   config XFS_DEBUG
> >   	bool "XFS Debugging support"
> >   	depends on XFS_FS
> > +	select RWSEM_DEBUG
> >   	help
> >   	  Say Y here to get an XFS build with many debugging features,
> >   	  including ASSERT checks, function wrappers around macros,
> 
> That may be a possible compromise. Actually, I am not against having them
> defined even outside the DEBUG_RWSEMS. We already have mutex_is_locked()
> defined and used in a lot of places. So this is just providing the rwsem
> equivalents.

So, once again, we have mixed messages from the lock maintainers.
One says "no, it might get abused", another says "I'm fine with
that", and now we have a maintainer disagreement stalemate.

This is dysfunctional.

Peter, Waiman, please make a decision one way or the other about
allowing rwsems ito support native write lock checking. In the
absence of an actual yes/no decision, do we assume that the
maintainers don't actually care about it and we should just
submit it straight to Linus?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
