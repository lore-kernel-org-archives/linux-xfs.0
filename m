Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A301D1D4341
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 11:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728990584; cv=none; b=YOT/bdgW8V2yR/8HG0/BaOyNjdAkfzcYy3Fff6KGSvr/O2BZEdS45UYF7CdXBWyN7re4FkY73/6I4mCsw6lplV9o2hB0HbyNYE65THyZ4V43RcaG3es44yUKr8sYcCIiclZ6vz7+Cp2DD7MfO04G1f2niP5QXNKPTEEusilJbVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728990584; c=relaxed/simple;
	bh=UzHr5py2yMRYU/730IkKH1+W9Y4MFxAi6kpukUMGWIg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=c/I7rwwLVysrNuxlsDHI/PK8fHgSzgBJflO54i7MEvymlCu1+yY5+cX6P9Ovh4DKZzviAFDoz2tKAF8Vu9mDJLG+gVH5QE/wqRRG8nOwShK2/zoObvJZchnQYMbZkCjj3rDx0RQIdpnahuQ+CrEnldTxFoWIcMaiC3wLcK7rGe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umkaoZrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umkaoZrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC0BC4CEC6;
	Tue, 15 Oct 2024 11:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728990584;
	bh=UzHr5py2yMRYU/730IkKH1+W9Y4MFxAi6kpukUMGWIg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=umkaoZrwgPXmKUOm/rPpVqoJNCQ/nF+btS6uKfWq3PirZagQHrPsxvS2fsoixbBJP
	 gQE8TqRzqZbe0GFPjlEgnIK9QSeh1XIzvAncY98LQxwiHsqWpqF6Jhzw1/T/iocCU7
	 mHqyW3j5ubvNmxlMTc6tSHlVeEUEsXfcEQhc7TJiCbhkt6GyqBQyO1/leGgf0Q2kTV
	 PZfgWRMJ0Unt+8hEhs4kL8lJczGn1iD1FdJ52BSe9N8DCmHIJEh2qK5jD/jVu2t6Ea
	 znj1Ats77Hb/TRCodc47GK9KfggZESljnZY2NIum9p/7fRPypEqRdSfvungadWODOo
	 o+E9UDqKm2x8g==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20241008040708.GQ21853@frogsfrogsfrogs>
References: <20241008040708.GQ21853@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: fix integer overflow in xrep_bmap
Message-Id: <172899058342.231867.4423719358891435687.b4-ty@kernel.org>
Date: Tue, 15 Oct 2024 13:09:43 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 07 Oct 2024 21:07:08 -0700, Darrick J. Wong wrote:
> The variable declaration in this function predates the merge of the
> nrext64 (aka 64-bit extent counters) feature, which means that the
> variable declaration type is insufficient to avoid an integer overflow.
> Fix that by redeclaring the variable to be xfs_extnum_t.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix integer overflow in xrep_bmap
      commit: 0fb823f1cf3417e06846d1ffe2c97e10a65a847e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

