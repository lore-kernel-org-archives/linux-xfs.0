Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Sep 2006 23:25:17 -0700 (PDT)
Received: from mail.crc.dk (mail.crc.dk [130.226.184.8])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8C6PAif023756
	for <linux-xfs@oss.sgi.com>; Mon, 11 Sep 2006 23:25:11 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.crc.dk (8.12.11.20060308/8.12.11) with ESMTP id k8C6OZKc008648
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 08:24:35 +0200
Received: from mail.crc.dk ([127.0.0.1])
 by localhost (mail.crc.dk [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 16800-09 for <linux-xfs@oss.sgi.com>;
 Tue, 12 Sep 2006 08:24:33 +0200 (CEST)
Received: from [130.226.183.100] (mkx.crc.dk [130.226.183.100])
	by mail.crc.dk (8.12.11.20060308/8.12.11) with ESMTP id k8C6OVA0008643
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 08:24:31 +0200
Message-ID: <4506529F.9030109@crc.dk>
Date: Tue, 12 Sep 2006 08:24:31 +0200
From: Mogens Kjaer <mk@crc.dk>
MIME-Version: 1.0
Subject: Re: Mounting IRIX disk on Linux
References: <45053B2D.50203@crc.dk> <4505712E.5070801@oss.sgi.com>
In-Reply-To: <4505712E.5070801@oss.sgi.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

linux-xfs@oss.sgi.com wrote:
> Mogens Kjaer wrote:
> 
>> How do I determine which of the requirements
>> listed in:
>>
>> http://oss.sgi.com/projects/xfs/faq.html#useirixxfs
>>
>> that hasn't been fulfilled?
> 
> 
> # xfs_db /dev/<device>
> xfs_db> sb 0
> xfs_db> p

This gives me:

magicnum = 0x58465342
blocksize = 4096
dblocks = 17888562
rblocks = 0
rextents = 0
uuid = 06ea04fb-1f3f-1024-8ab0-080069057580
logstart = 8912900
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 259255
agcount = 69
rbmblocks = 0
logblocks = 1168
versionnum = 0x1084
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 18
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 113856
ifree = 113202
fdblocks = 16727530
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0

How do I interprete this?

My guess is that this fs does not have directory
format 2, it might have been made before IRIX 6.5.5

Mogens
-- 
Mogens Kjaer, Carlsberg A/S, Computer Department
Gamle Carlsberg Vej 10, DK-2500 Valby, Denmark
Phone: +45 33 27 53 25, Fax: +45 33 27 47 08
Email: mk@crc.dk Homepage: http://www.crc.dk
