Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F4Ei8C064051 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 22:14:44 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7088167ECD
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:15:40 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id rBdtaBvNpOMtAtkd for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:15:40 -0800 (PST)
Message-ID: <4B4FEBEB.2050502@sandeen.net>
Date: Thu, 14 Jan 2010 22:15:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs 3.1.0 repair problems?
References: <4B4FDC3E.6030205@sandeen.net>
	<20100115035222.GC28498@discord.disaster>
In-Reply-To: <20100115035222.GC28498@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Jan 14, 2010 at 09:08:46PM -0600, Eric Sandeen wrote:
>> It looks like maybe the freespace checking isn't quite up to par:
>>
>> test 073 is dying with:
>>
>> _check_xfs_filesystem: filesystem on /mnt/test/14309.image is inconsistent
>> *** xfs_repair -n output ***
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - scan filesystem freespace and inode maps...
>> sb_fdblocks 26156829, counted 26157853
> 
> Actually, that looks like it is out by exactly 1024 blocks, which is
> the default amount of reserved space in the filesystem. Perhaps
> there is something else wrong with the unmount code that
> is not unreserving this space before the superblock is
> written to disk?
> 
> I'm about to see if I can reproduce it....
> 
> Cheers,
> 
> Dave.

Thanks, you may need some of the patches I sent to the list today to
make mkfs happy first :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
