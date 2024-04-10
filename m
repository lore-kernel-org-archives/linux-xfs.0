Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3353F138E
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 23:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712790445; cv=none; b=rYqOl7I5qkWZhT/cnnnWITq0U+7Z+c9Am5eaPpzk5bYPkWYY94nZAd7o15eDgbU1x5N9LbRkOMtJpOBz/vqupEjYeL85DD9xPgpu6KmexWOT1O/cAodHPc9tQX50/T/studPxzo0KTy2usnO7q2gKIr7r3NDaXdKSuy8CSFm8aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712790445; c=relaxed/simple;
	bh=ajv4I4mEyaE74sgnUbDP2V2C1H+iG6Prer1C17WJkm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/2qLVjXCLUErLFckeufMT+FvwwPhcZg5rT1ZAsQdKCbSogajINXEfjzxSOtMQ2mhJ6BI4R6wPnpW1gjXSAvzV0yHbruvFLfLZ4N8btYo0fT7hX8pEDb+U4vNTFRmnHxGCCCjiLFvJXjeyjbrduAV1VB0t4MWb0+Rv5ak4xC2qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZnHijWTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnHijWTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9327C433F1;
	Wed, 10 Apr 2024 23:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712790444;
	bh=ajv4I4mEyaE74sgnUbDP2V2C1H+iG6Prer1C17WJkm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZnHijWTStGu/PXVg8TJRya1robygeiJS066jO7ZBXvIJM06S2zC5BpA9qbgElc5Xt
	 E4Z1jP8v/2Nnrh2iWD9JlGM8jJDNfR6mRxvOhNeZX+LwN5yjKSQnvXHACuGzW21u97
	 bWLBhuIu6N8hUl53ZjuEVN8BwdVaNFPnjD/LTLuCtfsvMyWgB8hFsg4Mg49rRaaY/8
	 NbEYiUzTPy2AjGl0YPRPtGctRqi64hFVRuf9awrBaA7kM7n1qS673VkbAj1sRG3bVS
	 ot9alVdeZHP8AX1IismEkundh1FJuY9VXSjH/DQ0OZs1VsvfsSY6x2MGFC7SiVXKKF
	 KJwXzh5iBVziw==
Date: Wed, 10 Apr 2024 16:07:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/32] xfs: log parent pointer xattr replace operations
Message-ID: <20240410230724.GN6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969740.3631889.12974902040083725812.stgit@frogsfrogsfrogs>
 <ZhYi73ThMtCUVrF5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYi73ThMtCUVrF5@infradead.org>

On Tue, Apr 09, 2024 at 10:26:07PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 05:56:22PM -0700, Darrick J. Wong wrote:
> > From: Allison Henderson <allison.henderson@oracle.com>
> > 
> > The parent pointer code needs to do a deferred parent pointer replace
> > operation with the xattr log intent code.  Declare a new logged xattr
> > opcode and push it through the log.
> > 
> > (Formerly titled "xfs: Add new name to attri/d" and described as
> > follows:
> 
> I don't think this history is very important.  The being said,
> I suspect this and the previous two patches should be combined into
> a single one adding the on-disk formats for parent pointers, and the
> commit log could use a complete rewrite saying that it a

I combined the three patches into this:

    xfs: create attr log item opcodes and formats for parent pointers

    Make the necessary alterations to the extended attribute log intent item
    ondisk format so that we can log parent pointer operations.  This
    requires the creation of new opcodes specific to parent pointers, and a
    new four-argument replace operation to handle renames.  At this point
    this part of the patchset has changed so much from what Allison original
    wrote that I no longer think her SoB applies.

    Signed-off-by: Darrick J. Wong <djwong@kernel.org>

and about time, I was getting real irritated at having to iterate back
and forth across those. ;)

> > +			return false;
> > +		if (attrp->alfi_old_name_len == 0 ||
> > +		    attrp->alfi_old_name_len > XATTR_NAME_MAX)
> > +			return false;
> > +		if (attrp->alfi_new_name_len == 0 ||
> > +		    attrp->alfi_new_name_len > XATTR_NAME_MAX)
> > +			return false;
> 
> Given that we have four copies of this (arguably simple) check,
> should we grow a helper for it?

static inline bool
xfs_attri_validate_namelen(unsigned int namelen)
{
	return namelen > 0 && namelen <= XATTR_NAME_MAX;
}

Done.

> > +		if (attrp->alfi_value_len == 0 ||
> > +		    attrp->alfi_value_len > XATTR_SIZE_MAX)
> > +			return false;
> 
> All parent pointer attrs must be sized for exactly the parent_rec,
> so we should probably check for that explicitly?

Done.

> > +	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE) {
> 
> Please avoid the overly long line here.

I've turned that into a switch()

> >  
> > +	/* Validate the new attr name */
> > +	if (new_name_len > 0) {
> > +		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(new_name_len)) {
> 
> .. and here.
> 
> And while we're at it, maybe factor the checking for valid xattr
> name and value log iovecs into little helper instead of duplicating
> them a few times?

Ok, I'll add that as a prep patch.

--D
