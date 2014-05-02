Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F9FD7F6F
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 14:07:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A0AC304059
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 12:07:27 -0700 (PDT)
Received: from mail-ee0-f44.google.com (mail-ee0-f44.google.com
	[74.125.83.44]) by cuda.sgi.com with ESMTP id tFaREAsBiIq19kVE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 12:07:20 -0700 (PDT)
Received: by mail-ee0-f44.google.com with SMTP id c41so3371622eek.31
	for <xfs@oss.sgi.com>; Fri, 02 May 2014 12:07:19 -0700 (PDT)
Message-ID: <5363ECE8.6030706@gmail.com>
Date: Fri, 02 May 2014 22:07:20 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363A1D8.2020402@gmail.com>
	<5363B4C9.4000900@sandeen.net>	<5363CB5E.3090008@gmail.com>
	<5363CD70.3000006@sandeen.net> <5363DBD7.4060002@gmail.com>
	<5363E65C.6010006@sandeen.net>
In-Reply-To: <5363E65C.6010006@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

> to be honest, I'm not certain; if it came back under the same
> device name, things may have continued.  I'm not sure.

Personally, I haven't seen it reconnect even once. I've seen disks
fail to appear until the old references are removed, or even
partitions not detecting until all is clean. Reconnecting, only on SW
raid, and only when everything was just right.

> In general, filesystems are not very happy with storage being
> yanked out from under them.

Yup, I know that, except when there's raid 1, 5 or 6, some yanking is
possible. But I wish it were possible, even if manually at my own risk.

> Well, I did say that it was the simplest thing.  Not the best or 
> most informative thing.  :)

I know, I'm just philosophically opposed to rebooting, every time I'm
forced to reboot a system I have a nagging feeling I don't really know
what the problem is and how to fix it. So, having to reboot makes me
think I'm stupid. So I prefer fixing things.

> Somewhere in the vfs, the filesystem was still present in a way
> that the ustat syscall reported that it was mounted. xfs_repair
> uses this syscall to determine mounted state.  It called sys_ustat,
> got an answer of "it's mounted" and refused to continue.
> 
> It refused to continue because running xfs_repair on a mounted
> filesystem would lead to severe damage.

I understand that, and I'm okay with whatever I need to do in order to
restore the FS after the failure, but it would be good to have xfs
report the status correctly, i.e. show up in /proc/mounts UNTIL all
resources are released. What do you think?

> If xfs encounters an insurmountable error, it will shut down, and
> all operations will return EIO or EUCLEAN.  You are right that
> there is no errors=* mount option; the behavior is not configurable
> on xfs.

IMHO it should be, but since the last email I've glanced at some
mailing lists and understand that there's some reluctance, in the name
of not polluting the FS after an error. But at least a R/O remount
should be possible, to prevent yanking libraries from under
applications (root FS).

> You're right that this doesn't seem to be well described in
> documentation, that's probably something we should address.

Yup, any idea when? .... Also, I think it would be good to have a
section on what to do when things go south and what to expect. E.g. I
found out the hard way that xfs_check on a 2TB disk allocates 16G of
memory, so now I'm running it with cgroup based limitations, otherwise
I couldn't even open my emails now. I'm still not sure when to run
xfs_check and when xfs_repair, etc. At least I haven't seen such docs.
Maybe I missed them.

Martin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTY+zaAAoJELsEaSRwbVYr5+MP/AnX6a3aKjwgCI9NzV7/0FG2
Whm/9JR+wg3r0DQ1jc+RUn2NfFIFjkABmxid+icZeZy3o3P0fAcS8yFlKIdzvZaA
k7KWgITDbpd/IxVJA1kplxS+MJW/1ACUxGEfsEfDR9YwtkPR3hiFP0vNCp+Y8RTi
EDawgNYhJrmLFN/8cMkryPAWiowEBebUZAvDClwMkt9wJW0RzAeccc07IRHAMEuN
fBeu+iJJwMdGn/NQfJrOZBXdwU9C/M7v43L269g4H8mCSOFiHCe4prtKWK7LHb0q
JvAddCESBEYgAoO7LpZumAmpoGZDR69d80aLvWEayBm+FVi84Wbwl5gde+QH7UKx
lH2rWEngSv61OmW0CRfZ2MthYsjGGJF/+4JrVepSiCpu2Vra9X9yOZKV+aJzt+fX
lSgaoXsYNIkimJ1fDJHFMeHlZzU4ju4avD6YBNdZP/WPc20awxhv1jJys3ZZCwUc
ynAx44AFUS6PXqf6rGJngc/wcfvWDBYio7umbfx/WeLt2cn5CcNhqOWCvu4TNuAt
mn4vG1ULIP8v5YaTfDuZQ7vfP4DVDGWqyd4ZTdLkix0wXAAnwZrbpAVST8sgcKY9
17N5dXUT2JyoUZVydRwBzZPORNj6iWO3aKnXykAk/rW+yTGRJuamluS4GYmZQtaK
EqJhKeQD81CDtWPlnSr8
=+dT5
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
