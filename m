Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:43184 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752204AbeBZIP7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 03:15:59 -0500
MIME-Version: 1.0
In-Reply-To: <20180226073111.3066-1-wqu@suse.com>
References: <20180226073111.3066-1-wqu@suse.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 26 Feb 2018 10:15:57 +0200
Message-ID: <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
 power loss
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <wqu@suse.com>
Cc: fstests <fstests@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>

On Mon, Feb 26, 2018 at 9:31 AM, Qu Wenruo <wqu@suse.com> wrote:
> This test case is originally designed to expose unexpected corruption
> for btrfs, where there are several reports about btrfs serious metadata
> corruption after power loss.
>
> The test case itself will trigger heavy fsstress for the fs, and use
> dm-flakey to emulate power loss by dropping all later writes.
>

Come on... dm-flakey is so 2016
You should take Josef's fsstress+log-writes test and bring it to fstests:
https://github.com/josefbacik/log-writes

By doing that you will gain two very important features from the test:

1. Problems will be discovered much faster, because the test can run fsck
    after every single block write has been replayed instead of just at random
    times like in your test

2. Absolute guaranty to reproducing the problem by replaying the write log.
    Even though your fsstress could use a pre-defined random seed to results
    will be far from reproduciable, because of process and IO scheduling
    differences between subsequent test runs.
    When you catch an inconsistency with log-writes test, you can send the
    write-log recording to the maintainer to analyze the problem, even if it is
    a hard problem to hit. I used that useful technique for ext4,btrfs,xfs when
    ran tests with generic/455 and found problems.

Cheers,
Amir.
