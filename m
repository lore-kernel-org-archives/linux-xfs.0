Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDD73909B5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262835; cv=none; b=px9ljcOduF+/nak32sRCGuydTeH6yCrFKRQhpPWfWpWoVVzEV+DSoT44QRy78joQ4hvdjIaDF4HX3Km09mW+EFtJhwEGkepnSeZSKhGubYF9dGJvSJMS0sgmaP2hCmJ8HDmMWkTaA7lk6RlESWeTmM3hV0Mvv0qeaA7DkoIRRGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262835; c=relaxed/simple;
	bh=hQzgX9HTHQk2SQnV7uKr1823RS2PZzRNPcrd4/RLkA8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iBXGgbEOBbAnCnyqh4psmKiL0AEbDG7YbFv+x9J40YN8jmFowarHWzMgbRywpSVh6VYkDYDxQbGqxw9T0j+wj9xSeONLqZLpF+B95Pv8aQpxMcEz0a5FJGbXz/Mf2deoY4voTFuvWk0M+bZG6RMYxwF3kCM887ED+HgrK3lqAWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KccbD0xZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KccbD0xZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA7AC4CEF7;
	Mon, 23 Mar 2026 10:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774262835;
	bh=hQzgX9HTHQk2SQnV7uKr1823RS2PZzRNPcrd4/RLkA8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=KccbD0xZDO1jh3JgsACWAzppgYuPVT53UkrzTlWms7bzs0v3YPEYdRmQa6MUvfKPm
	 NSOJLzaJ0Nhkabdk8nGgCYV3/ONOOHznJk+JkYRDHU7koBtDUEG4NBeGg9X87z2rMX
	 AD6fY0G9MoFpPMLEzZbHfQBS/ET+NTm97kBt2uabijT8vXQv9FtlhWW86GYBUx6cA4
	 le5XZAcIKsbdcWZ0iJeJ+gzPB5066VYSBIfl+ps4lqQmowm2fqosqYJdstWsYqBYt1
	 CFQiPwauOLAEmRE81YgUoCQUT9SlMilyOKcEfG7XZ/i05olWG8HHNiiuYPRlMTZzz/
	 YqnI0BHhW25Jg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Lukas Herbolt <lukas@herbolt.com>
Cc: hch@infradead.org, djwong@kernel.org
In-Reply-To: <20260310123021.715566-2-lukas@herbolt.com>
References: <20260310123021.715566-2-lukas@herbolt.com>
Subject: Re: [PATCH v3 REBASE] xfs: Use xarray to track SB UUIDs instead of
 plain array.
Message-Id: <177426283381.254917.14273593301577622231.b4-ty@kernel.org>
Date: Mon, 23 Mar 2026 11:47:13 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 10 Mar 2026 13:30:22 +0100, Lukas Herbolt wrote:
> Removing the plain array to track the UUIDs and switch
> to xarray makes it more readable.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Use xarray to track SB UUIDs instead of plain array.
      commit: 8da6fd088472f4db6199fb68af6ec87fa26247ca

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

