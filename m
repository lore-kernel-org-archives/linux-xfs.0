Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6493C4741C
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 13:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE8C24679
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 13:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="N7p7slCg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAONYb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 08:24:31 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:45112 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgAONYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 08:24:30 -0500
Received: by mail-qv1-f66.google.com with SMTP id l14so7307045qvu.12
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 05:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JQDxitQ2kV6Oc8g1Nxnl8InwXqW6F+V+cnqQB5GX/Ak=;
        b=N7p7slCgV23Mblayrpfjr8Cs4qg0rXyzW7fIDxxF5tyrL+bvOaa4G+jk3bWXE5GIWa
         Ntfy8CrkOf/DaieT+JiP+jtZWEoU/lymYaCR21bKKmIwJk9fXB0ecZUAOOCdVWIVxNnG
         fJ3fXEiMLhm4t/mTXQMzdQN5tovBZWahXk8U70RuVf1pmTVtV3rCTemwhZ6ORdj6lKl7
         D5tKmSDIbWb9lNbfYEWJIgWMdzpCDqM0zVNerLc+GF+IWdxy6Ruxg+h7L0rs/CzOm3Sj
         /BuvX1x7xMVVGpYuTqVM9V+QZDxU7OWtFuGMsJWicrzT9FnwyDSisOy+/AHpghSXGtub
         CjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JQDxitQ2kV6Oc8g1Nxnl8InwXqW6F+V+cnqQB5GX/Ak=;
        b=HxAUhm3p9yDZXlWTKL+qn+Ec1tCnABOFLPgC6MHLU966EizyPCk4Q2t9htURzr+96E
         uDcBjJmQf7X5JxA692mRWpAd+FF+uTIQCFjVqnNU+SmYQoRgLSC0oTyu6tW9G7esZZGU
         tdUPUFT6VFWkcCVsZ0nBlzuR0DSY2nC+JVmHnP4R3Bqyw0VVaIoQCLttia3LcfTTvjmZ
         vg/l8is619L4IWfwndAUNC/zJdRFPau+9VM86IMbNd/C0SiXqnRCjro7bemREN5nMyq9
         AlzscyTrDwAPydnnr+vLlqM/vIrw/iFPc69xL7ZpcbUYyZ2q2G47UU8PFsvxPt1oxxtx
         J0sw==
X-Gm-Message-State: APjAAAWAiao1hUx6uvVYnkj5PQ98u0k+oAytPsFgpCUaOjSMe4yV9oIZ
        h+tWFVYIc67KwQeiWv2yH9lI3Q==
X-Google-Smtp-Source: APXvYqx6UQfK9lVHiSfTgP2tsd97lH+In54WqLxdvVCNYpS5wf/m93SemM+zVXgqN91OGZML192bFg==
X-Received: by 2002:ad4:4e86:: with SMTP id dy6mr22258073qvb.81.1579094669772;
        Wed, 15 Jan 2020 05:24:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id s26sm9366374qtq.22.2020.01.15.05.24.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Jan 2020 05:24:29 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1irieq-0006oi-6c; Wed, 15 Jan 2020 09:24:28 -0400
Date:   Wed, 15 Jan 2020 09:24:28 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: RFC: hold i_rwsem until aio completes
Message-ID: <20200115132428.GA25201@ziepe.ca>
References: <20200114161225.309792-1-hch@lst.de>
 <20200114192700.GC22037@ziepe.ca>
 <20200115065614.GC21219@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115065614.GC21219@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 07:56:14AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 14, 2020 at 03:27:00PM -0400, Jason Gunthorpe wrote:
> > I've seen similar locking patterns quite a lot, enough I've thought
> > about having a dedicated locking primitive to do it. It really wants
> > to be a rwsem, but as here the rwsem rules don't allow it.
> > 
> > The common pattern I'm looking at looks something like this:
> > 
> >  'try begin read'() // aka down_read_trylock()
> > 
> >   /* The lockdep release hackery you describe,
> >      the rwsem remains read locked */
> >  'exit reader'()
> > 
> >  .. delegate unlock to work queue, timer, irq, etc ..
> > 
> > in the new context:
> > 
> >  're_enter reader'() // Get our lockdep tracking back
> > 
> >  'end reader'() // aka up_read()
> > 
> > vs a typical write side:
> > 
> >  'begin write'() // aka down_write()
> > 
> >  /* There is no reason to unlock it before kfree of the rwsem memory.
> >     Somehow the user prevents any new down_read_trylock()'s */
> >  'abandon writer'() // The object will be kfree'd with a locked writer
> >  kfree()
> > 
> > The typical goal is to provide an object destruction path that can
> > serialize and fence all readers wherever they may be before proceeding
> > to some synchronous destruction.
> > 
> > Usually this gets open coded with some atomic/kref/refcount and a
> > completion or wait queue. Often implemented wrongly, lacking the write
> > favoring bias in the rwsem, and lacking any lockdep tracking on the
> > naked completion.
> > 
> > Not to discourage your patch, but to ask if we can make the solution
> > more broadly applicable?
> 
> Your requirement seems a little different, and in fact in many ways
> similar to the percpu_ref primitive.

I was interested because you are talking about allowing the read/write side
of a rw sem to be held across a return to user space/etc, which is the
same basic problem.

precpu refcount looks more like a typical refcount with a release that
is called by whatever context does the final put. The point above is
to basically move the release of a refcount into a synchrnous path by
introducing some barrier to wait for the refcount to go to zero. In
the above the barrier is the down_write() as it is really closer to a
rwsem than a refcount.

Thanks,
Jason
