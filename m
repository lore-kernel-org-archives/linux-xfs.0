Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB6D2EA754;
	Tue, 11 Aug 2026 16:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465748; cv=none; b=e9fZ5yD670xa9ISnSFn0mR1jLGX4WiBjbDQXGTWURo2Wm9NnTQWpjIuKwLNRUG7KYuiqHSqI+rTDMCYpVv44ERHwbJeHO+XToQCus7O3tHD+3J8ZT91G1vOzA/YMHbW+EJmPgBTPKH5gR9ynkK/E3Rxk6J83LeyH8VCV49+MaYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465748; c=relaxed/simple;
	bh=C1jpajQrWuOF3j5Pr1Ddzi0Kc/tRtKfoGXct28RFEoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8UCiak6bEXSiX6kF+PUrk3eNwVT1QykZaKidT+fijpmwSNmfvkQAz9kgkh4yGGQnXcWrIXhxAlTxPN+zJC4MOLOXKloSSl0YLZ7kYHQHVu0dpgP2/7/4FRN64CqhWYd8yqnIBsGN4Dxgx1I+pgD1EGjxzNlKcmfON0SqHJMsuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWXP9E1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWXP9E1S"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C99E11F000E9;
	Tue, 11 Aug 2026 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465746;
	bh=91UQoUF/zJ0f/Ujq+Dd1GUnY1kZrsRbXE5pzSQBIH/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iWXP9E1SeF4g2o15ZNrOMyxfJ9jT7WnhSBimlWhEU3cHPs2HdAhN9qC8saGgdrb9r
	 IAIdhMbaRQBnVz8f3jb037oBNQcL2odbhgChRfNIgmfH0zCyQqZkNA9mpobxMMlYzl
	 dAq1pTnIp3Sueixht9VXowiiNlrO0WEEUxQIWWmGZUYUCjVfeePiJNEhv8GnDfGgXe
	 Y3HTzvJ4IyXMNXBV1x3rcTevMEuBMrwiT8sbKYd8187HtK1I+huuq6L9gCD1yP9YFo
	 2aw9PZFmMmt38UbtUzTNZb689mmTijVDH9KM8qMslc0+BxrxZnqAyRiE9zRaNmUMHn
	 OdMAZUf1qiUJQ==
Date: Tue, 11 Aug 2026 09:29:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 13/21] xfs: use read ioend for fsverity data
 verification
Message-ID: <20260811162906.GC3556460@frogsfrogsfrogs>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-14-aalbersh@kernel.org>
 <20260804183632.GO3556460@frogsfrogsfrogs>
 <anmNNNNy4YsV_KLB@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260810183102.GY3556460@frogsfrogsfrogs>
 <anrZR9SarXJMBLgI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anrZR9SarXJMBLgI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Tue, Aug 11, 2026 at 10:18:05AM +0200, Andrey Albershteyn wrote:
> > > > "If we have fsverity and block device integrity attached to this bio,
> > > > we need to run both validations from the separate fsverity workqueue
> > > > to avoid deadlocking due to fsverity issuing its own reads."
> > > > 
> > > > (Assuming I understand the fsverity && pi case correctly.)
> > > > 
> > > > One thing I'm not clear about -- why is it safe to do the fsverity
> > > > validation here if PI isn't enabled?  Can't that also issue IO to pull
> > > > in merkle tree blocks?
> > > 
> > > Without PI, fsverity metadata is read without XFS bio completion
> > > path, we don't get here for the descriptor/metadata reads
> > > (see xfs_get_iomap_read_ops()). So, we won't block the queue, as
> > > data ioends won't be mixed with metadata ioends.
> > > 
> > > With PI, all fsverity reads goes through this path. We could get a
> > > case that data ioend is waiting for metadata IO to be completed which
> > > in turn is pending for data ioend to be finished (due to batch
> > > processing of multiple BIOs in the bio_complete wq).
> > > 
> > > So, this will issue more IO, but this IO will not get onto this
> > > queue (it will go through iomap_bio_submit_read()).
> > 
> > Ah, ok.  Maybe add to that comment:
> > 
> > "If we have fsverity enabled but block device integrity is not enabled,
> > completion of the fsverity metadata reads does not require a workqueue
> > so there is no deadlock potential."
> > 
> > then?
> > 
> > (Just echoing you to make sure I understand completely.)
> > 
> 
> yes,
> 
> I've changed it to:
> 
> +       /*
> +        * If we have fsverity and block device integrity attached to this bio,
> +        * we need to run fsverity verification of data folios from a separate
> +        * fsverity workqueue. This is necessary to avoid deadlocking due to
> +        * fsverity issuing more reads of fsverity metadata which would be
> +        * processed by the same worker in the BIO completion workqueue.
> +        *
> +        * Without device integrity, fsverity metadata IO will not use ioends for

I would like to nitpick this to "Without block device integrity..." but
otherwise this comment looks good to me :)

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +        * completion.
> +        */
> 
> 
> -- 
> - Andrey
> 
> 
