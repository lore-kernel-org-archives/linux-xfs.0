Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E8A37F37
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 14:30:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D1488F8065
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 12:30:44 -0700 (PDT)
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	FM4makYhbiA072TT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Apr 2015 12:30:43 -0700 (PDT)
Received: by iebrs15 with SMTP id rs15so26595113ieb.3
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 12:30:42 -0700 (PDT)
Received: from [192.168.1.171] (108-224-191-17.lightspeed.livnmi.sbcglobal.net.
	[108.224.191.17])
	by mx.google.com with ESMTPSA id o2sm7785228igr.9.2015.04.28.12.30.41
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 28 Apr 2015 12:30:41 -0700 (PDT)
Message-ID: <553FDFE0.7050800@gmail.com>
Date: Tue, 28 Apr 2015 15:30:40 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: question: are the metadata crc elements ready for general use?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I ask as I see this in the 3.2.2 mkfs.xfs command.  The default is to 
leave them off from what I can see on an mkfs.xfs.

root@unison:~/xfsprogs# mkfs.xfs /dev/sda
meta-data=/dev/sda               isize=256    agcount=55, 
agsize=268435455 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=14627632640, imaxpct=1
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

But they are there, and I am curious as to the developers/users 
thoughts.  Will they break things (nfs, CIFS/samba)?

Thanks!

Joe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
