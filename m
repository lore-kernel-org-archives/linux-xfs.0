Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 17:18:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m750Iph3018189
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 17:18:51 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 158F535AEE4
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 17:20:04 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id MaLyzP4k8JB52PxN for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 17:20:04 -0700 (PDT)
Date: Tue, 5 Aug 2008 10:19:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corruption of in-memory data detected - on heavy  hard linking
Message-ID: <20080805001952.GI6119@disturbed>
References: <48876D03.8010804@stepping-stone.ch> <20080725052051.GA26367@infradead.org> <489732B2.7000201@stepping-stone.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489732B2.7000201@stepping-stone.ch>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Affolter <c.affolter@stepping-stone.ch>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 06:47:46PM +0200, Christian Affolter wrote:
> Hi
>
>> On Wed, Jul 23, 2008 at 07:40:19PM +0200, Christian Affolter wrote:
>>> Kernel-Error:
>>> Filesystem "sdc1": XFS internal error xfs_trans_cancel at line 1163 
>>> of  file fs/xfs/xfs_trans.c.  Caller 0xffffffff803a4fcf
>>> Pid: 22816, comm: cp Not tainted 2.6.24-gentoo-r8 #1
>>
>> 2.6.24 is pretty old.  Did you try with a recent kernel?  We had some
>> fixes for in-core memory corruption although I don't remember one in
>> this area.
>
> I finally found the time to update the kernel to a recent 2.6.26 version.
>
> Unfortunately the problem still exists:
> Filesystem "dm-3": XFS internal error xfs_trans_cancel at line 1163 of  
> file fs/xfs/xfs_trans.c.  Caller 0xffffffff803a6672
> Pid: 12584, comm: cp Not tainted 2.6.26-gentoo #1

Ok, what we need is the following. First, try to reproduce the
problem on a small filesystem (say a few GB). Once you've reproduced
the problem, unmount and remount the filesystem to get the log
replayed, then take a xfs_metadump image of the filesystem. Put the
metadump image somewhere that can be downloaded (ftp/web site) and
let us know where it is.

If this is anything like the previous problem I found and fixed,
then it will be a corner-case bug that is only triggered by a
specific layout of free space and we need the filesystem image
to be able to work out exactly what corner case is broken....

> Before the shutdown happens the copy command receives a
> "No space left on device" error:
> cp: cannot create regular file `[file name snipped': No space left on device
> cp: cannot create regular file `[file name snipped]': Input/output error
>
> Although the device has more than 50% free space as well as free inodes.

It will be an AG that is out of space, not the entire filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
