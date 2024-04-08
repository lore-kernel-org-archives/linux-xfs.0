Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77198127B54;
	Mon,  8 Apr 2024 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588587; cv=none; b=C5nxJ9dto/U4yoe7ncUC1yh+S2WD9C481hk1k6+ee0hD97SRJnRBPaqxO1RZATEwospGOy56O6tXtjYg0rR7MpqtAae8kMWXxS5YHsonpnCSbZLYclA4Mlx50ZW6haErq21l1quDGt3Bv+1TyXJ2gfIZ1jajdETOqw8hijU170o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588587; c=relaxed/simple;
	bh=89G9ISlSu9YTcVmzvHI+/SOGxEbUIZoRox5wVyrzdF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z757hOGv9aSlkmI8ckcSCDvT9Tjp8Q51SWa8VIRnD5mNpRYx+FWJBqU27SMMMHk+UDq7rWYOxeVOItq2vhtPk+EnK1VQNkqDnmEZ98iR1bZXOcQRXDnK1if54ojSn7By/A8oWEcUSOnl0VrhmqkhzSofu64N6pyp//vD4atK2Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p9yZMdij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p9yZMdij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F320C433F1;
	Mon,  8 Apr 2024 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712588587;
	bh=89G9ISlSu9YTcVmzvHI+/SOGxEbUIZoRox5wVyrzdF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p9yZMdij79iKRReNqoo+p9m23NAvZQVT3CYSFCN8N7pPk+A3gjXyAJ0qvZv7pQwyx
	 bq+8ycWmOsEyBkWUwBL5cv1IHiB/uH9C0GNHJufnfHqTfSsfwHIe4JCQZTD0dyT0EA
	 ywRXPROThaNCKFqUSNirrYi41PUSZq0Mqu7bMHQChM6jd7A8s+CEg5qdtHrXLpajom
	 eaBW3B305TZyq57aHnpLRB4GzLrD+vH62C3D+8r78ls1K34IlUcCfttWIOghsqtOkL
	 w3yKIXQ2MCjVGWg1boxYyTAhruAW6zantjbxKU/JS9qdTUI8qXpoktZXgbu6Ea9ZTh
	 W0FmYTkUXTiGw==
Date: Mon, 8 Apr 2024 11:03:03 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: remove support for tools and kernels with v5
 support
Message-ID: <20240408150303.GD732@quark.localdomain>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408133243.694134-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408133243.694134-2-hch@lst.de>

On Mon, Apr 08, 2024 at 03:32:38PM +0200, Christoph Hellwig wrote:
> xfs: remove support for tools and kernels with v5 support

I think you mean tools and kernels *without* v5 support.

- Eric
