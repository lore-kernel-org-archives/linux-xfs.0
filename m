Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7R7Lgee070391 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 02:21:58 -0500
Received: from mx2.empa.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D50CD15550BA
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 00:22:31 -0700 (PDT)
Received: from mx2.empa.ch (mx2.empa.ch [152.88.7.32]) by cuda.sgi.com with
	ESMTP id Q1alMF0UCyIFQiHR for <xfs@oss.sgi.com>;
	Thu, 27 Aug 2009 00:22:31 -0700 (PDT)
Received: from Du-Exc-Hub1.empa.emp-eaw.ch (localhost [127.0.0.1])
	by mx2.empa.ch (Spam & Virus Firewall) with ESMTP id 9A113544D9A
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 09:22:04 +0200 (CEST)
Received: from Du-Exc-Hub1.empa.emp-eaw.ch ([152.88.6.64]) by mx2.empa.ch with
	ESMTP id CORAl0EkIhMl5GkJ for <xfs@oss.sgi.com>;
	Thu, 27 Aug 2009 09:22:04 +0200 (CEST)
From: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Date: Thu, 27 Aug 2009 09:22:02 +0200
Subject: xfs data loss
Message-ID: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
Content-Language: en-US
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Dear xfs developers

We have a SUN X4500 with 48 500 GB drives, that we configured under SUSE SLES 10.

Among others, we have 3 RAID5 xfs filesystems, /dev/md4 with 20 units (9.27 TB)
/dev/md5 with 20 units (9.27 TB) and /dev/md6 with 5 units (1.95 TB)

These units are not backed up.

Due to a power shock, suddenly and without log messages about one half (5 TB) of the user 
directories on /dev/md4 have disappeared.
Upon reboot, /dev/md6 showed only 3 units, and after a xfs_repair it was again ok.
/dev/md4 mounted immediately, but always with one half of the directories.


1) xfs_check gives no problem on /dev/md4

but 

2) xfs_logprint

xfs_logprint:
    data device: 0x904
    log device: 0x904 daddr: 9279295544 length: 262144

Header 0x1c8b wanted 0xfeedbabe
**********************************************************************
* ERROR: header cycle=7307        block=182240                       *
**********************************************************************
Bad log record header

and the same happens on /dev/md5.


3) xfs_ncheck eats a lot of memory and freezes after 6-7 hours without giving output

4) I have a xfs_metadump in a file (1.8 GB) but I don't know what to do with it.

WHat can I do? Any help would be appreciated, I would really be happy to recover those files...
:-)

Thank you in advance

Daniele Passerone
Empa, Switzerland


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
