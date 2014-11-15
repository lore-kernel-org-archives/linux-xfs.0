Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D207F7F3F
	for <xfs@oss.sgi.com>; Sat, 15 Nov 2014 08:27:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7043BAC006
	for <xfs@oss.sgi.com>; Sat, 15 Nov 2014 06:27:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kKeqwpMJFAPrXegY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Nov 2014 06:27:34 -0800 (PST)
Date: Sat, 15 Nov 2014 09:27:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Mismatch UUID
Message-ID: <20141115142730.GA54930@bfoster.bfoster>
References: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
	<20141114134208.GB36731@bfoster.bfoster>
	<BLU172-W1423188AD065CADCC115E6C48C0@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BLU172-W1423188AD065CADCC115E6C48C0@phx.gbl>
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
To: Robert Tench <robtench@hotmail.com>
Cc: xfs@oss.sgi.com

(Re-CC xfs list)

On Sat, Nov 15, 2014 at 08:10:18AM +1100, Robert Tench wrote:
> Hi Brian,
> 
> Thanks for your reply.
> 
> I had run xfs_repair -n previously which spewed out a ton of stuff, in the last email you would have received, there should be a link to hotmail onedrive where you could view the output of that command, I called it xfs.log
> 

I didn't see a link in the plaintext of the message. I see something now
buried in an html attachment that my mailer doesn't interpret very well,
and the link doesn't appear to work.

> If I try to mount the array, it comes back with 'Structure needs Cleaning' and won't mount.
> 
> When I tried to reassemble the array, it would only begin with 2 of the 5 drives, as I know that 3 of the drives had different update times and were out of sync.
> 
> I ended up doing a force assemble, which created the array and went into a resync process (really not sure if I did the right thing here).
> 

It's been a while since I've played around with md raid. Do you have a
command that you ran to put things back together? As was mentioned
up-thread, using a create (-C) command could just force an array
together in a particular geometry and write new metadata. This would
make the array look fine afterwards, but then there's no way to know
whether the array is actually in the original order and the data could
very well be scrambled.

Brian

> As to the geometry of the raid, I hope I had it in the right order. I previously had a data recovery tech remote connect to my desktop who had a look at the array. He had also not been able to successfully mount the raid, it was him that told me the order of the drives, which happened to be the exact order of their placement in the drive bays of the lacie nas.
> 
> Is there a way to check whether I have the correct geometry, or by doing the force assemble it would now be impossible to tell?
> 
> The data recovery tech, was also having the same issue of mismatched UUID.
> 
> Any help is appreciated,
> 
> Rob
> 
> > Date: Fri, 14 Nov 2014 08:42:08 -0500
> > From: bfoster@redhat.com
> > To: robtench@hotmail.com
> > CC: xfs@oss.sgi.com
> > Subject: Re: Mismatch UUID
> > 
> > On Fri, Nov 14, 2014 at 07:57:42PM +1100, Robert Tench wrote:
> > >                                                             Robert has a file to share with you on OneDrive. To view it, click the link below.                                                                                                        xfs.log                                                                            So finally have managed to find a way to save the complete log of running xfs_repair -n /dev.md4
> > > 
> > > And below is the output of xfs_check /dev/md4
> > > 
> > > root@ubuntu:~# xfs_check /dev/md4
> > > * ERROR: mismatched uuid in log
> > > *            SB : 813833a7-1bd3-4447-b575-09d1471bb652
> > > *            log: ea3833af-25ce-9f91-b575-018fb49df3b1
> > > ERROR: The filesystem has valuable metadata changes in a log which needs to
> > > be replayed.  Mount the filesystem to replay the log, and unmount it before
> > > re-running xfs_check.  If you are unable to mount the filesystem, then use
> > > the xfs_repair -L option to destroy the log and attempt a repair.
> > > Note that destroying the log may cause corruption -- please attempt a mount
> > > of the filesystem before doing this.
> > > 
> > 
> > You want to use xfs_repair (-n) rather than xfs_check. I think you
> > mentioned in your other email you've tried xfs_repair..? The above
> > message indicates a dirty log, have you attempted to mount the device to
> > replay the log?
> > 
> > > And the output from mdadm -D /dev/md4 is as follows
> > > 
> > 
> > How did you put the array back together? Did it assemble fine or did you
> > have to recreate it? If the latter, how are you sure the geometry is
> > correct (it looks like it's syncing)?
> > 
> > Brian
> > 
> > > root@ubuntu:~# mdadm -D /dev/md4
> > > /dev/md4:
> > >         Version : 1.0
> > >   Creation Time : Fri Jan  1 01:31:17 2010
> > >      Raid Level : raid5
> > >      Array Size : 11712962560 (11170.35 GiB 11994.07 GB)
> > >   Used Dev Size : 2928240640 (2792.59 GiB 2998.52 GB)
> > >    Raid Devices : 5
> > >   Total Devices : 5
> > >     Persistence : Superblock is persistent
> > > 
> > >     Update Time : Fri Nov 14 15:58:16 2014
> > >           State : clean 
> > >  Active Devices : 5
> > > Working Devices : 5
> > >  Failed Devices : 0
> > >   Spare Devices : 0
> > > 
> > >          Layout : left-symmetric
> > >      Chunk Size : 512K
> > > 
> > >            Name : (none):4
> > >            UUID : e0829810:9782b51f:25529f65:8823419c
> > >          Events : 1243386
> > > 
> > >     Number   Major   Minor   RaidDevice State
> > >        0       8        2        0      active sync   /dev/sda2
> > >        6       8       18        1      active sync   /dev/sdb2
> > >        2       8       34        2      active sync   /dev/sdc2
> > >        5       8       50        3      active sync   /dev/sdd2
> > >        4       8       66        4      active sync   /dev/sde2
> > > 
> > > 
> > > And then the response from mdadm -E /dev/md4
> > > 
> > > root@ubuntu:~# mdadm -E /dev/md4
> > > mdadm: No md superblock detected on /dev/md4.
> > > 
> > > Not sure what to do, any help would be appreciated
> > > 
> > > Regards,
> > > 
> > > Rob
> > > 
> > > 
> > > 
> > >                  		 	   		  
> > 
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> > 
>  		 	   		  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
