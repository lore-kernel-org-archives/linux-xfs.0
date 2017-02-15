Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751478AbdBOM1s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 07:27:48 -0500
Date: Wed, 15 Feb 2017 13:27:45 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS doesn't auto mount on boot when /etc/fstab entry has fs type
 set to auto
Message-ID: <20170215122745.nmwkmcqo23ecfr53@eorzea.usersys.redhat.com>
References: <CADWLRhrhPD9sPpXPFPx8BvsjwDc4nJFasTC8bRr+5rd3c48xxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADWLRhrhPD9sPpXPFPx8BvsjwDc4nJFasTC8bRr+5rd3c48xxg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vaibhaw Pandey <vaibhaw@scalegrid.io>
Cc: linux-xfs@vger.kernel.org

Hi,

> LABEL=/     /           ext4    defaults,noatime  1   1
> tmpfs       /dev/shm    tmpfs   defaults        0   0
> devpts      /dev/pts    devpts  gid=5,mode=620  0   0
> sysfs       /sys        sysfs   defaults        0   0
> proc        /proc       proc    defaults        0   0
> /dev/sdb /redis_data auto noatime,noexec,nodiratime 0 0
> $ df -T /redis_data/
> Filesystem     Type 1K-blocks  Used Available Use% Mounted on
> /dev/xvdb      xfs    5232640 32940   5199700   1% /redis_data
> 
> However if I change the /etc/fstab directive to:
> 
> /dev/sdb /redis_data xfs noatime,noexec,nodiratime 0 0
> 
> the auto mount starts working fine. Now this isn't a major problem
> since the functionality ultimately works. But I would certainly like
> to have the flexibility to avoid hard coding the fs type in the code
> that generates these fstab entries.
> 

I believe this is not a question for us, but for whatever software you are using
to mount your partitions, systemd, unit, init, whatever. It also might be a
problem with `mount` command, but if you say you can mount it normally after the
system is live, it looks not to be the case.

XFS doesn't control who and how it reads the entries in fstab.

As stated in `mount` manpage:

"If no -t option is given, or if the auto type is specified, mount will try  to
guess  the  desired  type.   Mount  uses  the  blkid  library for guessing the
filesystem type; if that does not turn up anything that looks familiar,  mount
will  try  to  read  the  file  /etc/filesystems,  or, if that
does not exist, /proc/filesystems.  All of the filesystem types listed there 
will be  tried, except  for  those  that  are labeled "nodev" (e.g. devpts, proc
and nfs). If /etc/filesystems  ends  in  a  line  with  a  single  *,   mount
will   read /proc/filesystems  afterwards.   While  trying,  all  filesystem
types will be mounted with the mount option silent."


Anyway, if you have the logs from your system when it tries to mount the
partition maybe it give us some clue of what is happening.

Cheers
 
> Any pointers or help is much appreciated. :)
> 
> Thanks,
> Vaibhaw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
