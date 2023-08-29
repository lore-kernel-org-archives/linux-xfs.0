Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30790C83F19
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 01:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbjH3BC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 21:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238711AbjH3BCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 21:02:08 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB114CD2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:02:01 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bc8a2f71eeso31789825ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693357321; x=1693962121; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G04il5j1AlLhnQfS8r77+f4BwMV5C8Xsu6+67TiXKLU=;
        b=ocSLR4UfwLJ+nTexCP7MpRFU5ojDQvnNCKX6zR1znLhOfRRiSGrlwfBDZQQATqoUM2
         ZHrDjQ6jbTPPUABVmsHk8uNzxzxAnFvPCSYjVEv/OvQJ1agUa+QYutZm47s9G5OG/vzs
         d/s6qgh+amoJYdw6/6znlRWWS4qHbX6UkPSnHgOSRdQOGEgnP4MWlLs82wOv9p6tKltv
         WQsdPBwFf5NG2FNYWWnrx7TtU+LMABcgkcAWW+HIszVMxkM4UUQaxJFb+iRlcPSaVGY1
         JKV3cCWlWlP8y/FubTl2WxnNeux3TNZPcJqmKpcvpB8gbkiuNMQDtKdTK/AdaNZAmKVb
         vw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693357321; x=1693962121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G04il5j1AlLhnQfS8r77+f4BwMV5C8Xsu6+67TiXKLU=;
        b=CVxgjwxeFlaFEKsSWJUbUsFtVEGDFyuVXA98Yp7rexUEcZZC882BFfEqVWyE1q7ZWm
         olTd+//LSVXBL3LFDrDRmjBTEDfGs4T6ba33rYosogyj1osrhdN03X5VZP46/7vGEaug
         6PrLDxpEsb/ILWdBTH038CxQyBT0jYwA3JLJm3/HmazNLrU7G+WMdIqZSma7JiX8HB1v
         qX+W/aFaJ2WEOqEto87ILLwz5U5V381rcqMy7Khwk7DAb+7oWRh0LCgMp/zb5G65s0Zb
         0VhUhAPKpVQTSvh0+oCGSj0JcEMf/pjliFbOyEgqI5Mz1sTgazb0/Q6cfQ8i55WBpyct
         3r6Q==
X-Gm-Message-State: AOJu0YwBXh8PVp7EgUwf91YG1G4OsBgQnUB0Kmc7UBvPoPTZh7GVv7Ai
        OzJPJ8279SyN/C54NXl86ROUu5dUEcMJx+t84zk=
X-Google-Smtp-Source: AGHT+IHb9V16NAMsDdQnv17HDu+d/ri9pcDaMgS3KUHIYwaNy+QLipXPyosAJlG5I51sHzYtGCJuoQ==
X-Received: by 2002:a17:903:11c5:b0:1c1:f1db:e86d with SMTP id q5-20020a17090311c500b001c1f1dbe86dmr828137plh.7.1693357321311;
        Tue, 29 Aug 2023 18:02:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b00198d7b52eefsm9964942plg.257.2023.08.29.18.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 18:02:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qb6fX-008FJZ-2i;
        Wed, 30 Aug 2023 07:54:39 +1000
Date:   Wed, 30 Aug 2023 07:54:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jose M Calhariz <jose.calhariz@tecnico.ulisboa.pt>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Data corruption with XFS on Debian 11 and 12 under heavy load.
Message-ID: <ZO5pHxqSVbni0Urt@dread.disaster.area>
References: <ZO4nuHNg+KFzZ2Qz@calhariz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZO4nuHNg+KFzZ2Qz@calhariz.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 06:15:36PM +0100, Jose M Calhariz wrote:
> 
> Hi,
> 
> I have been chasing a data corruption problem under heavy load on 4
> servers that I have at my care.  First I thought of an hardware
> problem because it only happen with RAID 6 disks.  So I reported to Debian: 
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1032391

Summary: corruption on HW RAID6, not on a separate HW RAID1 volume
on the same controller.

Firmware update of HW RAID controller made on disk corruption on
RAID6 volumes go away, but weird compiler failures still occurred
indicating data corruption was likely still occuring.

Updating kernel to "bookworm" which runs a 6.3 kernel didn't fix the
problem.

This smells of corruption occurring on read IO, not on write IO, and
likely a hardware related problem given the change of behaviour with
a firmware update.

> Further research pointed to be the XFS the common pattern, not an
> hardware issue.  So I made an informal query to a friend in a software
> house that relies heavily on XFS about his thought on this issue.  He
> made reference to several problems fixed on kernel 6.2 and a
> discussion on this mailing list about back porting the fixes to 6.1
> kernel.

I can't think of any bug fix we've been talking about backporting to
6.1 that might fix a data corruption? Anything that is a known data
corruption fix normally gets backported pretty quickly (e.g. the
corruption that could be triggered in 6.3.0-6.3.4 kernels had the
fix backported into 6.3.5 as soon as we identified the cause).

> With this information I have tried the latest kernel at that time on
> Debian testing over Debian v12 and I could not reproduce the
> problem.  So I made another bug report:
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1040416

Your test case of make -j 4096 fails on 6.1.27 but does not fail on
6.3.7. Which is different behaviour to the above bug. This time you
have a kernel log that indicates XFS appears to be hung up waiting
for an AGI lock during inode allocation from the hung task timer.

This does not indicate any sort of corruption is occurring - it
means either the storage is really slow (i.e. waiting for IO
completion on either the AGI, or IO completion on whatever is
holding the AGI lock) or there has been a deadlock of some kind.
EIther way, this sort of thing is not an indication of data corruption.

You also don't mention what storage hardware this is on - is this
still on the HW RAID6 volumes that were causing issues that you
reported in the first bug above?

----

There's really nothing in either of these bug reports that indicate
that XFS is the root cause, whilst there's plenty of anecdotal
evidence from the first bug to point at storage hardware
problems being the cause.

So, which of these problems is easiest to reproduce on your
machines? Pick one of them and:

- describe the storage hardware stack (BBWC, RAID, caching strategy)
- describe the storage software stack (drdb, lvm, xfs_info for the
  filesystem, etc)
- cpus, memory, etc
- example of a corrupt data file vs a good file (i.e. what is the
  corrupt data that is appearing in the corrupt .o files?)
- find the minimum storage stack that reproduces the problem, and
  determine if the problem reproduces across different storage
  hardware in the same machine.
- if you have known bad and known good kernels, run a bisect and see
  where the problem goes away (e.g. which -rcX kernel between good
  and bad results in the problem going away).

> My questions to this mailing list:
> 
>   - Have anyone experienced under Debian or with vanilla kernels
>   corruption under heavy load on XFS?

No.

I do long term kernel soak testing with my main workstation with
debian kernels (i.e. months of uptime, daily use with hundreds of
browser tabs, tens of terminals, multiple VMs, lots of source tree
work, all on XFS filesystems. I've been running this kernel:

Linux devoid 6.1.0-9-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.27-1 (2023-05-08) x86_64 GNU/Linux

on this machine for some months.

>   - Should I stop waiting for the fixes being back ported to vanilla
>   6.1 and run the latest kernel from Debian testing anyway?  Taking
>   notice that kernels from testing have less security updates on time
>   than stable kernels, specially security issues with limited
>   disclosure.

There's nothing to "fix" or backport until we've done root cause
analysis on the failures and identified what is actually causing
your systems to fail.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
