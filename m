Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37064 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbeB0AYD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 19:24:03 -0500
Subject: Re: [RFC] mkfs config file bikeshed now!
References: <20180226224224.GE19312@magnolia>
 <71515062-0ca8-3dbd-88d0-26c9d10b2c9d@sandeen.net>
 <20180226235649.GG19312@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d08407df-bf42-9d83-47a6-021d12aadeec@sandeen.net>
Date: Mon, 26 Feb 2018 18:24:01 -0600
MIME-Version: 1.0
In-Reply-To: <20180226235649.GG19312@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>



On 2/26/18 5:56 PM, Darrick J. Wong wrote:
>>> For example, say we had a /etc/xfs.conf file shipping with xfsprogs:
>> /etc/mkfs.xfs.conf please, this configures mkfs and nothing else, right?
> Ok.  I mean, I might let that be $sysconfdir/mkfs.xfs.conf or something,
> but I agree about the filename component of the path.
> 

*nod*

Also a $sysconfdir/mkfs.xfs.conf.d/ scanning scheme might be a
useful feature.

Or if we ban inheritance between sections (please), as darrick stated
offline maybe just allowing configfile specification on the commandline
so that you could point to /etc/xfs/mkfs/$FOO_OS.conf

The point would be that over-arching OS config file package could
drop in all the relevant config files for its defaults rather than
munging it all together in one config file.  I.e. if ceph wants one
thing and glusterfs wants another they could each supply their own
mkfs.xfs config file w/o hassle.

-Eric
