Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F10BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 10:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C4461206
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 10:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhJDKIn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Oct 2021 06:08:43 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:38734 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhJDKIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Oct 2021 06:08:43 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 99A73201AD;
        Mon,  4 Oct 2021 10:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633342013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=pAeBo0HnjWJfj+hLTn7PupYbmocQMW6bHJ1ny96tX7Y=;
        b=IVYnJYuntZ5zGKpPcbXW1eiDfx48dSKRT3/eH8zp9M8cfUvqEcLCtP+pKY6fk5Tj+prDqX
        MJOxqMv6eVzvNgbOsYmsSRQTRaudjNhJsvEDdwUt+vPDmidzQh4sN5ggYl+m1FHxb3Atig
        3ZQglI4RdRK1NGx7L6ZCwsG2IonVBK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633342013;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=pAeBo0HnjWJfj+hLTn7PupYbmocQMW6bHJ1ny96tX7Y=;
        b=KJmDUlgY+8xgxkGEy6pxo6ajfn7EFNNiAoL5puC/XN9bWcKmbPp90+Jup7f4m+KeaLIScF
        2Hckywj+NFKhn/Aw==
Received: from quack2.suse.cz (unknown [10.163.28.18])
        by relay2.suse.de (Postfix) with ESMTP id 8CB78A3B88;
        Mon,  4 Oct 2021 10:06:53 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 661F81E13FD; Mon,  4 Oct 2021 12:06:53 +0200 (CEST)
Date:   Mon, 4 Oct 2021 12:06:53 +0200
From:   Jan Kara <jack@suse.cz>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Performance regression with async inode inactivation
Message-ID: <20211004100653.GD2255@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

our performance testing grid has detected a performance regression caused
by commit ab23a77687 ("xfs: per-cpu deferred inode inactivation queues")
with reaim benchmark running 'disk' and 'disk-large' workloads. The
regression has been so far detected on two machines - marvin7 (48 cpus, 64
GB ram, SATA SSD), dobby (64 cpus, 192 GB ram, rotating disk behind
megaraid_sas controller).

The regression reports from mmtests on marvin7 (which from my experience I
find more reliable than dobby) look like:

reaim-io-disk-xfs
Hmean     disk-1       3597.12 (   0.00%)     3636.37 (   1.09%)
Hmean     disk-25    125000.00 (   0.00%)   121753.25 (  -2.60%)
Hmean     disk-49    218424.96 (   0.00%)   193421.05 * -11.45%*
Hmean     disk-73    286649.22 (   0.00%)   240131.58 * -16.23%*
Hmean     disk-97    349339.74 (   0.00%)   285854.62 * -18.17%*
Hmean     disk-121   373456.79 (   0.00%)   309199.32 * -17.21%*
Hmean     disk-145   399449.04 (   0.00%)   330547.11 * -17.25%*
Hmean     disk-169   420049.71 (   0.00%)   345132.74 * -17.84%*
Hmean     disk-193   458795.56 (   0.00%)   375243.03 * -18.21%*
Stddev    disk-1        102.32 (   0.00%)      117.93 ( -15.25%)
Stddev    disk-25      6981.08 (   0.00%)     4285.17 (  38.62%)
Stddev    disk-49      9523.63 (   0.00%)    10723.44 ( -12.60%)
Stddev    disk-73      9704.22 (   0.00%)     7946.73 (  18.11%)
Stddev    disk-97     10059.91 (   0.00%)     6111.28 (  39.25%)
Stddev    disk-121     5730.56 (   0.00%)    11714.34 (-104.42%)
Stddev    disk-145    11154.40 (   0.00%)     8129.06 (  27.12%)
Stddev    disk-169     4477.30 (   0.00%)     3558.86 (  20.51%)
Stddev    disk-193     8785.70 (   0.00%)    13258.89 ( -50.91%)

reaim-io-disk-large-xfs
Hmean     disk-1        722.72 (   0.00%)      721.85 (  -0.12%)
Hmean     disk-25     24177.95 (   0.00%)    24319.06 (   0.58%)
Hmean     disk-49     35294.12 (   0.00%)    34361.85 (  -2.64%)
Hmean     disk-73     43042.45 (   0.00%)    40896.36 *  -4.99%*
Hmean     disk-97     48403.19 (   0.00%)    46044.30 *  -4.87%*
Hmean     disk-121    52230.22 (   0.00%)    49347.47 *  -5.52%*
Hmean     disk-145    54613.94 (   0.00%)    52333.98 *  -4.17%*
Hmean     disk-169    57178.30 (   0.00%)    54745.71 *  -4.25%*
Hmean     disk-193    60230.94 (   0.00%)    57106.22 *  -5.19%*
Stddev    disk-1         18.74 (   0.00%)       30.19 ( -61.11%)
Stddev    disk-25       439.49 (   0.00%)      809.58 ( -84.21%)
Stddev    disk-49      1416.65 (   0.00%)      603.55 (  57.40%)
Stddev    disk-73       949.45 (   0.00%)      584.61 (  38.43%)
Stddev    disk-97       689.51 (   0.00%)      602.76 (  12.58%)
Stddev    disk-121      485.22 (   0.00%)      612.79 ( -26.29%)
Stddev    disk-145      147.37 (   0.00%)      442.99 (-200.60%)
Stddev    disk-169      282.25 (   0.00%)      613.42 (-117.33%)
Stddev    disk-193      970.05 (   0.00%)      572.59 (  40.97%)

Note that numbers behind dash (disk-xx) denote the number of reaim
"clients" - i.e., the number of processes reaim runs in parallel.

This reaim workload will create quite some small files, fsync them, do a
few operations on them like read, write, etc. and quickly delete them. This
happens in many processes in parallel so I can imagine the unlink workload
is rather heavy.

To reproduce the workload the easiest is probably to clone mmtests [1],
there's README.md and docs/Tutorial.md about how to run tests. Relevant
configurations are in configs/config-reaim-io-disk-large and
configs/config-reaim-io-disk, you will need to edit these files to set
appropriate test partition (will get wiped) and filesystem. Note that
mmtests do somewhat modify standard reaim benchmark so that it does not
call system("sync") after each operation (you can see modifications we
apply in [2] if you're interested).

I can probably find some time to better understand what's going on on these
machines later this week but if you have some suggestions what to look for,
you're welcome.

								Honza

[1] https://github.com/gormanm/mmtests
[2] https://github.com/gormanm/mmtests/blob/master/shellpack_src/src/reaim/reaim-install

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
