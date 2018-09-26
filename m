Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:40671 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbeIZHnu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 03:43:50 -0400
Date: Wed, 26 Sep 2018 11:33:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-ID: <20180926013329.GD31060@dastard>
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: TongZhang <ztong@vt.edu>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

On Tue, Sep 25, 2018 at 08:51:50PM -0400, TongZhang wrote:
> Hi,
> 
> I'm bringing up this issue again to let of LSM developers know the situation, and would like to know your thoughts.
> Several weeks ago I sent an email to the security list to discuss the issue where
> XFS's ioctl interface can do things like vfs_readlink without asking LSM's
> permission, which we think is kind of weird and this kind of operation should be
> audited by LSM.

These aren't user interfaces. They are filesystem maintenance and
extension interfaces.  They are intended for low level filesystem
utilities that require complete, unrestricted access to the
underlying filesystem via holding CAP_SYSADMIN in the initns.

i.e.  they are used to perform filesystem maintenance and extension
operations that need to be completely invisible to users from
userspace. e.g.  online file defragmentation (xfs_fsr), data
migration (e.g. HSM products), efficient backup of data (xfsdump),
metadata and data scrubbing, online repair, etc.

IOWs, I really don't think these interfaces are something the LSMs
should be trying to intercept or audit, because they are essentially
internal filesystem interfaces used by trusted code and not general
user application facing APIs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
