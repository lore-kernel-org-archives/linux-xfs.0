Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26943 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750729AbeBGXn7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 18:43:59 -0500
Date: Thu, 8 Feb 2018 10:43:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_extent_busy_flush vs. aio
Message-ID: <20180207234350.GA20266@dastard>
References: <20180123173902.GF32478@bfoster.bfoster>
 <f4751375-0710-cec8-ac6d-1f9546bba1ce@scylladb.com>
 <20180125130830.GD43198@bfoster.bfoster>
 <dd148ae0-fe9b-b5b6-5b03-05f0894ce969@scylladb.com>
 <20180129113556.fd4y3t5yupeqtn5t@destitution>
 <6eddde50-ad81-f2ce-c273-86442598a934@scylladb.com>
 <20180129215645.c5dfa3mmoio2iovo@destitution>
 <e76c840f-edd0-2dcc-e070-313cd2ea31da@scylladb.com>
 <20180207015741.yrhe3zfaypwljsdu@destitution>
 <9184712f-65e8-5591-2f2f-aeba48cde3f4@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9184712f-65e8-5591-2f2f-aeba48cde3f4@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Feb 07, 2018 at 12:54:43PM +0200, Avi Kivity wrote:
> On 02/07/2018 03:57 AM, Dave Chinner wrote:
> >IOWs, inode32 limits where and how many inodes you can
> >create, not how much user data you can write inode the filesystem.
> 
> Thanks a lot for the clarifications. Looks like inode32 can be used
> to reduce some of our pain.
> 
> There's a danger that when switching from inode64 to inode32 you end
> up with the inode32 address space already exhausted, right? Does
> that result in ENOSPC or what?

ENOSPC on inode allocation.

> Anyway, can probably be fixed by stopping the load, copying files
> around, and moving them back.

Yup, assuming you're able to find the files that need to be moved in
a finite period of time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
