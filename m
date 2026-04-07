Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B31C862D
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569096; cv=none; b=tY7rkadnilLCSEjaCRrW5Cv0xyR0gNMXEHI69p7E9zzv0SMl+z1ErUQoNqekNfiecHxXkjCKfNxg8mp4ahw4t1uhdWl/nW/c/vf39L47tz6t+uwg/sAVxzodlBIpORHBDa5r9FfgCTG96p6/oXHjoBDfikxHh7hxdUbkkSNz/bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569096; c=relaxed/simple;
	bh=InD2R9Y1hcPx357yIJmE/5n/LagTWJBVuvFfLUPoEns=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DkFxbni5DsP2YnqoYaQDd2bZX59IxKV/p/UFcAYEAf5G3pmIX91iQVVfHy5SwVDgT2utpeIFsQy1QAckGrTY0vAY61p5xQqQmbFKk1K0PzCG+NGrt+Ma1jSnbK5WdXJ1DyCMOqxSQ/3XUHfByIyc+CpHifhYVQDNxKVCUW2+swY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXFTBN/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXFTBN/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E160C116C6;
	Tue,  7 Apr 2026 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775569096;
	bh=InD2R9Y1hcPx357yIJmE/5n/LagTWJBVuvFfLUPoEns=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=PXFTBN/ZOTM90/9gtnWfsrm6dr41ND3CP0EIEZ6u+vExGSAX5M1S3s3KVzm5O+AMQ
	 D2ieIKTSUvYvbUXkSF9h0SeFS693VSjGrklWIAqxh8fSKNkiuCNnTOe4my1E/ynqOR
	 WCOyDDdbTV74z2oNsNX7teuKOEruw8PX3NNQIKpEkHmu7nrNQ/EI53vEydWK5cwCF0
	 DTTc94RB43mfGsik+czqMIVyt80NrrRrB1xUUrwKYQ270g4h1O0/uSW7BAD5jkLK47
	 SPaXdMNtTYz6c45SzxcYGCsSrqGjvpsbtj2vyktvvIEie0Qvue7aSDaXey238mqEl+
	 RhfVEBuM/rBKA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260330131607.3904269-2-hch@lst.de>
References: <20260330131607.3904269-1-hch@lst.de>
 <20260330131607.3904269-2-hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: remove a duplicate assert in xfs_setattr_size
Message-Id: <177556909522.105112.6439888763491531520.b4-ty@kernel.org>
Date: Tue, 07 Apr 2026 15:38:15 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 30 Mar 2026 15:15:59 +0200, Christoph Hellwig wrote:
> There already is an assert that checks for uid and gid changes besides a
> lot of others at the beginning of the function.
> 
> 

Applied to for-next, thanks!

[1/2] xfs: remove a duplicate assert in xfs_setattr_size
      commit: 0f7d2a9e020812a787d7c6dfc98715f9c8f72f53
[2/2] xfs: fold xfs_setattr_size into xfs_vn_setattr_size
      commit: e92b3fc5b17c75d3ca31983a7d35e8b88786ee4e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

