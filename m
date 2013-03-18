Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57A897F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 15:39:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34BB1304048
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:39:35 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id Ko5DM13U0WPXzKkj for
	<xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:39:34 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Xfs_repair and journalling
Date: Mon, 18 Mar 2013 21:37:40 +0100
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<51455408.4070801@hardwarefreak.com>
	(sfid-20130317_104906_951045_BA368DB9)
In-Reply-To: <51455408.4070801@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201303182137.41344.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, stan@hardwarefreak.com
Cc: Subranshu Patel <spatel.ml@gmail.com>

Am Sonntag, 17. M=E4rz 2013 schrieb Stan Hoeppner:
> On 3/16/2013 10:56 AM, Subranshu Patel wrote:
> > This is not observed in EXT4, fsck successfully recovers without
> > mounting the filesystem.
> =

> And this is the real problem.  You're *assuming* XFS should behave in
> the same manner as EXT4.  Why would you assume a Ferrari should behave
> like a Tata Nano?
> =

> XFS is far more sophisticated than EXT4 in many, many ways, including
> recovery after unclean shutdown.  XFS kernel code performs journal
> playback/recovery automatically when the filesystem is mounted.
> xfs_repair is a tool for fixing filesystems that are broken, not simply
> in need of journal playback.  Thus xfs_repair has no code to perform
> journal recovery.
> =

> EXT4 (and EXT3) lacks this sophistication and must call a user space
> tool, e2fsck, to perform journal playback/recovery.

Stan, to all what I know this is just not true.

Ext4 and Ext3 are perfectly capable to replay their journals as well. I =

would have notices with various Ext4 installations on laptops and =

workstations that had a unclean shutdown way more often than the two unclea=
n =

shutdowns you mentioned. My previous main laptop a ThinkPad T42 would have =

been broken by every month or so, considering me playing around and managin=
g =

to crash it every once in a while.

Thats the whole point of being a journaling filesystem.

> XFS is the Ferrari of Linux filesystems and EXT is the Tata.  Keep that
> in mind as you discover many of the other differences in the future.

XFS may be more advanced in many areas - for example the capacity it can =

hold and the scalability to really huge setups -, but the basic ability to =

replay a journal is not one of this areas.

Maybe both filesystem differ under what circumstances they are still able t=
o =

replay their journal, but from what I gathered the fully block based journa=
l =

of Ext filesystem is quite robust.

Additionally also BTRFS meanwhile recovers just fine from an unclean =

shutdown. At least it did on the last dozen hard crashes due to BTRFS not =

being able to deal nicely with out of memory situations in combination with =

some form of a memleak with Planeshift and/or Intel gfx driver unless I =

tweak the VM subsystem settings a bit.

Also ReiserFS 3 is able to replay a journal. It was the first Linux =

filesystem that had journaling. Not that I would use it but thats for other =

reasons. (Yes, I did not look it up, but I think XFS did journaling by that =

time or even earlier on IRIX already.)

And with all the mentioned filesystem, I would always first mount after a =

unclean shutdown and expect that all is fine. Just if it isn=B4t I would =

consider other options like repair tools. The XFS tools may the tools suite =

that guides to this behaviour more than tools for other filesystems however.

Thanks,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
