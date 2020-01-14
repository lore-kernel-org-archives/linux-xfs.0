Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3C0C33C9E
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 19:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9753424670
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 19:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="oPrqQqSe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgANT1D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 14:27:03 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34395 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728808AbgANT1C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 14:27:02 -0500
Received: by mail-qt1-f194.google.com with SMTP id 5so13536989qtz.1
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2020 11:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aJt6sr02+cPWFTf++BZXppcl8L9Qc4Zp51cj05VTask=;
        b=oPrqQqSe/ADv8qbMh9YJz6dG8lmq0i8sYcGqcKoHUevTV/iKnZZdCh1Zl9pqk7gfjy
         HYWWbwQp7/zq8Xif8qLlCBaRykT7I0Y20XZR9d4vI4H4yUa7ZQkaOSXqOTIdw5Pd4GLx
         2dqFBW3x3atoix9XhEkom81Zh6wsgnl/EYNywLM+dy1DLUlEoIrR9ivzk6iqGM+4uTg1
         C6NHzcU46ysDJZGjUMoBIDGO8XcK6I6OB8oBQkmcj5JopfmgztE7lYRFpjGRyn1WZKhx
         6ykQT1i82ZStGLCZpydQ1Hjf7Fnf+GIPYnsiIs7k3sxdVnOXQdqhg2FuLSeaYtalcKYV
         iE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aJt6sr02+cPWFTf++BZXppcl8L9Qc4Zp51cj05VTask=;
        b=ODtJ/PAmMCp0FvwD0WaEV3A75tk1ylt7ma6NFgUFTFFN2l+49ckzXVFib526yoRoeb
         hx3gw+xX43VnB4AZPgUwH1Xu0v6gQ2iJ0gdR6cagdAI6dmuOJEIllNzKnVdZpU1qE7hs
         eeB1lQBKGzvKVG4RbpwgE0Axe4pKwxaLXbmwfwoIG5rbAGBebKHjnwp7p5EqwJrXd23f
         h32fQdmxaWSKQPv5pex4kBKQw8LqUb1muW3uhk0j2Qsvd+ZIW1JP61LrbqzRMOTt1qFJ
         55uEs02v1ULeKr4Hak0IJZN6XYviWA9487heDqjc2XVfo3sEGXcL0kwNT5GjQCV84zpa
         YQtA==
X-Gm-Message-State: APjAAAXvKbOg8DvX8wlVUwB6ADHHkcQbofvO3hIsGF8u/wpEaHDYPGbL
        f7klY3gpt7449qmyOt9mAJPNbA==
X-Google-Smtp-Source: APXvYqySNCcNEO4FrkFCq2T3jATCYAK3ivaV1e2ZWAedX1tbYHW/XNiQzo5q+3L4u1x3cX9oTES0GA==
X-Received: by 2002:aed:2465:: with SMTP id s34mr158395qtc.158.1579030021872;
        Tue, 14 Jan 2020 11:27:01 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 17sm8063238qtz.85.2020.01.14.11.27.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jan 2020 11:27:01 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1irRq8-0006GA-MO; Tue, 14 Jan 2020 15:27:00 -0400
Date:   Tue, 14 Jan 2020 15:27:00 -0400
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
Message-ID: <20200114192700.GC22037@ziepe.ca>
References: <20200114161225.309792-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114161225.309792-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 05:12:13PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> Asynchronous read/write operations currently use a rather magic locking
> scheme, were access to file data is normally protected using a rw_semaphore,
> but if we are doing aio where the syscall returns to userspace before the
> I/O has completed we also use an atomic_t to track the outstanding aio
> ops.  This scheme has lead to lots of subtle bugs in file systems where
> didn't wait to the count to reach zero, and due to its adhoc nature also
> means we have to serialize direct I/O writes that are smaller than the
> file system block size.

I've seen similar locking patterns quite a lot, enough I've thought
about having a dedicated locking primitive to do it. It really wants
to be a rwsem, but as here the rwsem rules don't allow it.

The common pattern I'm looking at looks something like this:

 'try begin read'() // aka down_read_trylock()

  /* The lockdep release hackery you describe,
     the rwsem remains read locked */
 'exit reader'()

 .. delegate unlock to work queue, timer, irq, etc ..

in the new context:

 're_enter reader'() // Get our lockdep tracking back

 'end reader'() // aka up_read()

vs a typical write side:

 'begin write'() // aka down_write()

 /* There is no reason to unlock it before kfree of the rwsem memory.
    Somehow the user prevents any new down_read_trylock()'s */
 'abandon writer'() // The object will be kfree'd with a locked writer
 kfree()

The typical goal is to provide an object destruction path that can
serialize and fence all readers wherever they may be before proceeding
to some synchronous destruction.

Usually this gets open coded with some atomic/kref/refcount and a
completion or wait queue. Often implemented wrongly, lacking the write
favoring bias in the rwsem, and lacking any lockdep tracking on the
naked completion.

Not to discourage your patch, but to ask if we can make the solution
more broadly applicable?

Thanks,
Jason
