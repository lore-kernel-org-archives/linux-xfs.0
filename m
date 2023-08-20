Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A10EEE49A4
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Aug 2023 22:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjHTWOo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Aug 2023 18:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjHTWOn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Aug 2023 18:14:43 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE98C9D
        for <linux-xfs@vger.kernel.org>; Sun, 20 Aug 2023 15:14:41 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-68a3236a414so887135b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 20 Aug 2023 15:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692569681; x=1693174481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C/84XVBthIaoOVt1mZXtw/Rh5qXUaqqVnFVZRqslxEw=;
        b=JbfXBe5yJj7tuoCDtYIJh1eUs3k0BfBqEci+YnJkkxVInHNK36M9YMefi+GD5c5Uq0
         HjXsZwRtTXGy9VKVgQQywjsCfsThKJ7kkz5EINRtVVnTZb4YKm10AQ0uIOCgMaCgXx9p
         3axqIYW6Ng2HUTctMYnFuAUJmC6+f4tGJEbhXQSHL+59K/IXmKUa7zQdiPcuZG++hNQj
         2NmqYhpZwJlQixYRR8oWq/4Gz0cULiFfXc2PljMVtOlMUaXPEcFYbNylThzYVgnRx+As
         TEFYNsiGFt8xBIh52TSPMqs3vqS1sOAsB8/qTEhHft8u3pltaG4VMTyR6rpFF7qVkEuX
         j3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692569681; x=1693174481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/84XVBthIaoOVt1mZXtw/Rh5qXUaqqVnFVZRqslxEw=;
        b=G6cxa8FxI1X5JFpb8cD6J4LcQc0gLa4AJx+PKfho1XpBQbnVJ0AtUoJ6zC02bP3tyX
         79Y1VTNbpVjBNpqfd0tStp4Q0sBzodlxUDSA/IYoZ/VJWchte0dZuUUIlDN2EfL5FJMq
         WZTOHb7+44TunI2WzVZ274pBS//+h5ctE6d6uLf6xJu2iJPSMWvIqocg/Mx3OHAYaYfz
         vFnLdFGdKJTxik334FoEPYCcmfNfGcXQcmw2BYfxW9oG7KNe9s0xVWOgpa2qeUKWqBed
         /r0GSA2e0r6oS5pKzsxy8YQ2HnjV90eP158gve98NaVBoe1iMWJERWTHASDQe153SOlY
         stzg==
X-Gm-Message-State: AOJu0YyXgu5g+8rziWqVxcAUr6OG9fyVERKvrcv4jOtER1dooKG2Iwfu
        DrdelQtL/HH77iD2188mD4DOudnJWftPVVFX0g8=
X-Google-Smtp-Source: AGHT+IFq4WZR0ZS+ZF82L/lZKR+C8VbrJK8BYIZNA5reoBdEhoLQjz3qAvL/ar2KO6O2PC4kkzwO0w==
X-Received: by 2002:a05:6a20:42a3:b0:149:122b:6330 with SMTP id o35-20020a056a2042a300b00149122b6330mr1257850pzj.10.1692569681242;
        Sun, 20 Aug 2023 15:14:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id w24-20020aa78598000000b0068892a66b5csm4865997pfn.77.2023.08.20.15.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Aug 2023 15:14:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qXqgv-004Jv3-0y;
        Mon, 21 Aug 2023 08:14:37 +1000
Date:   Mon, 21 Aug 2023 08:14:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     fk1xdcio@duck.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Moving existing internal journal log to an external device
 (success?)
Message-ID: <ZOKQTTxcanMX86Sx@dread.disaster.area>
References: <E4E991B0-4CAA-4E7A-9AC8-531346EDAEC4.1@smtp-inbound1.duck.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E4E991B0-4CAA-4E7A-9AC8-531346EDAEC4.1@smtp-inbound1.duck.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 20, 2023 at 03:37:38PM -0400, fk1xdcio@duck.com wrote:
> Does this look like a sane method for moving an existing internal log to an
> external device?
> 
> 3 drives:
>    /dev/nvme0n1p1  2GB  Journal mirror 0
>    /dev/nvme1n1p1  2GB  Journal mirror 1
>    /dev/sda1       16TB XFS
> 
> # mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/nvme0n1p1
> /dev/nvme1n1p2
> # mkfs.xfs /dev/sda1
> # xfs_logprint -C journal.bin /dev/sda1
> # cat journal.bin > /dev/md0
> # xfs_db -x /dev/sda1
> 
> xfs_db> sb
> xfs_db> write -d logstart 0
> xfs_db> quit
> 
> # mount -o logdev=/dev/md0 /dev/sda1 /mnt

So you are physically moving the contents of the log whilst the
filesystem is unmounted and unchanging.

> -------------------------
> 
> It seems to "work" and I tested with a whole bunch of data.

You'll get ENOSPC earlier than you think, because you just leaked
the old log space (needs to be marked free space). There might be
other issues, but you get to keep all the broken bits to yourself if
you find them.

You can probably fix that by running xfs_repair, but then....

> I was also able
> to move the log back to internal without issue (set logstart back to what it
> was originally). I don't know enough about how the filesystem layout works
> to know if this will eventually break.

.... this won't work.

i.e. you can move the log back to the original position because you
didn't mark the space the old journal used as free, so the filesytem
still thinks it is in use by something....

> *IF* this works, why can't xfs_growfs do it?

"Doctor, I can perform an amputation with a tornique and a chainsaw,
why can't you do that?"

Mostly you are ignoring the fact that growfs in an online operation
- actually moving the log safely and testing it rigorously is a
whole lot harder to than changing a few fields with xfs_db....

Let's ignore the simple fact we can't tell the kernel to use a
different block device for the log via growfs right now (i.e. needs
a new ioctl interface) and focus on what is involved in moving the
log whilst the filesytem is mounted and actively in use.

First we need an atomic, crash safe mechanism to swap from one log
to another. We need to do that while the filesystem is running, so
it has to be done within a freeze context. Then we have run a
transaction that initialises the new log and tells the old log where
the new log is so that if we crash before the superblock is written
log recovery will replay the log switch. Then we do a sync write of
the superblock so that the next mount will see the new log location.
Then, while the filesystem is still frozen, we have to reconfigure
the in memory log structures to use the new log (e.g. open new
buftarg, update mount pointers to the log device, change the log
state to external, reset log sequence numbers, grant heads, etc).

Finally, if we got everything correct, we then need to free the old
journal in a new transaction running in the new log to clean up the
old journal now that it is no longer in use. Then we can unfreeze
the filesystem...

Yes, you can do amputations with a chainsaw, but it's a method of
last resort that does not guarantee success and you take
responsibility for the results yourself. Turning this into a
reliable procedure that always works or fails safe for all
conditions (professional engineering!) is a whole lot more
complex...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
