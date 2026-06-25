Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32499245019;
	Thu, 25 Jun 2026 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782410121; cv=none; b=P518DxQ+XQSPVMyvfpNsdIDxU4PzpO1cSisCHT6e1bRryt1C1v9+Als6J/m+NMF3KNMh5ukc4fQimS1vN1ao+x2+9905QTzWoYeLdbMOfESqi0M7Fts6g6CRpt3XPW+wgaAilA8p51796h0cry4hOC81xro1XxF70Lv5XYB8I8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782410121; c=relaxed/simple;
	bh=ky7vFA+kLp2WwoCZ0QlyEYPS3dBWjmzFfa5dHx09NgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZ3CLcsnOoOFus3P6cTGkIUqlbRyQsZiDYyvj4pxtPLMgv5pZDDZsH9DDIwSh/N7DBymkqhrmBiPPbtLCHmBwFMZs6cZgYeP5KUdm+FfXNy0qnJiWs4fR7RV5jQJU4D1zeLAJtS/4VE+au0LgbuskpHKVzoIi5BSlHmO2OEkkco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlLObI/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlLObI/e"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BFE971F000E9;
	Thu, 25 Jun 2026 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782410119;
	bh=CmPEiPARV3/xMoOf26mHkTIa1Jz90unuF8UFgKqXVZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WlLObI/eY+KWsXGDhfBdzoQC4I/ZTZM/BB6lUzFosFQJicG4sOdlZW9ezzLDOzZ/B
	 fZ6IKrzONyGVBDREAaz93XGllldQHH/k3YUftfrFRBaY2qPg66ycPWBFpyQgKDn4RS
	 ay7558f+5oqKodR306tkvtdcakTs1dxrWwRWbxKq5Me8H/IDy+OHFuUoBKXcYQq5Mc
	 EPEG7r1nopDtvbAop7IE2PIRQaUgdbgjOG6AMbJJKQTs7AiVZIsH36S8gWbAhMFA0i
	 YDtcFgkA53yHTcWbFSikWk6m8zmtwVRKLbMIXMTkJ200lwaH2a5t57sdUY0VJjQq4v
	 AyOexS11eUiuw==
Date: Thu, 25 Jun 2026 10:55:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: release dquot buffer after dqflush failure
Message-ID: <20260625175519.GF6078@frogsfrogsfrogs>
References: <20260625131623.3261735-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625131623.3261735-1-gaoyingjie@uniontech.com>

On Thu, Jun 25, 2026 at 09:16:23PM +0800, Yingjie Gao wrote:
> xfs_qm_dqpurge() gets a locked buffer from xfs_dquot_use_attached_buf().
> If xfs_qm_dqflush() fails, the error path skips xfs_buf_relse() and then
> calls xfs_dquot_detach_buf(), which tries to lock the same buffer again.
> 
> Release the buffer after xfs_qm_dqflush() returns so the error path drops
> the caller hold and unlocks the buffer before the dquot is detached,
> matching the other dqflush callers.
> 
> Fixes: a40fe30868ba ("xfs: separate dquot buffer reads from xfs_dqflush")
> Cc: stable@vger.kernel.org # v6.13+
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>

Looks fine, though scanning this function further, I suspect that "goto
out_funlock" in the "resurrect the refcount from the dead" isn't quite
right either.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index aa0d2976f1c3..896b24f87ac9 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -166,10 +166,9 @@ xfs_qm_dqpurge(
>  		 * does it on success.
>  		 */
>  		error = xfs_qm_dqflush(dqp, bp);
> -		if (!error) {
> +		if (!error)
>  			error = xfs_bwrite(bp);
> -			xfs_buf_relse(bp);
> -		}
> +		xfs_buf_relse(bp);
>  		xfs_dqflock(dqp);
>  	}
>  	xfs_dquot_detach_buf(dqp);
> -- 
> 2.20.1
> 
> 
