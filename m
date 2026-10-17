Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F313AC0F3;
	Sat, 17 Oct 2026 03:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792206048; cv=none; b=ZQw9zynAkLIC8X5QixY8cXUYIriR7TxcRR3IzRKrz5MvGcrY8MpN0V6Lu2XDEy9klfBSv8kYjLsPcbrOoFRjCoSQ+2bBRRp7rr6rol7KT++Ac51ghOgRKpaksCSGAgE/jwzBfRyWi5dhvN9nvqIHyU/t2gN1LpREizU93m5IUUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792206048; c=relaxed/simple;
	bh=1NCnHmHAiFBx6DE1soTzPxYirn4ZWu9IV0VRjQEoSkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsayYJJuvreZTNpReWdBcURZ7nB7FusE12lH/IyCGFbtJH0UjEVY0V3JzYxxU1xZhAsgnxwyflLDRa/gx8U/z8/dmwBr1l6Tmho8SUK4LXO+peGa/yU3XHFtjKZoX/GqtEXPu/vPWZZHz9+LmlN/zAitehmi8+zcCA6pzYyCyMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G2plqA4y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2plqA4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8841F000C8;
	Sat, 17 Oct 2026 03:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792206039;
	bh=nEn+CusHEuo7JRMQua/CI+Ds3eOaDSAz9H+xFjAWP4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2plqA4yeNwWyrDDkszetp9nvNGg8CvC0XKf3CPI9akyn8xwvdIlMx2sSaBJcLIsU
	 VISSmchqd+bb/zIhh47bc7eoU0Ei5zPZw0/JSoLT41TcMo+CvvgyT8Jw7BGDprCbxu
	 fDPWTRsUSaBApUrxrLV+tNgM0fDab27j9KHa3/jz6M3OAi+IRLVgvrCN4nntODSQOC
	 RK7yf6JAxi42a6wFkiHW7/GcsAVjVoqwPEXH55kBhVF5rzpJgrr0Npdum5sdIxn7QP
	 ToaGVWRZa2fFp8eblRoqfLkyPF+CkxpK8IKCQwIJyv4mK6mmruQXv0lUQuJWTgQpwJ
	 EmHL8CmN/4tJw==
From: Sasha Levin <sashal@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH RESEND 6.6 v2 0/5] Backport of XFS umount hang fixes
Date: Fri, 16 Oct 2026 23:00:17 -0400
Message-ID: <2026-10-16-1-daily-reply-0012-xfs-umount-hang-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015144723.GQ2705364@frogsfrogsfrogs>
References: <20261015144723.GQ2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This also looks good to me,
> Acked-by: "Darrick J. Wong" <djwong@kernel.org>

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha
