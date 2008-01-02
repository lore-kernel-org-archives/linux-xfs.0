Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jan 2008 05:16:28 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m02DGLIV005036
	for <xfs@oss.sgi.com>; Wed, 2 Jan 2008 05:16:24 -0800
Received: from welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2849A12250B1
	for <xfs@oss.sgi.com>; Wed,  2 Jan 2008 05:16:34 -0800 (PST)
Received: from welcomes-you.com (welcomes-you.com [85.214.50.128]) by cuda.sgi.com with ESMTP id Gt2BSU2YCeKFdkDy for <xfs@oss.sgi.com>; Wed, 02 Jan 2008 05:16:34 -0800 (PST)
Message-ID: <477B8EAB.8000703@welcomes-you.com>
Date: Wed, 02 Jan 2008 14:16:27 +0100
From: Carsten Aulbert <carsten@welcomes-you.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Subject: How to damage a XFS-Filesystem?
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I have the following scenario:

A file server with a 10 TB large xfs file system running on a RAID6 SATA
array, the server has 16 GB of memory. I want to test how long it would
take to run xfs_repair on it and if the amount of memory is enough for that.

Thus I think I would need to:

(1) Fill the disk with files
(2) Damage the file sytem
(3) Run xfs_repair

My questions:

(1) Is there a nice tool which fills up a disk? I.e. I want to write
files with varying size and want to be able to check the validity
(md5,sha1...) of the files before and after the damage. I don't know if
it matters, but the number of entries per directory should also vary
greatly ;)

(2) I don't know if xfs_repair cares if the file system was damaged or
not. If it uses the same amount of time and memory on a fully intact
file system, I guess I don't have a question anymore. Otherwise: How can
a damage a xfs file system to make the job harder for xfs_repair. I
guess a simple dd if=/dev/random of=/dev/sdb1 with some offsets will not
be very effective, right?

(3) Anything else I need to be aware of?

Thanks for your patience (and yes, I have tried the archives for answers)

Cheers

Carsten
