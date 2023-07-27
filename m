Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F499C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 01:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjG0BFd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 21:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjG0BFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 21:05:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71FA1BC1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 18:05:30 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-686f090310dso318310b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 18:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690419930; x=1691024730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vQZWdsfL3c3+nLQoSv9uMjsmjD+kQBiLGeXW1cjWH2U=;
        b=16cMx8ex/qRji4EFGMl+yzh7hb/oIQnCpi3iu2C6wB/eKYIc+O05wDPCGmxbWZ79MC
         AUZ9uwQ7ZObLwtDNffvzN+6lJ3ZIdw0giRvkxbkkk3ZWSETglb8AInjqyohtG060qmDm
         dC/rW0optXcqZIyx0ADpj+ZJxgCkW2wdebPoUKIDzLDnH0RLr8dXRB6BDHNGX2Zcy93B
         U9gEVV1QbLyWdgCTt73BIX0x9x1HccOUJ+IRnoRryqeDbgHpipP/vVPat9iDXBHi8D0F
         945dYrs+vWQCVZrr4yw6aNLT6XCflJMgQG/1YkT6rT/yi3GAxmVzsxcCMRYU4qNNi3QY
         kgFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690419930; x=1691024730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQZWdsfL3c3+nLQoSv9uMjsmjD+kQBiLGeXW1cjWH2U=;
        b=iKK5+tRtJ+gz6/lrTKE4Me6PTo1Mt/Vsdw1njetIBkRb6nGf2K9g06zWESVW5A10Kj
         kwzpWz2SCTHZjyseYyceh1QppaggFST6/+ywx+ag8QgViVk7vtVFqpvmE4rZHfiRC8X0
         dt7SK1hS0aOSTnKQ88vNzMDzn/BS96j1mQVKBFtC9dDjhtxUabuwMNPH6Ix7uZvnzQ+C
         lzTNDVZ7Mt2f2A+VFiTSzb8KVEF1IDx+bXfhyRe+YvWltBR41xqaH0iaFuR4UkyNEg6J
         /RPoMSOcdnwk03e5Ziup/QJIvQ8r05a75hjA8cNYdtzV+SKHx4+KKcP4VY07vvL0yHt2
         KhCA==
X-Gm-Message-State: ABy/qLbjsauSqaqXfpGpyAbpJes6hbol3Uz+7jdPz8Z1wzcbk/acs001
        W3yjKsCT7TphbuU+bIieAfggMQ==
X-Google-Smtp-Source: APBJJlFF3t9vPICu5QlWvPrq/DpgBq2pNUfdmM/GwMJVJJahF+hCFrp6QOGmwY3SXuE3Sm64QXqbxA==
X-Received: by 2002:a05:6a20:d408:b0:138:dbff:f0c1 with SMTP id il8-20020a056a20d40800b00138dbfff0c1mr3106395pzb.1.1690419930241;
        Wed, 26 Jul 2023 18:05:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id a23-20020a62bd17000000b00676bf2d5ab3sm211868pff.61.2023.07.26.18.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 18:05:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qOpRW-00AxZM-25;
        Thu, 27 Jul 2023 11:05:26 +1000
Date:   Thu, 27 Jul 2023 11:05:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <ZMHC1jwtAWXP3vPm@dread.disaster.area>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
 <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
 <20230726152320.GA11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726152320.GA11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 08:23:20AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 26, 2023 at 02:08:05PM +1000, Dave Chinner wrote:
> > On Mon, Jul 24, 2023 at 06:03:02PM +0000, Wengang Wang wrote:
> > > > On Jul 23, 2023, at 5:57 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > > On Fri, Jul 21, 2023 at 07:36:03PM +0000, Wengang Wang wrote:
> > > > i.e. we have full tracing of the log reservation accounting via
> > > > tracepoints in the kernel. If there is a leak occurring, you need to
> > > > capture a trace of all the reservation accounting operations and
> > > > post process the output to find out what operation is leaking
> > > > reserved space. e.g.
> > > > 
> > > > # trace-cmd record -e xfs_log\* -e xlog\* -e printk touch /mnt/scratch/foo
> > > > ....
> > > > # trace-cmd report > s.t
> > > > # head -3 s.t
> > > > cpus=16
> > > >          touch-289000 [008] 430907.633820: xfs_log_reserve:      dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 1024 grant_write_cycle 1 grant_write_bytes 1024 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2
> > > >          touch-289000 [008] 430907.633829: xfs_log_reserve_exit: dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 482800 grant_write_cycle 1 grant_write_bytes 482800 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2
> > > > 
> > > > #
> > > > 
> > > > So this tells us the transaction reservation unit size, the count of
> > > > reservations, the current reserve and grant head locations, and the
> > > > current head and tail of the log at the time the transaction
> > > > reservation is started and then after it completes.
> > > 
> > > Will do that and report back. You want full log or only some typical
> > > ones? Full log would be big, how shall I share? 
> > 
> > I don't want to see the log. It'll be huge - I regularly generate
> > traces containing gigabytes of log accounting traces like this from
> > a single workload.
> > 
> > What I'm asking you to do is run the tracing and then post process
> > the values from the trace to determine what operation is using more
> > space than is being freed back to the log.
> > 
> > I generally do this with grep, awk and sed. some people use python
> > or perl. But either way it's a *lot* of work - in the past I have
> > spent _weeks_ on trace analysis to find a 4 byte leak in the log
> > space accounting. DOing things like graphing the head, tail and grant
> > spaces over time tend to show if this is a gradual leak versus a
> > sudden step change. If it's a sudden step change, then you can
> > isolate it in the trace and work out what happened. If it's a
> > gradual change, then you need to start looking for accounting
> > discrepancies...
> 
> Any chance you'd be willing to share that pipeline?

It's all just one-off scripts I tend to write from scratch each
time. I'm always looking for different things, and I never know what
I'm looking for ahead of time, so the parser is always different....

> It'd be useful to
> stash that kind of debugging program in xfsprogs/tools to save time and
> eliminate an entire class of "Hey Dave, did I capture this correctly?"
> questions.
> 
> (At least until someone changes the tracepoints :P)

That happens frequently enough... :/

Regardless, it's the process of writing filter scripts that helps me
find the problem I'm looking for, not the actual filter script
itself.

e.g. I've been working on a similar "EFI reservation deadlocks on
log space during recovery" issue over the past couple of days from a
customer metadump.

The filesystem had a 2GB log, and it was full. Log recovery took a
several minutes to run there were so many items to recover. The
(incomplete) logprint of all the op headers was over a million lines
(somewhere around 400k individual log items) and I know that
logprint output skipped at least two checkpoints that had over
65,000 ophdrs in them each.

So log recovery was recovering roughly half a million log items from
the log, and only then it was hanging on the first EFI that needed
to be recovered. The mount trace was somewhere around 20GB of event
data at the point of the hang, the logprint output indicated about
1.3 million ophdrs in the log that were being processed by recovery.
I worked that out to be around half a million individual log items
in the log that needed recovery.

In setting up a regex to filter the trace down to something
managable, I noticed that the id of the EFI that hung recovery
matched an EFI in the very first checkpoint being recovered from the
log (from the logprint output). Logprint told me that this
checkpoint was almost entirely EFI/EFDs from an unlinked inode being
inactivated. The last two log items in that checkpoint were the
inode item and a single EFI. 

A quick grep failed to find that inode anywhere else in the
logprint, and the EFI id didn't show up in any EFD item, either.
Pulling them out of the mount trace confirmed that they only
appeared in recovery of the initial checkpoint. IOWs, the EFI -
and the inode that was locked across the processing of the EFI at
runtime - had pinned the tail of the log and that's why recovery
hung waiting on log space.

It turns out that the hang in log recovery followed a system
reboot due to a hung task timeout. So right now, it looks to me like
the runtime code had deadlocked the journal because transaction
reservation during a roll couldn't make progress because the inode
held locked across the transaction roll pinned the tail of the
log....

How that happened, I have no idea, but it was the _process_ of
writing filters to analysis the logprint data and log reservation
traces that allowed me to find this, not because I had a set of
canned scripts that exposed that explicit information. Even if I
write a scanned script to find unmatched EFIs in a log print, the
log print output is sufficiently unreliable that I couldn't rely on
the output of the filter script anyway.....

Fundamentally, I don't have the time to run this trace+filter
process this for every report of similar problems - it takes a long
time just to work out what what I need to look for in the traces.
Hence it's important that more people learn the process - how to
read and filter the traces to isolate something that might be going
wrong. I don't have canned scripts because the scripts I write are
guided by what I think I need to search for, and I regularly get to
a dead end and have to start the filtering process all over
again to look for something else entirely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
