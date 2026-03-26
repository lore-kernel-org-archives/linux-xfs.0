Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE0C2DC77F
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774545091; cv=none; b=sRo06YxC7PCFnPF6u07gF36Ujn3QDxaEuCPaWFyRcm+xbAaLy4dWq/anFuWv/u2sLW2UPbCPmltemYuN8N0g3syI+Zzi7oX5lG9RxxxQib1ZDtZSAmuskh7ib941yi0YzNEOrz4UmI1NIBmPkyK1WQnPgI9AN3nU7fMU5NJc+z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774545091; c=relaxed/simple;
	bh=WJ7o/ueIq6RVEDFO4ZbbLoHkLv7MTEPkK2JQvUCdHrU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=g7z1dftn3AQqBFLBm1Ds/x6/6XjtXxn0K8jYvnUToG2bvFyrrTVRht25dVFI6fT9znmHkKhbOFeBg8kSGW7DwjIMuzH5DWSb6K+RtTcrgS0dgIZr6RCRi+aU/Ck/TFvTslkolA5eFkkEQnpgyHfP6h4te3UNtu+pzMha9vi9wNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qD6eVTe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qD6eVTe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA62C116C6;
	Thu, 26 Mar 2026 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774545090;
	bh=WJ7o/ueIq6RVEDFO4ZbbLoHkLv7MTEPkK2JQvUCdHrU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=qD6eVTe/qnuc7TarIwLeR7FbPg/97KpOikCpqfrzcJRt/E2KzFl2YLwivVu1HeRJI
	 e6r86ukEKrm7scGmBITPEhqe4FQWDY8KAnj3xJWK8TRjeBrdl7Lwf9xM3jLKx6eOv9
	 /pHlN4gltSa8vOp9fpAj7Z//PequNkAl1rG4dctaXun894v/C+/hfzzxRr1QzeLeDC
	 LCq8HCeNGTSoMqlAGeYz/x8taO/E+QWZ/1829MzXZxuFQimem4lPlhWdzHCxbYRZub
	 F790y89eXoRQ3dn+qdsk6zMV/Svff4cgQ68c72YlSsOYIADH6XaTHJ5zxHOq8Q1kIV
	 UiWKK9JZXhaNA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org, hch@lst.de
In-Reply-To: <20260323210157.GM6223@frogsfrogsfrogs>
References: <20260323210157.GM6223@frogsfrogsfrogs>
Subject: Re: [PATCH 1/3] xfs: don't irele after failing to iget in
 xfs_attri_recover_work
Message-Id: <177454508941.65447.11371486250005907736.b4-ty@kernel.org>
Date: Thu, 26 Mar 2026 18:11:29 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 23 Mar 2026 14:01:57 -0700, Darrick J. Wong wrote:
> xlog_recovery_iget* never set @ip to a valid pointer if they return
> zero, so this irele will walk off a dangling pointer.  Fix that.
> 
> 

Applied to for-next, thanks!

[1/3] xfs: don't irele after failing to iget in xfs_attri_recover_work
      commit: 70685c291ef82269180758130394ecdc4496b52c
[2/3] xfs: don't expose stale pointers to callers of xlog_recover_iget
      (no commit info)
[3/3] xfs: remove file_path tracepoint data
      commit: e31c53a8060e134111ed095783fee0aa0c43b080

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

