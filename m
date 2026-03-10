Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF6E2D7398;
	Tue, 10 Mar 2026 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154336; cv=none; b=LrISDpUOtAcV0MXiu+8PEE8aBE0cje8UxT8KmmTEwkqMwqvaX/K3jiAzSvDbP6KorzFKQsIjOuRCb3S4xuBMa5yH0WS9AO0hspVPuDG9bsDY15YqK/7ztk/yxDnSO+AyM2phRBf2PN1mvaKKvIK26WaxF3SlS9aZnRDFIPRb7Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154336; c=relaxed/simple;
	bh=Mh0ZCAHlkr+dTfkk+HVeeK6XAphXubkXQamT3RWS5t4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQB06kCMaAh88iqC/nv3MGbafzqALdtH0ztvuFh3p1ytXtvplSnBQlXyLzvEYDgyPRAOdzqAzBEEosA80+r5tw1LkqRjNzH3lg5RwXmazg8EndqEc7Eb9BQGcHl1XhQMI8AeXu4Yx/ZSsXGGSRunM8v8WP6b5KNLS/u3luRYtFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/bsc/Bf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/bsc/Bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FEDC2BC86;
	Tue, 10 Mar 2026 14:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154336;
	bh=Mh0ZCAHlkr+dTfkk+HVeeK6XAphXubkXQamT3RWS5t4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e/bsc/BfcIItSD2famo7vCf4Xx8HQPyMK9Q6xU5ypysRA4ofgpOwssIX9XJwrpHGu
	 kBKWJe4vXZBSnvezAVZ6npQ6TStnz6acN1UP7VQKpg4yT5/Ja/IdWXRT6W8GPg9sWj
	 NsSVfOZX4QnNrvqTlK1jidBffUG1FXkIi4lt1/d2OnMXJLjolsBNhfYz9XTsxfxbJY
	 g17xnGDUh0jD9yCEmAayABBITZka6fVdfa2XTDwli7r+JyZ5LwhRqMgFO7fjKAqgw5
	 eJ8CmWKF6sc22KPXHQvYMYaryPAh4jJVVz086xaaKLpdv662fxTtVHx8ZdxjWNbh6/
	 3kNfhLUPjneXg==
Date: Tue, 10 Mar 2026 07:52:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 8/8] xfs: report cow mappings with dirty pagecache for
 iomap zero range
Message-ID: <20260310145215.GN1105363@frogsfrogsfrogs>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-9-bfoster@redhat.com>
 <20260309175602.GR6033@frogsfrogsfrogs>
 <aa-_IM8JBdqnMKRw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa-_IM8JBdqnMKRw@infradead.org>

On Mon, Mar 09, 2026 at 11:50:08PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 09, 2026 at 10:56:02AM -0700, Darrick J. Wong wrote:
> > Hrmm.  I wonder if IOMAP_REPORT should grow this new "expose dirty
> > unwritten cow fork mappings over a data fork hole" behavior too?  I
> > guess the only user of IOMAP_REPORT that might care is swapfile
> > activation, but that fsyncs the whole file to disk before starting the
> > iteration so I think it won't matter?
> 
> swapfile really should not be using IOMAP_REPORT, as IOMAP_REPORT
> implies just reporting what is there, while swapfile actually uses
> this as an I/O mapping..

Swapfiles are really a read-write lease on the entire file's layout,
right?  Maybe we ought to just have an IOMAP_LAYOUT opflag for it and
pnfs?

--D
