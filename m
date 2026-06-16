Received: from mxchg03.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CA040E8F4
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 09:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.100.38.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781601312; cv=none; b=aOXf/GTge21e5yvXwlWZoPeCWox7wVYPL92Cc96UeQVeYUcnovMfqMSAt62Y/ifsm3wN40WJCP7U4yI/x97XPzXIjrwaBBNETjN9ilj/XIUf7gybPtw8yp9qQdugiiIXDFa3LJBBLvCLBGThsS91U6qKoBUDJDVo+Y1zOi5T3Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781601312; c=relaxed/simple;
	bh=XJ0MdMqM6NupCQxRxkq18q7NmCmOV+2pR9TGSkK7GqI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=Xy2oAgWn91W3sDdKwzklY5Klr3oMNkV+g7u4c3OYgozg3tZ9R58D4teccB4QaQ+5K/337BxbxRo2+n6rnz2/+Pq7iT/ZCxufsxElgRKuEJG0ZEVjAjDaSWrTzGkKcBNGyIXm7ualFQYed72f89R+2znjBaPyXAJQboO07na1gzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de; spf=pass smtp.mailfrom=uni-hamburg.de; dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b=HtraT35a; arc=none smtp.client-ip=134.100.38.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b="HtraT35a"
Received: from mxchg03.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4gfh3T5VdRz2xGr
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 11:08:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-hamburg.de;
	s=rrzs003; t=1781600885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4su/1e6LIDYgqeDJUYQYcbf7CUX14yu1z5kJWDCufFQ=;
	b=HtraT35akZj0DtpSjzrgxtm8taUvrAnd85sAzfkqwEhNXL1mLCb6OqvdT1pElodKtLAwLO
	TlAOIb8cmwcWwDZlP5wAJ//0thGiQt7Xz0gon4Dbu/A3FGE9GxpnrVomge22vqh8uwqrGE
	uINiTei2h54ywXuRw4BF0DoY4nQFQiDLZK5m8y4N/H0G/JCAjNnvR1Euu83lcu2Dg3esyQ
	BC2WoQfDPW6kq39LkBCp9J0S/IezpIeXrhf3+MMqxtjnDNXjl2Uau7uW+2SAT0Nka9x0pa
	N3JtjEfOSoagvWUIO94aY430262MOOOSfGmCgwI5X+y6aSBO5JLAbo2snl6epQ==
Received: from exchange.uni-hamburg.de (EX-S-MR06.uni-hamburg.de [134.100.84.89])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4gfh3T4ZrFz2xGW
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 11:08:05 +0200 (CEST)
Received: from plasteblaster (134.100.32.91) by EX-S-MR06.uni-hamburg.de
 (134.100.84.89) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 16 Jun
 2026 11:08:05 +0200
Date: Tue, 16 Jun 2026 11:08:04 +0200
From: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
To: <linux-xfs@vger.kernel.org>
Subject: XFS group quota circumvention via NFS and chgrp
Message-ID: <20260616110804.5d26ff85@plasteblaster>
Organization: =?UTF-8?B?VW5pdmVyc2l0w6R0?= Hamburg
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: EX-S-MR03.uni-hamburg.de (134.100.84.82) To
 EX-S-MR06.uni-hamburg.de (134.100.84.89)
X-Rspamd-UID: 41f5fe
X-Rspamd-UID: de9f07

Dear Linux XFS folks,

I noticed that xfs group quotas can be circumvented via NFS* on vanilla
Kernel 6.6.x (slightly differing versions on client and server) as
follows:

1. A user has a primary group and an auxilliary group.
2. There are group quotas for both, possibly very restrictive.
3. User can create files with the primary group (within quota) and then
4. `chgrp $auxgroup file` to get rid of the quota and shift it to the
   other group.

The kicker is: The quota for the auxilliary group is ignored in this
case. So I can store unlimited amounts of data by chgrp'ing it away to
the other group in pieces.

This is not intentional behaviour, or is it?

This is _not_ the case with ext4 being served via NFS. Long form
comparison follows.

A1. ext4 locally

A fresh ext4 fs populated with some test files and quota set:

user@server:/srv/test/userx$ quota -g -f /srv/test/ grep -v :\ none
Disk quotas for group userx (gid 1005):=20
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
/dev/mapper/xyz-quotatest
                 307216*   1024    1024    none       4*      1       1    =
none
Disk quotas for group auxgroupxx (gid 187100007):=20
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
/dev/mapper/xyz-quotatest
                      0       1       1               1*      1       1    =
   =20

user@server:/srv/test/userx$ ls -l
total 307212
-rw-r--r-- 1 userx userx      104857600 Jun 15 14:52 bar
-rw-r--r-- 1 userx userx      209715206 Jun 15 15:01 bla
-rw-r--r-- 1 userx userx              6 Jun 15 14:51 blar
-rw-r--r-- 1 userx auxgroupxx         0 Jun 15 15:38 foo

user@server:/srv/test/userx$ chgrp auxgroupxx bla
chgrp: changing group of 'bla': Disk quota exceeded

Or, in other words:

user@server:/srv/test/userx$ strace chgrp auxgroupxx bla 2>&1 | grep chown
fchownat(AT_FDCWD, "bla", -1, 187100007, 0) =3D -1 EDQUOT (Disk quota excee=
ded)

This is all well as it should be. If I am root locally, though, it does
not matter:

user@server:/srv/test/userx# strace chgrp auxgroupxx bla 2>&1 | grep chown
fchownat(AT_FDCWD, "bla", -1, 187100007, 0) =3D 0

The data is moved to the other group even if the quota does not allow
it.

# repquota -g /srv/test/
*** Report for group quotas on device /dev/mapper/xyz-quotatest
Block grace time: 00:00; Inode grace time: 00:00
                        Block limits                File limits
Group           used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --      20       0       0              2     0     0      =20
userx     ++  102408    1024    1024   none       3     1     1   none
auxgroupxx ++  204808       1       1   none       2     1     1   none

But that is fine, as root is allowed to do anything, I presume.

A2. ext4 via NFS

There is no difference on NFS for non-root. The user is not allowed to
circumvent the group quota of auxgroupxx:

userx@client:/mnt/test/userx$ ls -l
total 307212
-rw-r--r-- 1 userx userx      104857600 2026-06-15 14:52 bar
-rw-r--r-- 1 userx userx      209715210 2026-06-15 21:14 bla
-rw-r--r-- 1 userx userx              6 2026-06-15 14:51 blar
-rw-r--r-- 1 userx auxgroupxx         0 2026-06-15 15:38 foo

userx@client:/mnt/test/userx$ strace chgrp auxgroupxx bla 2>&1 | grep chown
fchownat(AT_FDCWD, "bla", -1, 187100007, 0) =3D -1 EDQUOT (Disk quota excee=
ded)

Since root over NFS, at least with root squashing, is a bit less root,
it is reassuring that for the superuser, it also fails on the NFS client:

userx@client:/mnt/test/userx# strace chgrp auxgroupxx bla 2>&1 | grep chown
fchownat(AT_FDCWD, "bla", -1, 187100007, 0) =3D -1 EPERM (Operation not per=
mitted)

B1. xfs locally

To be fair, I also created a new volume with

	mkfs.xfs /dev/mapper/xyz-quotatest2
	mount -o usrquota,grpquota  /dev/mapper/xyz-quotatest2 /srv/test2/
	xfs_quota -x -c 'timer -g 60 -d' /srv/test2
	xfs_quota -x -c 'limit -g bsoft=3D100m bhard=3D101m userx' /srv/test2
	xfs_quota -x -c 'limit -g bsoft=3D4k bhard=3D4k auxgroupxx' /srv/test2

and confirmed the findings I had with the existing older fs.

root@server# xfs_quota -x -c 'report -g' /srv/test2/
Group quota on /srv/test2 (/dev/mapper/xyz-quotatest2)
                               Blocks
Group ID         Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root                0          0          0     00  [0 days]
userx          103424     102400     103424     00 [00:00:11]
auxgroupxx          0          4          4     00 [--------]

root@server# repquota -g /srv/test2/
*** Report for group quotas on device /dev/mapper/xyz-quotatest2
Block grace time: 00:01; Inode grace time: 00:01
                        Block limits                File limits
Group           used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --       0       0       0              3     0     0
userx     +-  103424  102400  103424   none       3     0     0
auxgroupxx --       0       4       4              1     0     0

userx@server:/srv/test2/userx$ ls -l
total 103424
-rw-r--r-- 1 userx userx      104857600 Jun 16 10:06 testzero
-rw-r--r-- 1 userx userx        1048576 Jun 16 10:25 testzero2
-rw-r--r-- 1 userx auxgroupxx         0 Jun 16 10:25 wedge

The userx should not be able to create files in auxgroupxx, as its
quota of 4K is already exhausted. And indeed, it works that way locally.

userx@server:/srv/test2/userx$ strace chgrp auxgroupxx testzero 2>&1 | grep=
 chown
fchownat(AT_FDCWD, "testzero", -1, 187100007, 0) =3D -1 EDQUOT (Disk quota =
exceeded)

Root can do it, as expected from the experience with ext4:

root@server:/srv/test2/userx/t# strace chgrp auxgroupxx testzero 2>&1 | gre=
p chown
fchownat(AT_FDCWD, "testzero", -1, 187100007, 0) =3D 0

root@server# repquota -g /srv/test2/
*** Report for group quotas on device /dev/mapper/xyz-quotatest2
Block grace time: 00:01; Inode grace time: 00:01
                        Block limits                File limits
Group           used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --       0       0       0              3     0     0
userx     --    1024  102400  103424              2     0     0
auxgroupxx +-  102400       4       4   none       2     0     0


Though, the block quota is actually also enforced for root here:

root@server# dd if=3D/dev/zero of=3Dwedge bs=3D1 count=3D4096
dd: error writing 'wedge': Disk quota exceeded
1+0 records in
0+0 records out
0 bytes copied, 9.6329e-05 s, 0.0 kB/s

Is that really intentional, btw.? Enforcing quota for root this way,
but not for chgrp/chown?


B2. xfs via NFS

Switching to a client node that has test2 mounted via NFS, after moving
testzero back to the userx group.

userx@client:/mnt/test2/userx$ quota -g -f /mnt/test2 | grep -v ': no'
Disk quotas for group userx (gid 1005):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
  server:/test2  103424* 102400  103424    none       3       0       0
Disk quotas for group auxgroupxx (gid 187100007):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
  server:/test2       0       4       4               1       0       0

userx@client:/mnt/test2/userx$s trace chgrp auxgroupxx testzero 2>&1 | grep=
 chown
fchownat(AT_FDCWD, "testzero", -1, 187100007, 0) =3D 0

userx@client:/mnt/test2/userx$ quota -g -f /mnt/test2 | grep -v ': no'
Disk quotas for group userx (gid 1005):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
  server:/test2    1024  102400  103424               2       0       0
Disk quotas for group auxgroupxx (gid 187100007):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
  server:/test2  102400*      4       4   00:01       2       0       0

The user happily moved 100M of data over to auxgroupxx and has quota
freed to start to comsume more data. The grace period should not
matter, as the soft limit is clearly hit, right? And it's only a minute
=E2=80=A6 so waiting a bit and preparing the next chunk:

userx@client:/mnt/test2/userx$ dd if=3D/dev/zero of=3Dtestzero3 bs=3D1M cou=
nt=3D100
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.128547 s, 816 MB/s

userx@client:/mnt/test2/userx$ quota -g -f /mnt/test2 | grep -v ': no'
Disk quotas for group userx (gid 1005):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
  server:/test2  103424* 102400  103424    none       3       0       0
Disk quotas for group auxgroupxx (gid 187100007):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
  server:/test2  102400*      4       4    none       2       0       0

Quota filled again, any grace period passed. Let's give us some space!

userx@client:/mnt/test2/userx$s trace chgrp auxgroupxx testzero3 2>&1 | gre=
p chown
fchownat(AT_FDCWD, "testzero3", -1, 187100007, 0) =3D 0

userx@client:/mnt/test2/userx$ quota -g -f /mnt/test2 | grep -v ': no'
Disk quotas for group userx (gid 1005):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
  server:/test2    1024  102400  103424               2       0       0
Disk quotas for group auxgroupxx (gid 187100007):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
  server:/test2  204800*      4       4    none       3       0       0

The added data is now in auxgroupxx's overdrawn quota, too. Repeat. The
user has no effective quota.

For completeness:

root@client# strace chgrp auxgroupxx testzero2  2>&1 | grep chown
fchownat(AT_FDCWD, "testzero2", -1, 187100007, 0) =3D -1 EPERM (Operation n=
ot permitted)

Root is squashed and not able to directly modify the ownership, as expected.

Now, is this non-enforcement for the group quota is a bug in XFS, or
rather in the translation to the quota data as NFS sees it? A bug in
NFS in enforcement? But only when serving XFS? I did not check ZFS over
NFS yet, but with ext4, there is at least one example where it works as
expected. I also checked with BeeGFS (on top of ZFS) that it enforces
group quotas as I expect. I noted some confusion with grace periods =E2=80=
=A6
and face more confusion myself on reading the xfs_quota(8) section on
the timer command.** Anyway, I waited until after any grace period in
the last example to avoid that complication.

Or is this possibly something fixed in a very recent kernel, by any
chance? Or a regression in 6.6? I am observing this in a production
setup where I cannot just freely swap out things.


Alrighty then,

Thomas


* Kernel NFSv4 over RDMA with sec=3Dsys, if that matters.

** =E2=80=9EAllows  the  quota  enforcement  timeout  (i.e. the amount of t=
ime
allowed to pass before the soft limits are enforced as the hard
limits)=E2=80=9D vs. =E2=80=9EWhen  setting  any other individual timer by =
id or name,
the value is the number of seconds from now, at which time the hard
limits will be enforced.  This allows extending the grace time of an
individual user who has exceeded soft limits.=E2=80=9D =E2=80=94 The hard l=
imits being
enforced after grace does mean the soft limits becoming hard, right?
The hard limits are always enforced, without grace, are they not?

PS: We use group quotas also for individual quotas precisely to be able
to mix personal quotas and working group quotas in a meaningful manner.

PPS: I learned before that project quotas are also no solution if you
value enforcement, as people can move data into unrestricted project
IDs at will. I hoped that plain user/group quotas are enforced, also
over NFS.

--=20
Dr. Thomas Orgis
HPC @ Universit=C3=A4t Hamburg
