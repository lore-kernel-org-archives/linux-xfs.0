Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BHAgqA142597 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 11:10:43 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFBB410AB10
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 09:10:06 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id LcwUcuyue5rQAWWY for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2009 09:10:06 -0800 (PST)
Date: Wed, 11 Feb 2009 12:10:05 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: sunit & swidth on RAID-1?
In-Reply-To: <20090211165316.GA4430@dentifrice>
Message-ID: <alpine.DEB.1.10.0902111208280.18885@p34.internal.lan>
References: <20090211155638.GA3864@dentifrice>
	<alpine.DEB.1.10.0902111141560.18885@p34.internal.lan>
	<20090211165316.GA4430@dentifrice>
MIME-Version: 1.0
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
To: mike dentifrice <fluor@poivron.org>
Cc: xfs@oss.sgi.com



On Wed, 11 Feb 2009, mike dentifrice wrote:

> Justin Piszcz a dit:
>> mkfs.xfs will auto-optimize for software-raid arrays for the most
>> part,  with HW raid on a 3ware controller, tweaking mkfs.xfs does not
>> help very  much.  with SW raid, at least for raid1 - I use the
>> defaults.
>
> Thanks for your reply. However, I wonder about the defaults:
>
> 	xfs_info /dev/md1 | grep -E '(sunit|swidth)'
>
> Outputs:
>
>        sunit=0      swidth=0 blks, unwritten=1
>        sectsz=512   sunit=0 blks
>
> What's the consequence of 0 values in this case?
>
> Greetings,
>
> -- 
> mike dentifrice <fluor@poivron.org>
>

# xfs_info /dev/md2 | grep -E '(sunit|swidth)'
          =                       sunit=0      swidth=0 blks
          =                       sectsz=512   sunit=0 blks, lazy-count=0

Mine is similar, I guess you would need to benchmark to find out if you 
were worried about it.  I ran multiple copies from a RAID1 (dual raptors)
and was able to get the performance of both of the drives combine, so I am 
not really worried about this setting.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
