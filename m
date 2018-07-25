Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729339AbeGYU3q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 16:29:46 -0400
Date: Wed, 25 Jul 2018 12:16:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Question about reflink feature
Message-ID: <20180725191626.GA4809@magnolia>
References: <5B582B43.8070207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B582B43.8070207@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: xfs <linux-xfs@vger.kernel.org>

[add linux-xfs to cc]

On Wed, Jul 25, 2018 at 03:48:19PM +0800, Xiao Yang wrote:
> Hi Darrick,
> 
> Sorry to bother you.
> 
> Currently, all reflink tests for XFS in xfstests are skipped even if we
> use the lastest kernel and xfsprogs.
> It seems that mkfs.xfs doesn't enable reflink by default, do you want to
> enable it by default in later
> xfsprogs version?

It will be enabled by default when we've had a long enough period to
test it and make sure it's stable for general use.  That may happen some
time in early 2019.

> Shoud we enable it forcely by "mkfs.xfs -m reflink" in
> xfstests if mkfs.xfs supports it?

For now, yes.

--D

> 
> Thanks,
> Xiao Yang
> 
> 
