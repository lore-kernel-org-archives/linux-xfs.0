Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C818E3AA4EF
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 07:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297759; cv=none; b=c+hKA81Th/WwFgK3yzj9ksiawonOKsNBfA1vPi+AupkqcmZbN3w6QMb3XqV0onL2Bgl3/M/sr56QKjfa9AbI2kT+n3DZhXELrYhUaBBEPy7MfjtuhBolyo9QxIfvLHRqG5y0v+UMGD5G5NcqOhMWN1yg5cpWHdQz1imp7/IBaFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297759; c=relaxed/simple;
	bh=aU1UZIZ+fYyrvaZjK1gFjeV8xepLtxJcRYxBLZWIt18=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OA5pH3LlPX528T0HvGSLDoAC0J++E8TzUIkfmHuGNSsS3HbtdWi2DCIJ7rJ2juMiefGoqIkGXDJIpQHYtVtg0wrnxxlbKft/SAAVeXQn3/EUM2OtAArwsfjDWOdyKebuPN2xGJ/Fie18zCm+KG4szefvZ71bvwlu4XmFEGB8Pwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSZB/1jY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSZB/1jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA70A1F00A3D;
	Fri, 21 Aug 2026 07:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787297749;
	bh=K3SJ/FEiCm4rUmMDPKB0ljEJiY3OZgC7lwKKf5FsvuM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OSZB/1jYc7COwosm0aFtIjmS/4uLYppcg2MUbUYYvDAWGtj1bWKCvLo1LJ6OINBDG
	 7HavmZFkQycJfDb87Rc7hHlJmYkmzEYf8iMo8F+wvIbTFvL5m+u8ybpPqJhJgLPcUl
	 Q8hb3n4QJl04PJtAlevdawKz6iBb6k9k3yTRpFHSHKlQQqTWx0sxt+sWo+rVODwVZl
	 lk6kgp+ozvuV5RkEs6hJswYlcAxXbiJLzXg8W5EHabVgYlUP8iIphwelZp/KNEgLA4
	 X6TnN4kSpOmfJ9SGVPfgH5PRw6l6XHlOor0vncW8hOYaDPgZXy8oQW4U2Chcp+e2LD
	 ed+FFIF0gahBA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260720093612.2186703-1-hch@lst.de>
References: <20260720093612.2186703-1-hch@lst.de>
Subject: Re: [PATCH] xfs: split an assert in xfs_trans_log_buf
Message-Id: <178729774832.580975.607215713102921815.b4-ty@kernel.org>
Date: Fri, 21 Aug 2026 09:35:48 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 20 Jul 2026 11:36:12 +0200, Christoph Hellwig wrote:
> Split the "irst <= last && last < BBTOB(bp->b_length)" assert into two to
> make it clear which condition fired.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: split an assert in xfs_trans_log_buf
      commit: b9b541e70d465a8c9cadf697eec7cb15b6653e7d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

