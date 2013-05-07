Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A1FB29DF8
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 08:20:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A7FA304071
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 06:20:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6q2OOooK4W2ppdOI for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 06:20:09 -0700 (PDT)
Message-ID: <5188FF88.6000508@sandeen.net>
Date: Tue, 07 May 2013 08:20:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs_repair segfaults.
References: <CADNx=KsT9DC=vveyTZx8EovddFx9mhRS-yzygaORHZ_4VyXfzQ@mail.gmail.com>
	<5187BF8A.2040303@sandeen.net>
	<CADNx=KvZPhbRn9Kc3+KdoAY7jZ3U0uyG6wgUB5vcxX85CkFdQg@mail.gmail.com>
	<CADNx=Kv0bt3fNGW8Y24GziW9MOO-+b7fBGub4AYP70b5gAegxw@mail.gmail.com>
In-Reply-To: <CADNx=Kv0bt3fNGW8Y24GziW9MOO-+b7fBGub4AYP70b5gAegxw@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Filippo Stenico <filippo.stenico@gmail.com>
Cc: xfs@oss.sgi.com

On 5/7/13 4:27 AM, Filippo Stenico wrote:
> Hello,
> this is a start-over to try hard to recover some more data out of my raid5 - lvm - xfs toasted volume.
> My goal is either to try the best to get some more data out of the volume, and see if I can reproduce the segfault.
> I compiled xfsprogs 3.1.9 from deb-source. I ran a xfs_metarestore to put original metadata on the cloned raid volume i had zeroed the log on before via xfs_repair -L (i figured none of the actual data was modified before as I am just working on metadata.. right?).
> Then I ran a mount, checked a dir that I knew it was corrupted, unmount and try an xfs_repair (commands.txt attached for details)
> I went home to sleep, but at morning I found out that kernel paniced due "out of memory and no killable process".
> I ran repair without -P... Should I try now disabling inode prefetch?
> Attached are also output of "free" and "top" at time of panic, as well as the output of xfs_repair and strace attached to it. Dont think gdb symbols would help here....
> 

> 

Ho hum, well, no segfault this time, just an out of memory error?

No real way to know where it went from the available data I think.

A few things:

> root@ws1000:~# mount /dev/mapper/vg0-lv0 /raid0/data/
> mount: Structure needs cleaning

mount failed?  Now's the time to look at dmesg to see why.

>From attached logs it seems to be:

> XFS internal error xlog_valid_rec_header(1) at line 3466 of file [...2.6.32...]/fs/xfs/xfs_log_recover.c
> XFS: log mount/recovery failed: error 117

> root@ws1000:~# mount

<no raid0 mounted>

> root@ws1000:~# mount /dev/mapper/vg0-lv0 /raid0/data/
> root@ws1000:~# mount | grep raid0
> /dev/mapper/vg0-lv0 on /raid0/data type xfs (rw,relatime,attr2,noquota)

Uh, now it worked, with no other steps in between?  That's a little odd.
It found a clean log this time:

> XFS mounting filesystem dm-1
> Ending clean XFS mount for filesystem: dm-1

which is unexpected.

So the memory consumption might be a bug but there's not enough info to go on here.

> PS. Let me know if you wish reports like this one on list.

worth reporting, but I'm not sure what we can do with it.
Your storage is in pretty bad shape, and xfs_repair can't make something out
of nothing.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
