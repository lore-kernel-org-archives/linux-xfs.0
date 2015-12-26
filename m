Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 63CFB7F37
	for <xfs@oss.sgi.com>; Sat, 26 Dec 2015 17:45:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 52E168F8033
	for <xfs@oss.sgi.com>; Sat, 26 Dec 2015 15:45:36 -0800 (PST)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id k98mqsk3G22A0T5i (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 26 Dec 2015 15:45:34 -0800 (PST)
Message-ID: <567F2677.7040304@tlinx.org>
Date: Sat, 26 Dec 2015 15:44:55 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: XFS and nobarrier with SSDs
References: <E127700EFE58FD45BD6298EAC813FA42020D8173@TIGER2010.xortex.local>	<3496214.YTSKClH6pV@merkaba>
	<566E6524.6070401@xortex.com>	<3911767.qVqsL1TcMv@merkaba>
	<20151214095823.GA30662@infradead.org>	<566E978E.2070502@xortex.com>
	<20151214102750.GA29192@infradead.org>
In-Reply-To: <20151214102750.GA29192@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Block mailing list <linux-block@vger.kernel.org>, Linux FS-Devel <linux-fsdevel@vger.kernel.org>, XFS mailing list <xfs@oss.sgi.com>



Christoph Hellwig wrote:
> The rule of thumb is: if nobarrier makes your workload run faster you
> should not be using it, aka: don't use it. 
----
	So what is the purpose of the switch if it is to only
be used when it makes no difference?

I.e. My raid controller does write-through if it's internal
battery needs replacing, otherwise, it does write-back.

On top of that my system is on a UPS that is good for a hour or more
of running.  

So, I used to use nobarrier on "work" disks where there were likely
to be alot of "writes".  Those disks are also backed up daily via
xfsdump/restore.  I figured those would benefit most, and at worst
I could restore to previous morning's backup.

Eventually stopped using the option, as for the most part, I couldn't
really measure any reliable difference in performance (which means
I should use it?!?).

Hmmm...

The only times I have experienced disk corruption on a single
disk were either back before I ever tried the option, or when
I had several months to a year where I tried to use software
RAID5 (several-10+ years ago, before it was possible to use
multiple cores for doing some RAID operations).

I doubt I'm going to try it again soon, but being told that
it's only "ok" to use an option when it makes no difference
in performance *sounds* more than a little confusing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
