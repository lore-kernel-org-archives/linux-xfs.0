Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795613530;
	b=nzZ8eaTxVvwbREXoIFcKk/8mPvzE9PYezsMlY+ofrPsL/zLFyDokHat/hMjS9YgXlB0Z
	 VerPraAIPMNol4tY4Z7N7lybLKzakahabcnUPBUS5CGmrqM3bK6Uo4UPScUz63llPF2iX
	 DalRfPQWdQ5nsQxcDczUXUt+Ud70p8UD06h7uqEhVpNslUAjRBHiukWrr933wD9Y7YA9U
	 NrWF4qbzJmXqKQ42Wbfj4MRaEobE3nxE6wb9VafR8Q07S3u+48SPV75jtU+zGLAdk1+jG
	 M4VDhhJy0+yWsAHZc4MGdwhqMI1C18CforbYecU2R302HAPTr4mKiHlpxDUELHe0fUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795613530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uM7VqOkMljiRrkOde+VoeTeZSpb+jARpg0aFOyEVz/E=;
	b=1pvLRexOgV+I+WRn0MUW2eWtGPdp1LIfcU74mfp3k9hfYOyYhTT3U44e0zeEm13AEUA/
	 SGEXK+c7BduQf5bW2n0syBX9yw6aDC6mpsFWcbdmH3UnKMq+h7es6PTGCdsZQ15u6WLyM
	 /zCuYEUH/wpls9dfI72W0FmZz7Hiaat6qldnwT1t98EUr2TkhgGXIJzmU5WrZqVz6Tdb/
	 Ht8B79z240yozGhudODhDPoEmyyAz0GIz3uEdmN3eYCOH6YCtMFZSuIY4xXnCYedfRI6p
	 Co2YLZOCZDT5V+46GNYmC5Gr2kTK9piOEaJTuA0cDj9r6G9pZjwxmH6qORu6+Yx6WVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kK4UH42m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6A9606A31E;
	Wed, 25 Nov 2026 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kK4UH42m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260C81F000D0;
	Wed, 25 Nov 2026 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795613530;
	bh=uM7VqOkMljiRrkOde+VoeTeZSpb+jARpg0aFOyEVz/E=;
	h=From:To:Cc:Subject:Date;
	b=kK4UH42mFFqIwJ4geBp2SUm7J9ZjLXfn/RHsMsDbQhnlDXa4+r4i2kxW0Ayhm5NUT
	 zklGD+imUImhgutEMipsoWudNYWl75N9Z1GSAszqAUBU9Wwl2ToEB8d4OGnl04klRJ
	 2w5TB96Q12+C0K7Kz6UKljjxaP4kTwhJH294OWNq+6/gaz4uMXNu1dAmTFzJb5uyRs
	 KBwb5gZIg6w3vrEgas9Pi4T/VJTTqnq6nWaFTKvI3f8Wr4YOQetW/hkiJz0wYP88dO
	 cCpcZRVKGiwGcI3rYaHGQuAU/b5qxtb8tH/SMTSgYH0EutkveHioTo+xZ48UQwgdmG
	 w1eAm5WWiyWRA==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	dgc@kernel.org,
	aalbersh@kernel.org,
	bfoster@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH 0/2] xfs: force all shared extent swap to use rmap shared path
Date: Wed, 25 Nov 2026 14:31:45 +0100
Message-ID: <20261125133204.113558-1-cem@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This series fix an issue while swapping a shared extent between two
files.

The first patch moves a trace point earlier in xfs_rmap, where it proved
to be more useful at least while tracking this bug.

The second patch is the fix itself

Carlos Maiolino (2):
  xfs: move _right_neighbor_result trace before erroring out
  xfs: force all shared extent swap to use rmap shared path

 fs/xfs/libxfs/xfs_rmap.c | 10 ++++++----
 fs/xfs/xfs_bmap_util.c   | 29 ++++++++---------------------
 2 files changed, 14 insertions(+), 25 deletions(-)

-- 
2.56.1

