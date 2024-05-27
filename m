Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC4C13AD37
	for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 10:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716806053; cv=none; b=qct4iWBo3uCxrIku9S0K1KKoILgA4Oz0Ola8RTIofnSkgjypb3SQPuIfLpv0f/yhfjpRfXwMkOGuV6hs9jvg5yWpca86uiyV33709OTY8Yu0BudALcZiR0XyF6sn0am+l027bSaUkx4/FTDZTVefDwaqXHPg35fjeiC560Hllj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716806053; c=relaxed/simple;
	bh=bYUpqJQlH12B7mcdEsSxXwtVo6ZzCa5A06fxyoSxSJY=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=TlsWDFRZ85i6MyibJJdnueqQNHp5/Msh6AuT31TCteCF21JQSLQFFNThRSIjyxr/BALgE3ShfCBfpPM6qafCHybdwIsCeOR4DD/PAO2UB2t0AKdJEJsF85kaR/pmfgDJ+My5EwyB7U+lXsgvL0r3JmtkkbqXwpMjYkVe2T9lExA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1inLiAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1inLiAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B95EC2BBFC;
	Mon, 27 May 2024 10:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716806053;
	bh=bYUpqJQlH12B7mcdEsSxXwtVo6ZzCa5A06fxyoSxSJY=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=u1inLiAEzXjDLNPs3hF3rSghOH6qpycoUd69VcxvvTBdRY6IbxYUUtttiXfWb0qaC
	 93RNrDjXMbxRVu/E4TYTmBMv4CCqHq63bI8mOXfU34LxzFS4uAhU3bzwUs/ppaQYGi
	 GcwLU6fMfJNQjh8vyVdNhKfPVIOz+8NiOKzspEPnrRaUwIPYK8eThYmZrx8Z1pBNrk
	 30Fc1qWZrAx0LhVusXXtRAtF6YEssm9o+Gx+CKk3r/b8tYwVUPSjLq6nN+a6tg4WCb
	 H5gWT3a70br8jQbQ0mK84XvwvSLAK8nw9h8aKvBdDT5xVMSHsFN1F9thW0BLRA73mj
	 FdO7+MZFxzS1Q==
References: <20240524164119.5943-1-llfamsec@gmail.com>
 <87ikyz7tvj.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZlRQ6W8BlfZ+3rWs@dread.disaster.area>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 djwong@kernel.org, lei lu <llfamsec@gmail.com>
Subject: Re: Fwd: [PATCH] xfs: don't walk off the end of a directory data block
Date: Mon, 27 May 2024 15:59:07 +0530
In-reply-to: <ZlRQ6W8BlfZ+3rWs@dread.disaster.area>
Message-ID: <875xuz7dcu.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, May 27, 2024 at 07:22:49 PM +1000, Dave Chinner wrote:
> On Mon, May 27, 2024 at 10:05:17AM +0530, Chandan Babu R wrote:
>> 
>> [CC-ing linux-xfs mailing list]
>> 
>> On Sat, May 25, 2024 at 12:41:19 AM +0800, lei lu wrote:
>> > Add a check to make sure xfs_dir2_data_unused and xfs_dir2_data_entry
>> > don't stray beyond valid memory region.
>
> How was this found? What symptoms did it have? i.e. How do we know
> if we've tripped over the same problem on an older LTS/distro kernel
> and need to backport it?
>
>> > Tested-by: lei lu <llfamsec@gmail.com>
>> > Signed-off-by: lei lu <llfamsec@gmail.com>
>> 
>> Also adding the missing RVB from Darrick,
>> 
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> That's not really normal process - adding third party tags like this
> are kinda frowned upon because there's no actual public record of
> Darrick saying this.

Ok. The patch was posted on security@kernel.org with me on CC. Hence, I had
decided to forward the patch to linux-xfs for any reviews from the wider
audience.
>
> i.e. patches send privately should really be reposted to the public
> list by the submitter and everyone then adds their rvb/acks, etc on
> list themselves.
>

Sorry, I didn't know about the last part i.e. rvbs need to be added once again
after reposting the patch.

>> 
>> > ---
>> >  fs/xfs/libxfs/xfs_dir2_data.c | 7 +++++++
>> >  1 file changed, 7 insertions(+)
>> >
>> > diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
>> > index dbcf58979a59..08c18e0c1baa 100644
>> > --- a/fs/xfs/libxfs/xfs_dir2_data.c
>> > +++ b/fs/xfs/libxfs/xfs_dir2_data.c
>> > @@ -178,6 +178,9 @@ __xfs_dir3_data_check(
>> >  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>> >  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
>> >  
>> > +		if (offset + sizeof(*dup) > end)
>> > +			return __this_address;
>> > +
>> >  		/*
>> >  		 * If it's unused, look for the space in the bestfree table.
>> >  		 * If we find it, account for that, else make sure it
>> > @@ -210,6 +213,10 @@ __xfs_dir3_data_check(
>> >  			lastfree = 1;
>> >  			continue;
>> >  		}
>> > +
>> > +		if (offset + sizeof(*dep) > end)
>> > +			return __this_address;
>> > +
>> >  		/*
>> >  		 * It's a real entry.  Validate the fields.
>> >  		 * If this is a block directory then make sure it's
>
> Nothing wrong with the code change, though.
>

-- 
Chandan
