Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E1hr36065812 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 20:44:03 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B2431B690F5
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:44:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id 4eTiN3kmo2hTbItg for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2009 18:44:32 -0700 (PDT)
Date: Thu, 13 Aug 2009 21:43:27 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <2001880032.1935971250214207721.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <835473717.1935811250214078456.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: John Quigley <jquigley@jquigley.com>, XFS Development <xfs@oss.sgi.com>


----- "Eric Sandeen" <sandeen@sandeen.net> wrote:

> Lachlan McIlroy wrote:
> > ----- "Eric Sandeen" <sandeen@sandeen.net> wrote:
> > 
> >> Felix Blyakher wrote:
> >>> On Aug 13, 2009, at 3:17 PM, John Quigley wrote:
> >>>
> >>>> Folks:
> >>>>
> >>>> We're deploying XFS in a configuration where the file system is 
> 
> >>>> being exported with NFS.  XFS is being mounted on Linux, with  
> >>>> default options; an iSCSI volume is the formatted media.  We're 
> 
> >>>> working out a failover solution for this deployment utilizing
> Linux
> >>  
> >>>> HA.  Things appear to work correctly in the general case, but in 
> 
> >>>> continuous testing we're getting XFS superblock corruption on a
> >> very  
> >>>> reproducible basis.
> >>>> The sequence of events in our test scenario:
> >>>>
> >>>> 1. NFS server #1 online
> >>>> 2. Run IO to NFS server #1 from NFS client
> >>>> 3. NFS server #1 offline, (via passing 'b' to
> /proc/sysrq-trigger)
> >>>> 4. NFS server #2 online
> >>>> 5. XFS mounted as part of failover mechanism, mount fails
> >>>>
> >>>> The mount fails with the following:
> >>>>
> >>>> <snip>
> >>>> kernel: XFS mounting filesystem sde
> >>>> kernel: Starting XFS recovery on filesystem: sde (logdev:
> >> internal)
> >>>> kernel: XFS: xlog_recover_process_data: bad clientid
> >>>> kernel: XFS: log mount/recovery failed: error 5
> >>> This is an IO error. Is the block device (/dev/sde) accessible
> >>> from the server #2 OK? Can you dd from that device?
> >> Are you sure?
> >>
> >>                 if (ohead->oh_clientid != XFS_TRANSACTION &&
> >>                     ohead->oh_clientid != XFS_LOG) {
> >>                         xlog_warn(
> >>                 "XFS: xlog_recover_process_data: bad clientid");
> >>                         ASSERT(0);
> >>                         return (XFS_ERROR(EIO));
> >>                 }
> >>
> >> so it does say EIO but that seems to me to be the wrong error;
> loks
> >> more
> >> like a bad log to me.
> >>
> >> It does make me wonder if there's any sort of per-initiator
> caching
> >> on
> >> the iscsi target or something.  </handwave>
> > Should barriers be enabled in XFS then?
> 
> Could try it but I bet the iscsi target doesn't claim to support
> them...
You're probably right.

Is it possible for a transaction record to span two log buffers and
only one made it to disk so the rest of the transction record appears
corrupt?

> 
> -eric
> 
> >> -Eric
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> >

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
