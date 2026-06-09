Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68663D9048
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780989971; cv=none; b=XAjAfc9chG9JNnnyUkIuqoW5k0TJZRw71e3fyoc9DTODwFRWNDHLW5wg/85H9lny4hRmOkzwAeaXw7fQ6Ou2VSt/fPX1Dw9i20C8/Xe4eU2qVWo/AnjCDiIaeo1bEn/KSJGUvUwR1/h06cKamaJJxE7cJnlDTkqNeq3sg9nj6FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780989971; c=relaxed/simple;
	bh=KA3RxybUl+S7GDrGnxZTgeNcW+huDC5X73fI1J7ipME=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BCxuWp6Xbg2Lwxd8tRE6fFnsvZnlw7hMB+HhXG80sMyToB4mR0xn8MMsLW23Ek27SdiAqLh9V3DRKfJcXpJtrWenfkRdO7hNWSROvcL5Mj7IPiynDzsaAeNopJAV+jtkCzQqv2LAJfk8d5XRuvjT10Zu4r33C331j64epfJG0+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQV0cbz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQV0cbz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCF01F00893;
	Tue,  9 Jun 2026 07:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780989970;
	bh=PA07wKRNVoX/w+4U+JvTgJ0Qos0vKJHKABMWRPNJgCA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=WQV0cbz5A2cSEvYlhaTnzK8eDCEthJWuCbVNYAVztzDVGWDF6YS5D7pq3834bAhgi
	 HO21n9pd/MFYazoqycJQJrXzcDND1jd1jnxkUQAFFwJu1Cf8XuY2MAbj24JiwhFFl+
	 AywHaL1gVzaXUXRAocWcmvHTB5iBjt/tK2iG8Dmo63b7R0ssLIl1Jf0OYCaF31lGXS
	 DQ7ngzHUE0NLn/ZKP8FOccDZ0XZfBmVFnuryUw2o85wEPBl6S6QmT23nDoq0SbCDVr
	 s01gsPmWxO1cgGQC0uk4NbWVRgDlV9Zr0ytW8S5fUEjcl9wyXZUhlDX6lSasWeinb5
	 3XoMp0WupIU1Q==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260601124410.3508980-1-hch@lst.de>
References: <20260601124410.3508980-1-hch@lst.de>
Subject: Re: shrink struct xfs_imap
Message-Id: <178098996994.72840.15084273981940742680.b4-ty@b4>
Date: Tue, 09 Jun 2026 09:26:09 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 01 Jun 2026 14:43:46 +0200, Christoph Hellwig wrote:
> struct xfs_imap is embedded into struct xfs_inode and takes up
> considerable space.  This series applies some relatively easy shrinkage
> to it.  It it based on top of the "remove struct xfs_inode.i_ino" series.
> 
> A git tree is also available:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-shrink-imap
> 
> [...]

Applied to for-next, thanks!

[1/5] xfs: cleanup xfs_imap
      commit: 41397e7ca8a06507ae6f52f68cd27b0812e9a561
[2/5] xfs: remove im_len field in struct xfs_imap
      commit: 33451947c4f0f91df74af2db4384143446a1157a
[3/5] xfs: massage xfs_imap_to_bp into xfs_read_icluster
      commit: caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c
[4/5] xfs: store an agbno in struct xfs_imap
      commit: 9b64ca202f364a6bf8e19bdd20953bc2d776c67f
[5/5] xfs: mark struct xfs_imap as __packed
      commit: 4f16139d8e296ec5403c3ebbe874dcd5c57648ca

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

