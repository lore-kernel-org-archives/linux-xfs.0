Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A5E42DA44;
	Wed,  8 Jul 2026 16:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783527496; cv=none; b=IN2dVvybIrWRhyQsaCI18coa7R6veaHwd1A7Yl62gS3J6wHl23P+c/MfMinkw0qR+QUT2avCIS+94Mhy5NuwOutUU4ZaTqVIPioTQBgid0ygJ1GTsw3ggh3t6+xYQYZ4ZR7Tw8Pi4QJRnSKZThJaghJlxdugswOSu1O5KafwEnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783527496; c=relaxed/simple;
	bh=g6M3lGbwNCXgQ5KgLhh/+rShX5VadDF7bwG1iRenO6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ9pgXySuHXYuITmJYsY6WRnH592IDlqx0Stfi9FbyOKnjRTZC6+aum/gKp91wuVupktUmk7BP2S+EuTt+6Imx8nXUTXGJ8Ov8xWJ9H9ZyPDKC6ALHSa3HGHpWVFthNkRinAaVqcy3WNIDkNVucz0nW9pMYBY5xQDRIkzfDY0xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bb2Ji3MM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bb2Ji3MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9511F00A3E;
	Wed,  8 Jul 2026 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783527494;
	bh=jKssdYZiy6udKlNV01GqsnyHLqSFgLJHIAJ0O3hJg4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bb2Ji3MMofOwrfCPD9WmYbHt/0TR4qmaPEKm6cLd+lywOAsljbIVW2WYfgLAH12Qy
	 XOmcU4Sd3HHKftB30QlTctZkh7oLs9EP9UTuNWHpI9cmChLobCrdipI4vfip1Vv/ZU
	 EAVkMmiBOhZpOvi3Fks7c5LDd83Ju/EVCO2GyWxO/4PgdlqE/4cusG6iuIUeWfI+3f
	 9tA5RRPZgsdPhQENMGCgsoTWFH1L6wFu2yr9e5dKY+gLjhOWpvM48QXoXQDpSaFnlP
	 Ags4V9BPmjPqRqkZ9ivxVPKDqL2Mat7nCugMCT6hOqvABBNnZzogMSllbBSu2Z8ztf
	 PBd35A9rA9JsQ==
From: Sasha Levin <sashal@kernel.org>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	stable@vger.kernel.org,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	lvc-project@linuxtesting.org,
	linux-xfs@vger.kernel.org,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
Date: Wed,  8 Jul 2026 12:18:02 -0400
Message-ID: <20260708120504.agent5-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ak2bBIGLumgLD4nd@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <ak2bBIGLumgLD4nd@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Jul 07, 2026 at 08:34:12PM -0400, Hamza Mahfooz wrote:
> I ran fstests both before and after applying the series with "-g auto"
> as Amir suggested and the only meaningful difference between the two is
> that all of the tests after xfs/234 refuse to run on the unpatched
> kernel (presumably because of the kernel panic). I have also attached
> both runs if you're interested in having a look for yourself.

Thanks for running these! Queued the series for 6.6.

-- 
Thanks,
Sasha
