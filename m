Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84B322CF31
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 13:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736775529; cv=none; b=k1AyBG5VHu1Bhpu954dGuUe+NlJErXlWSICq6wdb5dm4vcfNJaMMPGmr5FFLwzaHmd1eu3T2xkMbuKOnEzGn1JBlB/6hZCuH2b9IPEE5f0k/U+ccbS7D7vEBxCSUO+IWJs+sIqZwheXxBg0JtvTIp2CBsBlYBZvzRX+hPe/k2J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736775529; c=relaxed/simple;
	bh=K6HSspyhDT7Y0jKZSL4JvqLPPQ5C2GujAWTc3l3nwnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hFRV4qeH3zHadugoRnrS2RHwWFdyZpCupbdpFJ2gVFU4QKaGXT7vb3LBOOD5FWRXyCv75U379+cNO6HLU5+M7V5RTRWk8Oa3oNzAbH/c3TvVOFPctI3HFQvIQCWNn0cXWE0Z2wb0K6NLFVdKabtsGUDd/U0JTRbVV/LLBCMAHVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hadGorl3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hadGorl3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736775526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XNsY4ONxSrNjHz/aebponzVwHXBmaI44kLipEEXLGT0=;
	b=hadGorl3M81J1UIlbbDublc2//OLNsYGkv7lQy6dk4zRH9IYObpJGrdJTlJbDqihDVKmU6
	+7xDu5U0F600i4DmmEIgPUl8WGQpjdUk3syeAz6mGs/uvfRMuG30Vt96ex2vBjIiR1CnT+
	c9+AjIV2xft+AvfH9nGXRM+P9gwJ/24=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-xlFgX_vgM4qD8LHxynklrQ-1; Mon,
 13 Jan 2025 08:38:43 -0500
X-MC-Unique: xlFgX_vgM4qD8LHxynklrQ-1
X-Mimecast-MFC-AGG-ID: xlFgX_vgM4qD8LHxynklrQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72279195605A;
	Mon, 13 Jan 2025 13:38:41 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.118])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66AEB1955BE3;
	Mon, 13 Jan 2025 13:38:39 +0000 (UTC)
Date: Mon, 13 Jan 2025 08:40:51 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chi Zhiling <chizhiling@163.com>, Amir Goldstein <amir73il@gmail.com>,
	Dave Chinner <david@fromorbit.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z4UX4zyc8n8lGM16@bfoster>
References: <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250113024401.GU1306365@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Sun, Jan 12, 2025 at 06:44:01PM -0800, Darrick J. Wong wrote:
> On Sun, Jan 12, 2025 at 06:05:37PM +0800, Chi Zhiling wrote:
> > On 2025/1/11 01:07, Amir Goldstein wrote:
> > > On Fri, Jan 10, 2025 at 12:28 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > 
> > > > On Wed, Jan 08, 2025 at 09:35:47AM -0800, Darrick J. Wong wrote:
> > > > > On Wed, Jan 08, 2025 at 03:43:04PM +0800, Chi Zhiling wrote:
> > > > > > On 2025/1/7 20:13, Amir Goldstein wrote:
> > > > > > > Dave's answer to this question was that there are some legacy applications
> > > > > > > (database applications IIRC) on production systems that do rely on the fact
> > > > > > > that xfs provides this semantics and on the prerequisite that they run on xfs.
> > > > > > > 
> > > > > > > However, it was noted that:
> > > > > > > 1. Those application do not require atomicity for any size of IO, they
> > > > > > >       typically work in I/O size that is larger than block size (e.g. 16K or 64K)
> > > > > > >       and they only require no torn writes for this I/O size
> > > > > > > 2. Large folios and iomap can usually provide this semantics via folio lock,
> > > > > > >       but application has currently no way of knowing if the semantics are
> > > > > > >       provided or not
> > > > > > 
> > > > > > To be honest, it would be best if the folio lock could provide such
> > > > > > semantics, as it would not cause any potential problems for the
> > > > > > application, and we have hope to achieve concurrent writes.
> > > > > > 
> > > > > > However, I am not sure if this is easy to implement and will not cause
> > > > > > other problems.
> > > > > 
> > > > > Assuming we're not abandoning POSIX "Thread Interactions with Regular
> > > > > File Operations", you can't use the folio lock for coordination, for
> > > > > several reasons:
> > > > > 
> > > > > a) Apps can't directly control the size of the folio in the page cache
> > > > > 
> > > > > b) The folio size can (theoretically) change underneath the program at
> > > > > any time (reclaim can take your large folio and the next read gets a
> > > > > smaller folio)
> > > > > 
> > > > > c) If your write crosses folios, you've just crossed a synchronization
> > > > > boundary and all bets are off, though all the other filesystems behave
> > > > > this way and there seem not to be complaints
> > > > > 
> > > > > d) If you try to "guarantee" folio granularity by messing with min/max
> > > > > folio size, you run the risk of ENOMEM if the base pages get fragmented
> > > > > 
> > > > > I think that's why Dave suggested range locks as the correct solution to
> > > > > this; though it is a pity that so far nobody has come up with a
> > > > > performant implementation.
> > > > 
> > > > Yes, that's a fair summary of the situation.
> > > > 
> > > > That said, I just had a left-field idea for a quasi-range lock
> > > > that may allow random writes to run concurrently and atomically
> > > > with reads.
> > > > 
> > > > Essentially, we add an unsigned long to the inode, and use it as a
> > > > lock bitmap. That gives up to 64 "lock segments" for the buffered
> > > > write. We may also need a "segment size" variable....
> > > > 
> > > > The existing i_rwsem gets taken shared unless it is an extending
> > > > write.
> > > > 
> > > > For a non-extending write, we then do an offset->segment translation
> > > > and lock that bit in the bit mask. If it's already locked, we wait
> > > > on the lock bit. i.e. shared IOLOCK, exclusive write bit lock.
> > > > 
> > > > The segments are evenly sized - say a minimum of 64kB each, but when
> > > > EOF is extended or truncated (which is done with the i_rwsem held
> > > > exclusive) the segment size is rescaled. As nothing can hold bit
> > > > locks while the i_rwsem is held exclusive, this will not race with
> > > > anything.
> > > > 
> > > > If we are doing an extending write, we take the i_rwsem shared
> > > > first, then check if the extension will rescale the locks. If lock
> > > > rescaling is needed, we have to take the i_rwsem exclusive to do the
> > > > EOF extension. Otherwise, the bit lock that covers EOF will
> > > > serialise file extensions so it can be done under a shared i_rwsem
> > > > safely.
> > > > 
> > > > This will allow buffered writes to remain atomic w.r.t. each other,
> > > > and potentially allow buffered reads to wait on writes to the same
> > > > segment and so potentially provide buffered read vs buffered write
> > > > atomicity as well.
> > > > 
> > > > If we need more concurrency than an unsigned long worth of bits for
> > > > buffered writes, then maybe we can enlarge the bitmap further.
> > > > 
> > > > I suspect this can be extended to direct IO in a similar way to
> > > > buffered reads, and that then opens up the possibility of truncate
> > > > and fallocate() being able to use the bitmap for range exclusion,
> > > > too.
> > > > 
> > > > The overhead is likely minimal - setting and clearing bits in a
> > > > bitmap, as opposed to tracking ranges in a tree structure....
> > > > 
> > > > Thoughts?
> > > 
> > > I think that's a very neat idea, but it will not address the reference
> > > benchmark.
> > > The reference benchmark I started the original report with which is similar
> > > to my understanding to the benchmark that Chi is running simulates the
> > > workload of a database writing with buffered IO.
> > > 
> > > That means a very large file and small IO size ~64K.
> > > Leaving the probability of intersecting writes in the same segment quite high.
> > > 
> > > Can we do this opportunistically based on available large folios?
> > > If IO size is within an existing folio, use the folio lock and IOLOCK_SHARED
> > > if it is not, use IOLOCK_EXCL?
> > > 
> > > for a benchmark that does all buffered IO 64K aligned, wouldn't large folios
> > > naturally align to IO size and above?
> > > 
> > 
> > Great, I think we're getting close to aligning our thoughts.
> > 
> > IMO, we shouldn't use a shared lock for write operations that are
> > larger than page size.
> > 
> > I believe the current issue is that when acquiring the i_rwsem lock,
> > we have no way of knowing the size of a large folio [1] (as Darrick
> > mentioned earlier), so we can't determine if only one large folio will
> > be written.
> > 
> > There's only one certainty: if the IO size fits within one page size,
> > it will definitely fit within one large folio.
> > 
> > So for now, we can only use IOLOCK_SHARED if we verify that the IO fits
> > within page size.
> 
> For filesystems that /do/ support large folios (xfs), I suppose you
> could have it tell iomap that it only took i_rwsem in shared mode; and
> then the iomap buffered write implementation could proceed if it got a
> folio covering the entire write range, or return some magic code that
> means "take i_rwsem in exclusive mode and try again".
> 

Sorry if this is out of left field as I haven't followed the discussion
closely, but I presumed one of the reasons Darrick and Christoph raised
the idea of using the folio batch thing I'm playing around with on zero
range for buffered writes would be to acquire and lock all targeted
folios up front. If so, would that help with what you're trying to
achieve here? (If not, nothing to see here, move along.. ;).

Brian

> Though you're correct that we should always take IOLOCK_EXCL if the
> write size is larger than whatever the max folio size is for that file.
> 
> --D
> 
> > [1]: Maybe we can find a way to obtain the size of a folio from the page
> > cache, but it might come with some performance costs.
> > 
> > 
> > Thanks,
> > Chi Zhiling
> > 
> > 
> 

