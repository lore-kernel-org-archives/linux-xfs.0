Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B292EB5A1;
	Tue, 16 Sep 2025 11:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758022485; cv=none; b=gCazxsbKExAGW2W5mZs+XMaQ5Jhg88kz8kskoUBO1IwpvS9K4Xsi86Ro9V+hIyD1VajAV+445bnVTz31iXZkpDvbY6/9/AlqNF30fxec7aGMNKyuwxQdbQIAVVenAN6gdhnWIcD6kGIP0Tp8lQ8Ev1JP+r8dd3R3zcdbIheAkw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758022485; c=relaxed/simple;
	bh=fUlsCnhWDAw/qI7fsKIj7DPbYIqynrXHXjGxmYrc5qo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EIzQ6m/f8gjinufvka20UK5XBVc/Lb/D8bGPfvJM19H/19eI4dOu/qs/Ux6L/cChBEn874T6VE3inQGg9teI5hodjSSyYBhESwraHgSEreXqyUZaexOqSBrjiGUu3uF8BesPEN3FRnEkz1AXvUZtFjeopuNVyBMsMUnf+bzksr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4X0Htkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4X0Htkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6158CC4CEEB;
	Tue, 16 Sep 2025 11:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758022484;
	bh=fUlsCnhWDAw/qI7fsKIj7DPbYIqynrXHXjGxmYrc5qo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=j4X0Htkp5m2f/chFl4OextuKkP9i1oriE5nT+TZLWRoaA2IZIg6vF8ZJaJ+iPXvo0
	 IAZT7sh6/8lR/ahQCLbDbtjlK8qwhCXAnXEfMIMzy197tHhvNDH8fxGzNIxWQnNgAq
	 j5BuBjppNkKDHLwmuJmtvd6wjQEb758TmXE7VDEdLRDPZ25rBzXmGwYolAQ5kVH157
	 cGFUFwYY36CwcMAlRfPsqtVo57WcHRYVzwyB/xJ2RmJ80WXwE7Dq5yH3ZQvw/BsLSD
	 zSRH9UK1C5e0XRoRNR23SS7zOXQurQfSCIhqcjPnGvAyeXCua3L5QiKHQrUaliUp5S
	 Sis+L+WyT10Zg==
From: Carlos Maiolino <cem@kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 Linux Documentation <linux-doc@vger.kernel.org>, 
 Linux XFS <linux-xfs@vger.kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>
Cc: David Chinner <david@fromorbit.com>, Jonathan Corbet <corbet@lwn.net>, 
 "Darrick J. Wong" <djwong@kernel.org>, Charles Han <hanchunchao@inspur.com>, 
 Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20250909000431.7474-1-bagasdotme@gmail.com>
References: <20250909000431.7474-1-bagasdotme@gmail.com>
Subject: Re: [PATCH] xfs: extend removed sysctls table
Message-Id: <175802248202.997282.13567404398222475250.b4-ty@kernel.org>
Date: Tue, 16 Sep 2025 13:34:42 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 09 Sep 2025 07:04:31 +0700, Bagas Sanjaya wrote:
> Commit 21d59d00221e4e ("xfs: remove deprecated sysctl knobs") moves
> recently-removed sysctls to the removed sysctls table but fails to
> extend the table, hence triggering Sphinx warning:
> 
> Documentation/admin-guide/xfs.rst:365: ERROR: Malformed table.
> Text in column margin in table line 8.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: extend removed sysctls table
      commit: e3df98d30369d7859a855bd3e500ea46205640ca

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

