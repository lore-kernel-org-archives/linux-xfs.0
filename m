Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o05FUAtj216458 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 09:30:11 -0600
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B6901412D0
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2010 07:31:00 -0800 (PST)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id Bq7tDsjieYDr1K9e for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2010 07:31:00 -0800 (PST)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e6.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o05FQufI013016
	for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 10:26:56 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	o05FUxG3103376 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 10:30:59 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id
	o05FUw75007194 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 13:30:59 -0200
Message-ID: <4B435B34.20003@austin.ibm.com>
Date: Tue, 05 Jan 2010 09:31:00 -0600
From: Steven Pratt <slpratt@austin.ibm.com>
MIME-Version: 1.0
Subject: Re: [Jfs-discussion] benchmark results
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<20091224234631.GA1028@ioremap.net>
	<20091225161146.GC32757@thunk.org> <20100104162748.GA11932@think>
	<20100105004117.GP13802@discord.disaster>
In-Reply-To: <20100105004117.GP13802@discord.disaster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, tytso@mit.edu, reiserfs-devel@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>, xfs@oss.sgi.com, Chris Mason <chris.mason@oracle.com>, ext-users <ext3-users@redhat.com>

Dave Chinner wrote:
> On Mon, Jan 04, 2010 at 11:27:48AM -0500, Chris Mason wrote:
>   
>> On Fri, Dec 25, 2009 at 11:11:46AM -0500, tytso@mit.edu wrote:
>>     
>>> On Fri, Dec 25, 2009 at 02:46:31AM +0300, Evgeniy Polyakov wrote:
>>>       
>>>>> [1] http://samba.org/ftp/tridge/dbench/README
>>>>>           
>>>> Was not able to resist to write a small notice, what no matter what, but
>>>> whatever benchmark is running, it _does_ show system behaviour in one
>>>> or another condition. And when system behaves rather badly, it is quite
>>>> a common comment, that benchmark was useless. But it did show that
>>>> system has a problem, even if rarely triggered one :)
>>>>         
>>> If people are using benchmarks to improve file system, and a benchmark
>>> shows a problem, then trying to remedy the performance issue is a good
>>> thing to do, of course.  Sometimes, though the case which is
>>> demonstrated by a poor benchmark is an extremely rare corner case that
>>> doesn't accurately reflect common real-life workloads --- and if
>>> addressing it results in a tradeoff which degrades much more common
>>> real-life situations, then that would be a bad thing.
>>>
>>> In situations where benchmarks are used competitively, it's rare that
>>> it's actually a *problem*.  Instead it's much more common that a
>>> developer is trying to prove that their file system is *better* to
>>> gullible users who think that a single one-dimentional number is
>>> enough for them to chose file system X over file system Y.
>>>       
>> [ Look at all this email from my vacation...sorry for the delay ]
>>
>> It's important that people take benchmarks from filesystem developers
>> with a big grain of salt, which is one reason the boxacle.net results
>> are so nice.  Steve more than willing to take patches and experiment to
>> improve a given FS results, but his business is a fair representation of
>> performance and it shows.
>>     
>
> Just looking at the results there, I notice that the RAID system XFS
> mailserver results dropped by an order of magnitude between
> 2.6.29-rc2 and 2.6.31. The single disk results are pretty
> much identical across the two kernels.
>
> IIRC, in 2.6.31 RAID0 started passing barriers through so I suspect
> this is the issue. However, seeing as dmesg is not collected by
> the scripts after the run and the output of the mounttab does
> not show default options, I cannot tell if this is the case. 
Well the dmesg collection is done by the actual benchmark run which 
occurs after the mount command is issued, so if you are looking for 
dmesg related to mounting the xfs volume, it should be in the dmesg we 
did collect.  If dmesg actually formatted timestamps, this would be 
easier to see.  It seems that nothing from xfs is ending up in dmesg 
since we are running xfs with different threads counts in order without 
reboot, so the dmesg for 16 thread xfs is run right after 1 thread xfs, 
but the dmesg show ext3 as the last thing, so safe to say no output from 
xfs is ending up in dmesg at all.


> This
> might be worth checking by running XFS with the "nobarrier" mount
> option....
>   
I could give that a try for you.

> FWIW, is it possible to get these benchmarks run on each filesystem for
> each kernel release so ext/xfs/btrfs all get some regular basic
> performance regression test coverage?
>   
Possible yes.  Just need to find the time to do the runs, and more 
importantly postprocess the data in some meaningful way.  I'll see what 
I can do.

Steve

> Cheers,
>
> Dave.
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
