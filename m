Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3134457BD
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788434413; cv=none; b=NYdaig8W6kvZVVXUN8W02Z/aDFdomJ537wPqfTyZfFlQBmKBWyG3xlq69+zdvLc418IQHEvwdL8sD5QRtdyiNn3Ij/j0FaXnwB8a4/CofJohfuKlgua0zbZ5c9aARYHH6YrMWSisukdxrFJIRFtmafCeK2aekVombJuOsw8YWQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788434413; c=relaxed/simple;
	bh=T2sLP2oeRDeHG1pV2erpQ0w0oVWmvQut7On3/A6k0lM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+kaTm20LXr1H8DvA5jAn99ys3CDVgGOFbBMoCi+j5p+DcKBUBGTbRMidT+07B66kAgl+T2PgKIWmDPNCBShb6x43BEE2Ibm7rB9ji5rr4i8ALRIPvjx0IEHGSgw9teKl4Kt0jjHUVUjFkYQWobaH55aq1jwmsXIfW1sqpYxEi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kx5EkFgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kx5EkFgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598181F000E9;
	Thu,  3 Sep 2026 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788434412;
	bh=Gt8eVWRc6HQ97iMF7wG1orL5+A0dq4VgenIf5MOVqjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kx5EkFgwK5AQrsFRwQv0cLfpPlxyUJ5fgU/y8tuwhuBUHUo+QETeyyUCVyXKciBj+
	 jekSJyzf0QrKrt6/P1n1Eqo1Nv2goRG3io9/KX4+A8CiZqS68N4aJtbbpfmJiQ7k2J
	 mAjJwR9kHyG32Od/yeATM0h0XkM/V4CRe96otXBf3lJlRw4mGs/sp2nywNyy1YccTF
	 7bJkqb1yC5P9KFQpB+YX2HKDv9EoqWxmipUlFKEoKgdb9poAIA/+xg7eHC5f8M1q/1
	 KwW+2vgXweoLVHvcnTysX2Or5Xh7eGv9lFH7fzMaqaRytIfLlX5OB/hNdzLIeQ7/ZY
	 a54h433truBGw==
Date: Thu, 3 Sep 2026 13:20:08 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_db: print configuration file for mounted
 filesystems
Message-ID: <aplX2oKCA3xkdhY6@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
 <178821870646.2381199.5915299797285495548.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178821870646.2381199.5915299797285495548.stgit@frogsfrogsfrogs>

On 2026-08-31 16:27:20, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach xfs_db to emit a mkfs.xfs config file for an unmounted filesystem.
> This can be used to create a new filesystem based on an existing image.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
