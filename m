Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3413453385;
	Fri, 29 Mar 2024 09:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711705929; cv=none; b=GIQcyGxpcZ4cREddGnN6805P9C3TEjD4bpE34WBBWxuTH9OSCl1h5QFO47i7WG/5O/qEOYln0dqCdgEERfuFV5D03VxYBO51TvS8MtJAL0NeLcadJbZmoWNinM6t0aE7tPaU6JYg3loHNU1v2E1bkuEmTgFakPmsGqGo9Nu7Q4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711705929; c=relaxed/simple;
	bh=WJQPWy4hBldNTeti1EQIOUtyVFSvPO8pbmNVfA9n16o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qITUssgzDrIszruAKeTVlzG+GmwKam7KtH37T6miUdJQJyzLNf91MJ3lwcBR0qYIMaEkz98AlyZBxNsrudMZ4F+VlSbe2d6C+cPBUSuZDENKTYTdUGV0yWrsPjfkbZ9exUo3k0Arw/KA5vbQ0ufvyLsCG+3jQUpCOHCUBOLpwQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6BfXYsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6BfXYsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37133C433F1;
	Fri, 29 Mar 2024 09:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711705928;
	bh=WJQPWy4hBldNTeti1EQIOUtyVFSvPO8pbmNVfA9n16o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=x6BfXYsDr1w63TkCj6wY6I+jQSzWsWih0e9TJHGEEsuWCJc/XVnzmD61fkKxPpr2Q
	 sCcEI+H0u/IAt2eMZT7iJAEhpM11+9jVa03Li8uS+GiywBN1fXhogRo47sTU8BlALd
	 Xkkc8h8oX6VvNzOUb+9dtiJoD0wFvRgfpwoin4gw=
Date: Fri, 29 Mar 2024 10:52:02 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 00/24] xfs backports for 6.6.y (from 6.8)
Message-ID: <2024032917-lemon-scallion-ea4d@gregkh>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>

On Tue, Mar 26, 2024 at 05:12:09PM -0700, Catherine Hoang wrote:
> Hello,
> 
> This series contains backports for 6.6 from the 6.8 release. This patchset
> has gone through xfs testing and review.

Normally we want fixes for newer stable kernels too, i.e. 6.7.y, as you
never want someone to upgrade and have a regression.

But as the next 6.7 release will be the last one, it's probably fine
here, so I'll just take these for now.  But be aware of this in the
future please.

thanks,

greg k-h
