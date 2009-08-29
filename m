Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7TE7nkx224193 for <xfs@OSS.SGI.com>; Sat, 29 Aug 2009 09:08:10 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E58BA40C88C
	for <xfs@OSS.SGI.com>; Sat, 29 Aug 2009 07:08:41 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id FSFs0qTHDnG6BWLe
	for <xfs@OSS.SGI.com>; Sat, 29 Aug 2009 07:08:41 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1MhOba-0003TV-87
	for <xfs@OSS.SGI.com>; Sat, 29 Aug 2009 14:08:34 +0000
MIME-Version: 1.0
Message-ID: <19097.13921.614380.753501@tree.ty.sabi.co.uk>
Date: Sat, 29 Aug 2009 14:08:33 +0000
Subject: Re: xfs data loss
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

> Dear xfs developers We have a SUN X4500 with 48 500 GB drives,
> that we configured under SUSE SLES 10.

> Among others, we have 3 RAID5 xfs filesystems, /dev/md4 with
> 20 units (9.27 TB) /dev/md5 with 20 units (9.27 TB) and
> /dev/md6 with 5 units (1.95 TB)

AAAAA-Amazing! 19+1 RAID5s. With all identical drives in the same
box. What a wondersome, challenging configuration!

> These units are not backed up.

Many would say that RAID means that backup is not necessary.

> Due to a power shock, suddenly and without log messages about
> one half (5 TB) of the user directories on /dev/md4 have
> disappeared. [ ... ]

That was unreally unforeseeable! Power problems never happen to
computers, especially those that fry electronics or cause write
errors on multiple drives, so why worry? 

> Upon reboot, /dev/md6 showed only 3 units, and after a
> xfs_repair it was again ok.

Uh, that was the "/dev/md6 with 5 units", so I guess Elvis
personally came to deliver an exact copy of drive #4, or else
someone has invented a new algorithm to ensure that a RAID5 can
lose 2 drives and still be fine. In the latter case rush to the
patent office -- you shall become billionaires.

> /dev/md4 mounted immediately, but always with one half of the
> directories. 1) xfs_check gives no problem on /dev/md4 but 2)
> xfs_logprint [ ... ]

> 3) xfs_ncheck eats a lot of memory and freezes after 6-7 hours
> without giving output

I wonder whether the further advanced technique of creating a
multi-TB filesystem on a 32-bit kernel was used for higher
sophistication.

> WHat can I do? [ ... ]

Well, I am not at the level of those who can develop such an
advanced understanding of storage systems that includes 19+1
arrays and RAID5s that can lose 2 drives and be "again OK".

But I'd look at how many controllers and drives are actually
still working by doing a read test of all the drives. Once that
is known perhaps some recovery strategy can be discerned. If
several drives have failed it might take several weeks or months
or even years to do a partial recovery. If things are really
very lucky only some of the 6 host adapters have failed, or only
one drive per array, and replacing the host adapters will get
things working again, except that running 'xfs_repair' on an
incomplete array will have made things even better, more
challenging and advanced.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
