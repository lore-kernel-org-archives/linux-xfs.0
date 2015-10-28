Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C403D7CBF
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 12:31:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57D23AC001
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 10:31:44 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	6cxdlNGpuYT5TRtT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Oct 2015 10:31:41 -0700 (PDT)
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[127.0.0.1])
	by firestarter.dermichi.com with esmtpsa
	(TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim)
	(envelope-from <mw@dermichi.com>) id 1ZrUZX-0001Y5-Rj
	for xfs@oss.sgi.com; Wed, 28 Oct 2015 18:31:39 +0100
Subject: Re: Speeding up xfs_repair on filesystem with millions of inodes
References: <562F699E.2050002@dermichi.com> <20151027193855.GM8773@dastard>
	<562FFFF7.4010908@dermichi.com> <20151028001744.GO19199@dastard>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <5631067A.4050306@dermichi.com>
Date: Wed, 28 Oct 2015 18:31:38 +0100
MIME-Version: 1.0
In-Reply-To: <20151028001744.GO19199@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Dave!
Everything is in good shape again. This time xfs_repair finished without
detecting any problems. So i suppose the only problem was that there
wasn't enough RAM.
---snip---
        XFS_REPAIR Summary    Wed Oct 28 15:02:30 2015

Phase           Start           End             Duration
Phase 1:        10/27 23:19:34  10/27 23:19:34
Phase 2:        10/27 23:19:34  10/27 23:19:57  23 seconds
Phase 3:        10/27 23:19:57  10/28 04:10:50  4 hours, 50 minutes, 53
seconds
Phase 4:        10/28 04:10:50  10/28 09:03:00  4 hours, 52 minutes, 10
seconds
Phase 5:        10/28 09:03:00  10/28 09:03:16  16 seconds
Phase 6:        10/28 09:03:16  10/28 15:02:29  5 hours, 59 minutes, 13
seconds
Phase 7:        10/28 15:02:29  10/28 15:02:29

Total run time: 15 hours, 42 minutes, 55 seconds
---snip---

On 28.10.2015 01:17, Dave Chinner wrote:
> 
> Maybe you have a disk that is dying. Do your drives have TLER
> enabled on them?
>
Thanks for the hint. These are all enterprise-grade Nearline-SAS drives
(SEAGATE ST32000444SS) attached to a Dell PERC 6/i controller. I think
it isn't even possible to turn TLER on or off on them. They should all
be in good shape since the controller automatically does periodic patrol
reads.

On 28.10.2015 01:17, Dave Chinner wrote:
> 
> If kswapd is doing all the work, then it's essentially got no memory
> available. I would add significantly more swap space as well (e.g.
> add swap files to the root filesystem - you can do this while repair
> is running, too). If there's sufficient swap space, then repair
> should use it fairly efficiently - it doesn't tend to thrash swap
> because most of it's memory usage is for information that is only
> accessed once per phase or is parked until it is needed in a later
> phase so it doesn't need to be read from disk again...
> 
Good to know. However, the system was never low on swap. It has 40GB
swap available and never used more than 10GB during the repair (with 8GB
RAM). On the second run, with 16GB RAM, the xfs_repair never used any
swap at all.

On 28.10.2015 01:17, Dave Chinner wrote:
> 
> Defaults, but it's really only a guideline for cache sizing. If
> repair needs more memory to store metadata it is validating (like
> the directory structure) then it will consume as much as it needs.
> 
Will keep that in mind.

Thanks again for your help.

with kind regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
