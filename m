Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B4707F98
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 17:22:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A2CB8F8035
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 15:22:17 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZmtqfIgI2CqLJNby for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 15:22:16 -0800 (PST)
Date: Fri, 8 Mar 2013 10:22:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem corruption
Message-ID: <20130307232214.GY23616@dastard>
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com>
	<CAPcwv6wK7m5UbJZass5690N5UpXEMV+HVzJa5mn9KWtT9UPQ9w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcwv6wK7m5UbJZass5690N5UpXEMV+HVzJa5mn9KWtT9UPQ9w@mail.gmail.com>
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
To: Julien FERRERO <jferrero06@gmail.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

On Thu, Mar 07, 2013 at 02:15:31PM +0100, Julien FERRERO wrote:
> > We actually test brutal "Power off" for xfs, ext4 and other file systems. If
> > your storage is configured properly and you have barriers enabled, they all
> > pass without corruption.
> >
> > What hardware raid cards can do is to hide a volatile write cache. Either on
> > the raid HBA itself or, even worse, on the backend disks behind the card.
> > S-ata disks tend to default to write cache enabled and need to be checked
> > especially careful (sas drives tend to be write cache disabled by default).
> 
> Write cache is supposed to be disabled on the H/W RAID (according to
> hdparm) and barrier are correctly enabled since xfs does not report
> any warning at mount.
> 
> The odd thing is we never see this with kernel 2.6.18 where barriers
> weren't yet available.

Yes they were. XFS had barrier support added in 2.6.15.

> An other difference is the "unwritten extend"
> that was used to set to 0 by default. Now we cannot change this
> setting according to an old thread I've found: "unwritten extents on
> linux are generally a bad idea, this option should not be used.".

Yes, that would have been me that said that. I started seeing lots
of boy-racer "tweak your filesystem to go faster" blogs recommending
that unwritten extents should be turned off high up in google
results, with numbers to prove that it improved performance.

There were two common things wrong with these blogs:

	1. None of them mentioned that turning off unwritten extents
	exposes stale data to users. i.e. a whopping great big
	security hole.

	2. they reported significant performance improvements for
	workloads that *didn't use unwritten extents* when they set
	this flag. i.e. they mistook run-to-run variablity of the
	benchmark for a performance improvement. i.e. Benchmarking
	101 Fail.

When you get people who do not understand what they are doing and
giving bad advice as the first 10 hits for a google search about
optimising/tuning XFS filesystems, it's a major concern, and so I
took steps to ensure you can't turn off unwritten extents with
mkfs...

> Unfortunately, the engineer that chose this setting is no longer
> working with us...

It sounds like he read one too many of these blogs, because if mysql
is triggering speculative preallocation, it is not using unwritten
extents....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
