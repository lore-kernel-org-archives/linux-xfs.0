Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 13:45:01 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA2LilE2025511
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 13:44:47 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60EF37B058A
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 13:44:48 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id DzyFSLOQAONSVGL5 for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 13:44:48 -0800 (PST)
Date: Mon, 3 Nov 2008 08:44:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Which FileSystem do you use on your postfix server?
Message-ID: <20081102214444.GE19509@disturbed>
References: <20081031221817.GD19509@disturbed> <20081031225615.5E66B1F3EA0@spike.porcupine.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031225615.5E66B1F3EA0@spike.porcupine.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Wietse Venema <wietse@porcupine.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, Postfix users <postfix-users@postfix.org>, xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 06:56:15PM -0400, Wietse Venema wrote:
> Dave Chinner:
> Here's something I would like to know regarding the order of
> directory updates:
> 
> - Does fsync(file) guarantee the file's directory entry is safe?

No.

> Some file systems complete directory updates before the open/link/rename
> system call returns, so fsync() doesn't have to worry about it.

If you run with '-o dirsync', all directory transactions are guaranteed
to be in the log on disk by the time the syscall returns. Note that
this means you do at least one log write per create/link/rename/unlink
syscall, which has performance impact....

> - Does rename() guarantee that at least one directory entry will
> exist even when the system crashes in the middle of the operation?

Yes - either it will complete atomically or no change will occur at
all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
