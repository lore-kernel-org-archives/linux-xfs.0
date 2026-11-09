Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794211534;
	b=i2jCuOWI+fGmroRujhK87DLLoRHnbW7qdeBQFcNyy443FV4RWwWiaRNgXwcrkgTIg6i6
	 mj8i5V/JKytTBGlnQbz36fbXpoD4cHGiOiHoyjV81zPWZkr5QxjFQnHq1guISQW4FTaiL
	 a6SRJYbgkzK4vfIzmJ9nM9ZzTRWS+M3pDZb2Vq1Be7Gsq3xgpBuEo1o/qPcti9xBx4Y3Z
	 shzX6p1AinbOz3GQZYOol7FCycM7zae6hGKrKTHQujYTm3wO2m40D99fFilyLB0g4vmN0
	 jtW7utShm3WO6lkT0HldthHmpxpN2qIgCbeml4rcexIsC3285g85/KevHGZ5GXZVBGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794211534;
	h=Received:DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=0/u/0wAa2DgIPYhdzWv5qazd8qsjtzdjsZjZJZKwxDU=;
	b=v50i8WgzctA9F+1P8X9VJp3u9w5wcuUu5RzrzW5/kQRv/trlUf+pk0uLXCnO+YpQViAs
	 1nxRLAw+S6eE9RZg/teHoOmP3Hr81m6rcJFsoIpzvr0raVMyu5qiQxID92G1y9Sp/Hzko
	 iALPBDgJ5/NtAHJL1axre6Xm2WfbnywFdeLkANpZoy5aRAsb5IkSV5PwQJee/jglo9EnA
	 stN1dkcR91a6ag2LDK7KOBb+yG5xDqnT+k88pMRWwjlwIpqrYXVb+haKiH/IIqSpl5KJ0
	 BJRUo8DQxTxpcn+K59gLNP+3uT4UyPx3TGjgb621q8EIbkklgBOHJchr61o7ym7em+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kaD+NtIj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A11606A338
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 08:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kaD+NtIj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B731F008A1
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 08:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794211533;
	bh=0/u/0wAa2DgIPYhdzWv5qazd8qsjtzdjsZjZJZKwxDU=;
	h=Date:From:To:Subject;
	b=kaD+NtIjugaO/DBw6Y5W5zOECxSdva1g6HerJ81OwPuN0qKNJl9pbt0mMBe7DRfpS
	 ZOGKJ6kpav8ierl5eXpGsh1SE/+/efL8FJieMiHYT4p60mfOuGdCessqlrdp0bZvIN
	 OhqGhQlAkgmL605rry5YLp4sIvb9PUu1u+ky7I+uOvDh15J3rIexBMkMH/Y+9KLMbn
	 t8QAE20Gx2sae6Y+iWGLUuUSjcKRK99R0NRvRuSG6MMspeTUsT2qwnZBUrQ5q/HumY
	 fS5sMqIxXRGIDYs7KgbjJjZPxjgsLXdjGs8VRoo9cHIub7FsOtKYve3Nou9YvL7rXm
	 rY8PpeZyQl9tQ==
Date: Mon, 9 Nov 2026 09:05:30 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: Subject: [ANNOUNCE] xfs-linux: for-next is now 48326a2382d8
Message-ID: <avF-Whh2kTlEZvwK@nidhogg.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi folks,

The xfs-linux/for-next branch has just been updated.

Patches often get missed, if your outstanding patches have been
reviewed, are not already merged in the mainline and are not
listed below, please give me a heads-up.

Follows the list of staged patches.

----- Fixes for v7.4 -----

Rik van Riel (1):
      [0a2b9af9bd5f] xfs: keep successful near rt allocations

----- Next Merge-Window (v7.5) -----

Adrián García Casado (1):
      [976d3cd5b0a3] xfs: add __printf attribute to xfs_buf_alert_ratelimited()

Eric Sandeen (8):
      [20496da47af3] xfs: remove redundant stat checks after xfs_btree_insert()
      [e2293d89c56b] xfs: remove redundant stat checks after xfs_refcount_insert()
      [87f5edcd7190] xfs: remove redundant stat checks after xfs_inobt_insert_rec()
      [cfad3431d3ad] xfs: remove redundant stat check after rcbagbt_insert()
      [25b97ffb8111] xfs: remove status parameter from several btree insert functions
      [c71f58e4fde5] xfs: add stat check to xfs_btree_delete and remove caller checks
      [12be672e210c] xfs: remove redundant stat checks after xfs_refcount_delete()
      [01b68405c7f0] xfs: remove status parameter from two btree delete functions

Siddh Raman Pant (1):
      [13257daacb8f] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
