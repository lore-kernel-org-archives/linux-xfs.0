Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from firestarter.dermichi.com ([194.177.153.153]:54598 "EHLO
        firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764283AbdDSVrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 17:47:47 -0400
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
 <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
 <d6f598d1-7e7e-ac85-3cdc-e4f4bfdba94e@dermichi.com>
 <20170419180811.GB41631@bfoster.bfoster>
 <268ce851-dad0-a777-526a-82ad967490cd@dermichi.com>
 <20170419205525.GD5205@birch.djwong.org>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <86fbec25-f026-350b-ffe3-b0b182b768ac@dermichi.com>
Date: Wed, 19 Apr 2017 23:47:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170419205525.GD5205@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi Darrick!
Thanks for your input.

> 
> So... (speculating a bit here) you're running 20 different copies of
> rsnapshot and rsync, which are generating a lot of dirty data and dirty
> inodes.  Each of the threads reported by the hung task timeout are
> trying to reserve space in the log for metadata updates, and clearly
> those log reservation requests have poked the AIL to flush itself to
> clear space for new transactions.
> 
Yes, that is a pretty precise description of what the system is doing.
Although 20 parallel rsync's are pretty much the worst case scenario
(the cron jobs are designed to be starting at differing times). Usually
there are roughly 5 rsync's going on at the same time. The majority of
the files are not copied but hard linked during this process.

> The AIL thread is flushing inode updates to disk, which is a lot of RMW
> of dirty inodes, hence the high amounts of io reads you see.  The log is
> already 2GB in size on disk, so it cannot be made larger.  TBH, a
> /smaller/ log might help here since at least when we have to push the
> AIL to free up log space there'll be less of it that has to be freed up.
> 
That's interesting. I could try to create an external log of 500MB size
and see if that changes anything?

> OTOH I wouldn't expect the system to stall for 5-15 minutes ... but I
> guess a quarter of a 2GB log is 500MB, and if that's mostly dirty inode
> records, that's a /lot/ of inode updates that the AIL has to do (single
> threaded!) to clean out the space.  You /do/ seem to have 13 million
> inodes in slab, so it's not implausible...
> 
OK, do i understand you correctly that the xfsaild does all the actual
work of updating the inodes? And it's doing that single-threaded,
reading both the log and the indoes themselves?

> ...500MB / 200 bytes per dirty inode record = ~2.5 million inodes.
> ~2.5m inodes / 10 minutes = ~4200 inodes per second...
Yes, these numbers sound plausible. When everything is running smoothly
(i.e. most of the time) i do see up to 4500 combined reads+writes per
second. But when the problem arises, all i see i xfsaild doing around
120 reads/second, which is roughly the performance of a single 7200rpm
drive. Directly after this "read only phase" (which lasts for about 5-10
minutes most of the time) there is a short burst of up to 10000+
writes/sec (writing to the RAID controller cache I suppose). And then
the system goes back to the "normal phase" where it is doing both reads
and writes and all those blocked D state processes continue working.

> 
> That's probably within the ballpark of what 12 drives can handle.
> Considering that the inodes get allocated out in chunks of 64, we can
> take advantage of /some/ locality...
> 
> IOWs, the xfs is flushing big chunks of log all at once.  You might look
> at the io stats of each drive, to see if they're all busy, and how many
> io operations they're managing per second.  (But since you know the
> exact model of drives, you'll have to take my ballpark figures and work
> out whether or not they map to what you'd expect iops-wise from each
> drive.)
> 
Hm, i don't think i can query the io stats of the individual drives
behind the hardware RAID controller. If your theory is correct i should
only see a single drive busy during the "problem phase". Will look into
that. Maybe simply by eyeballing the drive led's ;-)

thanks,
Michael
