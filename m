Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795162565;
	b=UXOcEnh4/B2G8XHLpqFqa9N0enqRU5ae463dGDbqi+BGtE2WO4kGW6bHzXeVABwzEPy0
	 IL+A02xt15mZ0e16ms/1psAq9I9LL7dG1jP6WRKmG4o1fa57JsJmKWUR8GczsZviXhAbu
	 PKpFNVhizCoFJHBtED6ldhGjbXIgGFEMf8bxkE1Al0jghUF4xmIhq1YY3nnQcqKRyQvdl
	 jEJjugaxVFOE7LqM0yBlY3Dphtda6194HwATqHElJO97Y0uEUJioUEwdNR+tGU7XpoVDj
	 5wcUtsJgVNJdxj5QZQj3WtXKZAuHWifnynTDmkwUZtQLUPB2VQPPawrILQ1Q+sD2KtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162565;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gRnXn7A8a8ltwBq+RheRl5mDgBsU2Z5PbLlb1u7e8CU=;
	b=BJFsRyUJY4UbcqL6JI/lco7oXma4kGulbpVSgOy4JnXw6hh1QSJINwavxrVeXQ8GwhbE
	 gdcvOn6sxz2wZQuAyKfXvqnbGrqYZ+DTr/d4uUNqpro1duain6/3aSeTpk0rgZ5l1ojsF
	 vf5O4kOqz+G0AbQCvyXg8IvG0N3ozGCHnD7WBMO3m7swkG5TRb3nyokCL68DSjpU+nKgN
	 cMs+EEys8nx4v6PSw1eg0xwuRmnKBBf6wgnYAwTZ1objbxUWwxNOrKfbdySDt+k3V7Wcp
	 HBCUSvCw5L4/Qr833lyjaDohk2o1CszYpBXyzGbwkc6P5cemTJCLvdM1hB+JdCp6NIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O3SBUo3Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C14606A332;
	Fri, 20 Nov 2026 08:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O3SBUo3Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE661F000CA;
	Fri, 20 Nov 2026 08:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795162565;
	bh=gRnXn7A8a8ltwBq+RheRl5mDgBsU2Z5PbLlb1u7e8CU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O3SBUo3Qd1oYvzOGUJ5rYpD2S8YhyUOUglVc/LxFyzDJLfoAn4a0DXLMJ/nR+m9M8
	 sNN5u2N3okNnUETsRESBjksvHqkmuUTTC0GL7Ont3UhHFelFdFj0HhHZ7depwkLkrM
	 Tfv/2kQ7CM3b6uy97snz53Hu1sfbx+dQsM6VxJ2fSK5sIWd8oDLSs7VmdAamuShnoF
	 Q9DEGgGxDOMCy7wPXUwg36k8y4264dUYGGGdHlM6kDleWtbjv+uydRghVSrMVw5/EQ
	 7uL+EVf4BdNUN8gnHe6Dn2+hYNRRLpE+tOjk9vaTUe7t98luO9gcouKOjdlybNTogO
	 pIEzydj/7wkog==
Date: Fri, 20 Nov 2026 09:15:58 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev, 
	dsterba@suse.com, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Message-ID: <awABahzFVV5pX6bG@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-3-aalbersh@kernel.org>
 <20261119-gefunden-beteiligen-epidemie-5a23ff160ef4@brauner>
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
In-Reply-To: <20261119-gefunden-beteiligen-epidemie-5a23ff160ef4@brauner>

On 2026-11-19 21:48:27, Christian Brauner wrote:
> On Thu, Nov 05, 2026 at 12:55:27PM +0100, Andrey Albershteyn wrote:
> > Every filesystem that supports fs-verity keeps a private runtime inode
> > flag meaning Merkle tree is currently being built *_VERITY_IN_PROGRESS.
> > They all serve the same two purposes: reject a concurrent enable with
> > -EBUSY and let the write paths recognize the special writes done while
> >
> > ...
> >
> > +/**
> > + * fsverity_is_building() - is fs-verity being enabled on the inode
> > + * @inode: inode to check
> > + *
> > + * This checks whether the inode's Merkle tree is currently being built.
> > + * While this is the case the file is read-only to userspace and the only writes
> > + * allowed are for the fs-verity metadata. This becomes false when fsverity
> > + * metadata is fully created and written to disk or building failed.
> > + *
> > + * Return: true if fs-verity is being enabled on the inode
> > + */
> > +static inline bool fsverity_is_building(const struct inode *inode)
> > +{
> > +	return inode_state_read_once((struct inode *)inode) & I_VERITY_BUILDING;
> 
> Isn't the fix to make inode_state_read_once() take a const struct inode *?
> 

Yes I have a fix, I will send as part of this series in the next
revision

-- 
- Andrey
