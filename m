Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E707148850
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 20:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734468911; cv=none; b=KYhkOs8G6Uaycg3yUx9TaNh9vPIcIyVVJVhWAxpW9CupVjMjOsjs9KY2alS0XT2kU6lyjS+5dnytd99LEhGLRPswoVDCH1GPOK7Tn0CTymgZz0812B65hZKhfJ0ZBsqeq4JN/0MFbTFTQEecsQ0RkbTUJzNCuy6CFeEa1+R1Bwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734468911; c=relaxed/simple;
	bh=K4NRDfruukB8Hpt6V2VArwda5nDtaC1NAW1+xB/mC1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZaeQNKcWJjyKtZmeoONSJ1px6/zovTsRFELCZNxXmpX5PflA05BC4xn/08SXjzUHloQksy1lAwLQRx+w4G14AyKI5n98k0NDp+JfF57ZAfjAmBOiBSc7cXUTdA+xY4f0klePLoM3piGIxkVzzkMG9ASnZkFWsfOwZrK4NPOpDR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qZAG9WPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qZAG9WPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321D3C4CED3;
	Tue, 17 Dec 2024 20:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734468911;
	bh=K4NRDfruukB8Hpt6V2VArwda5nDtaC1NAW1+xB/mC1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qZAG9WPJ38gJXBdwo7du5bIYHOgD6YO+AI1NJKEFJlNCFcG4bPTSAo0tGnVnDiUF2
	 yzsUT98a64YlcgVURoS9LtjtdvBemteyIiHJ/JK1wGtwriZYMstuFwKv6MR5ov6I+M
	 KGn5X9WqNLtHrSbw89LTFhEFCdDZYCrlxIvsVKnqza9tkTz+bdBvE1gDBCCiZDlpOe
	 NGd0UBfCcy/Dl79K2L6cw4fuhZuRuLZgNnWQ9XY7vexlulmhRv22nC5CGJqIUqKJci
	 qP5xr2ltA2daJUWIZXzIaPB6PFSXTDl+dvnNt2ZYRdhx7IFSLVemCNYn1diJ1OWYLU
	 CA/oIbun/dTzg==
Date: Tue, 17 Dec 2024 12:55:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/43] xfs: scrub the realtime refcount btree
Message-ID: <20241217205510.GV6174@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125046.1182620.123195236500556349.stgit@frogsfrogsfrogs>
 <Z1v7zpBiiZ-G_sB0@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1v7zpBiiZ-G_sB0@infradead.org>

On Fri, Dec 13, 2024 at 01:18:06AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 05:17:32PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add code to scrub realtime refcount btrees.
> 
> Please explain what that actually means here.

How about:

"Add code to scrub realtime refcount btrees.  Similar to the refcount
btree checking code for the data device, we walk the rmap btree for
each refcount record to confirm that the reference counts are correct."

--D
