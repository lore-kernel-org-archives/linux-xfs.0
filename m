Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 04:24:16 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0ECOAR1026029
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 04:24:12 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B7E911CB35E
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 04:24:27 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183]) by cuda.sgi.com with ESMTP id lszGxFExEGC15GBX for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 04:24:27 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so3891749waf.18
        for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 04:24:27 -0800 (PST)
Message-ID: <d711080c0801140424w12e4440me62afc842ec79bbd@mail.gmail.com>
Date: Mon, 14 Jan 2008 17:54:26 +0530
From: "Gopala Krishna" <gopalakrishna.n.m@gmail.com>
Subject: Re: Question related to XFS sync , especially fsync
In-Reply-To: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
MIME-Version: 1.0
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,
My system information:
-bash-3.00# uname -a
Linux   XXXXX         #1 SMP Thu May 17 14:00:09 UTC 2007 ia64 ia64 ia64
GNU/Linux

-bash-3.00# cat /etc/issue
Welcome to SUSE Linux Enterprise Server 10 SP1 (ia64) - Kernel \r (\l).

Thanks,
Gopal.

On 1/14/08, Gopala Krishna <gopalakrishna.n.m@gmail.com> wrote:
>
> Hi,
> I am seeing some strange problem with XFS and would like to know  the
> expected behavior and if it is faulty is there any patches to resolve the
> problem.
>
> Problem:
> ======
> Basically I am extracting metadata information for a given file by reading
> the inode structure from the particular disk offset (based on it's  position
> calculated by published inode structure and super block structure
>  information). Before reading the metada data information from the disk, I
> am calling fsync (I used to call sync, but later I changed to fsync, since
> sync is not guranteed to flush all meta data)  to ensure all metadata
> related to file is flushed to disk. Later I am reading particular disk
> offset as per calculation.   I am getting XFS magic field properly after
> mapping to XFs inode structure. However I am not getting dimode properly in
> some cases (not all cases) and it shows 00000 even for regular file and
> directory.
>
> It is happening only when I copy new file to XFS.  But, when I unmount the
> file system and remount it, everything goes fine and I could get all
> expected meta data information and proper value for dimode (in the inode
> structure which indicates the type of the file, i.e regular directory
> etc.) .
>
> Once I mount it back and later even if I remove the same file and copy it
> back to XFS and then run my utility program, I could read mode information
> properly. But If I copy different file, again I could not get dimode
> properly. I have to unmount and remount to get the mode properly to make my
> utility program to display information properly. Once it starts getting
> proper mode value, it continues.
>
> So I am suspecting, even after calling fsync (which says it would block
> untill it flushes metadata information to disk ), is not really flushing. So
> only during unmount, it flushes metadata and hence I could get dimode
> properly. since after remounting , by reading metadata information , I could
> get mode properly and differentiate directory or regular file, and also it
> is filling magic etc. properly, I feel the data I am reading is right and
> that I could compare with stat system call and ls commands.
>
> If I am doing something wrong and no problem with XFS, then I should not
> get mode field properly even after unmount/remount operation.
>
> Is there any problem with XFS fsync? Why dimode is getting updated only
> during unmount? why not when I call fsync? Because fsync says it has to
> flush all meta dat to disk before existing.
>
> Please let me know your feedback.
>


[[HTML alternate version deleted]]
