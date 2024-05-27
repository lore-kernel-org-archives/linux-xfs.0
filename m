Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ECA15A846
	for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716828304; cv=none; b=aVfET3A1IxPCX3eQCpRjmyTnqsE9vljbIdfRceoxd7UhOd0FdL5hz5qmVCDD5OLYFM83p9A9xMyIoPwIh4/tFGiIGjmmXWN1STyRtm6OTUJMdxXdgZIj+go6pwgoD4JwEbY2mkZZa7fP/GqU4ZE9fv6Rl6XOhGRDaXp7oSKqVow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716828304; c=relaxed/simple;
	bh=CF90hzjRzm0D8H5WSLz8sMd/FbAPeUblbEMUZUy0bLM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=lomte6QyboyUuZcwZxGpqcGOA6tofhIvgOONKy1PmKN9CTpdq7THUi2I7G4O/sPYacRlj9s/farFD4WHtZeWRP6kG5NaGkly724i4kou6Td84/NIzawB8bb8yDHpsmhFSGXC3vACFyuGKHgn9ubNQoXOHAxtAHymPVwkxjWnn1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fkGvwvuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fkGvwvuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22587C2BBFC;
	Mon, 27 May 2024 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716828304;
	bh=CF90hzjRzm0D8H5WSLz8sMd/FbAPeUblbEMUZUy0bLM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=fkGvwvuyLjmkB7t8WfldtqjHrSjEjDVwPfXTDToKVb0eRz/K9cxK2cAwBPbpe4BPz
	 ztKoVusFicoqOC1wDP0BWpT1YmSvo7NUSnIE9u1bdaUG3KhgIY+xicwaVhKvNUNaV9
	 K9QXNR7AgnQpCgnifAHydlbNsSiU9cXnImoT+aG5xiiY2eM1Kk1zbYFIJVNq34Msix
	 NxXYLX2IJOz/Nv6qpddWiAyyeJ/Q9LHvEVWGMnSv8oByOpapCTHI3zPxOIbDIVkQr0
	 S5LJe1V35JctpHpQtQtF6UHozDZo7zf97IwcPBluugsv9mMlyaxC6LJL2p7ImAUqfA
	 +rw1P3Hwv0G2A==
References: <20240524164119.5943-1-llfamsec@gmail.com>
 <87ikyz7tvj.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZlRQ6W8BlfZ+3rWs@dread.disaster.area>
 <875xuz7dcu.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZlR1PQ01EkD5nrUv@dread.disaster.area>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 djwong@kernel.org, lei lu <llfamsec@gmail.com>
Subject: Re: Fwd: [PATCH] xfs: don't walk off the end of a directory data block
Date: Mon, 27 May 2024 22:10:08 +0530
In-reply-to: <ZlR1PQ01EkD5nrUv@dread.disaster.area>
Message-ID: <871q5n6w6q.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, May 27, 2024 at 09:57:49 PM +1000, Dave Chinner wrote:
> On Mon, May 27, 2024 at 03:59:07PM +0530, Chandan Babu R wrote:
>> On Mon, May 27, 2024 at 07:22:49 PM +1000, Dave Chinner wrote:
>> > On Mon, May 27, 2024 at 10:05:17AM +0530, Chandan Babu R wrote:
>> >> 
>> >> [CC-ing linux-xfs mailing list]
>> >> 
>> >> On Sat, May 25, 2024 at 12:41:19 AM +0800, lei lu wrote:
>> >> > Add a check to make sure xfs_dir2_data_unused and xfs_dir2_data_entry
>> >> > don't stray beyond valid memory region.
>> >
>> > How was this found? What symptoms did it have? i.e. How do we know
>> > if we've tripped over the same problem on an older LTS/distro kernel
>> > and need to backport it?
>> >
>> >> > Tested-by: lei lu <llfamsec@gmail.com>
>> >> > Signed-off-by: lei lu <llfamsec@gmail.com>
>> >> 
>> >> Also adding the missing RVB from Darrick,
>> >> 
>> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> >
>> > That's not really normal process - adding third party tags like this
>> > are kinda frowned upon because there's no actual public record of
>> > Darrick saying this.
>> 
>> Ok. The patch was posted on security@kernel.org with me on CC. Hence, I had
>> decided to forward the patch to linux-xfs for any reviews from the wider
>> audience.
>
> Ugh. More "security process" madness. Please at least tell us what
> context you are forwarding issues from so we aren't left guessing at
> what happened prior to the mailing list post...
>
> Regardless, this issue is no different to any number of
> syzkaller bugs that have been reported over the past few years.
> security@kernel.org should be reserved for real security problems,
> not for reporting issues found by filesystem image fuzzers that
> require root permissions before the kernel can be exposed to them.
>

Yes, I agree. Hence, I decided on forwarding the patch to linux-xfs mailing
list. However, I now realize that I should have asked the patch author to post
the patch on the mailing list. I am sorry about that.

>> > i.e. patches send privately should really be reposted to the public
>> > list by the submitter and everyone then adds their rvb/acks, etc on
>> > list themselves.
>> >
>> 
>> Sorry, I didn't know about the last part i.e. rvbs need to be added once again
>> after reposting the patch.
>
> I'm more concerned more about having an open, verifiable process.
> sobs and rvbs that stem from private discussions have no actual
> value because they are not verifiable via the archives of the public
> discussion on the issue.

-- 
Chandan
