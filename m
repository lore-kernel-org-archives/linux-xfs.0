Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA1Mvn4F059876 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 17:57:49 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KmrI4NFB0c7bZiRR for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 15:59:39 -0700 (PDT)
Date: Fri, 2 Nov 2012 09:59:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem recovery from secondary superblocks
Message-ID: <20121101225938.GS29378@dastard>
References: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
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
To: Aaron Goulding <aarongldng@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 30, 2012 at 10:02:28PM -0700, Aaron Goulding wrote:
> Hello! So I have an XFS filesystem that isn't mounting, and quite a long
> story as to why and what I've tried.
> 
> And before you start, yes backups are the preferred method of restoration
> at this point. Never trust your files to a single FS, etc.

It's kind of assumed knowledge round here or that there are good
reasons for not backing up the filesystem (e.g. it's hard to back up
a 500TB filesystem).

[snip raid horror story]

> Once I had the file created, I tried xfs_clean -f /mnt/restore/md0.dat to
> no luck. I used a hex editor to add XFSB to be beginning, hoping the

That won't work - the magic number is just one of many checks on the
superblock before it can be considered valid.

> recovery would just clean around the LVM data with similar results. The
> result looks like the following:
> 
> Phase 1 - find and verify superblock...
> bad primary superblock - bad or unsupported version !!!

And that's the second check :/

> attempting to find secondary superblock...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> unable to verify superblock, continuing...
> ....................................................................................................
> Exiting now.

So, that means if found 10 potential secondary superblocks, but
couldn't validate any of them. Can you find those superblocks and
hexdump them? something like: 

hexdump <dev or file> | grep -A 30 XFSB

Also of interest would be to hexdump the subsequent sector as well,
it should have a magic number of XAGF, and will also have a sequence
number in it that should help tell us if you've got everything in
order.

> running xfs_db /mnt/restore/md0.dat would appear to run out of memory.

No surprise there if the superblocks are toast.

> Next I tried xfs_db /dev/md1 to see if anything would load. I get the
> following:
> 
> root@jarvis:/mnt# xfs_db /dev/md1
> Floating point exception
> 
> With the following in dmesg:
> 
> [1568395.691767] xfs_db[30966] trap divide error ip:41e4b5 sp:7fff5db8ab90
> error:0 in xfs_db[400000+6a000]

what version are you running?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
