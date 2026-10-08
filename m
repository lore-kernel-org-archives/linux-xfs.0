Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FCC446053;
	Thu,  8 Oct 2026 13:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466369; cv=none; b=SuUcL9HtGmE1wH18/QqIBjDnKHRsDRQLfPdk+UrEfO587Ks9BOSLtIErD39+2f2qMh2NgUCpyO8CuLO/HV45gIuLjFsW6ZQ0Dc9jWKYafu29wHIdCvuPFznacCa4qcp0RGIF9xheUIO1/VYX8xRFhdF1JOij3lTEUSYnFkCT35M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466369; c=relaxed/simple;
	bh=LlnHri0Z2rhgSWemq19F5S1F/AigVUhj2tbIew60HDE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rmX41g8OoB3bLPfJoqXxKOadcE00zXc7uDmtEbpCIxGn5+xsJeCz0XdvBSnMF8nXXwtLaHr9YQowOgZv0LzYoLUWgzH4kgN9qqEfpdgPglOKAd99cyydPlfpycmnmVssAailAnyuTA2Gy4AuEOVfxkA6R/Ik9gP+6udsEU7Lq9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5swzelK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5swzelK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6630F1F000FF;
	Thu,  8 Oct 2026 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466368;
	bh=1GkUnfJbbqRB8kjEybiXKTxONql39AbevrBAWpEmv9M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=c5swzelKLVjFkXF8+wclq3Tf3k5EdyHn4RLH3GBbDKxQKuc600MRP5q5fICwE1Y6n
	 sK85zCautGUti2yzymMQhQiyQJOnsARfERVSWDVY5FUgeVwfuVkLVBuspBP+XntXLC
	 0sKoe8dyJ0hc6vak/fCgSvchIqM+tC3X6lYdFEllw/+b8yHKVwO2buojtkRbc3+F8E
	 kPq8FTzFZEO1leNy5M7uD6EVHrqhbUZSLi3W2UaFKFoZaISpOkAvf5zMN//ftXy6kU
	 KW3IUWOFXqKdLr6cPeYh7LeInP+ZPge5NKmixb2eYRFLV7yBb15TPTNQtf4e/EAs5d
	 Q6q31PIDzKx0A==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
Cc: dai.ngo@oracle.com, hch@lst.de, djwong@kernel.org, dgc@kernel.org, 
 sergeybashirov@gmail.com, cel@kernel.org, jlayton@kernel.org, 
 linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261006003425epcms2p586728e55ff5f9bbabc506b672fc4a421@epcms2p5>
References: <CGME20261006003425epcms2p586728e55ff5f9bbabc506b672fc4a421@epcms2p5>
 <20261006003425epcms2p586728e55ff5f9bbabc506b672fc4a421@epcms2p5>
Subject: Re: [PATCH] xfs: map pNFS layouts to the end of the extent again
Message-Id: <179146636404.378461.1931859114820869361.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:44 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 06 Oct 2026 09:34:25 +0900, Daejun Park wrote:
> Since commit 36ca6f11424a ("xfs: fix overlapping extents returned for
> pNFS LAYOUTGET"), xfs_fs_map_blocks() maps only the range that nfsd asks
> for.  For O_DIRECT, the Linux block layout client asks for the range of
> the I/O at hand, so it now needs a LAYOUTGET for every O_DIRECT read or
> write to a part of a file it has no layout for yet, where the first
> LAYOUTGET used to return the whole extent.  Each LAYOUTGET is a round
> trip, and xfs_fs_map_blocks() takes the iolock exclusively and writes
> back and invalidates the page cache of the file for it.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: map pNFS layouts to the end of the extent again
      commit: e3c682dd11303a95ff82ea63b9172dce788578d4

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

