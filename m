Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Oct 2007 03:01:49 -0700 (PDT)
Received: from mail.albertix.com ([213.152.197.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l99A1iQP011979
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2007 03:01:46 -0700
Received: from [192.168.1.3] (ip-184-86.sn2.eutelia.it [83.211.184.86])
	by mail.albertix.com (Postfix) with ESMTP id 49DACB9BA9
	for <xfs@oss.sgi.com>; Tue,  9 Oct 2007 11:38:56 +0200 (CEST)
Message-ID: <470B4D3A.3060105@albertix.com>
Date: Tue, 09 Oct 2007 11:43:22 +0200
From: "Alberto (albertix.com)" <alberto@albertix.com>
MIME-Version: 1.0
Subject: Recover fs
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

This is my first question, sorry for my english.
I have a very serious problem. I've demage (suppose) data on XFS  RAID 0 
disk, I'll try explain steps:

before:
n.2 sata hard disk monted on raid0 with xfs fs

after:
n.2 sata hard disk monted on raid0 with reiser fs

Story:
Server is gentoo based OS with TYAN MB with n.4 SATA onboard can be 
configured in Raid0, raid1, raid0+1.
On another controller (PCI) was mounted another sata hd with OS. This hd 
was faulted, than I decide to mount 2 hd with raid1 configuration for 
better security.
I've decided to move all same size disk to unique controller (on MB). 
When i moved this hard disks I've confused old disks with new and I've 
created new raid array on them.
Old array was xfs fs and new one i've decided to make reiserfs. After 
creation of RAID, i've make "mkreiserfs /dev/md1", but not on each single hd
Now I have new array (reiserfs) on disks witch before has very important 
data. When I saw my error, I've unmount array. With fdisk I see my sdc1 
free space.
In this exact moment i've lounched command: "xfs_repair -n /dev/sdc1".

I'm desperade (aprox. crying) , on this disks was 3 years of work data 
(web, db, materials).
It's possibility to recover this data (nothing else was writing after on 
disk disks) ??? . Pls help me
If is possibilty, I promise to make 10 copies (for penitency).

Alberto.

ALBERTIX.COM di Starosta Wojciech
Via Falcone e Borsellino, 11
47827 Villa Verucchio (RN)

tel: +39 0541 1796799
fax: +39 0541 1791899
mob: +39 3388908888

PIVA: 03583890409
CIAA: RN-299344
CF: STRWCC67S06Z127F

Banca: BANCA POPOLARE DELL'EMILIA ROMAGNA
Filiale: VILLA VERUCCHIO
ABI: 05387 CAB:68100
CC: 000001472060
CIN: B
