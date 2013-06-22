Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 057757F37
	for <xfs@oss.sgi.com>; Sat, 22 Jun 2013 00:30:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E870A304039
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 22:30:36 -0700 (PDT)
Received: from mail-gh0-f181.google.com (mail-gh0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	e9RMCWhXoxkxRIDf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Jun 2013 22:30:36 -0700 (PDT)
Received: by mail-gh0-f181.google.com with SMTP id z12so2479590ghb.12
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 22:30:35 -0700 (PDT)
Received: from [192.168.1.74] (75-63-29-182.lightspeed.irvnca.sbcglobal.net.
	[75.63.29.182]) by mx.google.com with ESMTPSA id
	u69sm13904931yhf.23.2013.06.21.22.30.33 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Fri, 21 Jun 2013 22:30:34 -0700 (PDT)
From: aurfalien <aurfalien@gmail.com>
Subject: LVM + XFS + external log + snapshots
Date: Fri, 21 Jun 2013 22:30:31 -0700
Message-Id: <022467CC-8EB2-41E9-8AF6-46F781882F6B@gmail.com>
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

Hi all,

So I have an XFS file system within LVM  which has an external log.

My mount option in FSTAB is;

/dev/vg_spock_data/lv_data	/data	xfs	logdev=/dev/sdc1,nobarrier,logbufs=8,noatime,nodiratime	1 1

All is well no issues and very fast.

Now I'd like to snapshot this bad boy and then run rsnapshot to create a few days backup.

A snapshot volume is created w/o issue;

lvcreate -L250G -s -n datasnapshot /dev/vg_spock_data/lv_data

But when i try to mount the file system;

mount /dev/vg_spock_data/datasnapshot /snapshot -o nouuid,ro

I get this;

mount: wrong fs type, bad option, bad superblock on /dev/mapper/vg_anette_data-datasnapshot,
      missing codepage or helper program, or other error
      In some cases useful info is found in syslog - try
      dmesg | tail  or so

The command dmesg shows;

XFS (dm-3): filesystem is marked as having an external log; specify logdev on the mount command line.
XFS (dm-3): SB validate failed

So I then use this mount option;

mount /dev/vg_anette_data/datasnapshot /snapshot -o logdev=/dev/sdc1,nouuid,ro

But get this error;

mount: /dev/mapper/vg_spock_data-datasnapshot already mounted or /snapshot busy

And the command dmesg shows;

XFS (dm-3): Invalid device [/dev/sdc1], error=-16

Am I doing something wrong or is this not possible?

I prefer being in error, I often am anyways.

Thanks in advance,

- aurf
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
