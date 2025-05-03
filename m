Received: from mail.karlsbakk.net (mail.karlsbakk.net [46.30.189.78])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C6E44C77
	for <linux-xfs@vger.kernel.org>; Sat,  3 May 2025 02:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.189.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746238060; cv=none; b=m1WVI8UrrC1151AdA7L8YvPkpH/uPVsl+3iv7MW6xCAxgx6d/PLAEjKWPhJ3YGtWgt9QAqLeRYkpcssTFmv8AR7ooklJVGjJVgThTt2AL5uY8atLs+BDMosuHZX7e3WSsF/ZrtBVRFcqzdyAsThgwpitMi0owtpil4KIGoXNtoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746238060; c=relaxed/simple;
	bh=oib7NO0Fszk7LLF+T8WGvHNOESLrVmW+9irhnfMCf9M=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=tIp47qKzmzSqxtOgP2VrfSms7xa8w2dbQDY7rJAVB/jHMT6O0uuViYzoPxucXcS5tPwWhiUDNwfmiL5klpjA9qHH5mL+bX3JzN4BRzeU41s4vcxXsxhtQPNxF9qZYcm5WwE+JAV3jrs4f7SVlkj5KepZtKqf+H4D3Pjn4z461RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=karlsbakk.net; spf=pass smtp.mailfrom=karlsbakk.net; arc=none smtp.client-ip=46.30.189.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=karlsbakk.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=karlsbakk.net
Received: from mail.karlsbakk.net (localhost [IPv6:::1])
	by mail.karlsbakk.net (Postfix) with ESMTP id 42C8E1A4
	for <linux-xfs@vger.kernel.org>; Sat,  3 May 2025 04:01:59 +0200 (CEST)
Received: from smtpclient.apple ([2001:4643:1e5c:0:5835:a27f:2652:872b])
	by mail.karlsbakk.net with ESMTPSA
	id iRx9DRd5FWiD5isAVNCnFw
	(envelope-from <roy@karlsbakk.net>)
	for <linux-xfs@vger.kernel.org>; Sat, 03 May 2025 04:01:59 +0200
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: XFS complains about data corruption after xfs_repair
Message-Id: <9EA56046-FECD-42C5-AEF6-721A8699A45B@karlsbakk.net>
Date: Sat, 3 May 2025 04:01:48 +0200
To: linux-xfs@vger.kernel.org
X-Mailer: Apple Mail (2.3826.500.181.1.5)

Hi all

I have an XFS filesystem on an LVM LV which resides on a RAID-10 (md) =
with four Seagate Exos 16TB drives. This has worked well for a long =
time, but just now, it started complaining. The initial logs were =
showing a lot of errors and I couldn't access the filesystem, so I gave =
it a reboot, tha tis, I had to force one. Anyway - it booted up again =
and looked normal, but still complained. I rebooted to single and found =
the (non-root) filesystem already mounted and unable to unmount it, I =
commented it out from fstab and rebooted once more to single. This =
allowed me to run xfs_repair, although I had to use -L. Regardless, it =
finished and I re-enabled the filesystem in fstab and rebooted once =
more. Starting up now, it seems to work, somehow, but ext4 still throws =
some errors as shown below, that is, "XFS (dm-0): corrupt dinode =
43609984, (btree extents)." It seems to be the same dinode each time.

Isn't an xfs_repair supposed to fix this?

I'm running Debian Bookworm 12.10, kernel 6.1.0-34-amd64 and xfsprogs =
6.1.0 - everything just clean debian.

Best regards

roy
--

Output from dmesg -T

[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): corrupt dinode 43609984, =
(btree extents).
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): Metadata corruption detected =
at xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 =
xfs_iread_bmbt_block
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): Unmount and run xfs_repair
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): First 72 bytes of corrupted =
metadata buffer:
[l=C3=B8. mai 3 03:28:14 2025] 00000000: 42 4d 41 33 00 00 00 f8 00 00 =
00 01 10 26 57 2a BMA3.........&W*
[l=C3=B8. mai 3 03:28:14 2025] 00000010: ff ff ff ff ff ff ff ff 00 00 =
00 06 61 32 b9 58 ............a2.X
[l=C3=B8. mai 3 03:28:14 2025] 00000020: 00 00 01 27 00 13 83 80 a4 0c =
52 99 b8 45 4b 5b ...'......R..EK[
[l=C3=B8. mai 3 03:28:14 2025] 00000030: b6 3e 63 d8 b0 5e 20 5f 00 00 =
00 00 02 99 6f 80 .>c..^ _......o.
[l=C3=B8. mai 3 03:28:14 2025] 00000040: 7f fb a7 f6 00 00 00 00 =
........
[l=C3=B8. mai 3 03:28:14 2025] kauditd_printk_skb: 1 callbacks =
suppressed
[l=C3=B8. mai 3 03:28:14 2025] audit: type=3D1400 =
audit(1746235694.948:72): apparmor=3D"STATUS" operation=3D"profile_load" =
profile=3D"unconfined" =
name=3D"libvirt-cd31a98d-8534-4b9a-97ef-41bd469d231c" pid=3D3544 =
comm=3D"apparmor_parser"
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): corrupt dinode 43609984, =
(btree extents).
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): Metadata corruption detected =
at xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 =
xfs_iread_bmbt_block
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): Unmount and run xfs_repair
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): First 72 bytes of corrupted =
metadata buffer:
[l=C3=B8. mai 3 03:28:14 2025] 00000000: 42 4d 41 33 00 00 00 f8 00 00 =
00 01 10 26 57 2a BMA3.........&W*
[l=C3=B8. mai 3 03:28:14 2025] 00000010: ff ff ff ff ff ff ff ff 00 00 =
00 06 61 32 b9 58 ............a2.X
[l=C3=B8. mai 3 03:28:14 2025] 00000020: 00 00 01 27 00 13 83 80 a4 0c =
52 99 b8 45 4b 5b ...'......R..EK[
[l=C3=B8. mai 3 03:28:14 2025] 00000030: b6 3e 63 d8 b0 5e 20 5f 00 00 =
00 00 02 99 6f 80 .>c..^ _......o.
[l=C3=B8. mai 3 03:28:14 2025] 00000040: 7f fb a7 f6 00 00 00 00 =
........
[l=C3=B8. mai 3 03:28:14 2025] audit: type=3D1400 =
audit(1746235695.192:73): apparmor=3D"STATUS" =
operation=3D"profile_replace" profile=3D"unconfined" =
name=3D"libvirt-cd31a98d-8534-4b9a-97ef-41bd469d231c" pid=3D3547 =
comm=3D"apparmor_parser"
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): corrupt dinode 43609984, =
(btree extents).
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): Metadata corruption detected =
at xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 =
xfs_iread_bmbt_block
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): Unmount and run xfs_repair
[l=C3=B8. mai 3 03:28:14 2025] XFS (dm-0): First 72 bytes of corrupted =
metadata buffer:
[l=C3=B8. mai 3 03:28:14 2025] 00000000: 42 4d 41 33 00 00 00 f8 00 00 =
00 01 10 26 57 2a BMA3.........&W*
[l=C3=B8. mai 3 03:28:14 2025] 00000010: ff ff ff ff ff ff ff ff 00 00 =
00 06 61 32 b9 58 ............a2.X
[l=C3=B8. mai 3 03:28:14 2025] 00000020: 00 00 01 27 00 13 83 80 a4 0c =
52 99 b8 45 4b 5b ...'......R..EK[
[l=C3=B8. mai 3 03:28:14 2025] 00000030: b6 3e 63 d8 b0 5e 20 5f 00 00 =
00 00 02 99 6f 80 .>c..^ _......o.
[l=C3=B8. mai 3 03:28:14 2025] 00000040: 7f fb a7 f6 00 00 00 00 =
........
[l=C3=B8. mai 3 03:28:15 2025] audit: type=3D1400 =
audit(1746235695.464:74): apparmor=3D"STATUS" =
operation=3D"profile_replace" profile=3D"unconfined" =
name=3D"libvirt-cd31a98d-8534-4b9a-97ef-41bd469d231c" pid=3D3558 =
comm=3D"apparmor_parser"
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): corrupt dinode 43609984, =
(btree extents).
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): Metadata corruption detected =
at xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 =
xfs_iread_bmbt_block
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): Unmount and run xfs_repair
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): First 72 bytes of corrupted =
metadata buffer:
[l=C3=B8. mai 3 03:28:15 2025] 00000000: 42 4d 41 33 00 00 00 f8 00 00 =
00 01 10 26 57 2a BMA3.........&W*
[l=C3=B8. mai 3 03:28:15 2025] 00000010: ff ff ff ff ff ff ff ff 00 00 =
00 06 61 32 b9 58 ............a2.X
[l=C3=B8. mai 3 03:28:15 2025] 00000020: 00 00 01 27 00 13 83 80 a4 0c =
52 99 b8 45 4b 5b ...'......R..EK[
[l=C3=B8. mai 3 03:28:15 2025] 00000030: b6 3e 63 d8 b0 5e 20 5f 00 00 =
00 00 02 99 6f 80 .>c..^ _......o.
[l=C3=B8. mai 3 03:28:15 2025] 00000040: 7f fb a7 f6 00 00 00 00 =
........
[l=C3=B8. mai 3 03:28:15 2025] audit: type=3D1400 =
audit(1746235695.760:75): apparmor=3D"STATUS" =
operation=3D"profile_replace" profile=3D"unconfined" =
name=3D"libvirt-cd31a98d-8534-4b9a-97ef-41bd469d231c" pid=3D3566 =
comm=3D"apparmor_parser"
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): corrupt dinode 43609984, =
(btree extents).
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): Metadata corruption detected =
at xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 =
xfs_iread_bmbt_block
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): Unmount and run xfs_repair
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): First 72 bytes of corrupted =
metadata buffer:
[l=C3=B8. mai 3 03:28:15 2025] 00000000: 42 4d 41 33 00 00 00 f8 00 00 =
00 01 10 26 57 2a BMA3.........&W*
[l=C3=B8. mai 3 03:28:15 2025] 00000010: ff ff ff ff ff ff ff ff 00 00 =
00 06 61 32 b9 58 ............a2.X
[l=C3=B8. mai 3 03:28:15 2025] 00000020: 00 00 01 27 00 13 83 80 a4 0c =
52 99 b8 45 4b 5b ...'......R..EK[
[l=C3=B8. mai 3 03:28:15 2025] 00000030: b6 3e 63 d8 b0 5e 20 5f 00 00 =
00 00 02 99 6f 80 .>c..^ _......o.
[l=C3=B8. mai 3 03:28:15 2025] 00000040: 7f fb a7 f6 00 00 00 00 =
........
[l=C3=B8. mai 3 03:28:15 2025] audit: type=3D1400 =
audit(1746235696.140:76): apparmor=3D"STATUS" =
operation=3D"profile_replace" info=3D"same as current profile, skipping" =
profile=3D"unconfined" =
name=3D"libvirt-cd31a98d-8534-4b9a-97ef-41bd469d231c" pid=3D3575 =
comm=3D"apparmor_parser"
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): corrupt dinode 43609984, =
(btree extents).
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): Metadata corruption detected =
at xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 =
xfs_iread_bmbt_block
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): Unmount and run xfs_repair
[l=C3=B8. mai 3 03:28:15 2025] XFS (dm-0): First 72 bytes of corrupted =
metadata buffer:
[l=C3=B8. mai 3 03:28:15 2025] 00000000: 42 4d 41 33 00 00 00 f8 00 00 =
00 01 10 26 57 2a BMA3.........&W*
[l=C3=B8. mai 3 03:28:15 2025] 00000010: ff ff ff ff ff ff ff ff 00 00 =
00 06 61 32 b9 58 ............a2.X
[l=C3=B8. mai 3 03:28:15 2025] 00000020: 00 00 01 27 00 13 83 80 a4 0c =
52 99 b8 45 4b 5b ...'......R..EK[
[l=C3=B8. mai 3 03:28:15 2025] 00000030: b6 3e 63 d8 b0 5e 20 5f 00 00 =
00 00 02 99 6f 80 .>c..^ _......o.
[l=C3=B8. mai 3 03:28:15 2025] 00000040: 7f fb a7 f6 00 00 00 00 =
........
--
Roy Sigurd Karlsbakk
roy@karlsbakk.net
+47 9801 3356
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt. =
Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 =
eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste =
tilfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.

