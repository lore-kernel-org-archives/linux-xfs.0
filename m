Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD790176AC5
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 08:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727684007; cv=none; b=RqlQIY72ulHXdTJfiKlOZqbZpwLi+J0TEq1l6V/Q4qIgCHJJt18dCeR+qLDbUOR5LB2dlpSHpf9AJ7hLYFZUnlLWQmpcJxwiyN8PDf0akPrBLOrf7Zt7NVgv4foJrTW6GZC/ZAl/ZVJXvlVyxPhn8FwMo8+HSVBmQXpCKDk+46E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727684007; c=relaxed/simple;
	bh=Qnhzgif+WgPuS6OaGPIAAtkwIh173pzxhXo1RK4EZls=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sdEUowHOtrTR+7zyKM3lRgkQqdtZasMrdJ8rgjNS2lfX0R1EFqhsiB/CQ2zeu3m87YHQCJqlgAwNt5gIB6YIsvQt2ByFA62E13Kp8eGO2dlp3eWAdhTCvy6pUKMzDBx2yZKkLGmAS5fGphW+Hiekj+NEbTtEUpUZkssYMLcIM2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hpJTu64o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hpJTu64o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760CCC4CECD
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 08:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727684007;
	bh=Qnhzgif+WgPuS6OaGPIAAtkwIh173pzxhXo1RK4EZls=;
	h=Date:From:To:Subject:From;
	b=hpJTu64otC6xF2pts8iIEI2LLyfh6hxACkRRC2xhTTOyt8nbDyeahIDX8LLMbER70
	 E3UyyqKxgak7LPksVSGWsG2oJfbN/9dPzkCOtS0GBsI4/STBcB1n/wGoDKTr2NT6ms
	 IglE0SrMP/C2dIBWO8pBJiwa3cfR0UODgrK8XFWKJP/ca+2dBdYPTJN2hpx4/+5rvi
	 5zDvUYvEvCa8aGKWBvledJRjguGqnMJhWoQ473OB4roVqKLDgqIbAZLA7VR7eurCKZ
	 7M5fhl9zJVdiPJ6PhR04CunGO/ZqlLIKL/7DsiooPBbmk6d0Nx0pLaAyIVgAvPr2Ld
	 Si9edoCVy2b1Q==
Date: Mon, 30 Sep 2024 10:13:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: master updated to v6.12-rc1
Message-ID: <dmtkdb22wnzjd26njdg3pecykqtbkm45efq7mjy3uw6h6ctjxs@gnb3pyib6eye>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The master branch of the xfs-linux repository located at:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

Has just been updated to synchronize it to linux's v6.12-rc1

We barely use the master branch, and it was still pointing to v6.6-rc1,
I expect to keep it more up2date, and giving I'm preparing -rc2, I thought
this was a good moment to update it.

Carlos
