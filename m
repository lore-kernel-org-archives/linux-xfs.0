Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C98480340;
	Tue, 21 Jul 2026 10:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630707; cv=none; b=fvim1vguIEKG8uUwnNIe1sYNuq7/M0RRgTf7Ti6Qphjqgs/bNMwy2QP5gOzOs5PBAPV4Rb+Q4AE+DrkOarm18oSPK6n/dSIeHdTMAiX54iamdignoYbrR27tN02stueuY5BOLf/IxJLt6rt8AD2jbTXKfFoP7KHcfve7kMAGZoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630707; c=relaxed/simple;
	bh=lAX/I1b4G1ANacxICZN4X2Y+R74nsCX/cQv7pBLioJY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gob75fEZDgrY7OQk2ceTINd/0vfQgJRhudebwcAWzKm/nep7BOYIQZc5j42PgKoBU01vXHAZg5jsDy1O6VdItvZUmlxRDSzZ7kXMLYPvjfK+DegWZNkIS0NeMeRO81v0a2+U9MeC2Nfe36ppzlq8A1876R2ESfUHodGiIb8A7+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/IVWjpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/IVWjpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBE41F0155B;
	Tue, 21 Jul 2026 10:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630691;
	bh=c8iEWvGy9GRlLi4Xjg5NSmMpzw9/TACfLMU1x2EuUKk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=A/IVWjpAQDfnHnwhMJCTKpN6wyO+8OG2YJf3H7KUNfaMkZKDzkHEUTiDKlHG0cKxE
	 hPnIAut1vdg+OcJTujudcZxZ2jWa1KpsfvSsEwTSddFnviruXKz9vx1YKvqihginhl
	 DIjyRCZrRqZv3tUnfLZYrWfipLifHccNTSMu/ePq6SC4lHa/Kv1AP329gRfUvRhhQ7
	 NyAKetYCqcr5pzR2ejOLU/ZbhLqNMd/wTuabOxPtHyWF5iuFf22s40S4cg845gB7q+
	 JUyATAvGItL5T9HpCVmvGdbx2tkXmTJR8aOlVN3BS1HwehORpyr7O6HpCAjb/j9alS
	 bMJSbIujSEFHA==
From: Carlos Maiolino <cem@kernel.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, bestswngs@gmail.com, stable@vger.kernel.org, 
 Christoph Hellwig <hch@lst.de>
In-Reply-To: <20260714215612.1528518-1-xmei5@asu.edu>
References: <20260714215612.1528518-1-xmei5@asu.edu>
Subject: Re: [PATCH v2] xfs: fix off-by-one in rtrefcount btree root level
 validation
Message-Id: <178463069007.324722.5307902735949232521.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:50 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Tue, 14 Jul 2026 14:56:12 -0700, Xiang Mei wrote:
> xfs_rtrefcountbt_compute_maxlevels() sets
> 
> 	mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
> 
> where the trailing "+ 1" already accounts for the inode-root level, so the
> deepest valid on-disk root level is m_rtrefc_maxlevels - 1 and a cursor must
> satisfy bc_nlevels <= bc_maxlevels (= m_rtrefc_maxlevels).
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix off-by-one in rtrefcount btree root level validation
      commit: fde50b32183f19041b4bab66c8f07b1cc38f8e26

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

