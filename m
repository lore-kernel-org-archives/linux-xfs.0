Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57538 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752085AbdLFWCA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 17:02:00 -0500
Subject: Re: [PATCH v7] generic: initial fiemap range query test
References: <1512057927-15022-1-git-send-email-nborisov@suse.com>
 <20171206174506.GI19219@magnolia>
 <0d1b5c25-9187-1405-17a2-1e44b65c53a8@suse.com>
 <20171206210659.GE6896@magnolia> <20171206215711.GG5858@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <61675ab2-0943-e5d7-8c94-247d3ef68a05@sandeen.net>
Date: Wed, 6 Dec 2017 16:01:58 -0600
MIME-Version: 1.0
In-Reply-To: <20171206215711.GG5858@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 12/6/17 3:57 PM, Dave Chinner wrote:

> There's a *simple answer* to this problem: fix the new command's
> output.
> 
> That is: the user asked for a specific range, so the command itself
> should trim the map returned by the kernel to only display the exact
> range the user asked for.  Then it doesn't matter if the underlying
> filesystem trims the extents or not, because the we're going to do
> that anyway in userspace.

I have a different opinion:

xfs_io is a debugging tool; the fiemap command sends an ioctl to the kernel.

Ranged fiemap queries are a real thing; you put numbers into the kernel,
and you get numbers out of the kernel.

IMNSO, xfs_io should present to the user /what the kernel returned/,
and not re-interpret it to fit some other notion of correctness if we
don't like what the kernel told us.

If you want to have some user-friendlier behavior where xfs_io layers
behaviors on top of what the kernel provides, then add a "-t" argument for trim,
but hiding ioctl inconsistencies by filtering them through xfs_io sounds
like the wrong approach to me.

-Eric
