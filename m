Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 19:02:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8I22Muw014065
	for <linux-xfs@oss.sgi.com>; Mon, 17 Sep 2007 19:02:25 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA21052; Tue, 18 Sep 2007 10:50:01 +1000
Message-ID: <46EF20B9.2060304@sgi.com>
Date: Tue, 18 Sep 2007 10:50:01 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: Newbie question about mkfs.xfs command
References: <12745380.post@talk.nabble.com>
In-Reply-To: <12745380.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hxsrmeng <hxsrmeng@gmail.com>
Cc: linux-xfs@oss.sgi.com

Hxsrmeng wrote:
> What does the second "loop" means in "mkfs.xfs -d file=loop loop"? Thanks.

The final parameter to mkfs.xfs needs to be a block device or a file.

In your case it looks like you intend to create a filesystem on a file
called loop (so you can mount it later as a loopback device?).

You dont need the '-d file=loop' (which is invalid, file= takes 1 or 0),
mkfs.xfs usually figures this out.


So assuming you created a test file with something like

# dd if=/dev/zero of=testfile bs=1k count=100000
100000+0 records in
100000+0 records out
102400000 bytes (102 MB) copied, 0.770193 seconds, 133 MB/s

You make an xfs filesystem with just

# mkfs.xfs testfile
meta-data=bar                    isize=256    agcount=6, agsize=4096 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=24576, imaxpct=25
          =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=1200, version=1
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

And after making a mount point, mount it with

# mount -o loop testfile testmount

The -o loop tells mount to use a loopback device to turn your testfile into
a block device for the mount. This is the only step you need root permissions
for.

Don
