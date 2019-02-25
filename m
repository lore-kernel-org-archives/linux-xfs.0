Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:42637 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727421AbfBYXLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 18:11:01 -0500
Date: Tue, 26 Feb 2019 10:10:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS root filesystem corruption after selinux-policy-targeted
 update
Message-ID: <20190225231057.GH23020@dastard>
References: <CAJCQCtRODsGw85CdJRD7EF9U2vx7EwFkaFQCtC1mPwckUkUBNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtRODsGw85CdJRD7EF9U2vx7EwFkaFQCtC1mPwckUkUBNw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Mon, Feb 25, 2019 at 03:16:40PM -0700, Chris Murphy wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=1679697
> 
> I'm not sure what the call trace is saying. User has been requested to
> run xfs_repair -n to see if it's really corrupt and maybe get more
> information in what manner it's corrupted.

A free space tree is corrupted. What caused it is unknown, and
without a reproducer we are unlikely to be able to find it.
xfs_repair is needed to rebuild the free space trees and hence fix
the corruption.

> I don't think it's
> selinux-policy related at all,

It's not. Might be xattr related (because relabelling manipulates
xattrs), but there's really nothing to go on at this point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
