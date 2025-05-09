Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908E6270543
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 07:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746775723; cv=none; b=g7dbkumASmG7QB5QrvmppIKBLL2Hi27tYgWn6uV7iBQLi9M8p8lT+QviahzCnsqdHzddRZM9KSFJfJ2OIRvleIg66GWlbg5qdPoP7G8sZijAaVb8OrqvNFcWKxw8wZcnPlOPDGtT81onSebWQ5Sg9U42rjRAcfJy1Nu5izOMOI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746775723; c=relaxed/simple;
	bh=OwUTWqCFH/+93+PgKRs+TBYJYiyuqrVr3936Q+cwY4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUNfFTK6MnuwYbXKZWBDVKKgwiYagyCvfnDruFJuyxXi7M5/feQX5JEjyOKHpo9agv6DPoN87TlnwemGxm5ciDuY9cd9izyGAV2p41SQScfRuS9txJs6R2OZZNHgH6cGM2GP8wrrcBnqgbrhzIDnJVM378SFGfa31VJFyiMx5Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBdUrifa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBdUrifa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3119CC4CEE4;
	Fri,  9 May 2025 07:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746775723;
	bh=OwUTWqCFH/+93+PgKRs+TBYJYiyuqrVr3936Q+cwY4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SBdUrifaKMfFdYqsdq7lR2qlIGLvABW1sMtK6K6bC/PyBG0Ro8OeHaOzcpq1SEk1c
	 sX8sfqCpTBv83BJvx4KqAhQSL4ifDu++1I61qJYZroOuiyc/apCowgQjCP+OaUiOV1
	 BQJ3qPsg2fnORWryD2g0P//QpLHmpggyyl+EgkoAQzeS2D4fpkPF45X9fKbU0ZQ2Lk
	 JksknsSgP4PMdetkhHM4YHpi6qHZzI88gnREUstC6AII8Ho/wTWZiAi7uWx4UNA2XD
	 VnPQoqDNJs2OgosGe0gXzHIdXtjV4Pc9ruli2p7EoEW5ISgezA05hcmQUAUnDWoCZH
	 GIOiuSnmCQWgA==
Date: Fri, 9 May 2025 09:28:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix comment on xfs_ail_delete
Message-ID: <dthhrzrjtjaowfqvlzsnupzt5wtp5kj2ff53yvcdm5jqj3nijw@ygcpmychio2m>
References: <20250507095239.477105-1-cem@kernel.org>
 <20250507095239.477105-2-cem@kernel.org>
 <eEMIbb_Qpm7PNuV3ytbZvZ-vFvHhx5WO_n-zjPO41JjySrxz-tUqdWbRF_lu3pRAUyhy-2vffy8XXVTd5isAVg==@protonmail.internalid>
 <aBwv7BRl41AsM0ji@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBwv7BRl41AsM0ji@infradead.org>

On Wed, May 07, 2025 at 09:15:40PM -0700, Christoph Hellwig wrote:
> The sibject line should be something like:
> 
> xfs: fix comment on xfs_ail_delete
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Will fix that and send with the V2, thanks for the RwB
