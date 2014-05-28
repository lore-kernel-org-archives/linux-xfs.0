Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 732FA7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 19:12:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 605C28F807A
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 17:12:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RXYRt0oW221FRvvM for
	<xfs@oss.sgi.com>; Tue, 27 May 2014 17:12:53 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4S0CrDV014142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 27 May 2014 20:12:53 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4S0CpUl010321
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 20:12:52 -0400
Message-ID: <53852A05.5040006@redhat.com>
Date: Tue, 27 May 2014 19:12:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 0/2, RFC] xfsprogs: try to handle mkfs of a file on 4k sector
	device
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
To: xfs-oss <xfs@oss.sgi.com>

Today if you mkfs.xfs <filename> where the file resides on a
hard-4k filesystem, we fail because it tries to do 512 direct
IO when 4k is required; this is a bit cryptic:

# mkfs.xfs -f mnt/fsfile
meta-data=mnt/fsfile             isize=256    agcount=4, agsize=8192 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=32768, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=853, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
existing superblock read failed: Invalid argument
mkfs.xfs: pwrite64 failed: Invalid argument

We can modify platform_findsizes() to use the fsgeom call to get the
"sector size" which should be used here, and warn that mismatches
might exist if it fails.

This does mean there'll be a new warning emitted on fs images hosted
on non-xfs filesystems; I'm not really quite sure it's worth it,
hence the RFC nature of this lightly tested 2-patch series...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
