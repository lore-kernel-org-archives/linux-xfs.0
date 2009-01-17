Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0HIoVXg031284 for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 12:50:31 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAA3598952
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 10:50:29 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id VAMrEnOLal9xtovB for
	<xfs@oss.sgi.com>; Sat, 17 Jan 2009 10:50:29 -0800 (PST)
Message-ID: <49722875.90202@sandeen.net>
Date: Sat, 17 Jan 2009 12:50:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: help with xfs_repair on 10TB fs
References: <adcf4ef70901170913l693376d7s6fd0395e2c88e10@mail.gmail.com>	<4972166D.5000006@sandeen.net>
	<adcf4ef70901171042p31054ae0rb56819fce7b6f47e@mail.gmail.com>
In-Reply-To: <adcf4ef70901171042p31054ae0rb56819fce7b6f47e@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alberto Accomazzi <aaccomazzi@gmail.com>
Cc: xfs@oss.sgi.com

Alberto Accomazzi wrote:
> On Sat, Jan 17, 2009 at 12:33 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>> Alberto Accomazzi wrote:
>>> I need some help with figuring out how to repair a large XFS
>>> filesystem (10TB of data, 100+ million files).  xfs_repair seems to
>>> have crapped out before finishing the job and now I'm not sure how to
>>> proceed.
>> How did it "crap out?
> 
> 
> Well, in the way I described below, namely it ran for several hours and then
> died without completing.  As you can see from the log (which captured both
> stdout and stderr) there's nothing that indicates what terminated the
> program.  And it's definitely not running now.
> 
> 
>> the src.rpm from
>>
>> http://kojipkgs.fedoraproject.org/packages/xfsprogs/2.10.2/3.fc11/src/
>>
> 
> Ok, I guess it's worth giving it a shot.  I assume I don't need to worry
> about kernel modules because the xfsprogs don't depend on that, right?

right.

> 
>>> After bringing the system back, a mount of the fs reported problems:
>>>
>>> Starting XFS recovery on filesystem: sdb1 (logdev: internal)
>>> Filesystem "sdb1": XFS internal error xfs_btree_check_sblock at line 334
>> of file
>>>  /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_btree.c.
>>  Caller 0x
>>> ffffffff882fa8d2
>> so log replay is failing now; but that indicates an unclean shutdown.
>> Something else must have happened between the xfs_repair and this mount
>> instance?
>>
> 
> Sorry, I wasn't clear: there was indeed an unclean shutdown (actually a
> couple), after which the mount would not succeed presumably because of the
> dirty log.  I was able to mount the system read-only and take enough of a
> look to see that there was significant corruption of the data.  Running
> xfs_repair -L at that point seemed the only option available.  But do let me
> know if this line of thinking is incorrect.

yes, if you have a dirty log that won't replay, zapping the log via
repair is about the only option.  I wonder what the first hint of
trouble here was, though, what led to all this misery.... :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
