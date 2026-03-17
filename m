Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65C926F293
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773763675; cv=none; b=GVIRItN9FEoj1WpxjeSOIsL3t+zyvbuxLbQrBzh2wV1wJ4ep/Oo/BFeiwSwXq8uIN6cO2PXSu3cwsxjpxZ59pv7gfv2c40szeX2/m0En1P4C2Et20MV3ziOOOp7pW1KSAyoS75nz7QcJNLwZm192aMx/XACS495sDcOvlJ0+WOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773763675; c=relaxed/simple;
	bh=mZaVUk40zwp7XAaD0WpCpkv5b8t6WvKbagbwcJiXnL8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HFt7RS/i474ZxkBLoV+zluE5bgodHZqIwbEztGEJWI07mSYTXSo8nkERl1iGMoZD5tnCUWCARbmPgDa6U7VHl5xkGTGGdPFKn7UbipRKvdGYcSkqoVo0WP2OUoD3xC/jbc0MAyZiV/BDlVXhxDBFD5Q/GOlz1R9Q9wwp0AcHxZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ptInDj/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ptInDj/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948E8C2BC86;
	Tue, 17 Mar 2026 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773763674;
	bh=mZaVUk40zwp7XAaD0WpCpkv5b8t6WvKbagbwcJiXnL8=;
	h=From:To:Cc:Subject:Date:From;
	b=ptInDj/hfP/N7Y2mILMOq15vW7vf6DUk0Wa8o/keP8gg4cs1I0Q91ZW4G8/AayjiQ
	 6Ohvj8+eB5Lm7FTMJJ8hBpqfcGOMw1TEDjKqJo/ezLWATAJJTSBmAJBVET2R56ofVI
	 a4OGnlEwUwTzXvUcmxl6dvN5d0fjIqceTx/fZ+717Ei3gKVgEvcoPlX7sqtfaqXCyb
	 R1wa6N5ouzJVho+YFLwemPY1Z0aojWJn5mRvqZx3aLlN8FELh8clCiFtF8KfKtg/YU
	 5Apqz7ZAvjLS27lk6TAvcmkgCOVXX9WNqh5GSnHlW+ahxeAMf0eqDnFh/Q+ANaBRzP
	 fO3BiLVJovWJw==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v2 0/2] Improve user experience with xfs_fsr
Date: Tue, 17 Mar 2026 17:07:38 +0100
Message-ID: <20260317160750.186873-1-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This is the V2 of this series (my apologies for the delay), based on an
user report via IRC in January.

V2 specific changes are detailed on each patch, but mostly patch 1 was
changed. Patch 2 only the description

Carlos Maiolino (2):
  fsr: package function should check for negative errors
  fsr: always print error messages from xfrog_defragrange()

 fsr/xfs_fsr.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

-- 
2.53.0

