Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1EF22CF36
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 12:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736771589; cv=none; b=QIdKeqSgMSOsua6dvp5XVt76N15scsUjrxO2IY2wo2SW6RsM2kyzUur0hXgAqGNo6Ho5I9EwYJ5rP/IYQNnw6QYyTW5tBTpO5xk+Oq3Yr9e1nTtTprpIWTUKH2/1q7N8KKD/O61jBXaqVFDgkObP/+xO61F36hiDI4zTEhapvIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736771589; c=relaxed/simple;
	bh=6TIIBZHKpIdBVM0tCi3Vhwo1m6QhUGlrAIV9uyypWmg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Qvb8v9A523bdF1fK3jhQ3jiPgensawqcHA/VcXQjRdxAGX6n+PJC0DygrqN78HaVbRBDe/g6xDq6IqaZiKSnr4470ohrktnEHiWp4Ah+Gapfx9dmkJ9T2vwG7aRDRYWTaHnNLyEz3Ffr79viyE+1bgnYsRC8kJPiveJuoqsF14o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCGp4QJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCGp4QJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5537C4CED6;
	Mon, 13 Jan 2025 12:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736771588;
	bh=6TIIBZHKpIdBVM0tCi3Vhwo1m6QhUGlrAIV9uyypWmg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=VCGp4QJt6ijm9868Ny3RZFO69gqcDkQ4aZThp2PsbZYxBaRxpxttSFKFW5dxQlOz1
	 c6WaT5x/JEL34qBqZEoR7wyW9zt4zm7jyqXks3bxkznmhJqFyhAF+gvLfzMDB26Ogu
	 TK6V5OIeg8b9K/tj5YIM6bkLLMhOKGZgTc8NjkWppGn8kj2fR/y1UeDwAoGH4HNZfV
	 jc7yVNuYZK481Smeu0zs2r9davUHXGhjZuh+ZJ6md1w4Shi8IxIVppA8ihwS6TV+b6
	 DKGFDJNis4wgfQvCxD4kddaPOGPvLnmxA+mU3v2lf17bH73bgJf/0Bs2OdaUU8C6Mp
	 xqXbpACx45JoA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20250109005402.GH1387004@frogsfrogsfrogs>
References: <20250109005402.GH1387004@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: lock dquot buffer before detaching dquot from
 b_li_list
Message-Id: <173677158754.21511.9707589214851624907.b4-ty@kernel.org>
Date: Mon, 13 Jan 2025 13:33:07 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 08 Jan 2025 16:54:02 -0800, Darrick J. Wong wrote:
> We have to lock the buffer before we can delete the dquot log item from
> the buffer's log item list.
> 
> 

Applied to next-rc, thanks!

[1/1] xfs: lock dquot buffer before detaching dquot from b_li_list
      commit: 4e7dfb45fe08b2b54d7fe2499fab0eeaa42004ad

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

