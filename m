Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7T55eoM049220 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 00:05:41 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4824543289
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 22:00:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	dv7y68hiHy6gODwC for <xfs@oss.sgi.com>;
	Sun, 28 Aug 2011 22:00:38 -0700 (PDT)
Date: Mon, 29 Aug 2011 15:00:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore Does Only Only Partial Restore
Message-ID: <20110829050025.GF3162@dastard>
References: <1314534700.48540.YahooMailClassic@web77701.mail.sg1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1314534700.48540.YahooMailClassic@web77701.mail.sg1.yahoo.com>
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: xfs@oss.sgi.com

On Sun, Aug 28, 2011 at 08:31:40PM +0800, Gim Leong Chin wrote:
> Hi,
> 
> This is the very first time I tried doing a xfsrestore of a back
> up and I hit some serious trouble.
> 
> I had openSUSE 11.1 (kernel 2.6.27) on my Acer notebook.  I did a
> xfsdump of /home to a WD My Passport external USB hard drive with
> XFS on it.
> 
> I installed openSUSE 11.4 (kernel 2.6.37), then tried to do
> xfsrestore from the WD USB drive.  The dump file is 121 GB.
> 
> I tried two times on two different days, but each time the
> xfsrestore would stop writing at the exact same point, 49 GB and
> say success at the end.
> 
> I then copied the dump file to one hard drive on my desk top, and
> did a dump to another hard drive, to /tmp/mnt3.  I get back
> identical messages:

....
> I downloaded xfsdump-3.0.5.tar.gz, did a build, and tried to do a restore using the newly built xfsrestore:

> {>
>   optimus:/home/chingl/archive/rat # /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore -f ./rat18Aug2011 /tmp/mnt3
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: using file dump (drive_simple) strategy
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: version 3.0.5 (dump format 3.0) - Running single-threaded
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: searching media for dump
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: examining media file 0
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: dump description:
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: hostname: rat
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: mount point: /home
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: volume: /dev/sdb3
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: session time: Thu Aug 18 12:57:36 2011
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: level: 0
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: session label: "rat_18Aug2011"
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: media label: "rat18Aug2011"
> 3>/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: file system id: f3b08587-cf98-4b7b-99b0-dc9d4e77b631
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: session id: d8069cd0-a092-4fb2-b378-0eda33474aae
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: media id: 96370000-6e2c-40eb-9c3c-93ca42de7524
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: searching media for directory dump
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: reading directories
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: 90820 directories and 539579 entries processed
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: directory post-processing
>   /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: restoring non-directory files
>   xfsrestore: content.c:7510: restore_extent_group: Assertion `ehdr.eh_type == 4' failed.

Which indicates that the dump file on your external drive is
probably corrupt. xfs_restore only has a certain number of known
extent types, and this ASSERT failure occurs if the extent type is
not valid - the restore code has checked for all special types,
and is now expecting a data extent, which it isn't. That's where the
restore will stop.

All the other restore attempts you've made have equivalent "failed
to read" errors that also indicate some kind of corruption in the
dump file.

> (>Aborted 2>optimus:/home/chingl/archive/rat #
> 
> 
> Could some one please assist to enlighten me what is going on, why
> does the restoration fail?  The xfsdump session looked OK.

Well, I can't tell you if the dump was ok or not without that
output. Even if the dump was successful, it could have easily been
corrupted by a memory or other hardware bit error on the way to
disk. Were there any IO errors reported in the kernel dmesg messages
while the dump was being taken?

> Is there any way I can extract back my /home back up?  This is my
> only back up copy.  i have two other xfsdump dump files taken
> earlier, I have not tried those.

No idea, you'll have to wait for the xfsdump experts to come online.

> Is xfsdump and xfsrestore really robust for dump to regular file,
> or should I have done a tar instead?

It should be fine, but if there was a hardware related problem then
all bets are off...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
