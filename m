Received: from mail-out02.uio.no (mail-out02.uio.no [129.240.10.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18016BE40
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 00:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.240.10.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741219959; cv=none; b=rQX4Gj5ybu969gl96GGbJCLZNscD4QRS9YxV19svy21AJdT1Rp1kHxZbTIaDXkdxs5XGm0QpQ1RMtJNGs7wKgCmefD4lnDKaIsLwMXYtv33P7agorQFcDfwWYiTaHQV6X2g18Pzc3r7+SzdfCG297zSvct4rtbEkZGJRz9FobtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741219959; c=relaxed/simple;
	bh=sglLyx43rilzZo/TL7Hl5VT5E8iGsO3jeLeWEZHi5w0=;
	h=Message-ID:Subject:From:To:Content-Type:Date:MIME-Version; b=PgH7wgq3Hq7wszxSs0XMgkcoNUtp1PmdW/OxQqgWf9YpKc6WMJMoW2MDuckFuG2jVWQksDx+EkK+DkILl7Wwr6iMrvXUqHgya+U2ZLaHbrIkmOT2du6NlofDDDwIzp8cV9dNXp2X4LxTnJzofyc9xL355kJvE79oTfLS/pPuYhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ifi.uio.no; spf=pass smtp.mailfrom=ifi.uio.no; dkim=pass (2048-bit key) header.d=ifi.uio.no header.i=@ifi.uio.no header.b=MMSoCZR2; arc=none smtp.client-ip=129.240.10.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ifi.uio.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ifi.uio.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ifi.uio.no header.i=@ifi.uio.no header.b="MMSoCZR2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ifi.uio.no;
	s=key2309; h=MIME-Version:Date:Content-Transfer-Encoding:Content-Type:To:From
	:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vfKyMnUKGNacR7RRpgy3GlsN+XC7MT/gFEEttvYYRZg=; b=MMSoCZR2YGR9G8eLzkl9G90MsS
	3SMaA4tarsT29y1pxtdH+iSbo1myceRIRNYDdx/eP9Jjb2c578MVyByCc57Gxac4AvSXD5ZNkOJ6W
	REwXQhxNaPtX1zkeyLCp3mjtyVc42fn8G04Cawaglugd+w2qgVx+H/0JmWoiMqjRzydJZ7s3AfZXL
	G85VBj/02E5WHqzMG+sdoLrkTrh7ZJzasqMJVABMK8/4BwV50zkiXdnVwx6BNjTXphCsHPxQvejsb
	b+D5QAPWoSlTlQtPYuEqqjKz9fgSla/us0ROQtK3smsTQqJfSoiSqmmzJerhUn35getw6Mij2aUSz
	qYDJNFnQ==;
Received: from mail-mx12.uio.no ([129.240.10.84])
	by mail-out02.uio.no with esmtps  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98)
	(envelope-from <kjetilho@ifi.uio.no>)
	id 1tpyRb-00000006bvK-3Pbi
	for linux-xfs@vger.kernel.org;
	Thu, 06 Mar 2025 00:46:31 +0100
Received: from vpn.i.bitbit.net ([87.238.42.13] helo=scribus.ms.redpill-linpro.com)
	by mail-mx12.uio.no with esmtpsa (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	user kjetilho (Exim 4.98)
	(envelope-from <kjetilho@ifi.uio.no>)
	id 1tpyRb-000000007Ce-19wO
	for linux-xfs@vger.kernel.org;
	Thu, 06 Mar 2025 00:46:31 +0100
Message-ID: <cbf4f4c23efba09467ca7c08e516fe8561a1f130.camel@ifi.uio.no>
Subject: nouuid hint in kernel message?
From: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Mar 2025 00:46:23 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
X-UiO-SPF-Received: Received-SPF: neutral (mail-mx12.uio.no: 87.238.42.13 is neither permitted nor denied by domain of ifi.uio.no) client-ip=87.238.42.13; envelope-from=kjetilho@ifi.uio.no; helo=scribus.ms.redpill-linpro.com;
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: FB9943F71D469580FF512A05F1FC419A8603FB8B

hey people, thank you for XFS!

tl;dr: consider changing the kernel message "Filesystem has duplicate
UUID - can't mount" to include a hint about the existence of the nouuid
mount option.  perhaps append " (use -o nouuid?)" to message?

sad backstory:

today I tried to use LVM snapshots to make consistent backups of XFS,
but I was stumped by:

   mount: /mnt/snap: wrong fs type, bad option, bad superblock on /dev/mapp=
er/vg0-test--snap, missing codepage or helper program, or other error.
          dmesg(1) may have more information after failed mount system call=
.

and dmesg said:

   XFS (dm-7): Filesystem has duplicate UUID d806fb70-8d81-4e57-a7e3-c2ed0a=
14af59 - can't mount
  =20
so - I thought the solution was to change the UUID of my snapshot using
`xfs_admin -U generate`.  this is the response (when the snapshot is of
an active filesystem):

   ERROR: The filesystem has valuable metadata changes in a log which needs=
 to
   be replayed.  Mount the filesystem to replay the log, and unmount it bef=
ore
   re-running xfs_admin.  If you are unable to mount the filesystem, then u=
se
   the xfs_repair -L option to destroy the log and attempt a repair.
   Note that destroying the log may cause corruption -- please attempt a mo=
unt
   of the filesystem before doing this.

so since I was unable to mount the filesystem, I tried xfs_repair -L --
which took a very long time and in the end gave me a corrupt filesystem.

... and then I found out about -o nouuid, so there was a happy ending :)
but I think it's a reasonably simple fix to give a hint to the user in
the kernel error message.

thank you!
--=20
venleg helsing,
Kjetil T.
