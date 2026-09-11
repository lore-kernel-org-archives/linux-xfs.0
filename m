Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF99C44E66B;
	Fri, 11 Sep 2026 07:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111775; cv=none; b=ZzJHkFM5ygIzZpC2POUHzdphQ0qK2hm5NFGvkWIOC+SfEQjhlD5kASMKzsKDc+pca+VZlp2b9PiGVGk9s2xn4+hebgRm0ScPRZF9YCt5StlM9sjUMnyi9sjOUhYEC4Lfzt5RahsHWi37GJT1Apo40qd20kBXsQj1zVyi/w9FsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111775; c=relaxed/simple;
	bh=3Pt8Cojb/dainoViIFbesUwWRjXDa9HrdRXhc0Npja0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Z8Q/qwtfCSc5PuE75lDbZXvhTtrW3Xxh5ts90aAdyuspLwYG7LEdxnB894JzVCEDnrhCsyyHkR4OuxVYh/s5fzp73zCKU8c9OczpycY/eoMPLJfddNHlrxbumkxlpuo54tx956k48QWOE4o+rG2uzbfEyxBkliUsn5EV/sunkwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUJqev9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUJqev9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C0F1F000FF;
	Fri, 11 Sep 2026 07:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789111774;
	bh=iSeU6vOcmgk1j80Ug+dL4HIfSQup3ByR261CafksI6s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ZUJqev9raGcX1RSULimDIAaWpNz8s1dbnDYjCR4RdGEc4TnHDFSwUe5xiS0eq5anQ
	 Y+jklW2mx3/xFe8eFbpZQh2ONqdS4ihz2ew8GyUOAhjl7V2K2xYXWsG6mlywN4jdDP
	 h2uldCqjYOA5xXcNU3AZTixcWZ/qweCoDZ7s2K1UXFk8Rolzm5s89oWfEAAtP8ykae
	 tWY104WLuuj9X8Nctnwg4pVyOaQ0byD5IkD3VRkW6zMIKIrGGMePYG7EcpSskYLREt
	 OCW4Z97KD4J/NG5IUzVpKcKhzB/AuuXKrwjGN84W8Ck+So92x1Au37mKlwUTjFPO+t
	 oeK7OWBPa4Mjg==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178892936663.4057962.1670503099807440927.stgit@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936663.4057962.1670503099807440927.stgit@frogsfrogsfrogs>
Subject: Re: [PATCH 2/7] xfs: actually check internal-rtdev fields in the
 superblock
Message-Id: <178911177317.25559.7864655044039880776.b4-ty@kernel.org>
Date: Fri, 11 Sep 2026 09:29:33 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 08 Sep 2026 23:04:50 -0700, Darrick J. Wong wrote:
> LOLLM points out that the superblock scrubber doesn't check the new
> fields that were added for internal realtime volumes when we added zoned
> device support.
> 
> 

Applied to for-next, thanks!

[2/7] xfs: actually check internal-rtdev fields in the superblock
      commit: 1ee2ce797c360785a3813fef62c90f427f3aed34

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

