Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A1B117F76
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 16:37:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 732EC8F804B
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 14:37:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0PobWR535NUBStOF for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 14:37:28 -0800 (PST)
Message-ID: <5106FDA5.80409@sandeen.net>
Date: Mon, 28 Jan 2013 16:37:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Volume fine on x86_64, corruption on ARM
References: <20130127225258.GA2287@vicerveza.homeunix.net>
In-Reply-To: <20130127225258.GA2287@vicerveza.homeunix.net>
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
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
Cc: xfs@oss.sgi.com

On 1/27/13 4:52 PM, Llu=EDs Batlle i Rossell wrote:
> Hello,
> =

> I'm using linux 3.7.3 in both machines (x86_64 and armv5tel), and I creat=
ed
> a volume in x86_64 to be the rootfs for the ARM. All fine, until I plugge=
d it
> into the ARM (Log below).
> =

> Given the corruption, I used xfs_repair in the x86_64, moved a lot of fil=
es into lost+found, plugged it back to the ARM, booted, and corruption agai=
n.
> =

> In the same USB HD, in the same ARM, and this same way, I've used succesf=
ully
> ext4 and btrfs for a long time. Is there any known issue with ARM?
> =

> Thank you,
> Llu=EDs.
> =

> ----------------------
> starting systemd...
> systemd 197 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX +IMA +=
SYSVINIT -LIBCRYPTSETUP +GCRYPT +ACL +XZ)
> =

> Welcome to NixOS 0.2pre-4eb2b09-af495e0!
> =

> Failed to insert module 'autofs4'
> dea96000: 58 46 53 42 00 00 10 00 00 00 00 00 01 bd 26 f0  XFSB..........=
&.
> XFS (sda1): Internal error xfs_da_do_buf(2) at line 2192 of file fs/xfs/x=
fs_da_btree.c.  Caller 0xbf057e68

So this was trying to read a dir2 directory metadata leaf block, and it did=
n't find the right magic.
XFSB is superblock magic . . . =


I tested an image which (I think) contains every dir2 format, created on x8=
6_64
(under a RHEL6 3.2 kernel) and checked it on ARM (a raspberry pi 3.2.24 ker=
nel)
so it's not really quite an apples to apples test.

Does the filesystem check clean on x86_64 right after you create it?  How d=
id you
create it?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
