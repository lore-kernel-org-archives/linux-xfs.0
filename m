Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:19715
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031509AbeBNVwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 16:52:47 -0500
Date: Thu, 15 Feb 2018 08:52:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: freezing system for several second on high I/O [kernel 4.15]
Message-ID: <20180214215245.GI7000@dastard>
References: <20180131022209.lmhespbauhqtqrxg@destitution>
 <1517888875.7303.3.camel@gmail.com>
 <20180206060840.kj2u6jjmkuk3vie6@destitution>
 <CABXGCsOgcYyj8Xukn7Pi_M2qz2aJ1MJZTaxaSgYno7f_BtZH6w@mail.gmail.com>
 <1517974845.4352.8.camel@gmail.com>
 <20180207065520.66f6gocvxlnxmkyv@destitution>
 <1518255240.31843.6.camel@gmail.com>
 <1518255352.31843.8.camel@gmail.com>
 <20180211225657.GA6778@dastard>
 <1518643669.6070.21.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1518643669.6070.21.camel@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mikhail <mikhail.v.gavrilov@gmail.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

On Thu, Feb 15, 2018 at 02:27:49AM +0500, mikhail wrote:
> On Mon, 2018-02-12 at 09:56 +1100, Dave Chinner wrote:
> > IOWs, this is not an XFS problem. It's exactly what I'd expect
> > to see when you try to run a very IO intensive workload on a
> > cheap SATA drive that can't keep up with what is being asked of
> > it....
> > 
> 
> I am understand that XFS is not culprit here. But I am worried
> about of interface freezing and various kernel messages with
> traces which leads to XFS. This is my only clue, and I do not know
> where to dig yet.

I've already told you the problem: sustained storage subsystem
overload. You can't "tune" you way around that. i.e. You need a
faster disk subsystem to maintian the load you are putting on your
system - either add more disks (e.g. RAID 0/5/6) or to move to SSDs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
