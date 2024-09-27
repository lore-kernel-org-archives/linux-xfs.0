Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246B51891AC;
	Fri, 27 Sep 2024 08:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727424014; cv=none; b=rToB/6KMYUUKcys0hGlkxei5nvGjIIXtudgYCqUdNyLcsalBl9GhRrxfZNssQrnnRk3MAbNZ2hGsj+lQlzTRyg9rLNwVyLW5rz4bxTA1fQ2/JshP9x+cege2jaAptt/ekfF8p0m+F68JrZK499ehLNwsZ5GfYHUJLo7TY6s5XdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727424014; c=relaxed/simple;
	bh=L0uoZHFB2C8UorYQjOj3kB0cugoikB5qFEFhLGdbOCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sGlq22JecP6DffQDJnx0gNWsYnoKRZjl+6mSsMDwnYPzM5IV0fsjmefffEwwEpWAL376NEMhBHHZViIr0F4NKPaqo26dl2BOAdJhatHPyqZ8U4gwUbBBMnrOV1FatIwH39Keut4oit37DPRqvUlHHL0ykJRQC7i3EHUViZZvnXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1c3qzkdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1c3qzkdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEB5C4CEC4;
	Fri, 27 Sep 2024 08:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727424013;
	bh=L0uoZHFB2C8UorYQjOj3kB0cugoikB5qFEFhLGdbOCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1c3qzkdDDnvJ+XyNj90PhSdilOVExaSWFpD7/ikDDDLBYR4XoF2tJ+7k15paCuBVb
	 DVz9Jb2OCbMtOv8IOuMBxhoJHUYvoxdA/jw77me9RtAeGWu0W4D3zVFTBXUSjS+m0Q
	 9x91Yp/iIUWeP33DiYhGixInIxviMnVTco6mQf7g=
Date: Fri, 27 Sep 2024 08:52:11 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Kuntal Nayak <kuntal.nayak@broadcom.com>
Cc: leah.rumancik@gmail.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com, vasavi.sirnapalli@broadcom.com,
	lei lu <llfamsec@gmail.com>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: Re: [PATCH v5.10] xfs: add bounds checking to
 xlog_recover_process_data
Message-ID: <2024092733-surfer-trace-668e@gregkh>
References: <20240924223958.347475-1-kuntal.nayak@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924223958.347475-1-kuntal.nayak@broadcom.com>

On Tue, Sep 24, 2024 at 03:39:56PM -0700, Kuntal Nayak wrote:
> From: lei lu <llfamsec@gmail.com>
> 
> [ Upstream commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 ]

For xfs patches, we can only take them from the xfs developers, so
please work with them to get acks that this series is properly tested
and approved by them for acceptance into the stable trees.

thanks,

greg k-h
