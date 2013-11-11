Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7554F7F6B
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 12:30:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 042ACAC003
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 10:30:20 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YHON5y7Hwn81QVhi for <xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 10:30:19 -0800 (PST)
Message-ID: <5281223A.7010503@sandeen.net>
Date: Mon, 11 Nov 2013 12:30:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: ag selection
References: <l5r3tf$m0j$1@ger.gmane.org>	<20131111175313.GA16643@orion.maiolino.org>	<20131111175550.GB16643@orion.maiolino.org>
	<528120B7.9030802@itwm.fraunhofer.de>
In-Reply-To: <528120B7.9030802@itwm.fraunhofer.de>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, xfs@oss.sgi.com

On 11/11/13, 12:23 PM, Bernd Schubert wrote:

> One of my colleagues benchmarked this on one of our fast systems and another 
> colleague current needs this system for other tests, so I don't have the 
> exact parameters. However, it was for sure formated with options like these:
> 
> mkfs.xfs -d su=256k,sw=10 -l version=2,su=256k -isize=512 /dev/sdX
> 
> and mounted with these options:
> 
> mount -onoatime,nodiratime,largeio,inode64,swalloc,allocsize=131072k,nobarrier /dev/sdX <mountpoint>

With all due respect, this is excessive knob-twiddling.  Slow down.  ;)

* V2 logs are default already, so -l version=2 is redundant.
* noatime implies nodiratime, so specifying both is redundant.
* "largeio" only changes the st_blksize value reported (from default page size to, in your case, the total stripe width).  Does that actually affect your application behavior?

Backing up, what kernel & what userspace versions are you testing?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
