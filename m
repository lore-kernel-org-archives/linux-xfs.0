Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4D4C64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 21:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjCHV4u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 16:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjCHVyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 16:54:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C39D3332
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 13:54:44 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id p3-20020a17090ad30300b0023a1cd5065fso275244pju.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 13:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678312484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9eJVa41nTmMQ+G4UBh2PB+ATL8MzATmHLYKGAZJwIy0=;
        b=UIldcrVurz1F2+jOwv90GDUHgNDJNzDrmzXtCIfMOIkLvItwdpkD4kO3CxXIqkfZar
         Fe5elgJj4q8SFfRfzwJNyc6pBHQTVCM+GIcC9kAzLQTFN7fwkB7E97q/thAZElt6DZH0
         9lxw809EPXWzhvzkgZ9vEU6zpq+Sr68Uu4VSyLDCPJ2ELQWbDXoaaWDAKl1bI+9xMeny
         qBB9BPOB2TDpITDE687EI39JD6N1cejECN4HeZzGWhDaClhf5qXeWVfw5WW6XO0fqaY8
         U4Z4m9HfYtkxcpIq0gCXcCDjbWxs0/5ZI+iK8gKGlnECdqM8q+tw/APBf+eulRL287gN
         VSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678312484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9eJVa41nTmMQ+G4UBh2PB+ATL8MzATmHLYKGAZJwIy0=;
        b=vwR2ijWX7NnDUVDAIxiM6Ywm0LLANnNodSOXtYZbHEs0Yd7jTwo4MtNxLJTnaJGs3j
         KJV3v+0XV0ZMgmacYwOCCTBo8fhc5T/0WWMWsWBHA9gLCLAkMQNz4c8pIddWzvt0el9r
         upzkPWqUbC+WJKWd2F0DiYsctXvzQzVgw+QPpKC/IThR5GXzQTgtmdmhxE/grReIIPLZ
         Dhhja2QbskrZCV9lNflLFTEVVVy/AAUpiAge6QyeBEWnaSWT9ROrSJRh40FawcopRc/B
         YFm7WJZo1urGzhQh15SnpFhj1d10Xu1/h3s34RSE4Cw/+iq8HwI0/VYGKWVn/nwP8ehD
         pBLA==
X-Gm-Message-State: AO0yUKUvjPgoNNIP239SwXMR075g+yo5NP6VtQ8lsAcK5jdzAHduzjt6
        oBRp0Ecaie61kPKfoiY1cC9c5A==
X-Google-Smtp-Source: AK7set9yRz1V13+udAytKTyotPF1CUbcR1Ua1DXz6+jnfNyurODG/UiKaYcGULo46TRERBNAMJUNsQ==
X-Received: by 2002:a17:90b:3505:b0:22b:b282:a9d7 with SMTP id ls5-20020a17090b350500b0022bb282a9d7mr19285284pjb.20.1678312483682;
        Wed, 08 Mar 2023 13:54:43 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090ad58800b002376d85844dsm199576pju.51.2023.03.08.13.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 13:54:42 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pa1k7-006RWP-DJ; Thu, 09 Mar 2023 08:54:39 +1100
Date:   Thu, 9 Mar 2023 08:54:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [LSF TOPIC] online repair of filesystems: what next?
Message-ID: <20230308215439.GM360264@dread.disaster.area>
References: <Y/5ovz6HI2Z47jbk@magnolia>
 <20230308171206.zuci3wdd3yg7amw5@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308171206.zuci3wdd3yg7amw5@quack3>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 08, 2023 at 06:12:06PM +0100, Jan Kara wrote:
> Hi!
> 
> I'm interested in this topic. Some comments below.
> 
> On Tue 28-02-23 12:49:03, Darrick J. Wong wrote:
> > Five years ago[0], we started a conversation about cross-filesystem
> > userspace tooling for online fsck.  I think enough time has passed for
> > us to have another one, since a few things have happened since then:
> > 
> > 1. ext4 has gained the ability to send corruption reports to a userspace
> >    monitoring program via fsnotify.  Thanks, Collabora!
> > 
> > 2. XFS now tracks successful scrubs and corruptions seen during runtime
> >    and during scrubs.  Userspace can query this information.
> > 
> > 3. Directory parent pointers, which enable online repair of the
> >    directory tree, is nearing completion.
> > 
> > 4. Dave and I are working on merging online repair of space metadata for
> >    XFS.  Online repair of directory trees is feature complete, but we
> >    still have one or two unresolved questions in the parent pointer
> >    code.
> > 
> > 5. I've gotten a bit better[1] at writing systemd service descriptions
> >    for scheduling and performing background online fsck.
> > 
> > Now that fsnotify_sb_error exists as a result of (1), I think we
> > should figure out how to plumb calls into the readahead and writeback
> > code so that IO failures can be reported to the fsnotify monitor.  I
> > suspect there may be a few difficulties here since fsnotify (iirc)
> > allocates memory and takes locks.
> 
> Well, if you want to generate fsnotify events from an interrupt handler,
> you're going to have a hard time, I don't have a good answer for that.

I don't think we ever do that, or need to do that. IO completions
that can throw corruption errors are already running in workqueue
contexts in XFS.

Worst case, we throw all bios that have IO errors flagged to the
same IO completion workqueues, and the problem of memory allocation,
locks, etc in interrupt context goes away entire.

> But
> offloading of error event generation to a workqueue should be doable (and
> event delivery is async anyway so from userspace POV there's no
> difference).

Unless I'm misunderstanding you (possible!), that requires a memory
allocation to offload the error information to the work queue to
allow the fsnotify error message to be generated in an async manner.
That doesn't seem to solve anything.

> Otherwise locking shouldn't be a problem AFAICT. WRT memory
> allocation, we currently preallocate the error events to avoid the loss of
> event due to ENOMEM. With current usecases (filesystem catastrophical error
> reporting) we have settled on a mempool with 32 preallocated events (note
> that preallocated event gets used only if normal kmalloc fails) for
> simplicity. If the error reporting mechanism is going to be used
> significantly more, we may need to reconsider this but it should be doable.
> And frankly if you have a storm of fs errors *and* the system is going
> ENOMEM at the same time, I have my doubts loosing some error report is
> going to do any more harm ;).

Once the filesystem is shut down, it will need to turn off
individual sickness notifications because everything is sick at this
point.

> > As a result of (2), XFS now retains quite a bit of incore state about
> > its own health.  The structure that fsnotify gives to userspace is very
> > generic (superblock, inode, errno, errno count).  How might XFS export
> > a greater amount of information via this interface?  We can provide
> > details at finer granularity -- for example, a specific data structure
> > under an allocation group or an inode, or specific quota records.
> 
> Fsnotify (fanotify in fact) interface is fairly flexible in what can be
> passed through it. So if you need to pass some (reasonably short) binary
> blob to userspace which knows how to decode it, fanotify can handle that
> (with some wrapping). Obviously there's a tradeoff to make how much of the
> event is generic (as that is then easier to process by tools common for all
> filesystems) and how much is fs specific (which allows to pass more
> detailed information). But I guess we need to have concrete examples of
> events to discuss this.

Fine grained health information will always be filesystem specific -
IMO it's not worth trying to make it generic when there is only one
filesystem that tracking and exporting fine-grained health
information. Once (if) we get multiple filesystems tracking fine
grained health information, then we'll have the information we need
to implement a useful generic set of notifications, but until then I
don't think we should try.

We should just export the notifications the filesystem utilities
need to do their work for the moment.  When management applications
(e.g Stratis) get to the point where they can report/manage
filesystem health and need that information from multiple
filesystems types, then we can work out a useful common subset of
fine grained events across those filesystems that the applications
can listen for.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
