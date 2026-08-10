Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67F735C69B;
	Mon, 10 Aug 2026 08:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350818; cv=none; b=gpbTQ9qCn8EKDYdT8PU1Ytmx4bL5CzxNEXAKBg3jRCO8a44sl1jQ/OOB/6v3251gPuiGMZ+yASpHfd1fy1BngaE894S+X9AX8Qe+lq1VaGrhrMin0CbjZ1cHWgjVDSMWISPl+T9+lqAGSu4P1vedLKXBE0nLpUy3Wt1fwkMqj48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350818; c=relaxed/simple;
	bh=KdWRtTl1P/hwef34dPCs6lnQNc5cgr88YyOCqkr6f+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rz8QWNuttA4kUlCmzNgOOk/s3IN/oEZvs4Z9f0GT/xrGMRrmwMHsxJQdVU0YlKck6QnrF+cSmQgDVJ0iv43mHJQvijo+vs6kztfk9hYlMT6zO3XhXWCB22a3Boc0PoWPXgL+25nMesKeMGukd/bOIhgJnGm6FTeziFCnf97wxDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZ0sNoTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZ0sNoTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF9E1F00A3A;
	Mon, 10 Aug 2026 08:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786350817;
	bh=BAtyw81+dBMiu7XlLAIQLatNTnzJYfKHmuu6xvYOIyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AZ0sNoTsACbmKvxS8u/yWus9xVKhsJ1sw7YXHSY0plOcnJztWWyy6K7DffjeNScfJ
	 M1ACXgiigHq/zftVDKz2KWQRGvyhIb+tyw1bJEKJWMSf7zAfFLjUEf69iE9aidV2UK
	 tbheV4Pug5nZv+XzwjxuCRiZGSsO9yDsnUCK3y5U18rVHPNC0BIusLbm5uw7Fxmvh3
	 pfzhRxc+pyg8ksrAsCAZPvmSRJ8Xo2tl2L5rDjMoQtBTm/Eg8azJOFBogY2QPgJHoB
	 0FS0xvBC8mBOthwT7GrgoxXEcYjYsI5TmBe2531CO6lj3KX3kM7EykqimuYVUqzl+r
	 5fz1kjp8sjgpg==
Date: Mon, 10 Aug 2026 10:33:32 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v14 11/21] xfs: don't report dio_mem_align and
 dio_offset_align for fsverity files
Message-ID: <anmMB2QB_CkGEdN0@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-12-aalbersh@kernel.org>
 <20260804174347.GC14046@lst.de>
 <20260804182453.GA2904385@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804182453.GA2904385@google.com>

On 2026-08-04 18:24:53, Eric Biggers wrote:
> On Tue, Aug 04, 2026 at 07:43:47PM +0200, Christoph Hellwig wrote:
> > On Mon, Aug 03, 2026 at 10:08:01PM +0200, Andrey Albershteyn wrote:
> > > Sashiko.dev reported that while fsverity files falls back to the
> > > buffered IO for Direct I/O, they should not report non-zero values in
> > > dio_mem_align and dio_offset_align, meaning it's not supported.
> > 
> > This doesn't make much sense to me.  If we didn't want to report
> > we'd also want to not set STATX_DIOALIGN | STATX_DIO_READ_ALIGN.
> > But in the end there is very little upside of this while adding
> > extra special cases.
> 
> Zero values in the alignments are defined to mean that DIO is
> unsupported; see statx(2).  It's right to do that here and also set
> STATX_DIOALIGN | STATX_DIO_READ_ALIGN, as that explicitly reports that
> DIO is unsupported.
> 
> Leaving the attribute flags unset would mean not reporting anything at
> all, which could mean DIO either supported or unsupported.
>

I will extend the commit message to include this

> 
> Acked-by: Eric Biggers <ebiggers@kernel.org>

Thanks!

-- 
- Andrey
