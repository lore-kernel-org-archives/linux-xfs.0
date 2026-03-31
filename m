Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169E93D890A
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774949819; cv=none; b=oatWEWoZv1cJp8T6u1Ctxy799WZeN2SWlD9Jc+icYo8INFD7S2/OPtLx2sQJsOF0uvBkZu5fHQ/e6fc9nom7WJmVOSLR4z/rYQcTgjL4P+qDm5OPusnVi/rovVDdhZoFVoW4PoX1sY9qKdUtjDWP9ivZ0N7rzY8yEOgWNxX29fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774949819; c=relaxed/simple;
	bh=/3dfDDaOvltk8w9G4ebslAEpf6gYc6V2YsdvDakhwpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OAFY+fL3IOrWD9rlKO6DbdlcugC36LCX1oAewa8viat26UwQ8Ltfc/v7ydreR81IR3UIyFuVDKNyyuFPmTMkivSJRT1AfkahTxRJ/k7UsHOAh38qlCotHkOjFxtJqki35FuCelb43ln1WAsRBAaQYtPVIYXh7JTlgNNjo5W8QcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPJWWNid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPJWWNid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124E9C19423;
	Tue, 31 Mar 2026 09:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949818;
	bh=/3dfDDaOvltk8w9G4ebslAEpf6gYc6V2YsdvDakhwpE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LPJWWNid9n/kulbQY2xLQ8aPIUTyewZI/HY0e7WebS6q2IDHaDYhEKJJd9lldmUo3
	 fm5BKwOjwjtjWItHl15fSb2mla3/KP7zYNhc+WJ4elj3iJqtYQwuaX08CGumNo+03/
	 02UaFSSyDGJz5Qhe007rTGlPWiTXlBd4ELCrgi5anq5BO11bquAYiN72KFH7cPRIIc
	 /6wrJYplTLxDqWxLrea6ydxUYXKTbaric94TpOSWKoAtQyEQI94WM0H6MnpGnk3xL7
	 bMBlLuHCISKQRmWODEeXBB3WyqYmRTQz3AizXJ2nJMIit42d6O5ozTUbOImienzMAO
	 Duef7dL4dNTkg==
Message-ID: <7d25508a-1106-47ba-8f3d-1d1a49166a3c@kernel.org>
Date: Tue, 31 Mar 2026 18:36:56 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] xfs: untangle the open zones reporting in mountinfo
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-5-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054111.3855818-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:41, Christoph Hellwig wrote:
> Keeping a value per line makes parsing much easier, so move the maximum
> number of open zones into a separate line, and also add a new line for
> the currently open number of open GC zones.  While that has to be either

s/the currently open number of/the current number of

> 0 or 1 currently having a value future-proofs the interface for adding
> more open GC zones if needed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
