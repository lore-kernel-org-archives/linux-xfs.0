Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD6D1CD3A;
	Tue, 30 Apr 2024 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714480603; cv=none; b=XXSJHLWyx0ot8z6gEOvwSegCGtXDCd8loNHxUHK9lKgM9JQ7drI8+9+TnoKr/t8xY1CkWNI+AeIEQUAdd3/LKZUN30XVAGl6uXYIZCwL+JGJyRuMB0dHU53U6W95/AzUePDl9J17zvkEV0vNTiz9LIoHJPZQ+U0ObQNtGa66N10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714480603; c=relaxed/simple;
	bh=rJxidQsVXLJaYPlkC3TY8fqNCvXDiIaVDIdpG+dVVUE=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=G78krx4cb6Fn5T03V6hgTezA7BWx3xCDat8X440ztYrhkrqFWpUefMpAuRuxJz9Arhq4bufiPkRqSU9dTuWuWurA85XhvW/kDMGdwbGuoWBYpsOUsb0g37Pct9rSsW9W5eIENaE2xLoDuYxRxTq4sJVJbLpAcDmj7x3CDbjc0V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s0D4nTE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0D4nTE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4ECC2BBFC;
	Tue, 30 Apr 2024 12:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714480603;
	bh=rJxidQsVXLJaYPlkC3TY8fqNCvXDiIaVDIdpG+dVVUE=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=s0D4nTE+cDFyni0FcsIdQaW3Q+6psjlRqL9qNZmrTRRlJxp0Dn5HZxP3yKbLiOrWc
	 tVErjXcDdLlEKoql/53/NKsfnbduN3iCSqiB3LwDzgWvgNcwcowOk4Q5VjSQS83RpR
	 0ItItFzaauMUjXCxrNXh6pHf6HdlrG1V7a3zRG5fRc5rg12jSYSuJWj4qnpXJC4K0A
	 hZpsC0z6UBZZcVyksk1h6e9hrwSukl9WKblELavzp8TI8FfpPkAelIaCM0CLDOOBOQ
	 oTE3G9C+RzLTUmYW6tFWebLTfA4oyqNNUkxulhOEKHTGCUYZW0/AGnbhYzBa9yoH2P
	 UX7h7MzkxzLIQ==
References: <20240429170548.1629224-1-hch@lst.de>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/077: remove _require_meta_uuid
Date: Tue, 30 Apr 2024 18:05:24 +0530
In-reply-to: <20240429170548.1629224-1-hch@lst.de>
Message-ID: <87cyq7kox4.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Apr 29, 2024 at 07:05:48 PM +0200, Christoph Hellwig wrote:
> _require_meta_uuid tries to check if the configuration supports the
> metauuid feature.  It assumes a scratch fs has already been created,
> which in the part was accidentally true to do a _require_xfs_crc call
> that was removed in commit 39afc0aa237d ("xfs: remove support for tools
> and kernels without v5 support").
>
> As v5 file systems always support meta uuids, and xfs/077 forces a v5
> file systems we can just remove the check.
>

This patch solves the bug,

Tested-by: Chandan Babu R <chandanbabu@kernel.org>

-- 
Chandan
