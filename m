Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E0cBpJ061225 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 19:38:21 -0500
Date: Thu, 13 Aug 2009 20:38:39 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1851101658.1934521250210319746.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <424153067.1934481250210293891.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: XFS corruption with failover
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: John Quigley <jquigley@jquigley.com>, XFS Development <xfs@oss.sgi.com>

----- "Felix Blyakher" <felixb@sgi.com> wrote:

> On Aug 13, 2009, at 3:17 PM, John Quigley wrote:
> 
> > Folks:
> >
> > We're deploying XFS in a configuration where the file system is  
> > being exported with NFS.  XFS is being mounted on Linux, with  
> > default options; an iSCSI volume is the formatted media.  We're  
> > working out a failover solution for this deployment utilizing Linux 
> 
> > HA.  Things appear to work correctly in the general case, but in  
> > continuous testing we're getting XFS superblock corruption on a very
>  
> > reproducible basis.
> > The sequence of events in our test scenario:
> >
> > 1. NFS server #1 online
> > 2. Run IO to NFS server #1 from NFS client
> > 3. NFS server #1 offline, (via passing 'b' to /proc/sysrq-trigger)
> > 4. NFS server #2 online
> > 5. XFS mounted as part of failover mechanism, mount fails
> >
> > The mount fails with the following:
> >
> > <snip>
> > kernel: XFS mounting filesystem sde
> > kernel: Starting XFS recovery on filesystem: sde (logdev: internal)
> > kernel: XFS: xlog_recover_process_data: bad clientid
> > kernel: XFS: log mount/recovery failed: error 5
> 
> This is an IO error. Is the block device (/dev/sde) accessible
> from the server #2 OK? Can you dd from that device?
> 
> >
> > kernel: XFS: log mount failed
> > </snip>
> >
> > When running xfs_repair:
> 
> That's not a good time to run xfs_repair. There were no
> indication that the filesystem is corrupted.
> 
> Let's take for a sec "NFS server #2" out of the picture.
> Can you mount the filesystem from the original server
> after it reboots?
If that fails too can you run xfs_logprint on /dev/sde and
post any errors it reports?

> 
> Felix
> 
> >
> >
> > <snip>
> > [root@machine ~]# xfs_repair /dev/sde xfs_repair: warning - cannot 
> 
> > set blocksize on block device /dev/sde: Invalid argument
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >       - zero log...
> > ERROR: The filesystem has valuable metadata changes in a log which 
> 
> > needs ...
> > </snip>
> >
> > Any advice or insight into what we're doing wrong would be very much
>  
> > appreciated.  My apologies in advance for the somewhat off-topic  
> > question.
> >
> > - John Quigley
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
