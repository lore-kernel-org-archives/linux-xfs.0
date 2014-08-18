Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 13C947F4E
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 11:16:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0218530407A
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 09:16:13 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id AIlvCpIUwNXAvASf
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 09:16:13 -0700 (PDT)
Subject: Re: inode64 directory placement determinism
MIME-Version: 1.0
Date: Mon, 18 Aug 2014 11:16:12 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
In-Reply-To: <20140818070153.GL20518@dastard>
References: <e1eeba7b0fb97c63e41f40ed9ac162d7@localhost>
	<20140818070153.GL20518@dastard>
Message-ID: <bc34a576d2b3e8c431633574deaa37cc@localhost>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 18 Aug 2014 17:01:53 +1000, Dave Chinner <david@fromorbit.com>
wrote:
> On Sun, Aug 17, 2014 at 10:29:21PM -0500, Stan Hoeppner wrote:
>> Say I have a single 4TB disk in an md linear device.  The md device has
a
>> filesystem on it formatted with defaults.  It has 4 AGs, 0-3.  I have
>> created 4 directories.  Each should reside in a different AG, the first
>> in
>> AG0.  Now I expand the linear device with an identical 4TB disk and
>> execute
>> xfs_growfs.  I now have 4 more AGs, 4-7.  I create 4 more directories.
>> 
>> Will these 4 new dirs be created sequentially in AGs 4-7, or in the
first
>> 4 AGs?  Is this deterministic, or is there any chance involved?  On the
> 
> Deterministic, assuming single threaded *file-system-wide* directory
> creation. Completely unpredictable under concurrent directory
> creations.  See xfs_ialloc_ag_select/xfs_ialloc_next_ag.
> 
> Note that the rotor used to select the next AG is set to
> zero at mount.
> 
> i.e. single threaded behaviour at agcount = 4:
> 
> dir number	rotor value	  destination AG
>  1		  0			0
>  2		  1			1
>  3		  2			2
>  4		  3			3
>  5		  0			0
>  6		  1			1
> ....
> 
> So, if you do what you suggest, and grow *after* the first 4 dirs
> are created, the above is what you'll get because the rotor goes
> back to zero on the fourth directory create. Now, with changing from
> 4 to 8 AGs after the first 4:
> 
> dir number	rotor value	  new inode location (AG)
>  1		  0			0
>  2		  1			1
>  3		  2			2
>  4		  3			3
> <grow to 8 AGs>
>  5		  0			0
>  6		  1			1
>  7		  2			2
>  8		  3			3
>  9		  4			4
>  10		  5			5
>  11		  6			6
>  13		  7			7
>  14		  0			0
> 
>> real system these 4TB drives are actually 48TB LUNs.  I'm after
>> deterministic parallel bandwidth to subsequently added RAIDs after each
>> grow operation by simply writing to the proper directory.
> 
> Just create new directories and use the inode number to
> determine their location. If the directory is not in the correct AG,
> remove it and create a new one, until you have directories located
> in the AGs you want.
> 
> Cheers,
> 
> Dave.


Thanks for the info Dave.  Was hoping it would be more straightforward. 
Modifying the app for this is out of the question.  They've spent 3+ years
developing with EXT4 and decided to try XFS at the last minute.  Product is
to ship in October, so optimizations I can suggest are limited.


-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
