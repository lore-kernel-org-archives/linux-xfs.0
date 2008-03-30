Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Mar 2008 21:53:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2U4r6ZK004822
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 21:53:10 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 239A88C27DA
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 21:53:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 8uqQmnmBoj7VTw94 for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 21:53:41 -0700 (PDT)
Message-ID: <47EF1CD4.7070009@sandeen.net>
Date: Sat, 29 Mar 2008 23:53:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] detect and correct bad features2 superblock field
References: <20080220054041.GM155407@sgi.com> <47EEED18.9090206@sandeen.net> <20080330045014.GA26934@josefsipek.net>
In-Reply-To: <20080330045014.GA26934@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Josef 'Jeff' Sipek wrote:
> On Sat, Mar 29, 2008 at 08:30:00PM -0500, Eric Sandeen wrote:

>> Hm, the other problem here may be that if we zero bad_features2, then
>> any older kernel will mount up as attr2... and run into the corruption
>> problem I found on F8...
>>
>> Should we make features2 and bad_features2 match rather than zeroing
>> bad_features2?
> 
> I thought that was discussed here (or was it on IRC?), and the conclusion
> was the best way is to always have features2 == bad_features2.  It is the
> safest way to handle things - the filesystem is guaranteed to work
> everywhere properly (old & new kernels).  Both the userspace (xfs_repair)
> and kernel have to of course do the same thing (or bad_features2 with
> features2, and save the result in both locations).
> 
> At least that's what I seem to remember.
> 
> Josef 'Jeff' Sipek.
> 

It might have been, but it's not what was checked in... *shrug*

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c#rev1.419


-Eric
