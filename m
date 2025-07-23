Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3EF2F4A15
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753282890; cv=none; b=Nu5MHX4Ql+ECW81wn+sBl15xOYpN+UZ5IarNsJObSR0zyCyremCJ043tcUXGkz3g55GyBmCkRzK83QQHBh4XVFjmW3gFyAX7gHtOLZpI+fEQlPc9Bmo6PmcfVa8SACaP1pmQoI7BMp/wYBwTyhMouV4K7OULuXvuCWb5rHxpMKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753282890; c=relaxed/simple;
	bh=8OcAPBHspc2yYlFe9pyqK3PEgkJ0i2Q1prCMfBYwPqs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dua4F9Y8X5V9jNcNg1fBnPDK7TCmGbpeNnm9x8/f4XKcN5hlMK7OoMc9t6tngG3pWJA9t5DO0UT48O60wGURP8sIjMqvoVLKZy9JSBO7qOE8+pM+kmNPXjTw1m3S8DzdUkREzDpkab/JH9DiY1PhpPN4XXYOtzPSHoUMbXbgpIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YypJhJpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YypJhJpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9ECC4CEEF;
	Wed, 23 Jul 2025 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753282887;
	bh=8OcAPBHspc2yYlFe9pyqK3PEgkJ0i2Q1prCMfBYwPqs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=YypJhJpmX5f+i1FgnP9L0apQKwmRNuLenr1fRaEokjEDfaFBej3KmUbdJ31Ny+a67
	 vnZOcf+lOYkQpZ9BpW6y03ltXc+d0ZCaXdpvEopdA5mhTcG2mF6fieiu7FRtsrlq2Z
	 IiTohqt2j41ETGO7Q9n0f3suF5EqdDL95p95Dp/T9Ay3qbsGvrQxMmBVY7+tHf/FhI
	 XNlfbXBQXdPauC6hZAyScG7nu5JoS9NuJ9MBzBtl4ISmRIXkc0RdvDFuVs1X9z3HrC
	 gV36mLl2Z484gXm/UeLN1lQCNsCtpSwhKNzbfC3a2ZGO1LnVUnhQip9ZHrLHGet/vH
	 Vr6P2j4hspmjw==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Alan Huang <mmpgouride@gmail.com>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250718034222.1403370-1-mmpgouride@gmail.com>
References: <20250718034222.1403370-1-mmpgouride@gmail.com>
Subject: Re: [PATCH] xfs: Remove unused label in xfs_dax_notify_dev_failure
Message-Id: <175328288631.86753.2650697421264444026.b4-ty@kernel.org>
Date: Wed, 23 Jul 2025 17:01:26 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 18 Jul 2025 11:42:22 +0800, Alan Huang wrote:
> 


Applied to for-next, thanks!

[1/1] xfs: Remove unused label in xfs_dax_notify_dev_failure
      commit: 414d21d65b8e15f2b45aa6d61fa277c7068a5d81

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

