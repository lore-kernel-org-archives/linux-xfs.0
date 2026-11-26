Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795754947;
	b=ItTPpdoW8/VIp21Utp3AZLsK25zgaVZeRDfTNQCyxyEZM5Fljl+w1neRwSLP0InpsROv
	 7aC6Mf+8aJRXGDu2UuguDJ00cNMdPQPCjxx1xDoXe0eQDhRYMKGEpLJRhmc5uLlMf9sWi
	 OerBl/Y64S60F0b0t3DrfYtaHirP/H2xVmXkX0Ih+dgZkfikXBrE22lKwizKhwHy7Mlma
	 S0BAs8MX/4mKU+X/75dOxPEKOpZKLiuQ+eBW9R1k75tzSXaVefs1HOoOr7ahBZxDswzCE
	 cBaOXyr+/gyY4KzhJ5zz2F9cLDhRbX60c/vpolYT+gwe8e1jbaY26KydPQHznHTObrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795754947;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=iNoXtWRsShqkaT8Om4t3txradi9WqhTkrESpAU8Gizw=;
	b=yEcpl/eqy4eIc6x1J4bCv5lPMFvFW4cmCthIh6yNDqGqQK/a6DgJvlUMIe68Fom+lsty
	 e0XFH8yPN8qptkRi2zveMDVLJG0Tj9TVPtjo/wM5UoWY3PQOrjvfq3j7F/nusM1HDsj31
	 hxqBl7Ol+1hc9jHgiIIgYH/dYuf9HEK55CxHARiIZTOp/BBqZyE1L0zTlQdIMfXMvQFiU
	 +knusJLRULLkOVTPjluwh0CXHWnqjnzdom6EERGNcejL7tm089CvsdcU6sQjkRkzXnxny
	 0qKqlpqiZAjCKZ2/e19mmaBhtGZYD0RKFvPG+iHvTVhAhPXAth75vGTkrXnOyqPAnWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1sjOoI+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CC5606A31C;
	Fri, 27 Nov 2026 04:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1sjOoI+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2011F00893;
	Fri, 27 Nov 2026 04:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795754947;
	bh=iNoXtWRsShqkaT8Om4t3txradi9WqhTkrESpAU8Gizw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X1sjOoI+UHrz7oU46o3WpACPhkmBp2c6kDzSU3gm6B3nyJ2dXtiaK3fuPhclpLx7M
	 XMZqijUZonsgfNW8QqdqjGJhRQdIoZZGauho/viK545zerxH1uSXMZ6/L837K7sSv/
	 fgFMSO4dJ2oUOhVmzbNfGuEK5bxuBSlsfe5e7EAc=
Date: Thu, 26 Nov 2026 20:05:54 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>, Alexander Aring <alex.aring@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
	Lauri Gates <lauri.gates@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 1/4] vfs: use goto out on error in vfs_fileattr_set()
Message-ID: <2026112647-earful-frosted-6ef3@gregkh>
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-2-koray.fra@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126163114.403846-2-koray.fra@gmail.com>

On Thu, Nov 26, 2026 at 05:31:11PM +0100, koraynilay wrote:
> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
> in the main body of vfs_fileattr_set().
> 
> Signed-off-by: koraynilay <koray.fra@gmail.com>

Real name please.

