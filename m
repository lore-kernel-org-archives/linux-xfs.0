Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE0FF7F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 09:35:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56448AC06B
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 07:35:08 -0700 (PDT)
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	VDJlE48dltFTnNRG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 07:35:07 -0700 (PDT)
Received: by mail-ie0-f181.google.com with SMTP id ar20so14365582iec.12
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 07:35:06 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 22:35:06 +0800
Message-ID: <CAD+1EGMos6SgyKDAKc8LHajUMbd9acZ9ghKCG=ksKZnhTxawDw@mail.gmail.com>
Subject: XFS real-time allocator
From: harryxiyou <harryxiyou@gmail.com>
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

Hi all,

I have created a real-time partition as follows.

root@node2:~# mkfs.xfs -f -r rtdev=/dev/sda3 /dev/sda4

meta-data=/dev/sda4              isize=256    agcount=4, agsize=56122440 blks

         =                       sectsz=512   attr=2, projid32bit=0

data     =                       bsize=4096   blocks=224489757, imaxpct=25

         =                       sunit=0      swidth=0 blks

naming   =version 2              bsize=4096   ascii-ci=0

log      =internal log           bsize=4096   blocks=109614, version=2

         =                       sectsz=512   sunit=0 blks, lazy-count=1

realtime =/dev/sda3              extsz=4096   blocks=14865657,
rtextents=14865657


I wonder how to use its real-time feature. And I should call some interfaces
supported by XFS in the user/kernel-space, right?


-- 
Thanks
Weiwei  Jia (Harry Wei)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
