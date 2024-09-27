Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E37D15D5C1;
	Fri, 27 Sep 2024 06:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727419846; cv=none; b=gppi84wAqFVYc3kTMNjCfkXq1fTNSg8cVvi9mmVWtoZQBQh+6AXo0o/W9xEbv+jYY/jU0eCM8Cj9UWGH106Ka2zN4w3NlVg2Tnsngt4aWYFRxm74rvtbSDFKu9lzCi0ff8VVyjGNsSbin43HWG4n63yNvobXcGchxJN/TtHqg/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727419846; c=relaxed/simple;
	bh=N8teYEJPkmK2POrlToDCjodPIDG98sQ3YaSljfJee4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpPP6z6cNZQYpEyuTrGvpwz9/Y9u5DvlKtOSbHrgU4qjcdFbPZBQyzdBpCCrIt8QhHd70XLjp0yVRn0vYxFgTCxyl69cv6fLA3Mp8MgSSn79qd++WTNp30CL3eeOGw0MkueEm/tpjcgR3/0s6A5kIZKhaipCWHzFRICB1Z0ETDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpfC1p7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpfC1p7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB563C4CEC4;
	Fri, 27 Sep 2024 06:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727419846;
	bh=N8teYEJPkmK2POrlToDCjodPIDG98sQ3YaSljfJee4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpfC1p7Gz5j0NfI+N24Vqj2s3n7ESFMBFWGnl+hunRPHndwWDinrblwTW0xstbCba
	 lnNCVors+ZmYdL/LWRPk3V+14mQOPcc3syygw52qSmZQPywbZK9h0QYaHvYJWVUvoM
	 KdjhAWmIzaanbTtGpLjmucQpU2HR+Yttj21o2IOo=
Date: Fri, 27 Sep 2024 08:50:43 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Leah Rumancik <leah.rumancik@gmail.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, amir73il@gmail.com,
	chandan.babu@oracle.com, cem@kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH 6.1 00/26] xfs backports to catch 6.1.y up to 6.6
Message-ID: <2024092735-authentic-masculine-decb@gregkh>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>

On Tue, Sep 24, 2024 at 11:38:25AM -0700, Leah Rumancik wrote:
> Hello again,
> 
> Here is the next set of XFS backports, this set is for 6.1.y and I will
> be following up with a set for 5.15.y later. There were some good
> suggestions made at LSF to survey test coverage to cut back on
> testing but I've been a bit swamped and a backport set was overdue.
> So for this set, I have run the auto group 3 x 8 configs with no
> regressions seen. Let me know if you spot any issues.
> 
> This set has already been ack'd on the XFS list.

All now queued up, thanks.

greg k-h
