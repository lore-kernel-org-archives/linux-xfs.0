Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Sep 2006 19:15:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8M2EqaG010369
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 19:14:54 -0700
Date: Fri, 22 Sep 2006 12:14:01 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_read_buf error 5.
Message-ID: <20060922021401.GA3034@melbourne.sgi.com>
References: <20060922001619.GW3034@melbourne.sgi.com> <43FB1967D03EC7449A77FA91322E364802A9AB91@SVL1XCHCLUPIN01.enterprise.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43FB1967D03EC7449A77FA91322E364802A9AB91@SVL1XCHCLUPIN01.enterprise.veritas.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nikhil Kulkarni <nikhil_kulkarni@symantec.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Thu, Sep 21, 2006 at 05:45:32PM -0700, Nikhil Kulkarni wrote:
> Hi David,
> 
> Hi David,
> 
> Thanks for your prompt response, I really appreciate it!!! I made a
> major tying mistake in describing the initial size of the partitions. We
> are having issues when we assign a size > 2TB and not 2GB. I'm sorry
> about the typo.

I was wondering about that ;)

> Here are the 2 /proc/partition files:
> 
> This is the one where the partition size is 3.5T
> 
> [nikhil@nkulkarni tmp]$ more xfs-log-3.5T
> [root@ssimppi7 log]# cat /proc/partitions
> major minor  #blocks  name
> 
>    8     0 4093902848 sda
>    8     1 1436513398 sda1

That says it's only 1.4TB...

> This is the one where the partition size is 2TB:
> 
> [nikhil@nkulkarni tmp]$ more xfs-log-2T
> root@ssimppi7 log]# cat /proc/partitions
> major minor  #blocks  name
> 
>    8     0 4093902848 sda
>    8     1 2047998298 sda1

And that is 2TB.

> I think you are right. The partitions are not set up correctly.
> 
> Do you know on a 2.5 kernel on a 32 bit operating system, which tool can
> be used to setup partitions for sizes up to 4TB or 8TB?
> fdisk on a 32 bit os does not work correctly. I thought parted worked
> but apparently it does not either.

Did you build your kernel with CONFIG_LBD=y? (Block layer option)
This is the option that allows >2TB block devices on 32 bit kernels...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
