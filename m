Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7R6kfJX008168 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 01:46:41 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	YANfdUOLF9A5Kg9A (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Aug 2012 23:47:30 -0700 (PDT)
Received: by obbwd18 with SMTP id wd18so5044182obb.26
	for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 23:47:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1104CDC2-47D2-40CF-8294-A17E33125D54@sandeen.net>
References: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
	<1104CDC2-47D2-40CF-8294-A17E33125D54@sandeen.net>
Date: Mon, 27 Aug 2012 08:47:29 +0200
Message-ID: <CAAxjCExx8LB3PyMUR8T215hMYps17D+Lvg4C0aOwLwD=d-NOMQ@mail.gmail.com>
Subject: Re: umount doesn't seem to really unmount
From: Stefan Ring <stefanrin@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

> Do you have barriers on and does iscsi pass them through to the target, and does the target propagate them to the disk itself?

Regardless of the barriers, it doesn't explain this:

$ sudo mount -o barrier=1,inode64 /dev/mapper/vg_xfs2-lvxfs1 /xfs1
$ sudo umount /xfs1
$ sudo xfs_logprint /dev/mapper/vg_xfs2-lvxfs1
xfs_logprint:
xfs_logprint: /dev/mapper/vg_xfs2-lvxfs1 contains a mounted and
writable filesystem
    data device: 0xfd01
    log device: 0xfd01 daddr: 83882016 length: 81912

It also happens in kernel 3.4.3-1.fc17. There are no other machines
which access the iSCSI target.

Right after boot, I can mount and umount it all that I want, and it
will work normally, i.e., say "Mounting Filesystem / Ending clean
mount" in dmesg, xfs_logprint NOT saying "... contains a mounted and
writable filesystem".

As crazy as that sounds, I've just found out what triggers the
situation. The weird behavior only manifests itself after this:

$ sudo service mysqld start

>From then on, it behaves as described earlier. Not that mysqld has
anything to do with XFS. It's just the plain package from Fedora, with
everything in the default place on the root filesystem, which is ext4.
As I've just found out, the behavior even returns to normal when I
shut down mysqld. So for now, my workaround is shutting down mysqld
myself before rebooting.

I'll try and see if this is easily reproducible inside a clean F17
install inside a KVM guest.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
