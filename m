Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 11:05:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m29I5ViX010667
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 11:05:34 -0700
Date: Sun, 9 Mar 2008 19:05:53 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.25-rc hangs
In-Reply-To: <47D413FA.50602@sandeen.net>
Message-ID: <alpine.DEB.1.00.0803091858480.5349@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de> <alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
 <47D413FA.50602@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sun, 9 Mar 2008, Eric Sandeen wrote:
>> I tried to follow the git-bisect manpage (and have successfully used
>> bisect in the past a few times), but I think ~5700 revisions between
>> 2.6.24 and 2.6.25 are just too much fuzz. The bisect logs so far, with
>> my comments inbetween:
>
> Christian, what is the test you are using for the bisect?

Sorry, I don't understand: which "test" do you mean?

I did the bisect as per the bisect log and then just rebooted. Which gave 
me no usable results yet. I'm trying to boot 2.6.25-rc1 in a few moments 
and see if the hang is there as well. If it is, I'll start bisecting again 
and hope that "halfway between -rc1 and .24" will be a bootable kernel 
this time...

The "error" I'm trying to chase is a system "hang", but no instant lockup. 
I can reproduce this by increasing disk I/O. I did this primarily with 
rsync from different filesystems to my backup XFS partition. After a few 
minutes, the INFO: messages[0] appeared.

Thanks,
Christian.

[0] http://lkml.org/lkml/2008/3/7/308
-- 
BOFH excuse #2:

solar flares
