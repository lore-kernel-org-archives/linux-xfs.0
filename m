Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98AE38F259
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 09:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772012330; cv=none; b=cElGYzLMOZMIb5XvBOLbq+DHOQMGWIeYeX+ropVVNuJOWadkVIX6l4L3MMm+PsV8Xc/KM0DBouClowECE6fP7H2eQhIGIPBN1Zb/Z2D+8t2YAvoRETFNK/P79qnOm0CQfa31Ix4gxmeODGt6keA+im15rf7TTlU0O6xxXaY1kMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772012330; c=relaxed/simple;
	bh=p9fbmydOZFIF/TYileGzfQVM4FU5VDdFJJYSDATA0NE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=m70wA1QDDTIvJGRHBhe02P3vszqXCRugX6DQ514hTLT6lSYAejhnGhoKT3IpjnQcYIOTVpRk6WTO6Id2ml6HLfr3yIPjgU5GXMG7ml/GbDo5Gav1P7V+tkKJn3tzM3Myx9DUWmZehwc3kvuJzvhal6xmT4B10qiuugLP0N/i0Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CInMVkk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CInMVkk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C582DC2BC86;
	Wed, 25 Feb 2026 09:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772012330;
	bh=p9fbmydOZFIF/TYileGzfQVM4FU5VDdFJJYSDATA0NE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=CInMVkk+sQ9nK2o5f1VvTCPVjkTpDhT+FZhcRFsIpTOKhEGiUMRljV1B9h2C03Vj2
	 Muy7csAE1sLHYxDXD6ZQULwcDO2/u4RV1nyPTEwLyUPNtTuetHipfWM7pWm3jMFNeE
	 XECLPdDqcyofH66AeF7ZmGyVuByu4RjR/CN8vPlU40etrcuweko9LR60qQL7Vr0Akj
	 htqRGPOL1Q9lZCPHrPkkxdQkT0i9hj0jtuoV1WE3SqJv9vxXh2mNCboB0Mdhg6zOqT
	 6Dfa1v+9Kroxqakpb75y47rqFdgQhr9/D/S+x97gd8bZq858+YY007r9L7uX3wBg82
	 iJqh1LP3KAH1w==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, hch@infradead.org, 
 "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com, 
 nirjhar.roy.lists@gmail.com
In-Reply-To: <cover.1771570164.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771570164.git.nirjhar.roy.lists@gmail.com>
Subject: Re: [PATCH v4 0/4] xfs: Misc changes to XFS realtime
Message-Id: <177201232851.40354.5097407504767806979.b4-ty@kernel.org>
Date: Wed, 25 Feb 2026 10:38:48 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 20 Feb 2026 12:23:57 +0530, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> This series has a bug fix and adds some missing operations to
> growfs code in the realtime code. Details are in the commit messages.
> 
> [v3]- v4
> 1. Added RBs from Darrick patch 1,2,3.
> 2. Updated the comments in patch 4.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: Fix xfs_last_rt_bmblock()
      commit: 5c230c08da92e8b4a4916b9de4bb87521adcba0e
[2/4] xfs: Add a comment in xfs_log_sb()
      commit: d93c48bfe3d969d370512f5adbfa29bcb91e020b
[3/4] xfs: Update lazy counters in xfs_growfs_rt_bmblock()
      commit: e37c36b26503edcfd8824ed16b256d83b58c2faf
[4/4] xfs: Add comments for usages of some macros.
      commit: fddf473b28fb68aefc56959cd86faf3acb5a8621

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

