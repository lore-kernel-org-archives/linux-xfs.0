Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6352 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751152AbcLGGOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2016 01:14:42 -0500
Date: Wed, 7 Dec 2016 17:14:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS bug?
Message-ID: <20161207061436.GF4326@dastard>
References: <0F1FE7A8-D5C6-4FFD-9B9C-E03FB1962F3E@flyingcircus.io>
 <20161201110347.GD11750@dastard>
 <7D83E56E-5922-4B0D-A963-3C9F22491F94@flyingcircus.io>
 <20161201201552.GF11750@dastard>
 <C28A1C2E-423B-48BC-8953-735B85CDFE08@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C28A1C2E-423B-48BC-8953-735B85CDFE08@flyingcircus.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Theune <ct@flyingcircus.io>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 06, 2016 at 08:25:52PM +0100, Christian Theune wrote:
> Hi,
> 
> here’s a follow-up. We found we have one host still running 4.1 that is awaiting its reboot to activate 4.4.
> 
> Is there a safe way forward that you would recommend? I would guess something like:
> 
> - shut down clients
> - unmount filesystems

- run xfs_repair from xfsprogs >4.5.0
- boot into 4.4 kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
