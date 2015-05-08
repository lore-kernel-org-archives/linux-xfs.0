Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1FEDC7F37
	for <xfs@oss.sgi.com>; Fri,  8 May 2015 00:53:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 161B1304053
	for <xfs@oss.sgi.com>; Thu,  7 May 2015 22:53:55 -0700 (PDT)
Received: from mail-pd0-f178.google.com (mail-pd0-f178.google.com
	[209.85.192.178]) by cuda.sgi.com with ESMTP id
	U0tyx9u99HIE1z84 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 May 2015 22:53:51 -0700 (PDT)
Received: by pdbqd1 with SMTP id qd1so65562402pdb.2
	for <xfs@oss.sgi.com>; Thu, 07 May 2015 22:53:50 -0700 (PDT)
Message-ID: <554C4F6A.5060501@xtremenitro.org>
Date: Fri, 08 May 2015 12:53:46 +0700
From: Dewangga Bachrul Alam <dewanggaba@xtremenitro.org>
MIME-Version: 1.0
Subject: Re: Valid Benchmark Value & Methods
References: <554B4B59.6000706@xtremenitro.org> <2204700.QypQcg3ER3@merkaba>
	<554B5782.4040303@xtremenitro.org> <20150507225521.GB16689@dastard>
In-Reply-To: <20150507225521.GB16689@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hello Dave!



On 05/08/2015 05:55 AM, Dave Chinner wrote:
> On Thu, May 07, 2015 at 07:16:02PM +0700, Dewangga wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hello Martin,
>> Thanks for your reply, yes I've read that link, but another question,
>> is noatime,nodiratime,etc still valid for performance tuning guidance?
> 
> You may have read it, but I don't think it sunk in....
> 
>> Even the default mount options only "rw,inode64,seclabel,attr2".
> 
> Where's relatime(*)? That's been a default for a lot longer than
> inode64...
> 
> $ grep "root " /proc/mounts
> /dev/root / xfs rw,relatime,attr2,inode64,noquota 0 0
> $
> 

I forgot write it, but relatime still exists on default mount options.

>> Is it still increase the performance if the additional mount options
>> added?
> 
> Depends on your workload, which is more critical to understand than
> anything else. Why? because it's your workload that is going to
> determine if twiddling a knob is going to have any effect on
> performance. Once you understand the workload and what the
> bottlenecks are, then you can look at what knobs the filesystem
> provides to alleviate those bottlenecks.
> 
> IOWs, asking the question "how do I tune my filesystem for best
> performance" is, fundamentally, the wrong way to go about obtaining
> best filesystem performance.  The questions that need to be answered
> are "what bottlenecks does my application have?" followed by "what
> does the filesystem provide to alleviate those bottlenecks".
> 
> i.e. understand the problem you need to solve *before* you try to
> solve it, otherwise you "solve" the wrong problem...
> 
> Cheers,
> 
> Dave.
> 
> (*) An example of exactly what I'm talking abou there. The default
> option of relatime gets >95% of the benefit of noatime onmost
> workloads compared to the old strictatime behaviour, but unlike
> noatime it still retains atime updates. IOWs there's a pretty good
> chance that noatime has little measurable impact on your
> application's performance, but understanding and benchmarking
> anything other than your application won't tell you this.
> 

Okay dave, got it. Standard optimize performance is add mount options
like noatime and nodiratime, any additional performance tune is depends
on the apps and the workloads.

Thanks anyway :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
