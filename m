Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o28Mhskr077484 for <xfs@oss.sgi.com>; Mon, 8 Mar 2010 16:43:54 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E8131D2009C
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 14:45:25 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id M0N7FVAZrbXik2ht for
	<xfs@oss.sgi.com>; Mon, 08 Mar 2010 14:45:25 -0800 (PST)
Message-ID: <4B957E03.9090000@sandeen.net>
Date: Mon, 08 Mar 2010 16:45:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: What are the correct mkfs.xfs parameters for a lying WD-EARS HDD?
References: <20100308221044.GA17830@citd.de>
In-Reply-To: <20100308221044.GA17830@citd.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

Matthias Schniedermeyer wrote:
> Hi
> 
> 
> More than a month ago i bought 4 Western Digital WD15EARS (1.5 TB) which 
> are (AFAIK) the first general/commercial available 4k sector SATA-HDDs.
> 
> Unfortunatly the HDDs lie about the 4k physical sector size and the most 
> prominent drawback is a worse than abysmal delete performance.
> ("Normal" Read & Write-performance is OK)
> 
> So if i wanted to (re-)mkfs the filesystems what would the correct 
> parameters be?
> 
> Kernel/Userspace is pretty recent (Debian-SID):
> mkfs.xfs version 3.1.1, kernel v2.6.33, util-linux 2.16.0
> Not that that should matter when the HDDs lies.

Recent kernel+util-linux-ng++fdisk+parted+xfsprogs -should- do the right thing for you....
Oh, but this was maybe the drive that didn't output the right stuff when queried.

Make sure your partitions, if any, are on 4k boundaries.(*)  older fdisk at least
won't do this by default, not sure about parted.

once that is done, tell mkfs.xfs "-s size=4096" to set the 4k sector size
(again, all-upstream should do this magically for sane drives)

-Eric

(*)unless the drive has an offset to make 512-sector 63 line up on a nice
boundary... in which case I guess you could experiment with perf both
ways to be sure...

> 
> Bis denn
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
