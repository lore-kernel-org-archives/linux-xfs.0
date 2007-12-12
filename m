Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 05:20:05 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBCDJYQj007484
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 05:19:36 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27B57471BF6
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 05:19:45 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id IjvV5vP05gumEUe8 for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 05:19:45 -0800 (PST)
Date: Wed, 12 Dec 2007 08:19:14 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mkfs.xfs ... lazy-count=1 ... not mountable by older kernels?
In-Reply-To: <475F2D54.3090609@sgi.com>
Message-ID: <Pine.LNX.4.64.0712120818500.3691@p34.internal.lan>
References: <475EE83A.3060607@ca.sophos.com> <20071211221554.GC4612@sgi.com>
 <475F2D54.3090609@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Sparks <dave@ca.sophos.com>, xfs@oss.sgi.com



On Wed, 12 Dec 2007, Timothy Shimmin wrote:

> David Chinner wrote:
>> On Tue, Dec 11, 2007 at 11:42:50AM -0800, David Sparks wrote:
>>> Hi all,
>>> 
>>> Is it expected that filesystems made with lazy-count=1 are not mountable 
>>> by
>>> older kernels?
>> 
>> That is expected. lazy-count is a mkfs option because it changes the 
>> on-disk
>> format slightly, and older kernels do not understand that format. Hence
>> mkfs sets a superblock feature bit to prevent the filesystem from being
>> mounted on kernels that don't understand the slightly different disk 
>> format.
>> 
>> Cheers,
>> 
>> Dave.
>
> And there will be a message in the logs but it probably isn't
> overly obvious what it is talking about.
>
> Looking at code, I presume it will come from:
>        if (!XFS_SB_GOOD_VERSION(sbp)) {
>                xfs_fs_mount_cmn_err(flags, "bad version");
>                return XFS_ERROR(EWRONGFS);
>        }
> so there will be a msg about a "bad version".
>
> --Tim
>
>

Has anyone done any benchmarks with Dave Chinner's recommendations for 
mkfs.xfs/optmizations?

Justin.
