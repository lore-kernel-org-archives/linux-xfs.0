Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A8A136E28
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 18:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462732; cv=none; b=Bl0Jbh3ojy6UKjnU5EKOZSE9L3Fx2HbvU3RdrtEKac2TSBT0sYHx+kZcuedNuskBuv5geVvtOb5phqgvoqEMVcsnZrXW3xY9ZTuURXXSsTwEeoX8cF9zmYlU3SgOlHaQ5gvR76kvJ660ggA4YWjgFzmOpnXXR9dDWXIl3aeWRjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462732; c=relaxed/simple;
	bh=uRQvImmKzTQFTm3jUGBmCzDyIf2NiROGeq/3XFSd7mU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OHRcMI7wPhbk14XYEhEANr+7i08X8ZkvVK0DJq+c0Boh4ZRamUNv0KDwtnxHFdC9NqhUZHTyEHA9Kzk1hWkZh6T4zjjv8gfGMEuAif7sW85KR7SPRBRgblktnKuBfDU44HQsH7kQlmWJVMeUCxVVGoCD9q/bh3UcRGF/hHCWJXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNIx/12X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNIx/12X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B2AC4CEC4;
	Fri, 27 Sep 2024 18:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727462732;
	bh=uRQvImmKzTQFTm3jUGBmCzDyIf2NiROGeq/3XFSd7mU=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=WNIx/12XUkav1qqWye1RJJcidEBY9ZmGBTwlESM44yRLFPw52zDyJwsDBJqcFFxgH
	 vcMORpwijpKBwLEJ6A9/ns/c1bwrl19muHs98mDp1k1K/M32ros6N5d2+vxkvj+7nR
	 hfV7Jtw7iG0HMBIcO7ftE3goQqbTbN3n/1PzWUr+uJOIhThemR4xQ9ULlGc8Wst9ZR
	 UhJtLwKrYkiD5eUBhnrv3OOGKnWeOCo0XLy+VSIPNNykM88yBgibeGGnW8KMZcJ78K
	 lIRSqNXP+WyNegv5HGT5LqASbV4Wsk0jCEaRD0+LiMj+qvQa9QgzztfT5bqt82AHHM
	 75bNf0OgTGFbA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Chandan Babu R <chandanbabu@kernel.org>
In-Reply-To: <20240925115512.2313780-1-chandanbabu@kernel.org>
References: <20240925115512.2313780-1-chandanbabu@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add Carlos Maiolino as XFS release
 manager
Message-Id: <172746273127.131348.9834411622718917032.b4-ty@kernel.org>
Date: Fri, 27 Sep 2024 20:45:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1

On Wed, 25 Sep 2024 17:25:09 +0530, Chandan Babu R wrote:
> I nominate Carlos Maiolino to take over linux-xfs tree maintainer role for
> upstream kernel's XFS code. He has enough experience in Linux kernel and he's
> been maintaining xfsprogs and xfsdump trees for a few years now, so he has
> sufficient experience with xfs workflow to take over this role.
> 
> 

Applied to xfs-6.12-rc2, thanks!

[1/1] MAINTAINERS: add Carlos Maiolino as XFS release manager
      commit: 70a8efc12268346370c8e6bb3f7610f771915316

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

