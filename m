Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43326 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754016AbeALBHq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 20:07:46 -0500
Subject: Re: [PATCH 01/27] xfs_scrub: create online filesystem scrub program
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520349393.2027.11445111828418979100.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c0fbf23d-022f-3eae-fcf5-bb93e8760683@sandeen.net>
Date: Thu, 11 Jan 2018 19:07:43 -0600
MIME-Version: 1.0
In-Reply-To: <151520349393.2027.11445111828418979100.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 1/5/18 7:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create the foundations of a filesystem scrubbing tool that asks the
> kernel to inspect all metadata in the filesystem and (ultimately) to
> repair anything that's broken.  Also create the man page for the
> utility.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

...

> +/*
> + * XFS Online Metadata Scrub (and Repair)
> + *
> + * The XFS scrubber uses custom XFS ioctls to probe more deeply into the
> + * internals of the filesystem.  It takes advantage of scrubbing ioctls
> + * to check all the records stored in a metadata object and to
> + * cross-reference those records against the other filesystem metadata.
> + *
> + * After the program gathers command line arguments to figure out
> + * exactly what the user wants the program is going to do, scrub

* exactly what the user wants the program to do

or -

* exactly what the program is going to do

or -

* exactly what the user wants to do

:)

> + * execution is split up into several separate phases:
> + *
> + * The "find geometry" phase queries XFS for the filesystem geometry.
> + * The block devices for the data, realtime, and log devices are opened.
> + * Kernel ioctls are test-queried to see if they actually work (the scrub
> + * ioctl in particular), and any other filesystem-specific information
> + * is gathered.
> + *
> + * In the "check internal metadata" phase, we call the metadata scrub
> + * ioctl to check the filesystem's internal per-AG btrees.  This
> + * includes the AG superblock, AGF, AGFL, and AGI headers, freespace
> + * btrees, the regular and free inode btrees, the reverse mapping
> + * btrees, and the reference counting btrees.  If the realtime device is
> + * enabled, the realtime bitmap and reverse mapping btrees are enabled.

checked?

-Eric
