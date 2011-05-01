Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41GrIsN184657 for <xfs@oss.sgi.com>; Sun, 1 May 2011 11:53:19 -0500
Received: from edge10.ethz.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 537D015D1316
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 09:56:53 -0700 (PDT)
Received: from edge10.ethz.ch (edge10.ethz.ch [82.130.75.186]) by cuda.sgi.com
	with ESMTP id 2SxXuyYkASFDK7Si for <xfs@oss.sgi.com>;
	Sun, 01 May 2011 09:56:53 -0700 (PDT)
Message-ID: <4DBD90A3.6000101@inf.ethz.ch>
Date: Sun, 1 May 2011 18:56:03 +0200
From: Benjamin Schindler <bschindler@inf.ethz.ch>
MIME-Version: 1.0
Subject: Re: xfs performance problem
References: <201104291828.46420.Martin@lichtvoll.de>
In-Reply-To: <201104291828.46420.Martin@lichtvoll.de>
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

Hi

On 29.04.2011 18:28, Martin Steigerwald wrote:
> sorry, forgot to cc.
> 
> Am Mittwoch, 27. April 2011 schrieb Dave Chinner:
>> On Tue, Apr 26, 2011 at 09:44:04PM +0200, Benjamin Schindler wrote:
>>> Hi
>>>
>>> Since upgrading to newer kernels I have serious problems with xfs
>>> performance on my root fs.
>>> It runs on a software raid 0 with 2 disks. On the same two disks,
>>> there are two more partitions running a software raid-1 with ext3.
>>> On the ext3 system, I have no issue, so I assume the drives are
>>> fine.
>>> But on the xfs filesystem, extracting a linux kernel archive takes 5
>>> minutes or more, running ldconfig similarily long. The harddrives are
>>> sata-2.
>>> I'm running gentoo linux with kernel 2.6.38-gentoo-r1. I'm attaching
>>> the kernel config but I guess more info is needed - just let me know
>>> what is needed.
>>
>> more than likely your problem is that barriers have been enabled for
>> MD/DM devices on the new kernel, and they aren't on the old kernel.
>> XFS uses barriers by default, ext3 does not. Hence XFS performance
>> will change while ext3 will not. Check dmesg output when mounting
>> the filesystems on the different kernels.
> 
> But didn't 2.6.38 replace barriers by explicit flushes the filesystem has to 
> wait for - mitigating most of the performance problems with barriers?
> 

Well, that doesn't seem to work then may be? As always, I'm willing to
do testing and provide info if required

Cheers
Benjamin

p.s. please keep the cc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
