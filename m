Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2364F7F4E
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 19:11:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 935EEAC002
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 17:11:43 -0700 (PDT)
Received: from mail-ob0-f177.google.com (mail-ob0-f177.google.com
	[209.85.214.177]) by cuda.sgi.com with ESMTP id
	Xt9eZnzKzegs3MFj (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 13 Jul 2013 17:11:42 -0700 (PDT)
Received: by mail-ob0-f177.google.com with SMTP id ta17so12576758obb.22
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 17:11:42 -0700 (PDT)
Received: from [192.168.1.74] (75-63-29-182.lightspeed.irvnca.sbcglobal.net.
	[75.63.29.182]) by mx.google.com with ESMTPSA id
	rs4sm61584743obc.10.2013.07.13.17.11.39 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Sat, 13 Jul 2013 17:11:40 -0700 (PDT)
From: aurfalien <aurfalien@gmail.com>
Subject: specify agsize?
Date: Sat, 13 Jul 2013 17:11:38 -0700
Message-Id: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
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

Hello again,

I have a Raid 6 x16 disk array with 128k stripe size and a 512 byte block size.

So I do;

mkfs.xfs -f -l size=512m -d su=128k,sw=14 /dev/mapper/vg_doofus_data-lv_data

And I get;

meta-data=/dev/mapper/vg_doofus_data-lv_data isize=256    agcount=32, agsize=209428640 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=6701716480, imaxpct=5
         =                       sunit=32     swidth=448 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=131072, version=2
         =                       sectsz=512   sunit=32 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


All is fine but I was recently made aware of tweaking agsize.  So I would like to mess around and iozone any diffs between the above agcount of 32 and whatever agcount changes I may do.

I didn't see any mention of agsize/agcount on the XFS FAQ and would like to know, based on the above, why does XFS think I have 32 allocation groups with the corresponding size?  And are these optimal numbers?

Thanks in advance,

- aurf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
