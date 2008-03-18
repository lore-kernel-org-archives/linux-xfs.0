Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 18:07:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2I17TVB014800
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 18:07:30 -0700
Received: from knox.decisionsoft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E0CC6B2FCA
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 18:07:56 -0700 (PDT)
Received: from knox.decisionsoft.com (knox-be.decisionsoft.com [87.194.172.100]) by cuda.sgi.com with ESMTP id 2XS06KAh5nG4A4FB for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 18:07:56 -0700 (PDT)
Message-ID: <47DF15BD.8020208@decisionsoft.co.uk>
Date: Tue, 18 Mar 2008 01:07:09 +0000
From: Stuart Rowan <strr-debian@decisionsoft.co.uk>
Reply-To: strr-debian@decisionsoft.co.uk
MIME-Version: 1.0
References: <47DEFE5E.4030703@decisionsoft.co.uk> <47DF0C9D.1010602@sgi.com>
In-Reply-To: <47DF0C9D.1010602@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: 2.6.24.3 nfs server on xfs keeps producing nfsd: non-standard
 errno: -117
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

Hi Tim,

Timothy Shimmin wrote:
> Hi Stuart,
> 
> Stuart Rowan wrote:
>> Hi,
>>
>> Firstly thanks for the great filesystem and apologies if this ends up 
>> being NFS rather than XFS being weird! I'm not subscribed so please do 
>> keep me CC'd.
>>
>> I have *millions* of lines of (>200k per minute according to syslog):
>> nfsd: non-standard errno: -117
>> being sent out of dmesg
>>
>> Now errno 117 is
>> #define EUCLEAN         117     /* Structure needs cleaning */
>> which seems to be only used from a quick grep by XFS and JFFS and smbfs.
>>
>>
> In XFS we mapped EFSCORRUPTED to EUCLEAN as EFSCORRUPTED
> didn't exist on Linux.
> However, normally if this error is encountered in XFS then
> we output an appropriate msg to the syslog.
> Our default error level is 3 and most reports are rated at 1
> so should show up I would have thought.
> 
> --Tim
>

Thanks for the swift reply -- reading previous mailing list posts, that 
was my expectation too!
I've attached the relevant section of /var/log/kern.log inline below -- 
there is no error message! Is there another way of inspecting what (if 
anything) a given XFS file-system thinks is wrong with it.

Thanks,
Stu.

Mar 17 23:01:50 evenlode kernel: SGI XFS with ACLs, security attributes, 
realtime, large block/inode numbers, no debug enabled
Mar 17 23:01:50 evenlode kernel: SGI XFS Quota Management subsystem
Mar 17 23:01:50 evenlode kernel: Filesystem "dm-0": Disabling barriers, 
not supported by the underlying device
Mar 17 23:01:50 evenlode kernel: XFS mounting filesystem dm-0
Mar 17 23:01:50 evenlode kernel: Ending clean XFS mount for filesystem: dm-0
Mar 17 23:01:50 evenlode kernel: Filesystem "dm-1": Disabling barriers, 
not supported by the underlying device
Mar 17 23:01:50 evenlode kernel: XFS mounting filesystem dm-1
Mar 17 23:01:50 evenlode kernel: Ending clean XFS mount for filesystem: dm-1
Mar 17 23:01:50 evenlode kernel: e1000: eth0: e1000_watchdog: NIC Link 
is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
Mar 17 23:01:50 evenlode kernel: RPC: Registered udp transport module.
Mar 17 23:01:50 evenlode kernel: RPC: Registered tcp transport module.
Mar 17 23:01:50 evenlode kernel: NET: Registered protocol family 10
Mar 17 23:01:50 evenlode kernel: lo: Disabled Privacy Extensions
Mar 17 23:01:50 evenlode kernel: IA-32 Microcode Update Driver: v1.14a 
<tigran@aivazian.fsnet.co.uk>
Mar 17 23:01:51 evenlode kernel: Installing knfsd (copyright (C) 1996 
okir@monad.swb.de).
Mar 17 23:01:51 evenlode kernel: NFSD: Using /var/lib/nfs/v4recovery as 
the NFSv4 state recovery directory
Mar 17 23:01:51 evenlode kernel: NFSD: starting 90-second grace period
Mar 17 23:01:57 evenlode kernel: eth0: no IPv6 routers present
Mar 17 23:03:04 evenlode kernel: 3w-9xxx: scsi0: AEN: INFO 
(0x04:0x000C): Initialize started:unit=0, subunit=0.
Mar 17 23:03:04 evenlode kernel: 3w-9xxx: scsi0: AEN: INFO 
(0x04:0x000C): Initialize started:unit=0, subunit=2.
Mar 17 23:04:40 evenlode kernel: nfsd: non-standard errno: -117
Mar 17 23:05:11 evenlode last message repeated 93970 times
Mar 17 23:06:12 evenlode last message repeated 188363 times

mount:
/dev/mapper/data-home on /home type xfs (rw,logbufs=8,usrquota)
/dev/mapper/data-archive on /home/archive type xfs (rw,logbufs=8)

evenlode:~# xfs_info /home
meta-data=/dev/data/home         isize=256    agcount=32, agsize=7372784 
blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=235929088, imaxpct=25
          =                       sunit=16     swidth=48 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0


evenlode:~# xfs_info /home/archive
meta-data=/dev/data/archive      isize=256    agcount=16, agsize=6553600 
blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=104857600, imaxpct=25
          =                       sunit=16     swidth=48 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0
