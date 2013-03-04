Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F6097F4C
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 16:55:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B3C9304032
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 14:55:51 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.10])
	by cuda.sgi.com with ESMTP id q9i6Eil4FAZukOEr (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 14:55:49 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by tyrex.lisa.loc (Postfix) with ESMTP id 20B651B971B00
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 23:55:48 +0100 (CET)
Received: from tyrex.lisa.loc ([127.0.0.1])
	by localhost (tyrex.lisa.loc [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id r1M05fXDHgWk for <xfs@oss.sgi.com>;
	Mon,  4 Mar 2013 23:55:41 +0100 (CET)
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: strange behavior of a larger xfs directory
Date: Mon, 04 Mar 2013 23:55:40 +0100
Message-ID: <5347920.zaxHybjLeK@xrated>
In-Reply-To: <4300208.uZ6HVTycB6@xrated>
References: <4300208.uZ6HVTycB6@xrated>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Am Montag, 4. M=E4rz 2013, 17:40:13 schrieb Hans-Peter Jansen:
> Hi,
> =

> after upgrading the kernel on a server from 2.6.34 to 3.8.1 (x86-32), I =

> suffer from a strange behavior of a larger directory, that a downgrade =

> of the kernel cannot repair.
> =

> The best way to reproduce the problem is cd into that directory and =

> running "vi .". It should display a full directory listing, but it only =

> displays a about dozen entries. Another way is just using bash tab =

> completion (e.g. ls <tab><tab> should display a screenful of items, but =

> only shows the very same dozen of entries. Userspace is quite old =

> (openSUSE 11.1/i586, but I cannot upgrade to a newer userspace for a =

> couple of reasons. OTOH, a simple ls displays the full list again, =


[...]

> > # then it preceeds with getdents64 and fetches already fetched entries
> =

> 27177 getdents64(3, {
>              {d_ino=3D4303329151, d_off=3D78, d_type=3DDT_UNKNOWN, d_recl=
en=3D32, d_name=3D"Black_Swan"} =


Okay, this is the culprit: 0x1007F977F overflows 32 bit, although I =

*never* mounted anything with inode64 option. =


For some reason, the intermediate kernel 3.8.0 has used the inode64 version
by *default*. This breaks bash tab completion and vdr. After forcing the =

inode32 option and copying some offenders away and back in place, the issue
vanishes. =


Unlike stated in the XFS FAQs, openSUSE 11.1 *has* issues with inode64, and
even more so, if enabled by default.

I will hack up a script now, that copes with this mess.

Cheers,
Pete

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
