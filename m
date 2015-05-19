Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5DC037F50
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 10:07:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 425FA304048
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 08:07:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gZwaSlBKrLUUYhZM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 May 2015 08:07:01 -0700 (PDT)
Date: Tue, 19 May 2015 12:05:43 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: inode64
Message-ID: <20150519150543.GA24002@hades.maiolino.org>
References: <4D4BF051.9000608@ncac.torun.pl> <555B4E53.8050908@ncac.torun.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <555B4E53.8050908@ncac.torun.pl>
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
To: Jerzy Borkowski <jubork@ncac.torun.pl>
Cc: xfs@oss.sgi.com

Hi,

If you use inode64, the inodes will be spread all along the disk. The inode
numbers are created based on its location in the disk, so, if you have a disk
which is larger than 1TB, you can have inode numbers larger than 32bit which you
mentioned.

If you want to keep inodes in the range you mentioned, you must need inode32
options, so no inode will be allocated beyond the 32 bits limit which you
mentioned.

But, since you have a 800GB filesystem, and not a filesystem larger than 1TB,
you can use inode64 and you will still have inodes in the 32bit range, but, if
in any circunstance you grow the filesystem, you'll have inodes being allocated
beyond that.

if you must keep inode allocations in the 32bit range, I suggest you using the
inode32 option, to avoid any future problems in case of a grow of the
filesystem.


On Tue, May 19, 2015 at 04:53:07PM +0200, Jerzy Borkowski wrote:
> Hi,
> 
> If an 800GB XFS filesystem is mounted with inode64 option,
> is it guaranteed that all inodes in the filesystem are in
> the range 0-0xFFFFFFFF ?
> Kernel is 3.17.x
> 
> Thanks,
> 
> Jurek
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
