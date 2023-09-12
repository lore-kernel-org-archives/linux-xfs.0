Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66485EE3F3F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 23:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbjILXQM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 19:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjILXQK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 19:16:10 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294C810F7
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 16:16:07 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1c397ed8681so29609805ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 16:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694560566; x=1695165366; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+9r0uKNgoHgA9k7pssqWbsfJtymb4YaeLhXN0MxfQSk=;
        b=DZE1dGR9JbRVOcH6YmJB8Tuadk2ZTUgoeH++sajuReUTsj8Ce2Fm+7eYYTdxkedFcW
         b1RLcyZtvrORgsD/IdzX86SCqXJfNWMNw6bCBZ0OuQYAs7Tc+lkvE4ymkaz/aIC+P/M9
         avKeKcm0l53cMjbwMkkhKjoYvMMdWnPV+LmUvPNmEHPELYT5tE/2KMAHGz9/WLrLgZE2
         BrCJk+QTLbSbkCMfgors3eoyM9Qa7rqnzrZ3XZejn7foz7KPWAqpU2L2qiuhOa43TdnD
         jy6V73ep8iHr0ePLObqnXxz2PqdvcFya+qnRB/oC64nUSnvhNrPTPhf4vJz20bC5lDSJ
         gkjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694560566; x=1695165366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9r0uKNgoHgA9k7pssqWbsfJtymb4YaeLhXN0MxfQSk=;
        b=MAbYUIALnrg+TEb9m29kVnf6AOs9nDDInv96AOxl61WSfgmoFwbZSIGgyPJAk0qE/V
         rlXakhzgoHC9Nwcqu6lk0M/DFAVzjQWTvlZTFT6BTdqHzjCQM1CdORUBZDIVq8GTHwG1
         fwGKUh8aj6fUngOGRvcVqXhPW0f9ssbjoXLSTJ+2YHgx8KIWgDH1vNJlQ51+k/IXLj06
         lySOA5cks28Y8YPUlTiRd4zkMGXHFEta6mP5Yo3iUkiBOJRPz2zZ0hSdGw1N5i7RTHmC
         LAeLgYXI5LV0uVPPqkEPETiRu8MWNCVpUQWLmHQhDAQPHOqsxgBUOkwCBWUcOO7PN0i1
         Y9+Q==
X-Gm-Message-State: AOJu0YwBb5ERnn83HaWu2Ot4PGxmj65YQD9zESlkxqocbKx42PH8XHrY
        kNmwx3ediiLrvWO4pCkppkjTYg==
X-Google-Smtp-Source: AGHT+IGKZdARZRmeluVcjP5PsUUVen4C9AzPnIa1JthH4Um4QkyYnNWIlrZ4Qvh0GCAr0FcFyH3tDg==
X-Received: by 2002:a17:903:1107:b0:1b8:b3f9:58e5 with SMTP id n7-20020a170903110700b001b8b3f958e5mr1595195plh.38.1694560566512;
        Tue, 12 Sep 2023 16:16:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id t7-20020a170902bc4700b001b7ffca7dbcsm9008283plz.148.2023.09.12.16.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 16:16:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qgCbz-00EQ6M-1G;
        Wed, 13 Sep 2023 09:16:03 +1000
Date:   Wed, 13 Sep 2023 09:16:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Waiman Long <longman@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] locking: Add rwsem_is_write_locked()
Message-ID: <ZQDxM3t8I6jIUMIF@dread.disaster.area>
References: <ZPoift7B3UDQgmWB@casper.infradead.org>
 <20230907193838.GB14243@noisy.programming.kicks-ass.net>
 <ZPpV+MeFqX6RHIYw@dread.disaster.area>
 <20230908104434.GB24372@noisy.programming.kicks-ass.net>
 <ZP5JrYOge3tSAvj7@dread.disaster.area>
 <ZP5OfhXhPkntaEkc@casper.infradead.org>
 <ZP5llBaVrJteHQf3@dread.disaster.area>
 <70d89bf4-708b-f131-f90e-5250b6804d48@redhat.com>
 <ZP+U49yfkm0Fpfej@dread.disaster.area>
 <20230912090342.GC35261@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912090342.GC35261@noisy.programming.kicks-ass.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 11:03:42AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 12, 2023 at 08:29:55AM +1000, Dave Chinner wrote:
> 
> > So, once again, we have mixed messages from the lock maintainers.
> > One says "no, it might get abused", another says "I'm fine with
> > that", and now we have a maintainer disagreement stalemate.
> 
> I didn't say no, I was trying to see if there's alternatives because the
> is_locked pattern has a history of abuse.

Yet you haven't suggested or commented on the proposed methods to
avoid abuse - you are still arguing that it can be abused. Go back
and read what I proposed before continuing to argue about
mutex_is_locked()....

> If not, then sure we can do this; it's not like I managed to get rid of
> muteX_is_locked() -- and I actually tried at some point :/
> 
> And just now I grepped for it, and look what I find:
> 
> drivers/hid/hid-nintendo.c:     if (unlikely(mutex_is_locked(&ctlr->output_mutex))) {
> drivers/nvdimm/btt.c:           if (mutex_is_locked(&arena->err_lock)
> 
> And there's more :-(

.... like this.

Seriously: if we put it behind CONFIG_DEBUG_RWSEM, and then turn
that on when other subsystem debug code wants the rwsem
introspection, why does anyone outside that subsystem even how it
gets used? It won't even get used in production kernels, because
nobody will turn something on that requires rwsem debug in a
production kernel.

If you are still concerned that this will happen, then do the same
that we've done for trace_printk and other debug only functions:
dump a big warning at boot time that rwsem debug is enabled and this
is not a supported production kernel configuration.

> Also, please just calm down already..

I'm perfectly calm and relaxed.  Asking for a definitive decision
between co-maintainers who are giving decidedly mixed signals is a
very reasonable request to make.  Just because you may not like what
such a request implies about how the code is being maintained, it
doesn't mean I'm the slightest bit upset, hysterical or irrational.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
