Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D16285CBD;
	Mon, 16 Jun 2025 12:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750077111; cv=none; b=d6CYyHpHDApk+frHpLNzOaMCNGkrUxe0kg023aSC46C0mOEx2rJ5PuzoiGYgfRIDvpkqun0R9Vam/W7z/LRfBTHjCs5f6us1Jpy7m0VzTzTBDcPnCR5clSxWSPPAHpo8OKQpSIkUuwR5D9KH+d0Ry3EeR0iKS8Zz+5tg/IEgwHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750077111; c=relaxed/simple;
	bh=LhF2XQPCqohR/czee1W8JdwgzHMldD0cFiT5vcMrzKQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JIZz4GqUhKcCUjXqrHhvojoCmIzPsbHKgUGmGb92sblEyaMXrJ7pa0cncB91vKRmLr0ehvckrFENqjGmXEbG7gnBAY82Sj0PN7ilSLQcN/xEFbcwGvyvN0yADGo5snGUo+WXHp/Fn5wybdN3UMceidnkn+AP7mOw1lDLPK3Ulvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=soPJj+Ix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="soPJj+Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14313C4CEEA;
	Mon, 16 Jun 2025 12:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750077110;
	bh=LhF2XQPCqohR/czee1W8JdwgzHMldD0cFiT5vcMrzKQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=soPJj+Ixvqfvuscg3p29wuoJYSQlS6XVFNek8qOTGi/F/ouEdClCbMF4Ldesal8Fe
	 hguhoVwXjCs8rULEn4D2lgzOSy0olHlm1shPnXu2/ShE97FhORjVBnjkwYZGrY0jgY
	 SFT+kLZu5vGEW/okNx/krgZOpVEhboG/T8Gu/wvbn3IuepBh9GntTqQb/Ab0ZuhZb2
	 mIuTHyfyiSZzMZCf0t7c98AwpDxNMim96QeViKChEim/LJwHiVdObeWrzTlGUA3HEv
	 0nXwZvE/rqmP9MQHRhVXriJra+GQfUmyIBaWqab8oV7L/zN4PqNSBpKu6o6pi6vKct
	 JgiE2198cB+jA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, 
 Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20250612175111.GP6156@frogsfrogsfrogs>
References: <20250612175111.GP6156@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: actually use the xfs_growfs_check_rtgeom
 tracepoint
Message-Id: <175007710867.485207.14307189296641516715.b4-ty@kernel.org>
Date: Mon, 16 Jun 2025 14:31:48 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 12 Jun 2025 10:51:12 -0700, Darrick J. Wong wrote:
> We created a new tracepoint but forgot to put it in.  Fix that.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: actually use the xfs_growfs_check_rtgeom tracepoint
      commit: db44d088a5ab030b741a3adf2e7b181a8a6dcfbe

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

