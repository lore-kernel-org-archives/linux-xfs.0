Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F2F79CD;
	Mon,  5 Oct 2026 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791223598; cv=none; b=nqSHrNxql/fpzfHzPzvqws39TMIRQKKrcFmGGjb3fFRc+9sgl5ewQJ27aOBYK+Q8x2D41EOYfWE6kr3lUTFJHMXzaUZVvhibqmgZE4q7mpkQ7+scEsBDm898zoW7gOB2Z78Ofbg3Y+k6Bbrfn+7uoK971axgJvxtBunbLk8zbJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791223598; c=relaxed/simple;
	bh=NHC7UPdSv21B+xczMv8ax/94E1S5+wHW0SiRyFbLp3Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=X7KXMX0fyi6uKqkFSd+aGYAmpRNb991mO8iUn3zVgnB5R5KYoil4N0azpD3GFSr+MDvyPr3geYnYR7pjvittKElyJECIjmcaNGYyEfgtoU/9G7e/2GBx+6T179FB7TnnPvuY2lEllMdUmp7MWZ+vzTpwsNzW5fvH/iFL3f6l+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OrDZQi+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OrDZQi+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585151F00893;
	Mon,  5 Oct 2026 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791223597;
	bh=NaUv/XuPYFWxQcwoZYq++jlTHd+q2e4+QQ5BadkgTmk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OrDZQi+GLNMQXBkd5xa0dPSqjB5oGLJB2zNB437Lp0LZuoL5uPNgo7zuJKob0PAmd
	 ISWFCd5IGNuKhqEKbNhq5LWDv1epsc3nwusGb3Aoj3vBJrrR35QS9jRvSdyOGrYxH/
	 wm6LjZm8CD41dh9mcNve3rcPQRXyUzOVISAp0pkG1J+Cxr50OlSPI58TPIk6XQunoR
	 GB1mZJ0ode8iVKEio1i5XiEutIHaAdac1SxsR/01etlL+J042hp29CrR9qHsJu3FQV
	 Q2/vOJQJTtqMx+NTDam1tRxD3/1IiiLynIKFOQhu8F8vvMs+OrjiqzaO3qVqAv0pAn
	 443kTPyYoYqBw==
From: Carlos Maiolino <cem@kernel.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260916004335.228753-1-yun.zhou@windriver.com>
References: <20260916004335.228753-1-yun.zhou@windriver.com>
Subject: Re: [PATCH] xfs: move xfs_sync_sb_buf() out of libxfs into
 xfs_ioctl.c
Message-Id: <179122359604.102066.989822171795256366.b4-ty@kernel.org>
Date: Mon, 05 Oct 2026 20:06:36 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 16 Sep 2026 08:43:35 +0800, Yun Zhou wrote:
> xfs_sync_sb_buf() dereferences mp->m_sb_bp and mp->m_rtsb_bp, which
> only exist in the kernel's struct xfs_mount, not in xfsprogs' libxfs.
> Keeping it in libxfs is a porting hazard.
> 
> Its only caller, xfs_ioc_setlabel(), is kernel-only, so move it there
> and make it static.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: move xfs_sync_sb_buf() out of libxfs into xfs_ioctl.c
      commit: 6654fca702b28b87cd365242498262080b1c223f

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

