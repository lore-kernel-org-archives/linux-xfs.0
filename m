Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B96C3AFB11;
	Mon,  7 Sep 2026 06:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762579; cv=none; b=ExY8bQZp9kC84xBW/MuCb7JlyNjbnDcmL91+gnVMdnFhay8OiLTGimOzX2dzZYhgzL8xju2rkCiAi/LikrzJ9DaEJLdF32gTL7DcE1g/43mbB9EgsLMSZfYrjwC4FrdsPfvHsz2r65NMx130k6kgzaVcLuBeN/czih/96SLTcrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762579; c=relaxed/simple;
	bh=j6mU34rN52KhOrISJBXX9uahO13i57ZbcyAF21SQIqo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=p1NX+PTU7l3EzzurA0/kAMYoA52UduwnvuJOPb+g0F0CvlTMJmEvPXV/WPe/6XWD00bO71mnSr013Q9BQLdzmSn1/zP/9xh4H+BNcR6bAACVf19lvqK53lpDeDLuftIn+aoQfXr0rkSd2OEwsfySHCZq1ttaySnw/wHOngKB6xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJvZQBoy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJvZQBoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393EE1F00A3D;
	Mon,  7 Sep 2026 06:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762574;
	bh=8DcWPr+rQm1+Z6qLy8UZB0lMVAsx097RnowAFY6hEXs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KJvZQBoy1pgo5CCoasAc9xCNLznCt4JeHt7I1q+B+D9V5COixzCXXOKNj0R9YYi6I
	 0zppgwIggYVF/CIQM4t8to4+LEyX6xtyO+kWlWspVstBspSkcMzVz9azbhV12zVQIF
	 YMSYbDk2+yaE/XKGuvypz9zPCRAsh7tTzFqTcAUjcLg2Bt+RSAowJk1+vC7eHA+78S
	 KwQLrKs1y25130IkDPqhW3cLriLY1Hxm4KCzXVIi5G7KjgaH6dZ1DjdNd6ve8S6aSH
	 2x+t0mhv3c+ddLrIpPuGldfjVTzX4vAETrgbVBIqgnDvvtwNS8RqYqc2ULJ9hTyT/4
	 CU2EBtdWTu2UA==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260903054952.GV1933798@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
 <178832750773.3508131.8667220003399042973.stgit@frogsfrogsfrogs>
 <20260903054952.GV1933798@frogsfrogsfrogs>
Subject: Re: [PATCH v1.1 3/5] xfs: compute dquot checksum after resetting
 dd_lsn in repair
Message-Id: <178876257293.14591.810009763625740971.b4-ty@kernel.org>
Date: Mon, 07 Sep 2026 08:29:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 02 Sep 2026 22:49:52 -0700, Darrick J. Wong wrote:
> LOLLM complains that xrep_quota_block updates dd_lsn after calculating
> the crc of the ondisk dquot.  That's clearly broken, so fix that.
> 
> 

Applied to for-next, thanks!

[3/5] xfs: compute dquot checksum after resetting dd_lsn in repair
      commit: de20f7014917d661afc03d9a1c157d0ae2775b49

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

