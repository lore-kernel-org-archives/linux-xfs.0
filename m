Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 14:03:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8KL2ugf014162
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 14:02:59 -0700
Message-ID: <46F2E001.4040107@sandeen.net>
Date: Thu, 20 Sep 2007 16:02:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs and Linux Linux 2.6.22 and Memory
References: <435577.15025.qm@web35711.mail.mud.yahoo.com>
In-Reply-To: <435577.15025.qm@web35711.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mariella Petrini <mariellapetrini@yahoo.com>
Cc: xfs@oss.sgi.com

Mariella Petrini wrote:

> QUESTION:
> 
> Is there any way to release that amount of memory
> without unmounting the file systems ?
> Is that caused to some caching mechanism ?
> Or could that be caused by something else ?

It's most likely the linux VFS caching the dentries & inodes, and
therefore caching the xfs inodes as well.

cat /proc/sys/fs/dentry-state and /proc/sys/fs/inode-state to see how
many are in memory, how many are active, and the age limit.

slabtop would fairly easily show you how much is in the dentry_cache &
the inode_cache too.

Are you actually seeing a problem with this (caching is generally good)
or just curious?

-Eric
