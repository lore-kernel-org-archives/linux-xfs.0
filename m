Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:58118 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1161578AbdEYAE7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2017 20:04:59 -0400
Date: Thu, 25 May 2017 10:03:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Message-ID: <20170525000300.GD17542@dastard>
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard>
 <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org>
 <20170522020112.GV17542@dastard>
 <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
 <CAJCQCtTgtMPCdZA3SOV7UFmQ3Y83op2JHPh-0iSkm7-2SvMCXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtTgtMPCdZA3SOV7UFmQ3Y83op2JHPh-0iSkm7-2SvMCXg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, May 24, 2017 at 12:22:13AM -0600, Chris Murphy wrote:
> Something seems really out of order here.

Intentionally so.

Filesystems do screwy, complex things to extract maximum performance
whilst maintaining operational ordering.  We use log sequence
numbers to ensure the order of operations is maintained correctly in
the active portion of the journal, but we provide no ordering
guarantees for metadata writeback operations from the journal.

> The kernel is installed
> first, then the initramfs is built, grub.cfg.new is created, grub.cfg
> is deleted, grub.cfg.new is renamed to grub.cfg. How is it the first
> two items are in the dirty log, not fully committed to fs metadata;
> but the grub.cfg is zero length?  Why isn't the old one still there as
> far as grub is concerned? If that were the case, the old kernel and
> initramfs could be booted and then the log replayed to fix up
> everything. The ordering here seems pretty screwy.

By mounting "-o ro,norecovery" what you are seeing is evidence of
metadata being flushed from the journal in optimal IO order rather
than strict sequence order. The filesystem is not in a consistent
state if you haven't recovered the journal. Recovering the journal
(i.e. a normal mount) replays all the recorded changes and intents
in strict sequence order, hence providing the high level operational
ordering semantics we guarantee users.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
