Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CF82222B7;
	Thu, 17 Apr 2025 08:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744880146; cv=none; b=eMhixY3ykzTu1YY28lvNohyKN/+u1SMSg1rZH7X3wv0WMJZauSojT9OTVeTfkw1TLH9A0kBuBBXlCUiUobx7BtUDiH875yCmUzfu8EmunsMTYB9LYTwjK1E2xlIC8wOcY3g/uuv7R2PM6BoGW4it4MhW87MHNWMIx0BykiHVTfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744880146; c=relaxed/simple;
	bh=Z//tAxRqkIHfiQMr8YMgUFo5EMGHmTTTBoHXLOWf+Bk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cyNB3NLepljtbWt2Ir0opRoqsYEXJXrJ5dhsRWNVb58vA/YFuSyT257owzgDNfOevGZZXJAE+U2QegdHfbB2ag0ydLPA4POi7J+OhyS0F5uPBAI4PBJc3YyXe6eGnICyb+iYQIM87fug4XRdlVfk17sRYnK391BLVzETgoFliqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KL/ecD2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KL/ecD2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F4FC4CEEA;
	Thu, 17 Apr 2025 08:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744880145;
	bh=Z//tAxRqkIHfiQMr8YMgUFo5EMGHmTTTBoHXLOWf+Bk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=KL/ecD2DsY5JBht3EC1wVbvvWw64azU95ITwstsx9TmyssnyaaVzEiXGk5735+IBN
	 Ifr59T1UaVu/xJZz9Vh2ZgOGovqT/82d/KZCVmq45hJsziQHQ8c9UpnmTN3nHHVFYP
	 aOBR9waNnu74NaiNME194Qjuiwo9UYHvDkkUI5/HTKOEq6h1FISmex0agzEJnDxJMt
	 CTEI/0KyRs55vGUvBfPHgBMJMO6/pXy9h1v3ATcmZxcCpNblEHjw7lzeCnRge9PgXo
	 raIwlzJcim28ENoWk3UChrWJ6KrAzXiUk4X91KrPYU/G277GGEv/Qtj4j4ZLaOAq8B
	 JQBsL9Io4Hoaw==
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250409123947.14464-1-hans.holmberg@wdc.com>
References: <20250409123947.14464-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH RESEND] xfs: document zoned rt specifics in admin-guide
Message-Id: <174488014424.437909.4984133297419613803.b4-ty@kernel.org>
Date: Thu, 17 Apr 2025 10:55:44 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 09 Apr 2025 12:39:56 +0000, Hans Holmberg wrote:
> Document the lifetime, nolifetime and max_open_zones mount options
> added for zoned rt file systems.
> 
> Also add documentation describing the max_open_zones sysfs attribute
> exposed in /sys/fs/xfs/<dev>/zoned/
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: document zoned rt specifics in admin-guide
      commit: c7b67ddc3c999aa2f8d77be7ef1913298fe78f0e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

