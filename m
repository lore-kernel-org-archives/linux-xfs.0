Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43D01C6B5
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711471920; cv=none; b=Ot9uvdL3c+e2jO3rZVHvTWjk4hBwRn3ATEBn+Ls06Jan6oRx/pVKSVnU+vuNYtI06ErzBTEso9u5dcNaviIVr0nxi4P0GBlOdE+11sTd+6EDxWgFKcLSnFCS0EQJwwYB1cAgsNjLZxpLWKNS74o1CDevORLwDFrd7O5Fjmi2o9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711471920; c=relaxed/simple;
	bh=uC6lWBKxg7u2Opn2DrIJ1u+vr91hx00UFIiLW2zNEOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csThRAdfPEaMc4FM3tOROT2/9iSUML9/+jDci9IhOo+yCxs+/TQ91VB5/JcVkrM+i7OwBePk2i1oqcWVVO6+0eUUq47yIJLKGMhYmuUqVTasLSoh1zz1PMWD7sdXhJmmCJ5Yg87m1poeM+kD6oCyYEof/mR400MCPNCa/QU2Yew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGv3zhyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGv3zhyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5887EC433C7;
	Tue, 26 Mar 2024 16:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711471920;
	bh=uC6lWBKxg7u2Opn2DrIJ1u+vr91hx00UFIiLW2zNEOE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KGv3zhyUXZ1QwefWdfdqruQ7K6qlZBUAdHNpdTU2D77PEdoZbXyKlGQHYpph5etS9
	 Br5vFh0ie/vqWOBv7p7mCmdsqGUijl2EBloo2fw0KYvGQKkJ7U5oc/9btqO5JR2LXb
	 JjW51SQoxXJYMyRDB4rUX54lkU/w4PWpigcub2dXsxpAqK7yyUL+xy99PlNhWAQfd1
	 Oen/n1vGS/jAeIGCuLPNz74GFZtX4hzM+MTU6jGb3D9wYDUhm/oMUgJ8kXlU85s1y3
	 9r3jUD+2HiJaEY+UNnFlLx8obbxL8qlp4kj2pVmVQDrrdk/BecL8DCvppyMoUp7omH
	 xfo31jQtkHy4w==
Date: Tue, 26 Mar 2024 09:51:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 089/110] libxfs: add xfile support
Message-ID: <20240326165159.GM6390@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132661.2215168.16277962138780069112.stgit@frogsfrogsfrogs>
 <ZgJdSnLbTlY4ZW8s@infradead.org>
 <20240326164736.GK6390@frogsfrogsfrogs>
 <ZgL8lq4M7Q7oNJwS@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgL8lq4M7Q7oNJwS@infradead.org>

On Tue, Mar 26, 2024 at 09:49:26AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 26, 2024 at 09:47:36AM -0700, Darrick J. Wong wrote:
> > There's not much reason.  Now that memfd_create has existed for a decade
> > and the other flags for even longer, I'll drop all these configure
> > checks.
> 
> The only really new and at the same time important/new one is
> MFD_NOEXEC_SEAL.  That's why I'd love to just defined it if it isn't
> defined so that any recent kernel (including disto backports) gets
> the flag and we avoid having executable memory as much as possible.

<nod> I'll factor that in too:

/*
 * Starting with Linux 6.3, there's a new MFD_NOEXEC_SEAL flag that disables
 * the longstanding memfd behavior that files are created with the executable
 * bit set, and seals the file against it being turned back on.
 */
#ifndef MFD_NOEXEC_SEAL
# define MFD_NOEXEC_SEAL	(0x0008U)
#endif

and later:

	/*
	 * memfd_create was added to kernel 3.17 (2014).  MFD_NOEXEC_SEAL
	 * causes -EINVAL on old kernels, so fall back to omitting it so that
	 * new xfs_repair can run on an older recovery cd kernel.
	 */
	fd = memfd_create(description, MFD_CLOEXEC | MFD_NOEXEC_SEAL);
	if (fd >= 0)
		goto got_fd;
	fd = memfd_create(description, MFD_CLOEXEC);
	if (fd >= 0)
		goto got_fd;


--D
