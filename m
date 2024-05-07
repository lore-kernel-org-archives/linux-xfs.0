Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFF7131BAD;
	Tue,  7 May 2024 23:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715125006; cv=none; b=olDVxFx4munOwkSZt41Vsjz+oYaHsyXlZVgmmINGbNkFCcQ+SPHBo75h3tTovsy87Imrp6ZpVSiuqrKxRBj31eGjEovOoM2KhybHo+ZUnYrM13tNACjSZKCKiowpuRi93m6YlX9QAP3TCpBdDr8sMRu5OhF5Prp6eV1nhFWV9ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715125006; c=relaxed/simple;
	bh=wnAuMuelVqBaOBHPNrOn1dHFRLCS5aMFuxMXl2adm8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fIdrPA0hD7XXe6K6HrOxopi1aeSUoFtwYRyXaqEvwI+/lGuYjCoAHTiYuZEtVstKuci6Tu9+IpyoaDHnu74lcsq2ReNf3EKr+YPMfzNtBHlaTviVViWOfsaEeNdO3sQHVcVsYnhTMcjFcTQlQzxrsHLReKc4phrWaTIHlvWpSYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9iwS89O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9iwS89O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12984C2BBFC;
	Tue,  7 May 2024 23:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715125006;
	bh=wnAuMuelVqBaOBHPNrOn1dHFRLCS5aMFuxMXl2adm8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z9iwS89OFb3ScbwH3X1Sd6EDA1EOXQ5QRFMuzuV/rhDDd9OF7rqDr4Le82rfdIMvK
	 svqVrTxhPbAQsV75hM2+qI+e6RktobL99LpJrZ8bwkUBWUTrouOxYj+GBjWHWYCYS6
	 834xXhzMZ1sBRbvtsVHS2Y64O7KHzOfdeZx7Zu5ArjF8Et7zhvnF5YRLhHgqwdKu13
	 jhpL5ncMBGQmQaJZ3TMNCv0XaUoJaD9Hthbe2cYQFHsid3q55VVqze1mS+BmKtKzBg
	 vEBIwu6T6QUFThpiaMbNaDeVnplTKkfqqaSR3jtNxdUcBcvJ0aZDLbtzjnpHWizuX8
	 KPuQ9bNFKzT2A==
Date: Tue, 7 May 2024 16:36:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: check for negatives in xfs_exchange_range_checks()
Message-ID: <20240507233645.GZ360919@frogsfrogsfrogs>
References: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
 <ZjnE2SjU7lGD0x5A@infradead.org>
 <d953392c-44d1-4c9f-a671-b25803181b97@moroto.mountain>
 <ZjnM2QBtL68KJtio@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjnM2QBtL68KJtio@infradead.org>

On Mon, May 06, 2024 at 11:40:25PM -0700, Christoph Hellwig wrote:
> On Tue, May 07, 2024 at 09:33:40AM +0300, Dan Carpenter wrote:
> > On Mon, May 06, 2024 at 11:06:17PM -0700, Christoph Hellwig wrote:
> > > On Sat, May 04, 2024 at 02:27:36PM +0300, Dan Carpenter wrote:
> > > > The fxr->file1_offset and fxr->file2_offset variables come from the user
> > > > in xfs_ioc_exchange_range().  They are size loff_t which is an s64.
> > > > Check the they aren't negative.
> > > > 
> > > > Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
> > > 
> > > In this commit file1_offset and file2_offset are u64.  They used to
> > > be u64 in the initial submission, but we changed that as part of the
> > > review process.
> > 
> > I've just checked again, and I think it was loff_t in that commit.
> > There are two related structs, the one that's userspace API and the
> > one that's internal.  The userspace API is u64 but internally it's
> > loff_t.
> 
> Ah, yes.  The in-kernel ones probably just needs to move to use u64
> as well.

I don't think we want userspace to be able to exchangerange data at file
positions that they can't read or write with a standard fs syscall.

--D
