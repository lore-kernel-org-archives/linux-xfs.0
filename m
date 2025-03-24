Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97821136988
	for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 08:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742806331; cv=none; b=GFspJH2HwzGMgF0kTEK/z0FXHzhYLGc8XK9AyUjLFT9lrUSLf+1SVnEKJvrBvJsaO3q8u+k8VHuT1BYjQ6dqPfUD2OO3o4/+ndsFhX0a+Ucfa+vpFxQGhziXu5dEAkVZdz4ffk067xgdOlAfbWUIbyQLQSrtXrwurEqjlTAnukQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742806331; c=relaxed/simple;
	bh=dIlElCLIWSI13AfXZRP56LuD3xcfFaBaZskCgYcF34E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ALn8AClFV9urv37eEP3yHgfkWDobuZAPIi9JOAKRCzxalokPbpfcI6yItPLj6YTai7mLWyYNx8NTWQiIhmdllt06mITjmJWz0vRXRCeVc706FdEz03faS61XyTpRwUim102SAHf8PGmXHloVX1yfRldTx+tPqPst2iebwJxoiC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZGcS6kG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZGcS6kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35C2C4CEDD;
	Mon, 24 Mar 2025 08:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742806331;
	bh=dIlElCLIWSI13AfXZRP56LuD3xcfFaBaZskCgYcF34E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=hZGcS6kGvZAHa3T5Md7fYG6MrT6BktuFVRsji1lOi1tVlQfZBE2+DfSIrFIInUeCO
	 6XsOWCEVT4UXr7xVmsYJRSq3OkLOcz5Cofn+V2wh2hybEawUV8WAptxI/i/JzYyOuC
	 m8abpePYoPCrj2RwlTaAqSNcwmBBwWVM0YAwSu02xY6euv+sc1mP5OJ4oONehqdIh2
	 FXEMdUoaKz7Yd3OAYItOzm6N7aK1zKtTaX1vv9ZqhGl12Tke/WvXRbYAmnfKv35tYz
	 3M3hKdwfw/uUKPXdB6XqY94T3vWygzi6JaqF7pHxVXqOSe1g2KX+RNnSma4v8a1UtU
	 QmF5p3dmzJRIw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Dan Carpenter <dan.carpenter@linaro.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20250317054512.1131950-2-hch@lst.de>
References: <20250317054512.1131950-1-hch@lst.de>
 <20250317054512.1131950-2-hch@lst.de>
Subject: Re: [PATCH 1/3] xfs: fix a missing unlock in xfs_growfs_data
Message-Id: <174280632955.284683.5178000607075767414.b4-ty@kernel.org>
Date: Mon, 24 Mar 2025 09:52:09 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 17 Mar 2025 06:44:52 +0100, Christoph Hellwig wrote:
> The newly added check for the internal RT device needs to unlock
> m_growlock just like all ther other error cases.
> 
> 

Applied to for-next, thanks!

[1/3] xfs: fix a missing unlock in xfs_growfs_data
      commit: beba9487138151c17dec17105364b35935f21562
[2/3] xfs: don't increment m_generation for all errors in xfs_growfs_data
      commit: 9ec3f7977a32f2045ef14445f165bcd96e596344
[3/3] xfs: don't wake zone space waiters without m_zone_info
      commit: f56f73ebf8bb13d72b93e490c1f175a0a2c836f2

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

