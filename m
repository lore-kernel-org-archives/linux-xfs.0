Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58298 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751357AbeBXR4q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 24 Feb 2018 12:56:46 -0500
Subject: Re: xfs_repair: add '-F' option to ignore writable mount checking
References: <5A914B45.8080200@xtaotech.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5c0df437-0f09-129c-945f-0f917bfdaa7e@sandeen.net>
Date: Sat, 24 Feb 2018 11:56:44 -0600
MIME-Version: 1.0
In-Reply-To: <5A914B45.8080200@xtaotech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yang Joseph <joseph.yang@xtaotech.com>, sandeen@redhat.com, nathans@debian.org
Cc: linux-xfs@vger.kernel.org

On 2/24/18 5:23 AM, Yang Joseph wrote:
> hello,
> 
> Before the repair process, xfs_repair will check if user specified device already
> has a writable mountpoint. And it will stat all the mountpoints of the system. If there
> is a dead mountpoint, this checking will be blocked and xfs_repair will enter 'D' state.
> 
> So, if user can make sure there is no writable mountpoint, xfs_repair can skip
> this checking. This PR add a new option '-F' to do this job.
> 
> Your suggestions are appreciated!

For starters, this patch seems whitespace mangled and does not apply for me.

However, repairing a filesystem that is actually mounted read-write
could cause serious damage.  Giving the admin tools to do this carries
significant risk; we already call it "dangerous" to repair even an
ro-mounted filesystem.

Do you have a testcase to produce a "dead" mountpoint which causes xfs_repair
to go into "D" state?  Where was xfs_repair stuck?

That sounds like a bug worth fixing, but I am much
less excited about adding options which could do serious damage
to a filesystem.

Thanks,
-Eric

