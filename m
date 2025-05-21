Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B991754B;
	Wed, 21 May 2025 22:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867266; cv=none; b=ck6OYrbydFKaOY6DKyqvh0czoRR3PL1qryabXHhp5dcxkwfsgd6Wan6JAJOAa6tbF+spXpPpYp+vsVuNVYp61/L8BtX6hQbNm60jE1kcf7wT3HNaGMiPUL8TbcRsIc+1/KeDCakRg1DiYB2ZTL1n4OVYxN3Syp4VC2Esia4VO/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867266; c=relaxed/simple;
	bh=hq7LbJ9F5E8ZOZP0/86x5tKkaZ27d+ASMYNZ9Rx8ibs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aSOqd44AbJxcLYo4Gij8ecT2QbDz+cvl9tkMizo1aosQr3JBzNRUSnS0r3ehROLTc4oVm+aD/05A1sodpx6EXuppte4YHB4k7nhMT9abxZkJgA9CAJ+rk2yav5zu/ExL6sO9rT9K209QfHpGp6kFQqKxfUrPbx2WysFSOkSptNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ek09fXfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ek09fXfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E239C4CEE4;
	Wed, 21 May 2025 22:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867265;
	bh=hq7LbJ9F5E8ZOZP0/86x5tKkaZ27d+ASMYNZ9Rx8ibs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ek09fXfX3vV6LyrX4nID+Sb2h88nd2Ku1tzA/Ejw3gvVJzzac5ijm7PwghofUVK5n
	 hHJMpwUzev7ZIzimXrT3eGMK2Pn16U6zg1pUyCy7QFeohF/6jGRpRJXjA23tbABsWB
	 fFZiVEyaijUtq/mh7E2e8u3GDWt75xTcLymk6lXxsSwF2Im2tWjYBgqSqDlp7OY1MZ
	 H59RKlVh2YHfaOPV9DoBGiUve8iYZqbYjW/PyR0lvDKvr0AMFDWyumaEt8Yo2Av85e
	 iyDiZvEEFk91ZOLz169j3fz964Pm+RjZ9Yp0zfli1IsReirZQ3deeqWddveVuETx2p
	 twpxWg84QIBiw==
Date: Wed, 21 May 2025 15:41:04 -0700
Subject: [PATCH 1/4] xfs/273: fix test for internal zoned filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <174786719409.1398726.5762252044518389370.stgit@frogsfrogsfrogs>
In-Reply-To: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For XFS filesystems with internal zoned sections, fsmap reports a u32
cookie for the device instead of an actual major/minor.  Adjust the test
accordingly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/273 |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/xfs/273 b/tests/xfs/273
index 7e743179975e81..87a1c623b73b46 100755
--- a/tests/xfs/273
+++ b/tests/xfs/273
@@ -50,6 +50,11 @@ rtdev_daddrs=$((rtdev_fsblocks * fsblock_bytes / 512))
 ddev_devno=$(stat -c '%t:%T' $SCRATCH_DEV)
 if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
 	rtdev_devno=$(stat -c '%t:%T' $SCRATCH_RTDEV)
+elif $XFS_INFO_PROG $SCRATCH_MNT | grep -q 'zoned=1'; then
+	# no external rt device and zoned=1 means fsmap reports internal device
+	# numbers instead of block major/minor.
+	ddev_devno="0:1"
+	rtdev_devno="0:3"
 fi
 
 $XFS_IO_PROG -c 'fsmap -m -n 65536' $SCRATCH_MNT | awk -F ',' \

