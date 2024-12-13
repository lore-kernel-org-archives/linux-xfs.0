Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0392A1552FC;
	Fri, 13 Dec 2024 07:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074750; cv=none; b=Y2XrNL7eEg53AN+gTCK8E3lZj+T26stsTsl3GJzm6AFvWEqbeAnexcrAaOqI6JU4s2UVfHcUD25TIDFGtmkm4813s8SclL6HmblmQZ8Jx2LmUTcbf+AxpLq1Y1OkvsR4pbtS9Cp9+WgZVPIqj7vQFgd4pjLL9tL3nLXwuFoGjj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074750; c=relaxed/simple;
	bh=TsXpYVWckMnjEMcF4UhCffkGU8fvIcywh4rPle6h6I8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ml3z6nYhG1RL3p5F9t6Uru2mX+091D3lXPGWF6Wwia8rb+cMOxIC8Plg3VlJHpvtzFvOZOj0N1pucL6qloqjRZLZgVDcOAhu4Fp9U+I4VmGvamR2cMhMgXIlFFs4U2a3VqO048CTG5bQ1l/quwxBzBrs2gq7jAsUiqMW88Oohw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQrUHPgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQrUHPgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7044C4CED0;
	Fri, 13 Dec 2024 07:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734074749;
	bh=TsXpYVWckMnjEMcF4UhCffkGU8fvIcywh4rPle6h6I8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=LQrUHPgwE45VqlnfCxegYHr/qyO8/6y1UNLgg+OA1CdHEoS4+RZ8Xu+fow4gs1gqS
	 UbjeeUn9RqpQYjkYpu7vX/C1YmXi/DhbT8GlBztgprWX5K1tPIqCKcmD90FvWZocRU
	 0a6JMqnhfirpf2oqBoNkFW44ziQdZ368KTFQai3e8Xa5jEJV60w3G9lKCsIeqQrdp4
	 Iv5q+39Xz02TJVo4o4QBHb0u42QgjzDMY1E8T5oTiGao7MdZDoARRKHvUVty2ErovD
	 tz+UG78ogYFNE+4mCiM5asGuKOhFb6F4txf3sTTfM5qwuckvcmvAVcQuDkD7UAceBt
	 LY3VUVDFr+81g==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: dan.carpenter@linaro.org, hch@lst.de, jlayton@kernel.org, 
 linux-xfs@vger.kernel.org, stable@vger.kernel.org, wozizhi@huawei.com
In-Reply-To: <173405445870.1255647.17634074191421041925.stg-ugh@frogsfrogsfrogs>
References: <173405445870.1255647.17634074191421041925.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.13
Message-Id: <173407474759.760757.8926159124287320358.b4-ty@kernel.org>
Date: Fri, 13 Dec 2024 08:25:47 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Thu, 12 Dec 2024 17:51:49 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs.  Christoph said that he'd
> rather we rebased the whole xfs for-next branch to preserve
> bisectability so this branch folds in his fix for !quota builds and a
> missing zero initialization for struct kstat in the mgtime conversion
> patch that the build robots just pointed out.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> [...]

Merged, thanks!

merge commit: bf354410af832232db8438afe006bb12675778bc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

