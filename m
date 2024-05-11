Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901225024E;
	Sat, 11 May 2024 13:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715433873; cv=none; b=QZj2cvwhYH8+vVDKxhN29jeG5uvnZL7JCLObz99W4Dmzhh5WZ1+I4pydIbrivIOiuOBqqZORgQkNEjyXVRxayIxhj2MnjvbthYTlx7ZLmzA9dYQBO1QEQXUIfJK5qiD3XfZhkNxYqUMcUnYNDj7/98CpOdOMJiE+6pN6klFWIyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715433873; c=relaxed/simple;
	bh=KWhEen8ZyWUOJdiJh62Vz4ZCTDGl/4g8ojbSHG797vI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YefIp3P8E+sPzoultRzfBBVbIwtspWoAvp6ycJPj7cw0b3GfI7rsmu+xDre7IWzLQBVQas6yH1sOiOrWLEq8pybP1Rqim3Y3bJMb2YhQj2h3+hhX6jq5e6Rz1VniFKAU1YSJM+nSzoNwt8avzx1BgmuIJOMs3xW9uFOXEZSE7kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QULweFxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QULweFxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3934C2BBFC;
	Sat, 11 May 2024 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715433873;
	bh=KWhEen8ZyWUOJdiJh62Vz4ZCTDGl/4g8ojbSHG797vI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QULweFxHSdW9seBEWq8qZd9TNrEruezuRB1ZfbKGZaTzZG52lMm3c8HviDzHZZGuk
	 d3Wlplscsi33wQVAzAHJ2Y3Ze3gdYsjdIHw2gs767Jqw6aJvIh10GzlyYzHO7YVn2f
	 FetG4BKTArzRLEcRJvd0Y3Lu+JOMM7Ps/Q/sQ3E/hbiqB70BI9PUMYtPkkZGKpdkT+
	 oSub4CSYzULx5mOx6wqKwtkDe/0gONfpkgipa0YyvXhGN4J/Jm17JthhsAkll3dQ5l
	 SeejPL9UarSIabXUtViJKMN19KY/LULyUInYL41hfLpWzHqT2H0TfNb1Wbl00IWfOM
	 g1pdxM1T9+QWA==
Date: Sat, 11 May 2024 09:24:31 -0400
From: Sasha Levin <sashal@kernel.org>
To: Leah Rumancik <leah.rumancik@gmail.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, amir73il@gmail.com,
	chandan.babu@oracle.com, "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 6.1] MAINTAINERS: add leah to 6.1 MAINTAINERS file
Message-ID: <Zj9xj1wIzlTK8VCm@sashalap>
References: <20240509201735.2208865-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240509201735.2208865-1-leah.rumancik@gmail.com>

On Thu, May 09, 2024 at 01:17:35PM -0700, Leah Rumancik wrote:
>I've been trying to get backports rolling to 6.1.y. Update MAINTAINERS
>file so backports requests / questions can get routed appropriately.

Queued up, thanks!

-- 
Thanks,
Sasha
