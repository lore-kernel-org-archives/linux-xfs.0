Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E4115AAD6
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 21:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712783884; cv=none; b=m4e3ko4m0po8zuwxpeU5UYMWU82zaqmrV8XvsabuD8LsadNlVrMl8HTvmQL061bX5qWJzQla1oJyfMvleqJS+ohZ6YMEkLkgoT9KTeleGJ6l7cSgjREgxXWPZm+cEXhXr7TW9zqtQOsibhSVKIudLF1TjIVyvqKFa9MW3AI9vOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712783884; c=relaxed/simple;
	bh=Ot/c+h0JTEkKuAtgoPS/YUmpKENTNI8IxnTYJYVGCaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLs//SdCLoPcB+he8Le0h1Sr6+mN3aaY2issCmYrOYtaGkV5BRPMMW6dIdI0K9BljS7Ohcui97Vc+ipCmiqVyIWikH7azZUMucn+4mrKknCOJhckmuKnTyzEdoueNqTK1X23B6CQTcudrPn2ilyRC57W4k+2gHhRs4/krrf9q1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XHzp4mzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XHzp4mzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403A3C43390;
	Wed, 10 Apr 2024 21:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712783884;
	bh=Ot/c+h0JTEkKuAtgoPS/YUmpKENTNI8IxnTYJYVGCaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XHzp4mzIrZK2NBVcmVuMywrQhU/uA0pWKtHHHTV58zUdC0ILIljmhrvtLldWGE2Gj
	 xGwlD9eBxvab0PzVB0IbMD+ge50bKx3e9OYw5UL8MDWoqY3fryvRivGX+OqQXcuF1J
	 GdtLD8+ovs987LLr1aF6fZbzikXkbioPljW8LbsO0dSRgZiib4XJ8f+6+sMvHFAl02
	 +zsWd71UlN15Y5UllcsPamDDNucYT5fQWIPrbWm6IBbrE3VgktD5caexiFIma0aT5F
	 5iiyJqRexNB7cndtbVGBdLVGeVZzBwqGWDlnpjkB2wdnZrYIX5jLTuw0f7+otpDLjd
	 tYPps2V6879Lg==
Date: Wed, 10 Apr 2024 14:18:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/32] xfs: allow logged xattr operations if parent
 pointers are enabled
Message-ID: <20240410211803.GE6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969690.3631889.15408823864477343629.stgit@frogsfrogsfrogs>
 <ZhYhGbiC3Cp6SmL5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYhGbiC3Cp6SmL5@infradead.org>

On Tue, Apr 09, 2024 at 10:18:17PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 05:55:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Don't trip this assertion about attr log items if we have parent
> > pointers enabled.  Parent pointers are an incompat feature that doesn't
> > use any of the functionality protected by
> > XFS_SB_FEAT_INCOMPAT_LOG_XATTRS, which is why this is ok.
> 
> I'd move the checks into the switch on op below, so that we check the log
> attrs feature for the "normal" logged attrs and the parent pointers flag
> for the parent pointer ops.

Good idea.

--D
