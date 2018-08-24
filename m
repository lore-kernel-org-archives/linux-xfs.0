Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:32792 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbeHYBDf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Aug 2018 21:03:35 -0400
Subject: Re: Corrupted large file ?
References: <F6BD1F63141BFD48924FAD7C646366FA02EC869C40@SRV-MBX-01.intra.igr.fr>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a53214a7-fd6f-1a0d-463b-e1882bd150cc@sandeen.net>
Date: Fri, 24 Aug 2018 16:27:12 -0500
MIME-Version: 1.0
In-Reply-To: <F6BD1F63141BFD48924FAD7C646366FA02EC869C40@SRV-MBX-01.intra.igr.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: BOURSIN YANNICK <YANNICK.BOURSIN@gustaveroussy.fr>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On 8/24/18 9:39 AM, BOURSIN YANNICK wrote:
> Hello Everybody,
> 
>                 I am facing some issues with XFS. I do not really know what went wrong and how to diagnose the issue I'm having, but here are the symptoms:
> . My kernel is: Linux proxmox1 4.13.13-2-pve #1 SMP PVE 4.13.13-32. It's a 40 cores server that features 160Tb storage (with RAID-6) and 384G RAM.                                                                                             
> . /dev/sdb1 is a raid array that is roughly 128Tb big
> . It contains mainly virtual machine disks for a proxmox instance
> . After a regular halt / restart in which nothing was odd, I could not start anymore one of my VM, kvm timing out.
> . Tried a few things, one of which was "head -n 1 <name of the image>.qcow2 . The image being a single 30Tb file.
> . The console freezes after that.

I know you said this was resolved - but I'll just point out a couple things.

"head -n 1" reads the first line.  When you are reading a binary qcow2 file which really isn't a line-by-line file, it's possible that it'll read the entire file looking for a newline.

IOWs, interacting with it via "head" is possibly not a great debugging approach.  :)

> It seems that I cannot do anything with the qcow2 image. I tried to dd it into another file, but no change. After that, I tried rebooting again, and it told me upon process termination:
> 
> "echo 0" > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Print_req_error: I/O error, dev sdb, sector 241349552640
> XFS (sdb1): metadata I/O error: block 0x38818de200 ("xfs_trans_read_buf_map") error 5 numblks 8

More of the dmesg would be more enlightening - too often the critical bits get edited out.

> . Tried to run after that xfs_repair with default parameters on my /dev/sdb1. Nothing's getting out of that, it's almost like xfs_repair doesn't detect anything. It has ran 3 times now, always with the same output which you can see there:
> 
> root@proxmox1:~/xfsprogs-4.17.0# xfs_repair -e /dev/sdb1

<snip clean repair>

> root@proxmox1:~/xfsprogs-4.17.0# echo $?
> 0

...

> Here is the output of dmesg after a ls was blocked:
> 
> 
> [ 3384.280537] INFO: task ls:21392 blocked for more than 120 seconds.
> [ 3384.280592]       Not tainted 4.13.13-2-pve #1
> [ 3384.280626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this                                                                                              message.
> [ 3384.280682] ls              D    0 21392   3298 0x00000004
> [ 3384.280687] Call Trace:
> [ 3384.280700]  __schedule+0x3cc/0x860
> [ 3384.280788]  ? xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
> [ 3384.280796]  schedule+0x36/0x80
> [ 3384.280800]  rwsem_down_read_failed+0x10a/0x170
> [ 3384.280804]  call_rwsem_down_read_failed+0x18/0x30
> [ 3384.280807]  ? call_rwsem_down_read_failed+0x18/0x30
> [ 3384.280880]  ? xfs_trans_roll+0xc0/0xc0 [xfs]
> [ 3384.280884]  down_read+0x20/0x40
> [ 3384.280938]  xfs_ilock+0xe0/0x110 [xfs]
...

Something else had the ilock, but we don't know what.  If it happens again, I'd take stock of other activity on the box, I guess.

-Eric
