Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646DD197A98
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688961; cv=none; b=rW2iD6iKx+PO5OJdpU9u3LBuiV54REVqHCzr5MK8Ec8v3+PZqkguAvc9vKGdylKwOsil5XLO+WzwVosoQ7pSlwsZvLimL84jx3NCb0iTVr3wkLVztcqfR6cMBcUYNDyNPz6c1hK+hVKZwDdM4lSWbHqrR0Emsk48QD5wV/jLIF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688961; c=relaxed/simple;
	bh=blkcAxawQfOp8FKVyPTNiq+apb9XVVeYgrFAqAfZm64=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=uDRUX5NbhdiRK8kl39irBQCOTiY3AlxEM0cCAZtaIQuhhAuwDXVonGMtAzvcBkeaftwi2SIH/os+d23ynrLqNTSKr/Cst+wgq+Tihb8/bFs/pWFHD1NvVcIEo2j94klrwjObQOh0oPuF5OXD+Vi0yMWhPhFmIRwuLiMHpbjlFuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org; spf=pass smtp.mailfrom=owlfolio.org; dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b=Z9CDih0Y; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FM81h4m7; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=owlfolio.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owlfolio.org header.i=@owlfolio.org header.b="Z9CDih0Y";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FM81h4m7"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 7C5B4114019B;
	Thu,  6 Jun 2024 11:49:18 -0400 (EDT)
Received: from imap45 ([10.202.2.95])
  by compute5.internal (MEProxy); Thu, 06 Jun 2024 11:49:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=owlfolio.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1717688958; x=1717775358; bh=P6h+Wqx4kO
	VRvZctp/y5T21qHXIrOnGp3NuAMhwKmv8=; b=Z9CDih0Y0A+AigMRYwWk0430Uk
	n3m3mKkAfqMqI5VzOGY5gSYqdYaCY6LhkQE+gaxgzJFaggcO08leaFS2fNTCdC7B
	bqipGLik2F8WNY8/VuXsLIU0fim6GcQ2oNFkk/OjexNcpJu/dG91UzXrB5EWzn4D
	1Ga7Fs3fTt6YBaagKMYNItPCCg+yaf4FCzqOb2VGGokpvNuNeUsgiRlwdUlU0P5L
	8uQLoBprOn9sxk0Q7k5s0a3q2ksmMKJ0WPnGHDERQpk2T8xexd0rNniBKXWyIjDr
	e/08fIuBTLN06kiN/9AuP5GkKoTVzRYVRHgr5mFfmNyqv3YKUxlZftxekR/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1717688958; x=1717775358; bh=P6h+Wqx4kOVRvZctp/y5T21qHXIr
	OnGp3NuAMhwKmv8=; b=FM81h4m7RnSZ43G+0N3ed2llYQsZcL6V2/C/kOVBUjih
	tJUmiq+wQu/HTi8z0gXiIja2R/rL8qLJLrooSFtIEq0pxqWbi0ViYnLWRPX1ocFs
	sNs/OCVTx2KRUMudX13pS4SGzUl0i1lRcoo4JpUc1xJE3K/dUJ0+naq/HazPjrTH
	LG2UlT87WBIYmlO5LzwWLNSv9MQEz8iC61mgHfOap9VEJ+bvs7RPlb0iadcHeffb
	ywCVt6lzkVVOPtyqu+pCUQXFbZ56ryXWcz6052PygY20QaPMY5NXs4kSpMiApaJ3
	JvA3RODAtRA5JfKlmCpHdSTKJYLD3qzKLxtqUVseEw==
X-ME-Sender: <xms:ftphZuf9Uxmpu-6JGUH-5spvvECbFZO9OXBJ9F7EnRAOncWGK8B_Ug>
    <xme:ftphZoPByukLO3evfPdOTL4qP13G6n2dexSRkZRfzlkpa9zR0PV0_7RruijnNshEk
    PXfB1Vim_i8AZv8agE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdelkedgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfgjfhffhffvvefutgesth
    dtredtreertdenucfhrhhomhepfdgkrggtkhcuhggvihhnsggvrhhgfdcuoeiirggtkhes
    ohiflhhfohhlihhordhorhhgqeenucggtffrrghtthgvrhhnpefhleefheduhfelgeehge
    ejveehueeihedvgfeuueetteelieeiteehfefhleduieenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeiirggtkhesohiflhhfohhlihhordhorh
    hg
X-ME-Proxy: <xmx:ftphZvhuVKvFJN01vtVrh0EDSFqiSSS3976V6sVgKOWQQJuTh9oOKA>
    <xmx:ftphZr97KXB8yPEZsRkWivEfGcYsRWhk21YN7Wj7TvsTszWNVmGRYA>
    <xmx:ftphZqsOL_m2Sos6ViN2VYtgmvJYiosOD3Z-8dFeHaHOiWmdHqkq4g>
    <xmx:ftphZiF9wbBF0eY_HWl_aHGbsTl2Xq_KfNZFgps_pkKpWzxQzsgFoA>
    <xmx:ftphZj4mr2mTBg0vIhg0KB4S-xJnxILKcliytkdzyUEb1sBFs-YReDpy>
Feedback-ID: i876146a2:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 0F653272007C; Thu,  6 Jun 2024 11:49:17 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-497-g97f96844c-fm-20240526.001-g97f96844
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <a9625e9f-e08c-4b2e-995d-693b2a992281@app.fastmail.com>
In-Reply-To: <ZmDvT/oWgVBiCw9o@dread.disaster.area>
References: <1eb0ef1c-9703-43fd-9a51-bda24b9d2f1b@app.fastmail.com>
 <ZmDvT/oWgVBiCw9o@dread.disaster.area>
Date: Thu, 06 Jun 2024 11:48:57 -0400
From: "Zack Weinberg" <zack@owlfolio.org>
To: "Dave Chinner" <david@fromorbit.com>
Cc: dm-devel@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: Reproducible system lockup, extracting files into XFS on dm-raid5 on
 dm-integrity on HDD
Content-Type: text/plain

On Wed, Jun 5, 2024, at 7:05 PM, Dave Chinner wrote:
> On Wed, Jun 05, 2024 at 02:40:45PM -0400, Zack Weinberg wrote:
>> I am experimenting with the use of dm-integrity underneath dm-raid,
>> to get around the problem where, if a RAID 1 or RAID 5 array is
>> inconsistent, you may not know which copy is the good one.  I have
>> found a reproducible hard lockup involving XFS, RAID 5 and dm-
>> integrity.
>
> I don't think there's any lockup or kernel bug here - this just looks
> to be a case of having a really, really slow storage setup and
> everything waiting for a huge amount of IO to complete to make
> forwards progress.
...
> Userspace stalls on on writes because there are too many dirty pages
> in RAM. It throttles all incoming writes, waiting for background
> writeback to clean dirty pages.  Data writeback requires block
> allocation which requires metadata modification. Metadata modification
> requires journal space reservations which block waiting for metadata
> writeback IO to complete. There are hours of metadata writeback needed
> to free journal space, so everything pauses waiting for metadata IO
> completion.

This makes a lot of sense.

> RAID 5 writes are slow with spinning disks. dm-integrity makes writes
> even slower.  If you storage array can sustain more than 50 random 4kB
> writes a second, I'd be very surprised. It's going to be -very slow-.

I wiped the contents of the filesystem and ran bonnie++ on it in direct
I/O mode with 4k block writes, skipping the one-character write and
small file creation tests.  This is what I got:

Version  2.00       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Name:Size etc        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
64G:4k::65536                 15.8m  19 60.5m  26            218m  31 279.1  13
Latency                         659ms     517ms             61146us    3052ms

I think this is doing seek-and-read, not seek-and-write, but 300 random
reads per second is still really damn slow compared to the sequential
performance.  And it didn't lock up (with unchanged hung task timeout of
two minutes) so that also tends to confirm your hypothesis -- direct I/O
means no write backlog.

(Do you know of a good way to benchmark seek-and-write
performance, ideally directly on a block device instead of having
a filesystem present?)

I don't actually care how slow it is to write things to this array,
because (if I can ever get it working) it's meant to be archival
storage, written to only rarely.  But I do need to get this tarball
unpacked, I'd prefer it if the runtime of 'tar' would correspond closely
to the actual time required to get the data all the way to stable
storage, and disabling the hung task timeout seems like a kludge.

...
> So a 1.6GB journal can buffer hundreds of thousands of dirty 4kb
> metadata blocks with writeback pending. Once the journal is full,
> however, the filesystem has to start writing them back to make space
> in the journal for new incoming changes. At this point, the filesystem
> with throttle incoming metadata modifications to the rate at which it
> can remove dirty metadata from the journal. i.e. it will throttle
> incoming modifications to the sustained random 4kB write rate of your
> storage hardware.
>
> With at least a quarter of a million random 4kB writes pending in the
> journal when it starts throttling, I'd suggest that you're looking at
> several hours of waiting just to flush the journal, let alone complete
> the untar process which will be generating new metadata all the
> time....

This reminds me of the 'bufferbloat' phenomenon over in networking land.
Would it help to reduce the size of the journal to something like 6MB,
which (assuming 50 random writes per second) would take only 30s to
flush?  Is a journal that small, for a filesystem this large, likely to
cause other problems? Are there any other tuning knobs you can think of
that might restrict the rate of incoming metadata modifications from
'tar' to a sustainable level from the get-go, instead of barging ahead
and then hitting a wall? I'm inclined to doubt that VM-level writeback
controls (as suggested elsethread) will help much, since they would not
change how much data can pile up in the filesystem's journal, but I
could be wrong.

Thanks for your help so far.
zw
