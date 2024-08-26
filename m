Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3726E172798
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724680985; cv=none; b=SbszkyL83hWitfQMN4dOHr79OQhKKSDu0qZKuaQq80xuz9h97mgrUuCRIGDtAa/lTQpryhYU5jIxow2dNK0I6L11VH+LJ4B9p67awCXNPst0I6QPH1Ow111iPj+19vHlFBUIfamZkvWr1C2/p/tD/qGIic6OxSVL/fdAf/yf6j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724680985; c=relaxed/simple;
	bh=UxE37JX3vBh/r7gY/QAYm5+kUjsT9br9WCPOtSKlIlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAElJ/mAi8w5H86MdPZNebo/iRYesRycjoCvFSGL/GRTbf31xxoWmcd3b3IzY8Jm95XGWV9HmLoSwKcxxB7BngAGM7fUHzF/GRHoQkezkhhT4f915Zn/f7H0CQXCASeiCK8HvC4AggrxAs1NouoEWcov9i9UWgwpy0dI1uPwMD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fni6IPpD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fni6IPpD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724680982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d4R4miyPHM6EuRnV2gZm55vWmA2gpIieEZBqSmcuGng=;
	b=fni6IPpDq5UB+LH6N6I4djjdQbZIeaNes+QPfXOPvsYjcybrv6zlS44QLFzjkWwHzYEfBk
	WLrBN27CNNvqNp0YPx5P6HhUs2n5oztIzotuBViv3W4u9AwAV7C9L0EZZbihETxmmOvlW5
	SPOJ+aRbG0T2p4EvEpLPN04sf844pts=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-mfhC92C0MS2yvgg7UTfrFg-1; Mon,
 26 Aug 2024 10:03:00 -0400
X-MC-Unique: mfhC92C0MS2yvgg7UTfrFg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25E6B195421E;
	Mon, 26 Aug 2024 14:02:59 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.22])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A09031955F43;
	Mon, 26 Aug 2024 14:02:57 +0000 (UTC)
Date: Mon, 26 Aug 2024 10:03:54 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH 1/3] fsx: factor out a file size update helper
Message-ID: <ZsyLShYLojBLPNiC@bfoster>
References: <20240822144422.188462-1-bfoster@redhat.com>
 <20240822144422.188462-2-bfoster@redhat.com>
 <20240822205019.GV865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822205019.GV865349@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Aug 22, 2024 at 01:50:19PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 22, 2024 at 10:44:20AM -0400, Brian Foster wrote:
> > In preparation for support for eof page pollution, factor out a file
> > size update helper. This updates the internally tracked file size
> > based on the upcoming operation and zeroes the appropriate range in
> > the good buffer for extending operations.
> > 
> > Note that a handful of callers currently make these updates after
> > performing the associated operation. Order is not important to
> > current behavior, but it will be for a follow on patch, so make
> > those calls a bit earlier as well.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  ltp/fsx.c | 57 +++++++++++++++++++++++++------------------------------
> >  1 file changed, 26 insertions(+), 31 deletions(-)
> > 
> > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > index 2dc59b06..1389c51d 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> > @@ -983,6 +983,17 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
> >  	}
> >  }
> >  
> > +/*
> > + * Helper to update the tracked file size. If the offset begins beyond current
> > + * EOF, zero the range from EOF to offset in the good buffer.
> > + */
> > +void
> > +update_file_size(unsigned offset, unsigned size)
> > +{
> > +	if (offset > file_size)
> > +		memset(good_buf + file_size, '\0', offset - file_size);
> > +	file_size = offset + size;
> > +}
> >  
> >  void
> >  dowrite(unsigned offset, unsigned size)
> > @@ -1003,10 +1014,8 @@ dowrite(unsigned offset, unsigned size)
> >  	log4(OP_WRITE, offset, size, FL_NONE);
> >  
> >  	gendata(original_buf, good_buf, offset, size);
> > -	if (file_size < offset + size) {
> > -		if (file_size < offset)
> > -			memset(good_buf + file_size, '\0', offset - file_size);
> > -		file_size = offset + size;
> > +	if (offset + size > file_size) {
> > +		update_file_size(offset, size);
> >  		if (lite) {
> >  			warn("Lite file size bug in fsx!");
> >  			report_failure(149);
> > @@ -1070,10 +1079,8 @@ domapwrite(unsigned offset, unsigned size)
> >  	log4(OP_MAPWRITE, offset, size, FL_NONE);
> >  
> >  	gendata(original_buf, good_buf, offset, size);
> > -	if (file_size < offset + size) {
> > -		if (file_size < offset)
> > -			memset(good_buf + file_size, '\0', offset - file_size);
> > -		file_size = offset + size;
> > +	if (offset + size > file_size) {
> > +		update_file_size(offset, size);
> >  		if (lite) {
> >  			warn("Lite file size bug in fsx!");
> >  			report_failure(200);
> > @@ -1136,9 +1143,7 @@ dotruncate(unsigned size)
> >  
> >  	log4(OP_TRUNCATE, 0, size, FL_NONE);
> >  
> > -	if (size > file_size)
> > -		memset(good_buf + file_size, '\0', size - file_size);
> > -	file_size = size;
> > +	update_file_size(size, 0);
> >  
> >  	if (testcalls <= simulatedopcount)
> >  		return;
> > @@ -1247,6 +1252,9 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
> >  	log4(OP_ZERO_RANGE, offset, length,
> >  	     keep_size ? FL_KEEP_SIZE : FL_NONE);
> >  
> > +	if (end_offset > file_size)
> > +		update_file_size(offset, length);
> > +
> >  	if (testcalls <= simulatedopcount)
> >  		return;
> 
> Don't we only want to do the goodbuf zeroing if we don't bail out due to
> the (testcalls <= simulatedopcount) logic?  Same question for
> do_clone_range and do_copy_range.
> 

Hm, good question. It's quite possible I busted something there. For
some reason I was thinking this would all be a no-op for that mode but I
hadn't quite thought it through (or tested it).

It looks like this is for the -b "beginning operation number" support,
so you can start a test from somewhere beyond operation 0 of a given
seed/sequence. As such it appears to make changes to incore state and
then write the goodbuf out to the file and truncate it as a final step
before proper operation begins.

Looking at how some of the current operations are handled, I think the
size-related goodbuf zeroing is Ok because we'd expect that part of the
file to remain zeroed, after a truncate up, etc., for example. In fact,
I'm wondering if the current zero range behavior is technically wrong
because if a zero range were to extend the file during simulation, we
don't actually update the in-core state as expected. This might actually
be worth factoring out into a bug fix patch with proper explanation.

WRT the eof pollution behavior during simulation, I'm kind of on the
fence. It's arguably wrong because we're not running the kernel
operations and so there's nothing to verify, but OTOH perhaps we should
be doing the zeroing associated with size changes in-core that should
wipe out the eof pollution. Then again, nothing really verifies this and
if something fails, we end up writing that data out to the test file.
None of that is really the purpose of this mechanism, so I'm leaning
towards calling it wrong and making the following tweaks:

1. Split out another bug fix patch to do size related updates (including
zeroing) consistently during simulation.

2. Update pollute_eofpage() in the next patch to skip out when testcalls
<= simulatedopcount (with some commenting).

Let me know if you think any of that doesn't make sense.

> /me reads the second patch but doesn't quite get it. :/
> 

The zeroing tests I was using were basically manual test sequences to do
things like this:

	xfs_io -fc "truncate 2k" -c "falloc -k 0 4k" ... -c "mwrite 0 4k" \
		-c "truncate 8k" <file>

... which itentionally writes beyond EOF before a truncate up operation
to test whether the zero range in the truncate path DTRT with a dirty
folio over an unwritten block. In a nutshell, I'm just trying to
genericize that sort of test a bit more by doing similar post-eof
mwrites opportunistically in fsx in operations that should be expected
to do similar zeroing in-kernel.

I.e., replace the "truncate 8k" above with any size extending operation
that starts beyond EOF such that we should expect the range from
2k-<endofpage> to be zeroed. Does that explain things better?

> Are you doing this to mirror what the kernel does?  A comment here to
> explain why we're doing this differently would help me.
> 

Yeah, sort of... it's more like writing a canary value to a small range
of the file but rather than expecting it to remain unmodified, we expect
it to be zeroed by the upcoming operation. Therefore we don't write the
garbage data to goodbuf, because goodbuf should contain zeroes and we
want to detect a data mismatch on subsequent reads if the kernel didn't
do the expected zeroing.

Brian

> --D
> 
> >  
> > @@ -1263,17 +1271,6 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
> >  	}
> >  
> >  	memset(good_buf + offset, '\0', length);
> > -
> > -	if (!keep_size && end_offset > file_size) {
> > -		/*
> > -		 * If there's a gap between the old file size and the offset of
> > -		 * the zero range operation, fill the gap with zeroes.
> > -		 */
> > -		if (offset > file_size)
> > -			memset(good_buf + file_size, '\0', offset - file_size);
> > -
> > -		file_size = end_offset;
> > -	}
> >  }
> >  
> >  #else
> > @@ -1538,6 +1535,9 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
> >  
> >  	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
> >  
> > +	if (dest + length > file_size)
> > +		update_file_size(dest, length);
> > +
> >  	if (testcalls <= simulatedopcount)
> >  		return;
> >  
> > @@ -1556,10 +1556,6 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
> >  	}
> >  
> >  	memcpy(good_buf + dest, good_buf + offset, length);
> > -	if (dest > file_size)
> > -		memset(good_buf + file_size, '\0', dest - file_size);
> > -	if (dest + length > file_size)
> > -		file_size = dest + length;
> >  }
> >  
> >  #else
> > @@ -1756,6 +1752,9 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
> >  
> >  	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
> >  
> > +	if (dest + length > file_size)
> > +		update_file_size(dest, length);
> > +
> >  	if (testcalls <= simulatedopcount)
> >  		return;
> >  
> > @@ -1792,10 +1791,6 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
> >  	}
> >  
> >  	memcpy(good_buf + dest, good_buf + offset, length);
> > -	if (dest > file_size)
> > -		memset(good_buf + file_size, '\0', dest - file_size);
> > -	if (dest + length > file_size)
> > -		file_size = dest + length;
> >  }
> >  
> >  #else
> > @@ -1846,7 +1841,7 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
> >  
> >  	if (end_offset > file_size) {
> >  		memset(good_buf + file_size, '\0', end_offset - file_size);
> > -		file_size = end_offset;
> > +		update_file_size(offset, length);
> >  	}
> >  
> >  	if (testcalls <= simulatedopcount)
> > -- 
> > 2.45.0
> > 
> > 
> 

