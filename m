Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DDF37FB2
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 07:48:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4120AC001
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 05:48:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RBfujHo8YRMKvKZH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 05:48:01 -0700 (PDT)
Date: Wed, 16 Jul 2014 08:47:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Occassional problems with unfreeze
Message-ID: <20140716124757.GC36312@bfoster.bfoster>
References: <CAD2VtSjwu3eB+mrs2vX0G4+MJbHyNGVXvVR+P_ssNY6rydvijA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD2VtSjwu3eB+mrs2vX0G4+MJbHyNGVXvVR+P_ssNY6rydvijA@mail.gmail.com>
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
To: Hrishikesh Barua <talonx@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 16, 2014 at 04:50:22PM +0530, Hrishikesh Barua wrote:
> We use XFS on Amazon EBS on Ubuntu 12.04.3, kernel "3.2.0-54-virtual".
> 
> Our backup scripts invoke "xfs_freeze -f" before taking a snapshot to
> ensure filesystem consistency. After the snapshot is taken, we invoke
> "xfs_freeze -u".
> 
> Recently, we have observed that some of these unfreeze calls exit with code
> 255. This results in a frozen filesystem, processes queuing up and us
> having to reboot the EC2 instance. Invoking freeze -u manually results in
> multiple processes like this -
> 
>      17628 ?        D      0:00 /usr/sbin/xfs_io -F -r -p xfs_freeze -x -c
> thaw /mysql-vol-a
>      17694 ?        D      0:00 /usr/sbin/xfs_io -F -r -p xfs_freeze -x -c
> thaw /mysql-vol-a
> 
> A search on this list reveals at least one other instance of this problem -
> http://oss.sgi.com/archives/xfs/2013-01/msg00437.html

That one looks like a freeze hang whereas you see an unfreeze hang.
Perhaps similar to this:

https://bugzilla.redhat.com/show_bug.cgi?id=1052004

> 
> No resolution seems to have happened there. Is this a known bug, or has it
> been fixed since (I'm running xfsprogs 3.1.7) ?
> 

Do you have the hung task output for when this occurs (echo w >
/proc/sysrq-trigger)?

Brian

> Regards
> Hrish

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
