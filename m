Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B07E26FD93
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 09:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771235563; cv=none; b=QaJVj61FCKMaTDsaOjTPmNhiIkUzO0YRyDjlCJ71WkDUzk+xpduPasF2DIcaY3gM1dEnL+xFgZE0bOKXQDnx+LAc7C3SUn9ucQRhmGubAiTkpp+2ePZrYDXLEM757IFPNr+EoaSmnOHnH5RRR7GdJs406NCGYI87HjrDIyvkExk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771235563; c=relaxed/simple;
	bh=MUGuKY4Gnm3/EiR6Prb2nO5Boxfnsma1Qv1s2gET2Y0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E5xS1RDm9nmf3HL0Kb5QrFqd6CIrroksT+xdNpEBJL1jCmXZsVilYcV7m52xAfsoZMEVY+iqTphxwn0+aS2H7AuaL2PjImq9DO7H9SO9ffug2VdVi+OAJc3fq13NDDrC27cO+URuBAZgelNuKjEjgwB9SFo2hYDbPjoA/uJNZCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ws0qq2Nu; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ws0qq2Nu"
Message-ID: <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771235558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1XmG/hIaACTUgj9EBZ/72IQ5DDq7ji1NcrhuA61/gY=;
	b=ws0qq2Nut0J5hbxl5bHXlf7XQFx3x6Mx6g822LS8NfZJDAE5CxoIZ9x9O5bC1hDcxgJKv9
	VXJglNMvxamiC1cq97YAIcLqaDq0rxOpEM0KYhj5GvQWhh8Wlk9W1wroyXXzGF5v64hdVE
	ild9jTGKiQkQgQ+vAiU8rzs+5/CFKOU=
Date: Mon, 16 Feb 2026 10:52:35 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
 Andres Freund <andres@anarazel.de>, djwong@kernel.org,
 john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>,
 dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
 gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
 vi.shah@samsung.com
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2/13/26 14:32, Ojaswin Mujoo wrote:
> On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
>> Hi all,
>>
>> Atomic (untorn) writes for Direct I/O have successfully landed in kernel
>> for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
>> remains a contentious topic, with previous discussions often stalling due to
>> concerns about complexity versus utility.
>>
>> I would like to propose a session to discuss the concrete use cases for
>> buffered atomic writes and if possible, talk about the outstanding
>> architectural blockers blocking the current RFCs[3][4].
> 
> Hi Pankaj,
> 
> Thanks for the proposal and glad to hear there is a wider interest in
> this topic. We have also been actively working on this and I in middle
> of testing and ironing out bugs in my RFC v2 for buffered atomic
> writes, which is largely based on Dave's suggestions to maintain atomic
> write mappings in FS layer (aka XFS COW fork). Infact I was going to
> propose a discussion on this myself :) 
> 

Perfect.

>>
>> ## Use Case:
>>
>> A recurring objection to buffered atomics is the lack of a convincing use
>> case, with the argument that databases should simply migrate to direct I/O.
>> We have been working with PostgreSQL developer Andres Freund, who has
>> highlighted a specific architectural requirement where buffered I/O remains
>> preferable in certain scenarios.
> 
> Looks like you have some nice insights to cover from postgres side which
> filesystem community has been asking for. As I've also been working on
> the kernel implementation side of it, do you think we could do a joint
> session on this topic?
>
As one of the main pushback for this feature has been a valid usecase, the main
outcome I would like to get out of this session is a community consensus on the use case
for this feature.

It looks like you already made quite a bit of progress with the CoW impl, so it
would be great to if it can be a joint session.


>> We currently have RFCs posted by John Garry and Ojaswin Mujoo, and there
>> was a previous LSFMM proposal about untorn buffered writes from Ted Tso.
>> Based on the conversation/blockers we had before, the discussion at LSFMM
>> should focus on the following blocking issues:
>>
>> - Handling Short Writes under Memory Pressure[6]: A buffered atomic
>>   write might span page boundaries. If memory pressure causes a page
>>   fault or reclaim mid-copy, the write could be torn inside the page
>>   cache before it even reaches the filesystem.
>>     - The current RFC uses a "pinning" approach: pinning user pages and
>>       creating a BVEC to ensure the full copy can proceed atomically.
>>       This adds complexity to the write path.
>>     - Discussion: Is this acceptable? Should we consider alternatives,
>>       such as requiring userspace to mlock the I/O buffers before
>>       issuing the write to guarantee atomic copy in the page cache?
> 
> Right, I chose this approach because we only get to know about the short
> copy after it has actually happened in copy_folio_from_iter_atomic()
> and it seemed simpler to just not let the short copy happen. This is
> inspired from how dio pins the pages for DMA, just that we do it
> for a shorter time.
> 
> It does add slight complexity to the path but I'm not sure if it's complex
> enough to justify adding a hard requirement of having pages mlock'd.
> 

As databases like postgres have a buffer cache that they manage in userspace,
which is eventually used to do IO, I am wondering if they already do a mlock
or some other way to guarantee the buffer cache does not get reclaimed. That is
why I was thinking if we could make it a requirement. Of course, that also requires
checking if the range is mlocked in the iomap_write_iter path.

>>
>> - Page Cache Model vs. Filesystem CoW: The current RFC introduces a
>>   PG_atomic page flag to track dirty pages requiring atomic writeback.
>>   This faced pushback due to page flags being a scarce resource[7].
>>   Furthermore, it was argued that atomic model does not fit the buffered
>>   I/O model because data sitting in the page cache is vulnerable to
>>   modification before writeback occurs, and writeback does not preserve
>>   application ordering[8].
>>     -  Dave Chinner has proposed leveraging the filesystem's CoW path
>>        where we always allocate new blocks for the atomic write (forced
>>        CoW). If the hardware supports it (e.g., NVMe atomic limits), the
>>        filesystem can optimize the writeback to use REQ_ATOMIC in place,
>>        avoiding the CoW overhead while maintaining the architectural
>>        separation.
> 
> Right, this is what I'm doing in the new RFC where we maintain the
> mappings for atomic write in COW fork. This way we are able to utilize a
> lot of existing infrastructure, however it does add some complexity to
> ->iomap_begin() and ->writeback_range() callbacks of the FS. I believe
> it is a tradeoff since the general consesus was mostly to avoid adding
> too much complexity to iomap layer.
> 
> Another thing that came up is to consider using write through semantics 
> for buffered atomic writes, where we are able to transition page to
> writeback state immediately after the write and avoid any other users to
> modify the data till writeback completes. This might affect performance
> since we won't be able to batch similar atomic IOs but maybe
> applications like postgres would not mind this too much. If we go with
> this approach, we will be able to avoid worrying too much about other
> users changing atomic data underneath us. 
> 

Hmm, IIUC, postgres will write their dirty buffer cache by combining multiple DB
pages based on `io_combine_limit` (typically 128kb). So immediately writing them
might be ok as long as we don't remove those pages from the page cache like we do in
RWF_UNCACHED.


> An argument against this however is that it is user's responsibility to
> not do non atomic IO over an atomic range and this shall be considered a
> userspace usage error. This is similar to how there are ways users can
> tear a dio if they perform overlapping writes. [1]. 
> 
> That being said, I think these points are worth discussing and it would
> be helpful to have people from postgres around while discussing these
> semantics with the FS community members.
> 
> As for ordering of writes, I'm not sure if that is something that
> we should guarantee via the RWF_ATOMIC api. Ensuring ordering has mostly
> been the task of userspace via fsync() and friends.
> 

Agreed.

> 
> [1] https://lore.kernel.org/fstests/0af205d9-6093-4931-abe9-f236acae8d44@oracle.com/
> 
>>     - Discussion: While the CoW approach fits XFS and other CoW
>>       filesystems well, it presents challenges for filesystems like ext4
>>       which lack CoW capabilities for data. Should this be a filesystem
>>       specific feature?
> 
> I believe your question is if we should have a hard dependency on COW
> mappings for atomic writes. Currently, COW in atomic write context in
> XFS, is used for these 2 things:
> 
> 1. COW fork holds atomic write ranges.
> 
> This is not strictly a COW feature, just that we are repurposing the COW
> fork to hold our atomic ranges. Basically a way for writeback path to
> know that atomic write was done here.
> 
> COW fork is one way to do this but I believe every FS has a version of
> in memory extent trees where such ephemeral atomic write mappings can be
> held. The extent status cache is ext4's version of this, and can be used
> to manage the atomic write ranges. 
> 
> There is an alternate suggestion that came up from discussions with Ted
> and Darrick that we can instead use a generic side-car structure which
> holds atomic write ranges. FSes can populate these during atomic writes
> and query these in their writeback paths. 
> 
> This means for any FS operation (think truncate, falloc, mwrite, write
> ...) we would need to keep this structure in sync, which can become pretty
> complex pretty fast. I'm yet to implement this so not sure how it would
> look in practice though.
> 
> 2. COW feature as a whole enables software based atomic writes.
> 
> This is something that ext4 won't be able to support (right now), just
> like how we don't support software writes for dio.
> 
> I believe Baokun and Yi and working on a feature that can eventually
> enable COW writes in ext4 [2]. Till we have something like that, we
> would have to rely on hardware support.
> 
> Regardless, I don't think the ability to support or not support
> software atomic writes largely depends on the filesystem so I'm not
> sure how we can lift this up to a generic layer anyways.
> 
> [2] https://lore.kernel.org/linux-ext4/9666679c-c9f7-435c-8b67-c67c2f0c19ab@huawei.com/
> 

Thanks for the explanation. I am also planning to take a shot at the CoW approach. I would
be more than happy to review and test if you send a RFC in the meantime.

--
Pankaj

