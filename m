Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D30D7F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 16:05:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F2E7B8F8050
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 14:05:53 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xmBNTWd1vFVT1YA5 for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 14:05:51 -0700 (PDT)
Date: Tue, 23 Sep 2014 07:05:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Repair XFS from 1/3 of the table
Message-ID: <20140922210548.GO4267@dastard>
References: <CAJiJ=8+1P1odzJGpWRvPQh84KQMx5ukzFS9pACjRr7aHGiTpXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJiJ=8+1P1odzJGpWRvPQh84KQMx5ukzFS9pACjRr7aHGiTpXQ@mail.gmail.com>
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
To: Alessio Di Maria <alessio.dimaria@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 19, 2014 at 10:58:49PM +0200, Alessio Di Maria wrote:
> Hi, for fist i'm sorry for my bad English..
> so,
> I'm trying to do a recovery from my NAS,
> After it stopped, 3 disk of 4 was reinitialized so, raid partition was
> deleted on disk 1 2 and 3, and first about 5m was zero filled..

So you lost the root inode and a lot of other critical metadata.

> I'm actually work on a copy of that...
> in my luck, the XFS superblock was on 4th disk..
> I was able to rebuild RAID5 with the original configuration and now i can
> read RAW files up to few kb... i was able to read a 15Mb zip file, and some
> big jpeg, so i can say that RAID it's working fine
> 
> At sector 384 of the raid volume start the xfs superblock, i made a
> loopback at this offset,
> mounting it.. but obviusly it said that was not clean.
> making xfs_repair i get anything, but with xfs_repair -L i had infinite
> list of lost inode, and than i was able to mount the partition,
> but with any file, only the lost + found directory with few but complete
> files...

That happens when you lose the root inode.

> On the NAS there were Big Files of ISCSI, in the lost + found i find one of
> this, big 100Gb.. now i don't know how i can recovery the rest..

If you had regions of of the drives zeroed, then you've lost data
randomly in the files in the filesystem. It's basically
unrecoverable if you don't have a backup.

> Is it possible to find lost inode?

You can google for xfs_irecover, but you've already run xfs_repair
and so it's going to be mostly useless at this point.

> i tryied with many programs to get back the original Filesystem but
> anything up the Lost + Found directory after the repair...
> I know that XFS is based on sparse file, and so i can't find my file and
> hope to copy it contigusly (about 5Gb) cose the fs reidirect zero filled
> zone... in addiction i can't do a RAW recovery cose in the deep of 2.7Tb i
> find MFT entryies and system files inner ISCSI units...
> So what chache?
> Wha can i do myself?

If xfs_repair hasn't recovered the inodes that contained the files
you care about, then it's almost certain that you've lost
those files forever unless you have a backup. You can try grepping
the raw device for sectors that contain signatures you care about,
but that only works for contiguous files that were lost (that's
effectively what photorec does).

Other than that, there's nothing that can be done to recover what
has been lost from the corpse you have on your hands...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
