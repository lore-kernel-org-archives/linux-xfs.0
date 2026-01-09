Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BE03148BB;
	Fri,  9 Jan 2026 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971026; cv=none; b=iYxeHNUBv64v3AK4zgQaeoo8Tgf2LcNcOeABHXqEzvoWoD5GKwvZD+6pCPZmpHA6rZ6Ws/cCHy+dvfGxq9kWPQc3XCXmnWVyNfMsX8eCM4MyU5VKnapH34hxCtSF3VM55TPnPUOAr8sJKfSCtZFNCREQijjgfsf2Gmdg9mbnfcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971026; c=relaxed/simple;
	bh=MU4L6YrIscxHINz9rWxdKBEEhkbpzgLsEuPMp8ps2Bc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LORIUWknqvIgRtFFihdt4XULBdrmtjj3A+naJd5uP5xiTH1mLPgW62Fa6Y7aMEV5Dv+E8Ul/Hj+LX6Ba6DmlQVrAswE0IPwTAImJjRiz5UOmxX/s9GGKogRwaMepbj3F5y0oW92+r/qwl+9MzYtKCS3jWnRSfcM0Dtzm7x1yf3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G46U0/m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G46U0/m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EA0C4CEF1;
	Fri,  9 Jan 2026 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767971026;
	bh=MU4L6YrIscxHINz9rWxdKBEEhkbpzgLsEuPMp8ps2Bc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=G46U0/m8aaQ3uMsNZZIZ8qEMSkZf5LnjP5rlzG1edLnINv/fKLkHtJhA3dhkihSZV
	 8MG6E6yGe/S2zeU2Avwm5pWXY/vGTUVEelAdECh9kKfgKH+L2ROnw3A4O4wbU0YVNs
	 n3vCH3BKUr9BJaXMryWXM8h0qX5NirW9j2HrWndEq98Zcfs2w5pBylLhJsFUDdWtCx
	 OmVEv2+6p4vaOrGMUkCMwacA1nWoegj6NIcdl6ll494U1dVCe1qmh6tXw9dXRZKYyb
	 aT+EmJfNvQkWHlJdUNmwRK44zG3DeE3eUVAhSKko4gvJ+Rw1ABZ0waJck8W94foilX
	 spQcnp9DY7vvw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>, 
 Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <aUUqDiGqwfmDcY_p@stanley.mountain>
References: <aUUqDiGqwfmDcY_p@stanley.mountain>
Subject: Re: [PATCH next] xfs: fix memory leak in xfs_growfs_check_rtgeom()
Message-Id: <176797102479.430235.6714661375529863593.b4-ty@kernel.org>
Date: Fri, 09 Jan 2026 16:03:44 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 19 Dec 2025 13:33:50 +0300, Dan Carpenter wrote:
> Free the "nmp" allocation before returning -EINVAL.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix memory leak in xfs_growfs_check_rtgeom()
      commit: 8dad31f85c7b91fd8bdbc6d0f27abc53bd8b1ffe

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

