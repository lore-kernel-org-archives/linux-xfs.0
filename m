Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9275CC35247
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 00:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 542FF2087E
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 00:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgBDAIv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 19:08:51 -0500
Received: from p3plmtsmtp01.prod.phx3.secureserver.net ([184.168.131.12]:57824
        "EHLO p3plmtsmtp01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726474AbgBDAIv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 19:08:51 -0500
Received: from n64.mail01.mtsvc.net ([216.70.64.196])
        by :MT-SMTP: with ESMTP
        id yllMiUH46D9jayllMiWGQd; Mon, 03 Feb 2020 17:08:20 -0700
X-SID:  yllMiUH46D9ja
Received: from [162.248.116.186] (port=62381 helo=[192.168.101.29])
        by n64.mail01.mtsvc.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <alan@instinctualsoftware.com>)
        id 1iyllK-0005Ky-FH; Mon, 03 Feb 2020 19:08:19 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: su & sw for HW-RAID60
From:   Alan Latteri <alan@instinctualsoftware.com>
In-Reply-To: <20200203235501.GJ20628@dread.disaster.area>
Date:   Mon, 3 Feb 2020 16:08:16 -0800
Cc:     linux-xfs@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9F0A2193-755E-4304-96EE-8F16FA7B0FBB@instinctualsoftware.com>
References: <2CE21042-5F18-4642-BF48-AF8416FB9199@instinctualsoftware.com>
 <20200203225914.GB20628@dread.disaster.area>
 <03E9DDCF-9395-4E8A-A228-E8E5B004B111@instinctualsoftware.com>
 <B41F5F0B-1A6F-4089-8AC3-F3A39830CDA7@instinctualsoftware.com>
 <20200203235501.GJ20628@dread.disaster.area>
To:     Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
X-Authenticated-User: 1434467 alan@instinctualsoftware.com
X-MT-ID: 9DCC79A4E204102198399334CA945B5BD229B688
X-CMAE-Envelope: MS4wfPEyEs4EWOUHgylzNziocKtodLsMOe9fKY5isK0Oy85qG+I6ms8iIkYMl/v/oy1KkJ7eaGtmSatD58tfVhvafntVj6Ca8bbfXNRNOlu3Eoq+8lym52yU
 ovw/X0Ajt/vxHXdrWZ6gyvZ+xJyS96wPVzsaW3Zz3ZZ9hLmUSZ21sedo2jPbTx2ZZpp9bxTQyV/w7b7Jrfx3w1lcER3CbVySx0vHIUH7cRiHtszN8RbRDWeP
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

You are correct.  There is an LVM layer on top made with the following commands:

pvcreate /dev/sda
vgcreate chwumbo /dev/sda
lvcreate -l 100%FREE -n data chwumbo 

Running mkfs.xfs against raw block device produces the following result.

mkfs.xfs -f -d su=2560k,sw=5 /dev/sda
mkfs.xfs: Specified data stripe unit 5120 is not the same as the volume stripe unit 512
mkfs.xfs: Specified data stripe width 25600 is not the same as the volume stripe width 512



[root@chwumbo storcli]# ./storcli64 /c0 show
Generating detailed summary of the adapter, it may take a while to complete.

Controller = 0
Status = Success
Description = None

Product Name = AVAGO 3108 MegaRAID
Serial Number = FW-BDVQ8HEAARBWA
SAS Address =  500304801cffe808
PCI Address = 00:3b:00:00
System Time = 02/03/2020 16:06:04
Mfg. Date = 00/00/00
Controller Time = 02/03/2020 16:06:04
FW Package Build = 24.21.0-0119
BIOS Version = 6.36.00.3_4.19.08.00_0x06180203
FW Version = 4.680.00-8505
Driver Name = megaraid_sas
Driver Version = 07.707.51.00-rc1
Current Personality = RAID-Mode 
Vendor Id = 0x1000
Device Id = 0x5D
SubVendor Id = 0x15D9
SubDevice Id = 0x809
Host Interface = PCI-E
Device Interface = SATA-3G
Bus Number = 59
Device Number = 0
Function Number = 0
Drive Groups = 1

TOPOLOGY :
========

------------------------------------------------------------------------------
DG Arr Row EID:Slot DID Type   State BT       Size PDC  PI SED DS3  FSpace TR 
------------------------------------------------------------------------------
 0 -   -   -        -   RAID60 Optl  N  727.612 TB dsbl N  N   dflt N      N  
 0 0   -   -        -   RAID6  Optl  N  145.522 TB dsbl N  N   dflt N      N  
 0 0   0   0:0      2   DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   1   0:18     3   DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   2   0:20     4   DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   3   0:21     5   DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   4   1:6      6   DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   5   0:9      7   DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   6   0:19     8   DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   7   0:17     9   DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   8   0:13     10  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   9   1:4      11  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   10  0:7      12  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 0   11  0:26     13  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   -   -        -   RAID6  Optl  N  145.522 TB dsbl N  N   dflt N      N  
 0 1   0   0:15     14  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   1   1:3      15  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   2   0:14     16  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   3   1:1      17  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   4   0:29     18  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   5   0:22     19  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   6   0:28     20  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   7   0:25     21  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   8   1:2      22  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   9   0:6      23  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   10  0:23     24  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 1   11  0:27     25  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   -   -        -   RAID6  Optl  N  145.522 TB dsbl N  N   dflt N      N  
 0 2   0   0:5      26  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   1   0:3      27  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   2   0:16     28  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   3   0:8      29  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   4   1:5      30  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   5   1:17     31  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   6   1:12     32  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   7   1:8      33  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   8   1:9      34  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   9   1:25     35  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   10  1:11     36  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 2   11  0:10     37  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   -   -        -   RAID6  Optl  N  145.522 TB dsbl N  N   dflt N      N  
 0 3   0   1:18     38  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   1   0:1      39  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   2   0:11     40  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   3   1:0      41  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   4   0:2      42  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   5   1:13     43  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   6   1:21     44  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   7   0:12     45  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   8   1:22     46  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   9   1:10     47  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   10  1:24     48  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 3   11  1:26     49  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   -   -        -   RAID6  Optl  N  145.522 TB dsbl N  N   dflt N      N  
 0 4   0   1:7      50  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   1   0:24     51  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   2   1:19     52  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   3   1:29     53  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   4   0:4      54  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   5   1:27     55  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   6   1:15     56  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   7   1:28     57  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   8   1:16     58  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   9   1:23     59  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   10  1:14     60  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
 0 4   11  1:20     61  DRIVE  Onln  N   14.551 TB dsbl N  N   dflt -      N  
------------------------------------------------------------------------------

DG=Disk Group Index|Arr=Array Index|Row=Row Index|EID=Enclosure Device ID
DID=Device ID|Type=Drive Type|Onln=Online|Rbld=Rebuild|Dgrd=Degraded
Pdgd=Partially degraded|Offln=Offline|BT=Background Task Active
PDC=PD Cache|PI=Protection Info|SED=Self Encrypting Drive|Frgn=Foreign
DS3=Dimmer Switch 3|dflt=Default|Msng=Missing|FSpace=Free Space Present
TR=Transport Ready

Virtual Drives = 1

VD LIST :
=======

---------------------------------------------------------------------
DG/VD TYPE   State Access Consist Cache Cac sCC       Size Name      
---------------------------------------------------------------------
0/0   RAID60 Optl  RW     No      RWBD  -   ON  727.612 TB VDName_00 
---------------------------------------------------------------------

Cac=CacheCade|Rec=Recovery|OfLn=OffLine|Pdgd=Partially Degraded|Dgrd=Degraded
Optl=Optimal|RO=Read Only|RW=Read Write|HD=Hidden|TRANS=TransportReady|B=Blocked|
Consist=Consistent|R=Read Ahead Always|NR=No Read Ahead|WB=WriteBack|
AWB=Always WriteBack|WT=WriteThrough|C=Cached IO|D=Direct IO|sCC=Scheduled
Check Consistency

Physical Drives = 60

PD LIST :
=======

-----------------------------------------------------------------------------
EID:Slt DID State DG      Size Intf Med SED PI SeSz Model            Sp Type 
-----------------------------------------------------------------------------
0:0       2 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:1      39 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:2      42 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:3      27 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:4      54 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:5      26 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:6      23 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:7      12 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:8      29 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:9       7 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:10     37 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:11     40 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:12     45 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:13     10 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:14     16 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:15     14 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:16     28 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:17      9 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:18      3 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:19      8 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:20      4 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:21      5 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:22     19 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:23     24 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:24     51 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:25     21 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:26     13 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:27     25 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:28     20 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
0:29     18 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:0      41 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:1      17 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:2      22 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:3      15 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:4      11 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:5      30 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:6       6 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:7      50 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:8      33 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:9      34 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:10     47 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:11     36 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:12     32 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:13     43 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:14     60 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:15     56 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:16     58 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:17     31 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:18     38 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:19     52 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:20     61 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:21     44 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:22     46 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:23     59 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:24     48 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:25     35 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:26     49 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:27     55 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:28     57 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
1:29     53 Onln   0 14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
-----------------------------------------------------------------------------

> On Feb 3, 2020, at 3:55 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> On Mon, Feb 03, 2020 at 03:12:06PM -0800, Alan Latteri wrote:
>> I should have read your response more thoroughly as you say exactly that, “behaves as a single disk”.
>> 
>> Here is the output from the mkfs.xfs command.  Not sure if those warning indicate any harm.
>> 
>> [root@chwumbo ~]# mkfs.xfs -f -d su=2560k,sw=5 /dev/chwumbo/data
>> mkfs.xfs: Specified data stripe unit 5120 is not the same as the volume stripe unit 8192
>> mkfs.xfs: Specified data stripe width 25600 is not the same as the volume stripe width 16384
> 
> What is /dev/chwumbo/data? It's reporting that it is a su=4M,sw=2
> device, not a device with the physical characteristics you
> described.
> 
> If it's LVM, it needs to be configured to align to the underlying
> storage as well (i.e. 2560kB allocation units and alignment) so that
> it doesn't cause the filesystem to be misaligned on the disks....
> 
>> meta-data=/dev/chwumbo/data      isize=512    agcount=728, agsize=268434560 blks
>>         		=                       sectsz=4096  attr=2, projid32bit=1
>>        		 =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>         		 =                       reflink=1
>> data    		 =                       bsize=4096   blocks=195316939776, imaxpct=1
>>         		 =                       sunit=640    swidth=3200 blks
>> naming  		 =version 2              bsize=4096   ascii-ci=0, ftype=1
>> log      		 =internal log           bsize=4096   blocks=521728, version=2
>>        		 =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> realtime 		 =none                   extsz=4096   blocks=0, rtextents=0
> 
> Otherwise that looks like a normal 728TB filesystem.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

