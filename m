Received: from mail.karlsbakk.net (mail.karlsbakk.net [46.30.189.78])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077C71EB3D
	for <linux-xfs@vger.kernel.org>; Sun, 25 May 2025 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.189.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748169576; cv=none; b=N/5C2VtGX++qb7gr7nyUu8eLigMcKrWH0udNLKkG8dzJZoz8pJiVDtGVuMdTOspTs1H0Qje9Tec0k65R1Ag4eBhyjlrNzrH76HVw7TdDBPdmarGVW6nTy5ltGp9Fx7VtADE2v0tmLGEizBG4x9u2HH0lqyaREaKs2I1kUg7HI9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748169576; c=relaxed/simple;
	bh=vpQ6wb0Yv4TAqqOD7n5nTv3PAQIaG866qdAmrz3+4iY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=sDvlo6rUktqqeyvrTmiFdSHJgcgQUJhigpDIctUe/C56uFpHXh7jj6Cyo+E57zLDR/GQ3r0zI087NhPl1jeZ9cf6v0X9D5YICo2ezCer/sTqw2AmbYDJ8x/NakhZNZQYrSgb5HH35M8LTEx8xaKcgbwhQHse1hnHAaV6B9bz2Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=karlsbakk.net; spf=pass smtp.mailfrom=karlsbakk.net; arc=none smtp.client-ip=46.30.189.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=karlsbakk.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=karlsbakk.net
Received: from mail.karlsbakk.net (localhost [IPv6:::1])
	by mail.karlsbakk.net (Postfix) with ESMTP id A17CB136;
	Sun, 25 May 2025 12:39:32 +0200 (CEST)
Received: from smtpclient.apple ([2001:2020:311:e59d:2cc1:39ac:4c0f:75f8])
	by mail.karlsbakk.net with ESMTPSA
	id P83UJGTzMmixVj0AVNCnFw
	(envelope-from <roy@karlsbakk.net>); Sun, 25 May 2025 12:39:32 +0200
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: XFS complains about data corruption after xfs_repair
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
In-Reply-To: <BFF21A51-ECA7-454B-8379-F456849D16AC@karlsbakk.net>
Date: Sun, 25 May 2025 12:39:22 +0200
Cc: linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <92DD8C35-E3F2-43D9-BF4B-19C442A13DA6@karlsbakk.net>
References: <9EA56046-FECD-42C5-AEF6-721A8699A45B@karlsbakk.net>
 <aBaaDGrMdE6p0BiW@dread.disaster.area>
 <BFF21A51-ECA7-454B-8379-F456849D16AC@karlsbakk.net>
To: Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

> On 24 May 2025, at 03:18, Roy Sigurd Karlsbakk <roy@karlsbakk.net> =
wrote:
>=20
>> On 4 May 2025, at 00:34, Dave Chinner <david@fromorbit.com> wrote:
>>=20
>> On Sat, May 03, 2025 at 04:01:48AM +0200, Roy Sigurd Karlsbakk wrote:
>>> Hi all
>>>=20
>>> I have an XFS filesystem on an LVM LV which resides on a RAID-10 =
(md) with four Seagate Exos 16TB drives. This has worked well for a long =
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
>>>=20
>>> Isn't an xfs_repair supposed to fix this?
>>>=20
>>> I'm running Debian Bookworm 12.10, kernel 6.1.0-34-amd64 and =
xfsprogs 6.1.0 - everything just clean debian.
>>=20
>> Can you pull a newer xfsprogs from debian/testing or /unstable or
>> build the latest versionf rom source and see if the problem
>> persists?
>=20
> I just tried with xfsprogs-6.14 and also upgraded the kernel from =
6.1.0-35 to 6.12.22+bpo. The new xfsprogs haven't been installed =
properly, just lying in its own directory to be run from there. I downed =
the system again and ran a new repair. After the initial repair, I ran =
it another time, and another, just to check. After rebooting back, it =
still throws thesame error at me about "[l=C3=B8. mai 3 03:28:14 2025] =
XFS (dm-0): Metadata corruption detected at =
xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 =
xfs_iread_bmbt_block"
>=20
>> It is complaining that it is trying to load more extents than the
>> inode thinks it has allocated in ip->if_nextents.
>>=20
>> That means either the btree has too many extents in it, or the inode
>> extent count is wrong. I can't tell which it might be from the
>> dump output, so it would be useful to know if xfs-repair is actually
>> detecting this issue, too.
>>=20
>> Can you post the output from xfs_repair? Could you also pull a newer
>> xfs_reapir from debian/testing or build 6.14 from source and see if
>> the problem is detected and/or fixed?
>=20
> I couldn't find much relevnt output, really. I can obviously run it =
again, but it takes some time and if you have some magick options to try =
with it, please let me know first.
>=20

So, basically, I now get this error message in dmesg/kernel log every =
five (5) seconds:

[s=C3=B8. mai 25 12:12:40 2025] XFS (dm-0): corrupt dinode 43609984, =
(btree extents).
[s=C3=B8. mai 25 12:12:40 2025] XFS (dm-0): Metadata corruption detected =
at xfs_iread_bmbt_block+0x2ad/0x320 [xfs], inode 0x2996f80 =
xfs_iread_bmbt_block
[s=C3=B8. mai 25 12:12:40 2025] XFS (dm-0): Unmount and run xfs_repair
[s=C3=B8. mai 25 12:12:40 2025] XFS (dm-0): First 72 bytes of corrupted =
metadata buffer:
[s=C3=B8. mai 25 12:12:40 2025] 00000000: 42 4d 41 33 00 00 00 f8 00 00 =
00 01 10 26 57 2a  BMA3.........&W*
[s=C3=B8. mai 25 12:12:40 2025] 00000010: ff ff ff ff ff ff ff ff 00 00 =
00 06 61 32 b9 58  ............a2.X
[s=C3=B8. mai 25 12:12:40 2025] 00000020: 00 00 01 27 00 13 83 80 a4 0c =
52 99 b8 45 4b 5b  ...'......R..EK[
[s=C3=B8. mai 25 12:12:40 2025] 00000030: b6 3e 63 d8 b0 5e 20 5f 00 00 =
00 00 02 99 6f 80  .>c..^ _......o.
[s=C3=B8. mai 25 12:12:40 2025] 00000040: 7f fb a7 f6 00 00 00 00        =
                  ........

roy
--
Roy Sigurd Karlsbakk
roy@karlsbakk.net
+47 9801 3356
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt. =
Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 =
eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste =
tilfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.


