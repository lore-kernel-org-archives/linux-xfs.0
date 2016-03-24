Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 085EE7CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:09:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B884E8F804B
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:09:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id K8NaFD4FB6Drtr0X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:09:02 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 1F7C95714
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:09:02 +0000 (UTC)
Received: from redhat.com (dhcp-26-103.brq.redhat.com [10.34.26.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2OB8xrX005538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:09:01 -0400
Date: Thu, 24 Mar 2016 12:08:59 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160324110859.GA20072@redhat.com>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<6457b1d9de271ec6cca6bc2626aac161@mail.gmail.com>
	<20160322140345.GA54245@bfoster.bfoster>
	<0f3832c45509f444f55fda2aaf9c9deb@mail.gmail.com>
	<20160323123010.GA43073@bfoster.bfoster>
	<20160323153221.GA19456@redhat.com>
	<20160323223747.GX30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323223747.GX30721@dastard>
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
To: xfs@oss.sgi.com

On Thu, Mar 24, 2016 at 09:37:47AM +1100, Dave Chinner wrote:
> On Wed, Mar 23, 2016 at 04:32:21PM +0100, Carlos Maiolino wrote:
> > I'm still trying to get a reliable reproducer, at least exactly with what I have
> > seen a few days ago.
> > 
> > Shyam, could you try to reproduce it with a recent/upstream kernel? That would
> > be great to make sure we have been seen the same issue.
> > 
> > AFAICT, it happens in the following situation:
> > 
> > 1 - Something is written to the filesystem
> > 2 - log checkpoint is done for the previous write
> > 3 - Disk failure
> > 4 - XFS tries to writeback metadata logged in [2]
> > 
> > When [4] happens, I can't trigger xfs_log_force messages all the time, most of
> > time I just get an infinite loop in these messages:
> > 
> > [12694.318109] XFS (dm-0): Failing async write on buffer block
> > 0xffffffffffffffff. Retrying async write.
> >
> > Sometimes I can trigger the xfs_log_force() loop.
> 
> This all smells like the filesystem is getting IO errors but it not
> in a shutdown state. What happens when you run 'xfs_io -x -c
> "shutdown" /mnt/pt' on a filesystem in this state? Can you then
> unmount it?
> 

I'll give it a try today, although, I can't do it while umount command is hung,
since, before the command get stuck, the mount point is removed from the
user namespace, so I have no access to the mountpoint from userspace while the
command is 'running'.


> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
