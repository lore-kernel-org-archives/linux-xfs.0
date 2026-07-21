Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37461370D5F;
	Tue, 21 Jul 2026 10:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630699; cv=none; b=OCgxSEkgtPVtybUILbKF8NWhwKDalYHI+mwlP4cv95HSjY33SK+tYL038KAsWkZI2IBRLbRmXMStpo5kYI0jXTFlKvz+NOyP9cAY02qUCUT65/0JoLh0WAee8IRgczIul5yeVnvOYMCifpN1NcJIvkllNYpm5iWsPL8SlB/ei1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630699; c=relaxed/simple;
	bh=GpB9AilSZ5CezBT0sFsgun3VzqNlPTiMzsiEaIEMflo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=J/3ZlUiSnFP8/uTY2TSuhZh0cblwSZPavVY0LqJXFdL0Byqkkb3UjKkY+d30OL6a8wUW1NWrYW7+RuvfWbuQlLRUfaqjlcCzjYtJzXl2tE3OxMGyV91QUMnuw7lMZ9EHNYIsJmDFIJk8W3iw4uUHCPT9P136FHkDZ1hDKY98sRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8GeDZrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8GeDZrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E5D1F00AC4;
	Tue, 21 Jul 2026 10:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630688;
	bh=iwWKtxT/1YgOwekF2f4j5+DDR/tsLEs+2T+xru8iFFY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Z8GeDZrMY0H5lq5zZ7tByOXQn3aPUt2eiKr+WETJRd61IN6Zd8Z5qKR3ryUTEtYMQ
	 1WTiWaDyarQeL92av91Ri6XRMwWyNzAXv2dLDnt41DTf4xyB6u573xAYHWtRiajtT4
	 0CMy+wv7tyV76HF49sgIqgqiKlf3C22mKjZ8NoZ53hpsm7tVbbkyNSlvaeT8DIPsx9
	 IU3sy2+xvBe61SNA7gBMKJQEmg/u5Emy7Fy5vEjmc3Y4IJNZCueOv5TbwqcYDWbUWG
	 pB58Nu3gSqFlAB815mkKCulUV17GfkSsxWIcLgIa7CA+exrnZ4lCrEFZwjOi80reMh
	 SRgaQEpe6nDUA==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, hch@infradead.org, Qiang Ma <maqianga@uniontech.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260716092245.1847930-1-maqianga@uniontech.com>
References: <20260716092245.1847930-1-maqianga@uniontech.com>
Subject: Re: [PATCH v2] xfs: clear zapped attr fork state when bmap repair
 finds no attr fork
Message-Id: <178463068664.324722.539069507612436578.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:46 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Thu, 16 Jul 2026 17:22:45 +0800, Qiang Ma wrote:
> xfstests xfs/377 can make xfs_scrub repeatedly check and repair the
> attr block map after inode repair zaps an attr fork.
> 
> When inode repair zaps an attr fork, it records
> XFS_SICK_INO_BMBTA_ZAPPED so that scrub/repair can revisit the attr fork
> block map.  If the fork has been reset to an empty state and removed,
> BMBTA repair has no attr fork mappings to rebuild and can return success.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: clear zapped attr fork state when bmap repair finds no attr fork
      commit: 38cd012fba2cf65007ff804913c1069cf82a1c0b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

