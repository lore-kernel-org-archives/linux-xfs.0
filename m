Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 04:03:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m75B2tI9025355
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 04:02:56 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4BF135D91F
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 04:04:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id JLeWBBSp8GOQ73EC for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 04:04:10 -0700 (PDT)
Date: Tue, 5 Aug 2008 13:03:57 +0200
From: Karel Zak <kzak@redhat.com>
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
Message-ID: <20080805110357.GL21873@nb.net.home>
References: <1217553598.3860.16.camel@luna.unix.geek.nz> <20080801073033.GF6201@disturbed> <20080801193133.GA838@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080801193133.GA838@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jasper Bryant-Greene <jasper@amiton.co.nz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, util-linux-ng@vger.kernel.org

On Fri, Aug 01, 2008 at 09:31:33PM +0200, Christoph Hellwig wrote:
> I'ts most likely a fallout, but I wonder why.  To get this behaviour
> moutn would have to add all the options it finds in /proc/self/mounts
> to the command line.

 mount(8) does not read and use /proc/self/mounts at all.

    Karel


 Man mount:

 remount

     Attempt  to remount an already-mounted file system.  This is commonly used
     to change the mount flags for a file system, especially to make a readonly
     file system writeable. It does not change device or mount point.

     The  remount  functionality follows the standard way how the mount command
     works with options from fstab. It means the  mount  command  doesn’t  read
     fstab (or mtab) only when a device and dir are fully specified.

     mount -o remount,rw /dev/foo /dir

     After  this  call  all  old mount options are replaced and arbitrary stuff
     from fstab is ignored, except the loop= option which is internally  gener-
     ated and maintained by the mount command.

     mount -o remount,rw  /dir

     After  this call mount reads fstab (or mtab) and merges these options with
     options from command line ( -o ).


-- 
 Karel Zak  <kzak@redhat.com>
