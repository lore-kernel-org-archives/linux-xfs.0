Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C6227F50
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 09:59:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DFF02304051
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 07:59:45 -0800 (PST)
Received: from mail-pd0-f181.google.com (mail-pd0-f181.google.com
	[209.85.192.181]) by cuda.sgi.com with ESMTP id
	FrbmunSEvPakG0Dh (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 07:59:44 -0800 (PST)
Received: by mail-pd0-f181.google.com with SMTP id p10so12117087pdj.26
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 07:59:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <529455CB.6050907@hardwarefreak.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>
	<528FBBE5.80404@hardwarefreak.com>
	<1385369796.2076.16.camel@bews002.euractiv.com>
	<5293EF32.9090301@hardwarefreak.com>
	<20131126025210.GL8803@dastard>
	<52941C5D.1000305@hardwarefreak.com>
	<20131126061458.GM8803@dastard>
	<529455CB.6050907@hardwarefreak.com>
Date: Thu, 28 Nov 2013 16:59:43 +0100
Message-ID: <CAMqSRmCJEp1i9QXGRBZ+2Ohv95=JfTkwO9oTnE3fkX0K1f6hug@mail.gmail.com>
Subject: Re: ARC-1120 and MD very sloooow
From: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>
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
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> Right.  It's unusual to see this many mount options.  FYI, the XFS
> default is relatime, which is nearly identical to noatime.  Specifying
> noatime won't gain you anything.  Do you really need nosuid, nodev, noexec?

Well better say what I don't want on the filesystem no?

 >Do you also see the low write speed and slow ls on md0, any/all of your
> md/RAID10 arrays?

Yes, all drive operations are slow, unfortunately, I have no drives in
the machine
that are not managed by the controller to push tests further.

> The usual: "iostat -x -d -m 5" output while the test is running.
> Also, you are using buffered IO, so changing it to use direct IO
> will tell us exactly what the disks are doing when Io is issued.
> blktrace is your friend here....

I've ran the following:


    # dd if=/dev/zero of=/srv/store/video/test.zero bs=512K count=6000
oflag=direct
    6000+0 records in
    6000+0 records out
    3145728000 bytes (3.1 GB) copied, 179.945 s, 17.5 MB/s

    # dd if=/srv/store/video/test.zero of=/dev/null iflag=direct
    6144000+0 records in
    6144000+0 records out
    3145728000 bytes (3.1 GB) copied, 984.317 s, 3.2 MB/s


Traces are huge for the read test so I put them on Google Drive + SHA1 sums:
https://drive.google.com/folderview?id=0BxJZG8aWsaMaVWkyQk1ELU5yX2c

Drives `sdc` to `sdf` are part of the RAID10 array. Only drives `sdc` and `sde`
are used when reading.

> That makes me wonder if the controller and drive write caches have been disabled.
> That could explain this.

Caching is enabled for the controller but not much information.


    > sys info
    The System Information
    ===========================================
    Main Processor     : 500MHz
    CPU ICache Size    : 32KB
    CPU DCache Size    : 32KB
    CPU SCache Size    : 0KB
    System Memory      : 128MB/333MHz/ECC
    Firmware Version   : V1.49 2010-12-02
    BOOT ROM Version   : V1.49 2010-12-02
    Serial Number      : Y611CAABAR200126
    Controller Name    : ARC-1120
    ===========================================


By the way is enabling the controller cache a good idea? I would disable
it and let the kernel manage.

--
Jimmy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
