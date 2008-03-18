Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 06:49:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2IDnUlI018857
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 06:49:30 -0700
Message-ID: <47DFC880.6040403@decisionsoft.co.uk>
Date: Tue, 18 Mar 2008 13:49:52 +0000
From: Stuart Rowan <strr-debian@decisionsoft.co.uk>
Reply-To: strr-debian@decisionsoft.co.uk
MIME-Version: 1.0
Subject: Re: 2.6.24.3 nfs server on xfs keeps producing nfsd: non-standard
 errno: -117
References: <47DEFE5E.4030703@decisionsoft.co.uk> <47DF0C9D.1010602@sgi.com>
In-Reply-To: <47DF0C9D.1010602@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Timothy Shimmin <tes@sgi.com>

Timothy Shimmin wrote, on 18/03/08 00:28:
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
>> My nfs server export two locations
>> /home
>> /home/archive
>> both of these are XFS partitions, hence my suspicion that the -117 is 
>> coming from XFS.
>>
>> xfs_repair -n says the filesystems are clean
>> xfs_repair has been run multiple times to completion on the 
>> filesystems, all is fine.
>>
>> The XFS partitions are lvm volumes as follows
>> data/home 900G
>> data/archive 400G
>> The volume group, data, is sda3
>> sda3 is a 6 drive 3ware 9550SXU-8LP RAID10 array
>>
>> The NFS server is currently in use (indeed the message only starts 
>> once clients connect) and works absolutely fine.
>>
>> How do I find out what (if anything) is wrong with my filesystem / 
>> appropriately silence this message?
>>
>> Many thanks,
>> Stu.
>>
> 
> 
I briefly changed the sysctl fs.xfs.error_level to 6 and then back to 3

It gives the following message and backtrace

> Mar 18 13:35:15 evenlode kernel: nfsd: non-standard errno: -117
> Mar 18 13:35:15 evenlode kernel: 0x0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> Mar 18 13:35:15 evenlode kernel: Filesystem "dm-0": XFS internal error xfs_itobp at line 360 of file fs/xfs/xfs_inode.c.  Caller 0xffffffff8821224d
> Mar 18 13:35:15 evenlode kernel: Pid: 2791, comm: nfsd Not tainted 2.6.24.3-generic #1
> Mar 18 13:35:15 evenlode kernel: 
> Mar 18 13:35:15 evenlode kernel: Call Trace:
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8821224d>] :xfs:xfs_iread+0x71/0x1e8
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8820f784>] :xfs:xfs_itobp+0x141/0x17b
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8821224d>] :xfs:xfs_iread+0x71/0x1e8
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8821224d>] :xfs:xfs_iread+0x71/0x1e8
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8820d7c9>] :xfs:xfs_iget_core+0x352/0x63a
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8029095f>] alloc_inode+0x152/0x1c2
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8820db4c>] :xfs:xfs_iget+0x9b/0x13f
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff882243d1>] :xfs:xfs_vget+0x4d/0xbb
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8822f0d2>] :xfs:xfs_nfs_get_inode+0x2e/0x42
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8822f1f9>] :xfs:xfs_fs_fh_to_dentry+0x64/0x97
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff88332554>] :exportfs:exportfs_decode_fh+0x30/0x1dc
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff88347c16>] :nfsd:nfsd_acceptable+0x0/0xca
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8023b11a>] set_current_groups+0x148/0x153
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8834df5f>] :nfsd:nfsd_setuser+0x11c/0x171
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff88347762>] :nfsd:nfsd_setuser_and_check_port+0x52/0x57
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff88347edb>] :nfsd:fh_verify+0x1fb/0x4a4
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff88261024>] :sunrpc:svc_tcp_recvfrom+0x7ab/0x843
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff88349141>] :nfsd:nfsd_open+0x1f/0x170
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff88349538>] :nfsd:nfsd_read+0x7f/0xc4
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff88350321>] :nfsd:nfsd3_proc_read+0x117/0x15a
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8834524e>] :nfsd:nfsd_dispatch+0xde/0x1c2
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8825e192>] :sunrpc:svc_process+0x3f7/0x6e9
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff803fba8d>] __down_read+0x12/0x9a
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8834582f>] :nfsd:nfsd+0x191/0x2ae
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8020cbe8>] child_rip+0xa/0x12
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8834569e>] :nfsd:nfsd+0x0/0x2ae
> Mar 18 13:35:15 evenlode kernel:  [<ffffffff8020cbde>] child_rip+0x0/0x12
> Mar 18 13:35:15 evenlode kernel: 

Does that help?

Thanks,
Stu.
