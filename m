Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B122F99A5
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763055564; cv=none; b=R3FaQgSH7D5IRSjMZmLBUjJMlftjaRZ+PEOQXWW9t3ZCJhPFdEh2IDF/LpRtT/yD7r7wQ8uOoU+H/RK01MeR+iB5U2Hlxe8Hik/XhzO/KxUWRzffJrfPkxBP+VgNtk6emWaVcHXVj756YCjYxWDnpRv6xnYKVcHFPVWZQrlNkbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763055564; c=relaxed/simple;
	bh=GGp2s0LvtKjt+t1W7yDNtjXdzWykxFnnHM6LUMYRznE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5P1/R13OjjtC7w3K/SK55DSwZqtTeVRgFpt8jd471rN88SgIhp0xZvMHnPSPqqYxyNphINM3FwztljM0WixBeMOxV1ROOnHcZLBggsXxsGHwQ6sMGN7CjcLkBUDtXfovyW4djvElyQsEfUEddg6yCHlo0mlgCV5+v6ODhylnaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S2Fy41ml; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S2Fy41ml"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763055562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PXiG8WHDv5vtbMZ81FzbMwHzCV62RlyG1r3nUFcyKUo=;
	b=S2Fy41mlyE2uNEtFwfqEKx5YAKe4bmOn0tyrfZvs+Ak0HGx4Oi1EGz03Yx3dezHhtUT0mn
	7Zj1swCnjNilNre/8mR2uqQPsSkYZ0ul5IA+skbZS4VLa3DqePOmMuRA9OOQF8C0DFWxLO
	qyAPALVPAY978zud1m1FIF0PehNmcPI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-E9sQLSMdPc-ALg_OhBjXIQ-1; Thu,
 13 Nov 2025 12:39:18 -0500
X-MC-Unique: E9sQLSMdPc-ALg_OhBjXIQ-1
X-Mimecast-MFC-AGG-ID: E9sQLSMdPc-ALg_OhBjXIQ_1763055557
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 221EC1956070;
	Thu, 13 Nov 2025 17:39:17 +0000 (UTC)
Received: from redhat.com (unknown [10.45.224.162])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D6D9300018D;
	Thu, 13 Nov 2025 17:39:11 +0000 (UTC)
Date: Thu, 13 Nov 2025 18:39:07 +0100
From: Kevin Wolf <kwolf@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Keith Busch <kbusch@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: fall back from direct to buffered I/O when stable writes are
 required
Message-ID: <aRYXuwtSQUz6buBs@redhat.com>
References: <20251029071537.1127397-1-hch@lst.de>
 <aQNJ4iQ8vOiBQEW2@dread.disaster.area>
 <20251030143324.GA31550@lst.de>
 <aQPyVtkvTg4W1nyz@dread.disaster.area>
 <20251031130050.GA15719@lst.de>
 <aQTcb-0VtWLx6ghD@kbusch-mbp>
 <20251031164701.GA27481@lst.de>
 <kpk2od2fuqofdoneqse2l3gvn7wbqx3y4vckmnvl6gc2jcaw4m@hsxqmxshckpj>
 <20251103122111.GA17600@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103122111.GA17600@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Am 03.11.2025 um 13:21 hat Christoph Hellwig geschrieben:
> On Mon, Nov 03, 2025 at 12:14:06PM +0100, Jan Kara wrote:
> > I also think the performance cost of the unconditional bounce buffering is
> > so heavy that it's just a polite way of pushing the app to do proper IO
> > buffer synchronization itself (assuming it cares about IO performance but
> > given it bothered with direct IO it presumably does). 
> >
> > So the question is how to get out of this mess with the least disruption
> > possible which IMO also means providing easy way for well-behaved apps to
> > avoid the overhead.
> 
> Remember the cases where this matters is checksumming and parity, where
> we touch all the cache lines anyway and consume the DRAM bandwidth,
> although bounce buffering upgrades this from pure reads to also writes.
> So the overhead is heavy, but if we handle it the right way, that is
> doing the checksum/parity calculation while the cache line is still hot
> it should not be prohibitive.  And getting this right in the direct
> I/O code means that the low-level code could stop bounce buffering
> for buffered I/O, providing a major speedup there.
> 
> I've been thinking a bit more on how to better get the copy close to the
> checksumming at least for PI, and to avoid the extra copies for RAID5
> buffered I/O. M maybe a better way is to mark a bio as trusted/untrusted
> so that the checksumming/raid code can bounce buffer it, and I start to
> like that idea.

This feels like the right idea to me. It's also what I thought of after
reading your problem description.

The problem is not that RAID5 uses bounce buffers. That's the correct
and safe thing to do when you don't know that the buffer can't change.
I'd argue changing that would be a RAID5 bug, and the corruption you
showed earlier in the thread is not a sign of a buggy filesystem or
application [1], but that you told the device to operate incorrectly.

What is the problem is that it still uses bounce buffers when you do
know that the buffer can't change. Then it's just wasteful and doesn't
contribute to correctness.

Passing down a flag to the device so that it can decide whether the
bounce buffer is needed seems like the obvious solution for that.

> A complication is that PI could relax that requirement if we support
> PI passthrough from userspace (currently only for block device, but I
> plan to add file system support), where the device checks it, but we
> can't do that for parity RAID.

Not sure I understand the problem here. If it's passed through from
userspace, isn't its validity the problem of userspace, too? I'd expect
that you only need a bounce buffer in the kernel if the kernel itself
does something like a checksum calculation?

Kevin

[1] For a QEMU developer like me, not blaming the application may sound
    like an excuse, but we're really only in the same position as the
    kernel here for anything that comes from the guest. Whenever we rely
    on stable buffers, we already have to use bounce buffers, too.

