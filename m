Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 01:45:22 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4U8jGWt031303
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 01:45:18 -0700
Date: Wed, 30 May 2007 04:45:16 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs_fsr 2.2.38 bug/kernel 2.6.21.3 cannot defrag volume
In-Reply-To: <20070530004140.GX85884050@sgi.com>
Message-ID: <Pine.LNX.4.64.0705300443270.3755@p34.internal.lan>
References: <Pine.LNX.4.64.0705291404430.2944@p34.internal.lan>
 <20070530004140.GX85884050@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, apiszcz@solarrain.com



On Wed, 30 May 2007, David Chinner wrote:

> On Tue, May 29, 2007 at 02:05:44PM -0400, Justin Piszcz wrote:
>> # uname -a
>> Linux boxname 2.6.21.3 #2 SMP Sun May 27 11:34:21 EDT 2007 i686 GNU/Linux
>> # xfs_fsr -V
>> xfs_fsr version 2.2.38
>> # xfs_db -V
>> xfs_db version 2.8.18
>> # xfs_db -c frag -f /dev/md1
>> actual 449, ideal 403, fragmentation factor 10.24%
>> # xfs_fsr /dev/md1
>> /d2 start inode=0
>> # xfs_db -c frag -f /dev/md1
>> actual 449, ideal 403, fragmentation factor 10.24%
>> #
>
> Try xfs_db -c "frag -v" -f /dev/md1 to see which inodes are
> fragmented, then run xfs_db -c "inode <num>" -c bmap -f /dev/md1
> to see whether it is a sparse file or not....
>
> Remember - xfs_fsr does best effort defrag - if it can't make
> progress, it does nothing, and it can't defrag directories...
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>

# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md1              746G  101G  645G  14% /d2

# xfs_db -c "frag -v" -f /dev/md1
inode 512 actual 0 ideal 0
inode 513 actual 0 ideal 0
inode 514 actual 0 ideal 0
inode 515 actual 3 ideal 1
inode 518 actual 0 ideal 0
inode 146353073 actual 0 ideal 0
inode 146353075 actual 3 ideal 1
inode 146353076 actual 1 ideal 1
..
inode 4160750217 actual 1 ideal 1
inode 4160750218 actual 1 ideal 1
inode 4160750219 actual 1 ideal 1


# xfs_db -c "frag -v" -f /dev/md1 | wc
     422

Thoughts?

# xfs_db -c "inode 146353073" -c bmap -f /dev/md1
# (no output)
# xfs_db -c "inode 4160750219" -c bmap -f /dev/md1
data offset 0 startblock 260410208 (31/363360) count 740 flag 0


Justin.
