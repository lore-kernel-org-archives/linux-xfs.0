Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 51DA67FAA
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 17:02:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2320AC008
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 15:02:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mzQN87XEzXdFBP3b for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 15:02:48 -0700 (PDT)
Date: Fri, 15 Mar 2013 09:02:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
Message-ID: <20130314220244.GA21651@dastard>
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
	<CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
	<51373FC1.6010101@redhat.com>
	<CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
	<513751F2.2060109@redhat.com>
	<CAOdS1hngSuHn_HiremLyUS7Qd9eZ68=8arfBuHnEpwXQaBw9Wg@mail.gmail.com>
	<5140CBE3.80705@sandeen.net> <20130313234213.GW21651@dastard>
	<CAOdS1hnVoMtXnOrECrU8xUyRn82UUJ=jMzX0_odnAs0GH8V-yA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOdS1hnVoMtXnOrECrU8xUyRn82UUJ=jMzX0_odnAs0GH8V-yA@mail.gmail.com>
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
To: Shrinath M <shrinath.m@webyog.com>
Cc: Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, Vivek Goel <vivek.goel@webyog.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, Supratik Goswami <supratik.goswami@webyog.com>, Ric Wheeler <rwheeler@redhat.com>

On Thu, Mar 14, 2013 at 06:58:19AM +0530, Shrinath M wrote:
> Thanks Ben, Dave and Eric.
> 
> Eric,
> >>but I am wondering if there might be more information before this which
> is not in your trimmed logs.
> No, this was the first entry every time we have it in /var/log/messages.
> dmesg also holds the same. After reboot, it simply fixes without anyone
> doing anything.
> 
> The Linux we are running is definitely amazon baked one, looks like this -
> $~: uname -a Linux ip-100-0-100-1 3.2.34-55.46.amzn1.x86_64 #1 SMP Tue Nov
> 20 10:06:15 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

So, this is an amazon special kernel by the looks of it. I think
that only amazon can really help you track down the problem...

>  - dmesg shows something like this after repairing/rebooting -
> 
> [    8.414176] SGI XFS with ACLs, security attributes, realtime, large
> block/inode numbers, no debug enabled
> [    8.415342] SGI XFS Quota Management subsystem
> [    8.417664] XFS (md0): Mounting Filesystem
> [    8.771553] XFS (md0): Starting recovery (logdev: internal)
> [    9.977325] XFS (md0): Ending recovery (logdev: internal)
> 
> Check the first line there, it says no debug enabled. How good/bad is this
> debug mode in production environments? We are not getting any corruption in
> our local/test environments, in production, we are getting it once on every
> third day.

debug shoul dnot be used in production environments. It'll cause
panics in situations where production kernels continue just
fine, and it changes the allocation algorithms to give better code
coverage for testing rather than optimal layout.

> Dave,
> You say unlinked inode list, but if that, it should have an entry in
> /var/log/messages, right?

It did - the error that Eric pointed out.

> Anyway, how can we create this situation?

If I knew, I would have fixed the bug already. You need to work out
what in your production environment is triggering it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
