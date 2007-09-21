Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 19:14:30 -0700 (PDT)
Received: from web35703.mail.mud.yahoo.com (web35703.mail.mud.yahoo.com [66.163.179.157])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L2ELgf002908
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 19:14:24 -0700
Date: Thu, 20 Sep 2007 19:14:23 -0700 (PDT)
From: Mariella Petrini <mariellapetrini@yahoo.com>
Subject: Re: xfs and Linux Linux 2.6.22 and Memory
In-Reply-To: <46F2E001.4040107@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <773373.46803.qm@web35703.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, dgc@sgi.com


> 
> Are you actually seeing a problem with this (caching
> is generally good)
> or just curious?
>
I was mostly curious, especially because In some cases
after having created all the files I may not need to
have all of them cached and I may need to availability
of the RAM for other purposes.


Thank you all for all the info,

Mariella


--- Eric Sandeen <sandeen@sandeen.net> wrote:

> Mariella Petrini wrote:
> 
> > QUESTION:
> > 
> > Is there any way to release that amount of memory
> > without unmounting the file systems ?
> > Is that caused to some caching mechanism ?
> > Or could that be caused by something else ?
> 
> It's most likely the linux VFS caching the dentries
> & inodes, and
> therefore caching the xfs inodes as well.
> 
> cat /proc/sys/fs/dentry-state and
> /proc/sys/fs/inode-state to see how
> many are in memory, how many are active, and the age
> limit.
> 
> slabtop would fairly easily show you how much is in
> the dentry_cache &
> the inode_cache too.
> 
> Are you actually seeing a problem with this (caching
> is generally good)
> or just curious?
> 
> -Eric
> 
> 
> 



       
____________________________________________________________________________________
Be a better Globetrotter. Get better travel answers from someone who knows. Yahoo! Answers - Check it out.
http://answers.yahoo.com/dir/?link=list&sid=396545469
