Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KJ01ee108001 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 14:00:01 -0500
Received: from mail1.noloco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5613C111B5F
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 12:01:14 -0700 (PDT)
Received: from mail1.noloco.com (mail.bcgibcgi.com [38.119.107.104]) by
	cuda.sgi.com with ESMTP id GTjs5AlC2MD2ELde for
	<xfs@oss.sgi.com>; Wed, 20 Oct 2010 12:01:14 -0700 (PDT)
Received: from ASSP.nospam (localhost.localdomain [127.0.0.1])
	by mail1.noloco.com (Postfix) with ESMTP id 195CA268001
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 14:01:14 -0500 (CDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail1.noloco.com (Postfix) with ESMTP id A8DABE11C5
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 14:01:13 -0500 (CDT)
Received: from mail1.noloco.com ([127.0.0.1])
	by localhost (mail1.noloco.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XK7e3mFyLlLn for <xfs@oss.sgi.com>;
	Wed, 20 Oct 2010 14:01:12 -0500 (CDT)
Received: from [127.0.0.1] (173-165-241-186-minnesota.hfc.comcastbusiness.net
	[173.165.241.186])
	by mail1.noloco.com (Postfix) with ESMTPSA id 56F92E118F
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 14:01:12 -0500 (CDT)
Message-ID: <4CBF3C6C.2020803@dolphinlogic.com>
Date: Wed, 20 Oct 2010 14:01:00 -0500
From: Shawn Usry <shawn@dolphinlogic.com>
MIME-Version: 1.0
Subject: Re: Interesting possible XFS crash condition
References: <4CBE887F.6020506@dolphinlogic.com> <201010201012.39778@zmi.at>
In-Reply-To: <201010201012.39778@zmi.at>
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
Cc: xfs@oss.sgi.com



On 10/20/2010 3:12 AM, Michael Monnerie wrote:
> On Mittwoch, 20. Oktober 2010 Shawn Usry wrote:
>> Limited information shown in what I've been able to capture in the
>> kernel crash.  Nothing really specific or repeatable (different
>> message  each time) - some instances to the term "atomic" and "xfs"
>> - other times "irq" related
> I'm not a dev, but I'd say a kernel crash dump would be very helpful.
> Can't you at least take pictures of the messages?
>
> I've never read about such XFS errors, maybe you should
> 1) xfs_metadump
> 2) xfs_mdrestore (into a file)
> 3) mount that file
> and try to access files there. If this also crashes, it will really be
> XFS related.
>
> Also, can you try putting the hard disks onto another system, possibly
> with changing the RAID controller? It might be a hardware error.
>
Thanks for the suggestions / comments guys.

@Emmanuel - I've run a verify on the unit several times, some purposely, 
some that start automatically after the system reboots after a crash.
All have completed without a problem.   I even forcibly removed a disk, 
and re-added it to the array, to force a rebuild.  This completed 
without error,
or any messages other than start/completed in dmesg.

@Michael -  I can try to capture some of the kernel dump - but getting 
this info is often sketchy - most often, no dump is ever produced to 
even the console
screen.  Even using netconsole to redirect console output and kernel 
debugging set, there is often little if any information.   What data is 
sometimes
produced is rarely the same (seemingly) information - but I'll try to 
capture what I can on several repeat offenses.

I gave the xfs_metadata/xfs_mdrestore procedure a run and this produced 
no problems.  I could access the filesystem and files just fine - of 
course they are
all basically empty files so I couldn't really do any real work with 
them, but I could traverse the filesystem copy/move files just fine.  If 
there are any other
detailed tests I could try there please let me know.

On hardware swapping - I'll have to find an MB with a 64-bit pci slot in 
it.  Otherwise, I sadly don't have a second controller to work with.

A couple of other notes:

1.  I thought this might be driver-related (3w-xxxx) but I've tried 
several versions of the driver, by using different distributions (Centos 
5, Fedora 13)
with the same results.  To note, the array was originally created, and 
expanded, under Centos 5.5.   I reinstalled the OS to Fedora 13, hoping 
that newer
code might resolve the issue.  Same results.

2.  I did upgrade the firmware on the controller to a newer version 
AFTER the issue appeared, hoping this would resolve it.  Same results.

At this point I'm leaning toward faulty hardware somewhere.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
