Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DA107F50
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 12:56:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4022F30405F
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 10:56:06 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id l2C6tBkfRvsiQLdk
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 10:56:06 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 90B606C0E7
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 12:56:05 -0500 (CDT)
Message-ID: <51912937.4030404@hardwarefreak.com>
Date: Mon, 13 May 2013 12:56:07 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_repair force_geometry
References: <5190DB7F.2050505@tum.de>
In-Reply-To: <5190DB7F.2050505@tum.de>
Reply-To: stan@hardwarefreak.com
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

On 5/13/2013 7:24 AM, Benedikt Schmidt wrote:
> Hi,
> currently I'm looking for the correct usage of the force_geometry option
> of xfs_repair. I wasn't able to find more documentation on this option
> beside that it exists. Could please somebody explain it to me?

> For a more detailed description of my problem: I've got here a hard disk
> which is dying at the moment, so I copied all the content with dd_rescue
> to a new and bigger one. To use xfs_copy wasn't possible as the
> filesystem was already corrupted. 

This is a standalone disk which wholly contains an XFS filesystem, yes?
 The filesystem is corrupted and cannot be repaired?  And it won't mount?

> So now I've got nearly everything on
> the second hard disk (dd_rescue could'nt copy something around 6 or 7
> MB), but I can not mount the filesystem or even run xfs_repair on it, as
> it fails to find a superblock. I think the problem lies in the fact that
> the new disk has a different geometry than the previous one.

Given the fact that the filesystem is already corrupted and not
repairable, and the disk is in a state of failure, it's not surprising
you can't repair or mount after the ddrescue copy, which now contains
the same corrupted structures.

If the original can't be repaired nor mounted, why would you believe a
sector-by-sector copy could be?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
