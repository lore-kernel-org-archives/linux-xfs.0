Received: from mxchg03.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101C0343887
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2026 21:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.100.38.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781816755; cv=none; b=gT6MD5V9gcIpoLoaB6Q30Z7maCKVkJsEcwGZ8oi/Pi5km2IF74974r2Fdwonq8ArnZjxovS2PNqC1IkS+ntloPWN89OCw7kl4Y+32bAfU5Jvxmq3rBqQXHp/tY/pXxmMg78HGdVxRFR9GN1yNzaXAoF3FG7EH5kabpV+fIAdbYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781816755; c=relaxed/simple;
	bh=qXQGM6WjiN3nEr37wWIbCPHnoyQ5iJ7Yw8y7nM9VQto=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cOvbHKdmM1nKRSu16ML+PsaL1dEML+N5aj8/DrEcy6ZHAbnzBkXYSLLfH8wHa2rMC/2VoKeW3Qz1GprkQoX6MMHN91fR343jTsBp7s1bstYiYDU/dj2q1Tnopw2PmP1vFaLDPkY+u1/f0wx58EcFHjR5hDii4sRLpPYAOyorXR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de; spf=pass smtp.mailfrom=uni-hamburg.de; dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b=FSk88L9g; arc=none smtp.client-ip=134.100.38.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b="FSk88L9g"
Received: from mxchg03.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4ghCtZ1lHxz2xDG
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2026 23:05:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-hamburg.de;
	s=rrzs003; t=1781816742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b2gPJSXSZ3PAZmyI239iMr1HG4++JQnXd2pdipG9vWk=;
	b=FSk88L9gN+elzDILpHkJvot/ISgGgpNdBMf9NaqZY3RpAT5hc6W2NTxzQ3YArBGyWE94i/
	a1PcnTIFYer44CKCF9vg+N//sMvmv1v2vpXkzPKK9812MNhHgQy0AnR1aqXPH+BvWUldTR
	XlgHFszDH1eeBkpWRqxhNo/LGkK5fBwqswQpR43RGetrChaMC5gzG/UBXMVPQvdZSaOxyV
	RzmTU1AmVu4KB2bEzofv6/JOHjlfUtLMAsK2OAjM9Y+VXi+jsWGtjcBDwnDdaZaR3ghHOJ
	jFdGsp0UV3p5JLLOD5IkLbxbp5nYC6JATtfqU1PS/Vk2aDHjcmxwWP+x8tkMRg==
Received: from exchange.uni-hamburg.de (EX-S-MR06.uni-hamburg.de [134.100.84.89])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4ghCtZ0qyhz2xCx
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2026 23:05:42 +0200 (CEST)
Received: from plasteblaster (134.100.32.91) by EX-S-MR06.uni-hamburg.de
 (134.100.84.89) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 18 Jun
 2026 23:05:41 +0200
Date: Thu, 18 Jun 2026 23:05:40 +0200
From: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
To: <linux-xfs@vger.kernel.org>
Subject: Re: XFS group quota circumvention via NFS and chgrp
Message-ID: <20260618230540.424cceee@plasteblaster>
In-Reply-To: <20260616110804.5d26ff85@plasteblaster>
References: <20260616110804.5d26ff85@plasteblaster>
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
X-ClientProxiedBy: EX-S-MR08.uni-hamburg.de (134.100.84.91) To
 EX-S-MR06.uni-hamburg.de (134.100.84.89)
X-Rspamd-UID: 55e48e
X-Rspamd-UID: 4cfdcb

Am Tue, 16 Jun 2026 11:08:04 +0200
schrieb "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>:

> Dear Linux XFS folks,
>=20
> I noticed that xfs group quotas can be circumvented via NFS* on vanilla
> Kernel 6.6.x (slightly differing versions on client and server) as
> follows:

I was asked off-list to provide an easier reproducer. Let's try this:

1. Prepare/start a VM in the terminal.

dd if=3D/dev/zero of=3Dxfs.img bs=3D1M count=3D500
wget -O debian-live.iso https://gitlab.com/api/v4/projects/74667529/package=
s/generic/debian-libre-live/13.3.0/debian-live-13.3.0-amd64-libre-standard.=
iso
isoinfo -R -i debian-live.iso -x /live/vmlinuz > vmlinuz
isoinfo -R -i debian-live.iso -x /live/initrd.img > initrd.img
qemu-system-x86_64 -nographic -enable-kvm -smp 2 -m 4G \
  -cdrom debian-live.iso -drive index=3D0,driver=3Draw,file=3Dxfs.img \
  -kernel vmlinuz -initrd initrd.img -append "boot=3Dlive components consol=
e=3DttyS0 ro"

Login as user/live, and sudo su, or prepend sudo all the time below, if
you prefer.

2. In the VM, as root:

apt install -y nfs-kernel-server
mkfs.xfs -f /dev/sda
mount -o usrquota,grpquota /dev/sda /srv
xfs_quota -x -c 'limit -g bsoft=3D1m bhard=3D2m -d' /srv
echo "auxgrp:x:1001:user" >> /etc/group
mkdir -p /srv/share/user
chown user:user /srv/share/user
echo "/srv localhost(fsid=3D0,rw)" >> /etc/exports
echo "/srv/share localhost(fsid=3D1,rw)" >> /etc/exports
systemctl restart nfs-kernel-server
mount localhost:/share /mnt/

# First blob. Works.
su user -c 'dd if=3D/dev/zero of=3D/mnt/user/blob1 bs=3D2M count=3D1'
# Second blob. Fails:
su user -c 'dd if=3D/dev/zero of=3D/mnt/user/blob2 bs=3D2M count=3D1'
# Show the limited state.
xfs_quota -x -c report /srv
# Move one block to the other group, filling its quota.
su user -c 'chgrp auxgrp /mnt/user/blob1'
# Now write the second blob.
su user -c 'dd if=3D/dev/zero of=3D/mnt/user/blob2 bs=3D2M count=3D1'
# Magic: Move that away, getting out of auxgrp quota.
su user -c 'chgrp auxgrp /mnt/user/blob2'
xfs_quota -x -c report /srv

# For fun: Just fill the disk.
# side fact: I froze qemu with 100% CPU load when having a sync
# command in the loop instead of sleep. It's one of those days where
# I step onto bugs everywhere.
n=3D3
while su user -c "dd if=3D/dev/zero of=3D/mnt/user/blob$n bs=3D2M count=3D1=
" &&
sleep 0.1 &&
su user -c "chgrp auxgrp /mnt/user/blob$n"
do
  n=3D$((n+1))
done
xfs_quota -x -c report /srv

Result after the individual writes:

User quota on /srv (/dev/sda)
                               Blocks                    =20
User ID          Used       Soft       Hard    Warn/Grace    =20
---------- --------------------------------------------------=20
root                0          0          0     00 [--------]
user             4096          0          0     00 [--------]

Group quota on /srv (/dev/sda)
                               Blocks                    =20
Group ID         Used       Soft       Hard    Warn/Grace    =20
---------- --------------------------------------------------=20
root                0       1024       2048     00 [--------]
user                0       1024       2048     00 [--------]
auxgrp           4096       1024       2048     00 [--none--]

This shouldn't be possible. Should it? After the writing loop, I get

2097152 bytes (2.1 MB, 2.0 MiB) copied, 0.0206776 s, 101 MB/s
1+0 records in
1+0 records out
2097152 bytes (2.1 MB, 2.0 MiB) copied, 0.0204505 s, 103 MB/s
dd: closing output file '/mnt/user/blob14': Disk quota exceeded
User quota on /srv (/dev/sda)
                               Blocks                    =20
User ID          Used       Soft       Hard    Warn/Grace    =20
---------- --------------------------------------------------=20
root                0          0          0     00 [--------]
user            28612          0          0     00 [--------]

Group quota on /srv (/dev/sda)
                               Blocks                    =20
Group ID         Used       Soft       Hard    Warn/Grace    =20
---------- --------------------------------------------------=20
root                0       1024       2048     00 [--------]
user             1988       1024       2048     00  [7 days]
auxgrp          26624       1024       2048     00 [--none--]

It quite consistently stops at blob14. I don't quite get why, though.
Inode size does not count into block quota for xfs, right? Why be able
to write 13 blobs, but not 14, when the quota is filled at one already?

Different questions. The main question is: Why I am able to move data
beyond the group quota?


Alrighty then,

Thomas

--=20
Dr. Thomas Orgis
HPC @ Universit=C3=A4t Hamburg
