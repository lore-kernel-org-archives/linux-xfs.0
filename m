Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08EC1482E8
	for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 12:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771332180; cv=none; b=AzHNmCwtjo2FYQaahbopFuQRSmSws49LAMJm0iIfB+edB3WjLfJ2q/WSUOa+ZtKrsOJ7/MoW8+j4+5QDw6Gus9IB1GU1B/MjGmHWJMM09akcCCJgt1t2wnDytXgPU6YWvjR7tMuhG4YuFDLW/GOXQxJ1boUu+gUtEvzRfXFy5bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771332180; c=relaxed/simple;
	bh=HPfF9FXYIEsCzB6Gh5Ceal5kKcdQMhEjpIC03DM8Pjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fIdAa66ZH0E6pzh+L3sr/UZi0OPGxe6FY4KcN04n1+aKc/GrSWsnN9WP9hdKsgRzfbX34ElQFX6BEMQ5NmBuqcK0uNhFwCfiPeo+4ShVwXIgnYQchzyyhtFWaZacvzcNDvyHj2nCaTQTsRmS2MgDBXIn7FKoSHXOwqOtOUJkzdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nd0EUNwq; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nd0EUNwq"
Message-ID: <4627056f-2ab9-4ff1-bca0-5d80f8f0bbab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771332166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hHe3ZejbOvudEwAFGp4CJMQCUggASakx2SvWy48y3WA=;
	b=nd0EUNwqwPgsrOW39DUKMqi0MAu86LgmPAc45mvnFMyfd00VVEkLVG905HJY5LjZtYOxhT
	2xV5Dft2o/QCfaaYr5jKBgtQZr11QWsPRVkswFGstncp2L532LR9+4PX7FtJzluYTGY/2b
	QU9DrWfQEvKcvV0+uS0eYFGr/IRCB1A=
Date: Tue, 17 Feb 2026 13:42:35 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Jan Kara <jack@suse.cz>, Andres Freund <andres@anarazel.de>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
 john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
 dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
 gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
 vi.shah@samsung.com
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
 <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2/17/2026 1:06 PM, Jan Kara wrote:
> On Mon 16-02-26 10:45:40, Andres Freund wrote:
>>> Hmm, IIUC, postgres will write their dirty buffer cache by combining
>>> multiple DB pages based on `io_combine_limit` (typically 128kb).
>>
>> We will try to do that, but it's obviously far from always possible, in some
>> workloads [parts of ]the data in the buffer pool rarely will be dirtied in
>> consecutive blocks.
>>
>> FWIW, postgres already tries to force some just-written pages into
>> writeback. For sources of writes that can be plentiful and are done in the
>> background, we default to issuing sync_file_range(SYNC_FILE_RANGE_WRITE),
>> after 256kB-512kB of writes, as otherwise foreground latency can be
>> significantly impacted by the kernel deciding to suddenly write back (due to
>> dirty_writeback_centisecs, dirty_background_bytes, ...) and because otherwise
>> the fsyncs at the end of a checkpoint can be unpredictably slow.  For
>> foreground writes we do not default to that, as there are users that won't
>> (because they don't know, because they overcommit hardware, ...) size
>> postgres' buffer pool to be big enough and thus will often re-dirty pages that
>> have already recently been written out to the operating systems.  But for many
>> workloads it's recommened that users turn on
>> sync_file_range(SYNC_FILE_RANGE_WRITE) for foreground writes as well (*).
>>
>> So for many workloads it'd be fine to just always start writeback for atomic
>> writes immediately. It's possible, but I am not at all sure, that for most of
>> the other workloads, the gains from atomic writes will outstrip the cost of
>> more frequently writing data back.
> 
> OK, good. Then I think it's worth a try.
> 
>> (*) As it turns out, it often seems to improves write throughput as well, if
>> writeback is triggered by memory pressure instead of SYNC_FILE_RANGE_WRITE,
>> linux seems to often trigger a lot more small random IO.
>>
>>> So immediately writing them might be ok as long as we don't remove those
>>> pages from the page cache like we do in RWF_UNCACHED.
>>
>> Yes, it might.  I actually often have wished for something like a
>> RWF_WRITEBACK flag...
> 
> I'd call it RWF_WRITETHROUGH but otherwise it makes sense.
> 

One naive question: semantically what will be the difference between
RWF_DSYNC and RWF_WRITETHROUGH? So RWF_DSYNC will be the sync version and 
RWF_WRITETHOUGH will be an async version where we kick off writeback immediately 
in the background and return?

--
Pankaj

