Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67JYEh7189893 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 14:34:14 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8550554D03
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 12:34:12 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id IjY5r0NrABqLFAHj for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 12:34:12 -0700 (PDT)
Message-ID: <4E160A34.20902@sandeen.net>
Date: Thu, 07 Jul 2011 14:34:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs doesn't resize
References: <20110707182532.GA31319@sonic.net>
In-Reply-To: <20110707182532.GA31319@sonic.net>
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
To: Keith Keller <kkeller@sonic.net>
Cc: xfs@oss.sgi.com

On 7/7/11 1:25 PM, Keith Keller wrote:
> Hi all,
> 
> First, I hope that this message fixes my mail client breaking threading.
> 
> I am sorry for following up my own post (again), but I realized this
> morning that there may be another possible risk I had not considered:
> 
> On Wed, Jul 06, 2011 at 03:51:32PM -0700, kkeller@sonic.net wrote:
>>
>> So, here is my xfs_db output.  This is still on a mounted filesystem.
> 
> How safe/risky is it to leave this filesystem mounted and in use?
> I'm not too concerned about new data, since it won't be a huge amount,
> but I am wondering if data that's already been written may be at risk.
> Or, it it a reasonable guess that the kernel is still working completely
> with the old filesystem geometry, and so won't write anything beyond the
> old limits while it's still mounted?  df certainly seems to use the old
> fs size, not the new one.

I don't remember all the implications of this very old bug...

It seems like you need an "exit strategy" - you probably cannot leave
your fs mounted -forever- ...

If it were me, if possible, I'd make backups of the fs as it's mounted
now, then umount it and make an xfs_metadump of it, restore that metadump
to a new sparse file, and point xfs_repair at that metadata image file,
to see what repair might do with it.

If repair eats it alive, then we can look into more xfs_db type surgery
to fix things up more nicely...

-Eric

> Thanks again,
> 
> 
> --keith
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
