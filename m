Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFA413C9BE;
	Thu, 23 May 2024 07:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716448122; cv=none; b=g6SSdxz1KP/IsSrNsu4d6qAQPJCjrWchvhOBIsDnpB3/cmFu530ULNuWD3oaCxsHlt7xK/Ehklkr+YyvBBjrgJa3bNK/xLNO+QVeJQ3EjB0MJwuJI+GI06EYCsnLskMbCWmkKFY7BSmbOzBsO9oG8NwASojaIQfLctWgaUrv7eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716448122; c=relaxed/simple;
	bh=rgHNG8A/UW39eLcCHIvH1tJHdR7hEkUA+zLqGB7RWus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ri2zB6BFpC36ZgR/BAJOShUtkWqrm90sSY50iChxOFlLEy60Vrx7KdQzr0BV26qfzS3YRGmOa12aBURH34TH9Ztj70KnlMvTtr6+wLGm3UuC0Wa4fpf1KNY7ixODmPfc9wbbhWuSYOFW+Au+9hMUGV4NM+O7esJEPZ5vCx21nEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aa3Mp2oR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aa3Mp2oR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47619C32789;
	Thu, 23 May 2024 07:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716448121;
	bh=rgHNG8A/UW39eLcCHIvH1tJHdR7hEkUA+zLqGB7RWus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aa3Mp2oRo59Qoo/HCtrmJ3v3jto/vmsH57eewipmCSxAwHM7LV+KytubCKZoc5AXU
	 nL5+RXiOXk7w0YiiuPOCV9xjCph0MkWT7dpBnzKF6HbFEIo8KFu1/3fvYIqBa4G67J
	 LNWjkCBuIITL0fVCd3ntW7EYAMU1Cpz0iZaDvFLY=
Date: Thu, 23 May 2024 09:08:38 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Leah Rumancik <leah.rumancik@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
	fred@cloudflare.com, Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 6.1 01/24] xfs: write page faults in iomap are not
 buffered writes
Message-ID: <2024052317-payday-overlabor-1931@gregkh>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
 <2024050436-conceded-idealness-d2c5@gregkh>
 <CAOQ4uxhcFSPhnAfDxm-GQ8i-NmDonzLAq5npMh84EZxxr=qhjQ@mail.gmail.com>
 <CACzhbgSNe5amnMPEz8AYu3Z=qZRyKLFDvOtA_9wFGW9Bh-jg+g@mail.gmail.com>
 <2024052207-curve-revered-b879@gregkh>
 <CACzhbgQzrmKHX-VAzt8VKsxRT8YZN1nVdnd5Tq4bc4THtp5Lxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACzhbgQzrmKHX-VAzt8VKsxRT8YZN1nVdnd5Tq4bc4THtp5Lxg@mail.gmail.com>

On Wed, May 22, 2024 at 02:55:18PM -0700, Leah Rumancik wrote:
> On Wed, May 22, 2024 at 7:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, May 06, 2024 at 10:52:16AM -0700, Leah Rumancik wrote:
> > > Ah my bad, I'll make sure to explicitly mention its been ACK'd by
> > > linux-xfs in the future.
> > >
> > > Will send out a MAINTAINERS file patch as well.
> >
> > Did that happen?
> 
> Yep, https://lore.kernel.org/all/Zj9xj1wIzlTK8VCm@sashalap/

Great, that's why it's not in my review queue anymore :)

thanks for confirming.

greg k-h
