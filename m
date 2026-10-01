Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1563651AEFC;
	Thu,  1 Oct 2026 12:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790858699; cv=none; b=RSa2igrW6TjeGcR7Tk5C5Az5jUfRR8D3HSaDMJoGb1A49aDC3GOprV42HEFvD+8BeLao6jhaLzfgZOZLadY8dWwwG+ilqLUKvYQH0GnFcGCaeRrbQe/3Q3PMvIyC/Is0Haek9Tz+nrsIboxlXVo7PiM1LnCLl/lyhWHchIKds3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790858699; c=relaxed/simple;
	bh=bthn7RFeziiN9QE573KrOBfytvKpyTRLM7xwE0a/dFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PC6rqJFF5ZKLA5f48NraUiYNMRDCCXSmzlOFKPRhfQxNcKNN683yJ3Ll75WfXaB+1pYo7IwXMUovax4VinjaeGvux3Z40WrZg8N20ftvjAyAC45J57Csnr9pYL44Yv2btK3GtRf3HIlSqtOo/3YjlP0g4OGVSqHGzm9KTxNKcR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNe8HoGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNe8HoGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5511F00898;
	Thu,  1 Oct 2026 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790858697;
	bh=Sm0xq/fjQv6PDpZzT72qBpzu0mj42KLlaFjsJsfIW0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XNe8HoGHfQSGhG9EWZKg0UDNTRs0LhJK5qQ6g236b3YzOB5Mz1AprQDcIyy6kR26Y
	 k9BylszCKHYY4h1ReTGBd8ZOyAnm+BJmX0vzAm6p68mPliCIErh9JYk69HVipKmTup
	 ErJPAEeGdruxS5vvVhqhAs7I5gGmBHNakOBoV45tyI0MzPl5gWtltO3E0qXzHJT0ek
	 chAsC0S2l1AtQZDrX90YsaHP3cgtsN400qQ+ug4kKPF7lJJAvneCaOZNAkshzFu67m
	 VfxKOaJwlE/+M/NQtQPXWE18Klqy1PwLiaziHr0cVmpHsFS5N2hLa3wqy1Tv//R0Ib
	 p1MiG0OdhvKag==
Date: Thu, 1 Oct 2026 14:44:52 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: basic functional testing of media verification
 command
Message-ID: <ar5VttNjTWJV_Pxu@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
 <179060965824.790984.9346083899208929049.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179060965824.790984.9346083899208929049.stgit@frogsfrogsfrogs>

On 2026-09-28 08:36:42, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Implement a simple testcase to check that media verification works on
> however the scratch filesystem is configured.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
