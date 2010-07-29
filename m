Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58FAoJe009761 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 10:10:51 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5584048086A
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 15:48:43 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id RXH3J6BVDAjnXxyX for
	<xfs@oss.sgi.com>; Thu, 29 Jul 2010 15:48:43 -0700 (PDT)
Subject: Re: filesystem shrinks after using xfs_repair
Mime-Version: 1.0 (Apple Message framework v1081)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <20100730000924.77d6767e@galadriel.home>
Date: Thu, 29 Jul 2010 15:48:38 -0700
Message-Id: <DA1BD3EA-02CA-43DD-97F0-215F19323EB5@ucsc.edu>
References: <20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100724005426.GN32635@dastard>
	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100724023922.GP32635@dastard>
	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>
	<20100726034545.GE655@dastard>
	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
	<20100726060604.GF7362@dastard>
	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
	<20100726102036.GH7362@dastard>
	<0EC8FE5D-212C-4030-9D59-FDF38DF4E9EE@ucsc.edu>
	<D6C570D6-FEC7-4E3C-AAC2-13275721370A@ucsc.edu>
	<20100730000924.77d6767e@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com


On Jul 29, 2010, at 3:09 PM, Emmanuel Florac wrote:

> Le Thu, 29 Jul 2010 12:22:30 -0700 vous =E9criviez:
> =

>> I tried filling up the disk with data to see if that worked Ok and it
>> did, up until this point. There is something I don't understand going
>> on though. 'df' says that I have 381 GB free on the disk, but I can't
>> write to the disk anymore because it says it there isn't any space
>> left on it. Is this some insane round off error or is there something
>> going on here?
> =

> You probably ran out of inodes. Do you have many small files?
> =

> -- =

> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------

Hi,

I checked the inodes with this command, and it looks like I have plenty lef=
t. It's this entry, '/dev/mapper/vg1-vol5'.  =


[root@nimbus ~]# df -hi
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sdb2               6.2M    208K    6.0M    4% /
/dev/sda5               219M    452K    218M    1% /export
/dev/sda2              1001K    5.5K    996K    1% /var
tmpfs                   4.0M       1    4.0M    1% /dev/shm
/dev/mapper/vg1-vol5    1.5G   1020K    1.5G    1% /export/vol5
/dev/sdb1               127M     42K    127M    1% /storage
tmpfs                   4.0M     629    4.0M    1% /var/lib/ganglia/rrds


thanks,

Eli


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
