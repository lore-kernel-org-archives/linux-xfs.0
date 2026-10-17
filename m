Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AAE3C98BE;
	Sat, 17 Oct 2026 03:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792206046; cv=none; b=jx6Zz7joHCLxjA6Ov24OAPsI4enUSgEhtiu4XRqgk8t25DHzEXRKXUNk0BiYvLmXrcrSV1U6D/2PPSDJ6bBHxf2usZKkTjXC5SM6WD6ozKD2I75D9Fz1UyeMDpqFulH2XLwyQyXZQl+azUTg24HHzp5PQkUxoMBiSled1v/2dSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792206046; c=relaxed/simple;
	bh=E3AFUtHBAZfF72CoZu3xpPRb/agH0NVS1vNhs87csT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KllZR3g5KCUM1meRnBqaPJJRCI5dHRXmsBsu4pO4sOZOXwH1UcqVJPmfC+feztym1gGvuV0/LD5RVPBcilbihfnwsmxxkSR+9aDc0F060A5Mbrg8o2vxlgFMnIWldO7NnaI23pDk9TXVu6DmWxYrxTZlTKpW5cHnFNd9cI2YqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbNBbQZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbNBbQZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1C81F000C9;
	Sat, 17 Oct 2026 03:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792206036;
	bh=EqtAl+BNCy540pMe0VIdVXvH7QqtXtu40lGYCOjByko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbNBbQZCUkXXda+TuG6uFtFOVoVCVmp1UDmOOA/p8I6GArWOoaPwV+hf+W/7dT+Od
	 WBlJR3lKpP+t4O0YFHXXbdtIJefxXSVXFaO/Pdv7oUAEsVpeDIWMKDGJslY+d2EvQH
	 wcDVoul8/sriLfWEt02HG2RmfrlyJStKiOC8YXcFUTjrAXwGADDLTi/7+PLauQn72v
	 p42r52+OsZDpb5eL+Jb60zgGZ0/TzuqDCJEv6QeB8vVgpdhkZyFfDIPx1N/Qij9jZ/
	 fiaJdk+7Mlgsd5HjQbcrDB8uluuAPDWsNeOv3AsjUNnVv5vsmuEGkOXqS9RFsaLClA
	 QBFYQfDsrEsig==
From: Sasha Levin <sashal@kernel.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Mark Tinguely <mark.tinguely@oracle.com>,
	dchinner@redhat.com,
	linux-kernel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH RESEND 5.10 v2 00/19] Backport of XFS umount hang fixes
Date: Fri, 16 Oct 2026 23:00:15 -0400
Message-ID: <2026-10-16-1-daily-reply-0010-xfs-umount-hang-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015144739.GR2705364@frogsfrogsfrogs>
References: <20261015144739.GR2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Looks good to me,
> Acked-by: "Darrick J. Wong" <djwong@kernel.org>

Queued the series for 5.10, thanks.

-- 
Thanks,
Sasha
