Received: from mail.karlsbakk.net (mail.karlsbakk.net [46.30.189.78])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D737D1C32
	for <linux-xfs@vger.kernel.org>; Sat, 24 May 2025 01:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.189.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748049521; cv=none; b=h3JuuRKHQpGryp+ryUHXcg86OQjYilCzcIJbql1vcS5QqvSoQH9JRmHhFSyyvOJyElL15azjgcJzY/FuWNsGK2QkzjH+lIwwG9hOpDMyN66u2xnj1xeYOkBB3h49EKx1CO5FQsodkS0mflS7v7r6sv3cSBD4eGa1qLCEaSPptMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748049521; c=relaxed/simple;
	bh=RUtmx9xW9ngfsMp+fH0q3S5Ge23UqwCUF3PvmvglPAE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EZGEd+YcuysUKrOIv60KHvnfOKWDQRhOWnZWjqWL2jNJBLZrAn09CbXTIR5ilhdRX+3bktwHMTuGqzhiQhgnR4R8Jh4cwv5TvedU5QFMLvoso9Q08eX4AZ+6qzHAiyGmd9wiUpY6xTDdKx4GspHQMPTusZju6OdpNhgcl08qEzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=karlsbakk.net; spf=pass smtp.mailfrom=karlsbakk.net; arc=none smtp.client-ip=46.30.189.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=karlsbakk.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=karlsbakk.net
Received: from mail.karlsbakk.net (localhost [IPv6:::1])
	by mail.karlsbakk.net (Postfix) with ESMTP id 666281FC;
	Sat, 24 May 2025 03:18:37 +0200 (CEST)
Received: from smtpclient.apple ([2001:4643:1e5c:0:10b7:47a4:5970:45da])
	by mail.karlsbakk.net with ESMTPSA
	id 3AnJFW0eMWgbPzwAVNCnFw
	(envelope-from <roy@karlsbakk.net>); Sat, 24 May 2025 03:18:37 +0200
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
In-Reply-To: <aBaaDGrMdE6p0BiW@dread.disaster.area>
Date: Sat, 24 May 2025 03:18:26 +0200
Cc: linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BFF21A51-ECA7-454B-8379-F456849D16AC@karlsbakk.net>
References: <9EA56046-FECD-42C5-AEF6-721A8699A45B@karlsbakk.net>
 <aBaaDGrMdE6p0BiW@dread.disaster.area>
To: Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

> On 4 May 2025, at 00:34, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Sat, May 03, 2025 at 04:01:48AM +0200, Roy Sigurd Karlsbakk wrote:
>> Hi all
>>=20
>> I have an XFS filesystem on an LVM LV which resides on a RAID-10 (md) =
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
>>=20
>> Isn't an xfs_repair supposed to fix this?
>>=20
>> I'm running Debian Bookworm 12.10, kernel 6.1.0-34-amd64 and xfsprogs =
6.1.0 - everything just clean debian.
>=20
> Can you pull a newer xfsprogs from debian/testing or /unstable or
> build the latest versionf rom source and see if the problem
> persists?

I just tried with xfsprogs-6.14 and also upgraded the kernel from =
6.1.0-35 to 6.12.22+bpo. The new xfsprogs haven't been installed =
properly, just lying in its own directory to be run from there. I downed =
the system again and ran a new repair. After the initial repair, I ran =
it another time, and another, just to check. After rebooting back, it =
still throws thesame error at me about "[l=C3=B8. mai 3 03:28:14 2025] =
XFS (dm-0): Metadata corruption detected at =
xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 =
xfs_iread_bmbt_block"

> It is complaining that it is trying to load more extents than the
> inode thinks it has allocated in ip->if_nextents.
>=20
> That means either the btree has too many extents in it, or the inode
> extent count is wrong. I can't tell which it might be from the
> dump output, so it would be useful to know if xfs-repair is actually
> detecting this issue, too.
>=20
> Can you post the output from xfs_repair? Could you also pull a newer
> xfs_reapir from debian/testing or build 6.14 from source and see if
> the problem is detected and/or fixed?

I couldn't find much relevnt output, really. I can obviously run it =
again, but it takes some time and if you have some magick options to try =
with it, please let me know first.

thanks

roy
--
Roy Sigurd Karlsbakk
roy@karlsbakk.net
+47 9801 3356
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt. =
Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 =
eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste =
tilfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.=
