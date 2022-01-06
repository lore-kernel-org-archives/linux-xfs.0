Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA052C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 20:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiAFUH7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jan 2022 15:07:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231401AbiAFUH6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jan 2022 15:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641499678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Eim3UDcPYBHr/me/rHdRrqYhxCR08CSHkZPgGhAtWLo=;
        b=bxmLQ4LcEaIoDVSJamfu+CELX59p+yp+OP8D5ErvH4n9FfhaAbuHKLCq/dVJNrfkIN6wMU
        0qTq5E7vMSNH4Yz9cHLhIRFAhwjgpx1yb9rdnbWJ6XDxCiWC7Cymo5jjldmGAq5qJ2QQo+
        a2MAIbHgJyAjlL1N7I2Jmc3tNPVlZ8U=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-lRPmfy2JPPed61mUkuNRrw-1; Thu, 06 Jan 2022 15:07:57 -0500
X-MC-Unique: lRPmfy2JPPed61mUkuNRrw-1
Received: by mail-qv1-f69.google.com with SMTP id 13-20020a0562140d0d00b00411590233e8so3073352qvh.15
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jan 2022 12:07:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Eim3UDcPYBHr/me/rHdRrqYhxCR08CSHkZPgGhAtWLo=;
        b=4mJWgxu4xUtgD6GihzUqZ7rvK7Ht/PJK7mken1LBDH26tGWckVLgt7Iw44FnqPdf1J
         lnnKntilOjFVgkcwaIati6fvx/zXrIVY8aIbx1gixPf0E5XUmmdF+iwt809BKriRpPIe
         2MDd2+csrF/xQ2Y47yp39gMq1cpKNZlfb6JPqXfzbXsVHsz2wMhuWdlkS9B8cXd30sxq
         ww9NeZgijfWHj3IQ2Kw6r/Z4uCLj4yCz3sx/nAkUUpjhiFsOIit2ICiucUT68RKkNGxX
         nsgcOQAyoskLV8n+CCagL39+02dpmXC3n3JcOGszThJFhlqT/lgfPGW3Di1ITaQXtbWZ
         NsaA==
X-Gm-Message-State: AOAM531QSDf2EhpDKDzcRCAVAsPJlz7Rtw3HOEN3S3B708Sx3vEPDo5V
        Q498ogE7d2WzfTOY9BUmlEjAzCnhXX+Chss95CQaXsfHjOEpnKdn+ZvkSwKeJkuBI/xi+3z8/uj
        enLHUoER2Uw1DOzOFeZvr
X-Received: by 2002:a05:6214:401a:: with SMTP id kd26mr33623820qvb.30.1641499676200;
        Thu, 06 Jan 2022 12:07:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDCDZ4Kv/wPQ0cuOzh5XgF9r9sRIVj+c1Ja6rWRjJ21Zty8ZRvB9IoK0HdS+82u0N0mZUhCQ==
X-Received: by 2002:a05:6214:401a:: with SMTP id kd26mr33623794qvb.30.1641499675959;
        Thu, 06 Jan 2022 12:07:55 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id b11sm2293050qtx.85.2022.01.06.12.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 12:07:55 -0800 (PST)
Date:   Thu, 6 Jan 2022 15:07:53 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "trondmy@kernel.org" <trondmy@kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "willy@infradead.org" <willy@infradead.org>
Subject: Re: [PATCH] iomap: Address soft lockup in iomap_finish_ioend()
Message-ID: <YddMGRQrYOWr6V9A@bfoster>
References: <6f746786a3928844fbe644e7e409008b4f50c239.camel@hammerspace.com>
 <20220101035516.GE945095@dread.disaster.area>
 <fb964769132eb01ed4e8b67d6972d50ee3387e24.camel@hammerspace.com>
 <20220103220310.GG945095@dread.disaster.area>
 <9f51fa6169f4c67d54dd8563b52c540c94c7703a.camel@hammerspace.com>
 <20220104012215.GH945095@dread.disaster.area>
 <0996c40657b5873dda5119344bf74556491e27b9.camel@hammerspace.com>
 <c9d9b7850c6086b123b4add4de7b1992cb62f6ad.camel@hammerspace.com>
 <20220105224829.GO945095@dread.disaster.area>
 <28e975e8235a41c529bccb2bc0e73b4bb2d1e45e.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28e975e8235a41c529bccb2bc0e73b4bb2d1e45e.camel@hammerspace.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 06, 2022 at 06:36:52PM +0000, Trond Myklebust wrote:
> On Thu, 2022-01-06 at 09:48 +1100, Dave Chinner wrote:
> > On Wed, Jan 05, 2022 at 08:45:05PM +0000, Trond Myklebust wrote:
> > > On Tue, 2022-01-04 at 21:09 -0500, Trond Myklebust wrote:
> > > > On Tue, 2022-01-04 at 12:22 +1100, Dave Chinner wrote:
> > > > > On Tue, Jan 04, 2022 at 12:04:23AM +0000, Trond Myklebust
> > > > > wrote:
> > > > > > We have different reproducers. The common feature appears to
> > > > > > be
> > > > > > the
> > > > > > need for a decently fast box with fairly large memory (128GB
> > > > > > in
> > > > > > one
> > > > > > case, 400GB in the other). It has been reproduced with HDs,
> > > > > > SSDs
> > > > > > and
> > > > > > NVME systems.
> > > > > > 
> > > > > > On the 128GB box, we had it set up with 10+ disks in a JBOD
> > > > > > configuration and were running the AJA system tests.
> > > > > > 
> > > > > > On the 400GB box, we were just serially creating large (>
> > > > > > 6GB)
> > > > > > files
> > > > > > using fio and that was occasionally triggering the issue.
> > > > > > However
> > > > > > doing
> > > > > > an strace of that workload to disk reproduced the problem
> > > > > > faster
> > > > > > :-
> > > > > > ).
> > > > > 
> > > > > Ok, that matches up with the "lots of logically sequential
> > > > > dirty
> > > > > data on a single inode in cache" vector that is required to
> > > > > create
> > > > > really long bio chains on individual ioends.
> > > > > 
> > > > > Can you try the patch below and see if addresses the issue?
> > > > > 
> > > > 
> > > > That patch does seem to fix the soft lockups.
> > > > 
> > > 
> > > Oops... Strike that, apparently our tests just hit the following
> > > when
> > > running on AWS with that patch.
> > 
> > OK, so there are also large contiguous physical extents being
> > allocated in some cases here.
> > 
> > > So it was harder to hit, but we still did eventually.
> > 
> > Yup, that's what I wanted to know - it indicates that both the
> > filesystem completion processing and the iomap page processing play
> > a role in the CPU usage. More complex patch for you to try below...
> > 
> > Cheers,
> > 
> > Dave.
> 
> Hi Dave,
> 
> This patch got further than the previous one. However it too failed on
> the same AWS setup after we started creating larger (in this case 52GB)
> files. The previous patch failed at 15GB.
> 

Care to try my old series [1] that attempted to address this, assuming
it still applies to your kernel? You should only need patches 1 and 2.
You can toss in patch 3 if you'd like, but as Dave's earlier patch has
shown, this can just make it harder to reproduce.

I don't know if this will go anywhere as is, but I was never able to get
any sort of confirmation from the previous reporter to understand at
least whether it is effective. I agree with Jens' earlier concern that
the per-page yields are probably overkill, but if it were otherwise
effective it shouldn't be that hard to add filtering. Patch 3 could also
technically be used in place of patch 1 if we really wanted to go that
route, but I wouldn't take that step until there was some verification
that the yielding heuristic is effective.

Brian

[1] https://lore.kernel.org/linux-xfs/20210517171722.1266878-1-bfoster@redhat.com/

> NR_06-18:00:17 pm-46088DSX1 /mnt/data-portal/data $ ls -lh
> total 59G
> -rw-r----- 1 root root  52G Jan  6 18:20 100g
> -rw-r----- 1 root root 9.8G Jan  6 17:38 10g
> -rw-r----- 1 root root   29 Jan  6 17:36 file
> NR_06-18:20:10 pm-46088DSX1 /mnt/data-portal/data $
> Message from syslogd@pm-46088DSX1 at Jan  6 18:22:44 ...
>  kernel:[ 5548.082987] watchdog: BUG: soft lockup - CPU#10 stuck for
> 24s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:23:44 ...
>  kernel:[ 5608.082895] watchdog: BUG: soft lockup - CPU#10 stuck for
> 23s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:27:08 ...
>  kernel:[ 5812.082587] watchdog: BUG: soft lockup - CPU#10 stuck for
> 22s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:27:36 ...
>  kernel:[ 5840.082533] watchdog: BUG: soft lockup - CPU#10 stuck for
> 21s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:28:08 ...
>  kernel:[ 5872.082455] watchdog: BUG: soft lockup - CPU#10 stuck for
> 21s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:28:40 ...
>  kernel:[ 5904.082400] watchdog: BUG: soft lockup - CPU#10 stuck for
> 21s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:29:16 ...
>  kernel:[ 5940.082243] watchdog: BUG: soft lockup - CPU#10 stuck for
> 21s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:29:44 ...
>  kernel:[ 5968.082249] watchdog: BUG: soft lockup - CPU#10 stuck for
> 22s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:30:24 ...
>  kernel:[ 6008.082204] watchdog: BUG: soft lockup - CPU#10 stuck for
> 21s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:31:08 ...
>  kernel:[ 6052.082194] watchdog: BUG: soft lockup - CPU#10 stuck for
> 24s! [kworker/10:0:18995]
> Message from syslogd@pm-46088DSX1 at Jan  6 18:31:48 ...
>  kernel:[ 6092.082010] watchdog: BUG: soft lockup - CPU#10 stuck for
> 21s! [kworker/10:0:18995]
> 
> -- 
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com
> 
> 

