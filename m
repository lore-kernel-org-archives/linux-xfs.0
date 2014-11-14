Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 340F07F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 06:48:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 231D38F804C
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 04:48:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qyMwRa8xpDR4RAHg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 04:48:25 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAECmOiH003605
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 07:48:24 -0500
Received: from hades.localdomain (ovpn-113-81.phx2.redhat.com [10.3.113.81])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAECmHbl006974
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 07:48:23 -0500
Date: Fri, 14 Nov 2014 10:48:10 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Wrong d_type presented by xfs_io
Message-ID: <20141114124807.GA2240@hades.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi guys,

I've been looking through an issue raised by Brian, regarding my RENAME_EXCHANGE
patchset, where, apparently, the d_type of some files are reseted during the
exchange. Brian presented an example here:

http://oss.sgi.com/archives/xfs/2014-11/msg00170.html

When trying to debug it, I've been trying to create and rename some FS objects
to try to reproduce the issue, but, all the files I've been creating are shown
as DT_UNKNOWN type:

ex:

/dev/vdb2 on /xfs/scratch type xfs (rw,relatime,seclabel,attr2,inode64,noquota)

[root@localhost scratch]# mkdir /xfs/scratch/dir1

[root@localhost scratch]# xfs_io -c "readdir -v" /xfs/scratch/

00000006: d_ino: 0x00000083 d_off: 0x00000200 d_reclen: 0x18 d_type: DT_UNKNOWN
d_name: dir1


[root@localhost scratch]# mknod /xfs/scratch/mybdev b 253 19

00000008: d_ino: 0x00000084 d_off: 0x00000200 d_reclen: 0x20 d_type: DT_UNKNOWN
d_name: mybdev




So, anyone knows if is there any problem with xfs_io, or, if I'm doing something
wrong here?

[root@localhost scratch]# xfs_io -V
xfs_io version 3.2.1


or maybe, we have a bug somewhere else.


Cheers

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
