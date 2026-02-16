Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCBA2E717B
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 13:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771247898; cv=none; b=CirvaPbh3VdgL/0VTWRLwPYcodci0JTf0L0nEFUCK7qS0nWJWCswPJeOV8KtT6IjUxV77EWtNdXyhGSpt42xOh9nwWa9UzQ6+2ARhzk+wcoNVFfehqWn7sNqCeq27FJQWMtvjOFqp4VspR5CY0oybfCjtq1OV3lOo+RudCB1Vko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771247898; c=relaxed/simple;
	bh=vZEGwyLXtwS50t+qseTk7VEoyijqYlIwNiT1NUT/MaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WuCBdz0MixGJ585qZCBKyk7XPnYZM7o90cPRQWyLU5yju9YF4hOcu6FdT01SrDdDf7rksjypyPHTG28wFS4fWmx+gD/RiYAS/rCuaAC4eUuctU+mY8s4cO03y6mfGtvhjS08t6QrjOVjubJQd992n/ErzDIbXukD1Gbv1ua0fPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p48jLXCy; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p48jLXCy"
Message-ID: <c29d36eb-0706-4f3c-aaed-de7d9ef74bed@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771247894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V05ejPvopLo9DRbeUi1eZlG4ZZP00I4HL4AVm44w2ig=;
	b=p48jLXCyB4VQIxa8U3Gdq7k8wKO8XyymBq6W8BKSRkDN7UxEod2Qo9XWM6In41SsmVr+1X
	6bxBpYh3sSb2Zy2qbVUyeFagIxBxAeBh7JjAaEUhiDSJL47UcvZlEFoNMF1POC5KagDyAC
	gKbYB0/kLVuZKWkLCLWUh1bnjRK+ODA=
Date: Mon, 16 Feb 2026 14:18:10 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
 Andres Freund <andres@anarazel.de>, djwong@kernel.org,
 john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
 dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
 gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
 vi.shah@samsung.com
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2/16/2026 12:38 PM, Jan Kara wrote:
> Hi!
> 
> On Fri 13-02-26 19:02:39, Ojaswin Mujoo wrote:
>> Another thing that came up is to consider using write through semantics
>> for buffered atomic writes, where we are able to transition page to
>> writeback state immediately after the write and avoid any other users to
>> modify the data till writeback completes. This might affect performance
>> since we won't be able to batch similar atomic IOs but maybe
>> applications like postgres would not mind this too much. If we go with
>> this approach, we will be able to avoid worrying too much about other
>> users changing atomic data underneath us.
>>
>> An argument against this however is that it is user's responsibility to
>> not do non atomic IO over an atomic range and this shall be considered a
>> userspace usage error. This is similar to how there are ways users can
>> tear a dio if they perform overlapping writes. [1].
> 
> Yes, I was wondering whether the write-through semantics would make sense
> as well. Intuitively it should make things simpler because you could
> practially reuse the atomic DIO write path. Only that you'd first copy
> data into the page cache and issue dio write from those folios. No need for
> special tracking of which folios actually belong together in atomic write,
> no need for cluttering standard folio writeback path, in case atomic write
> cannot happen (e.g. because you cannot allocate appropriately aligned
> blocks) you get the error back rightaway, ...
> 
> Of course this all depends on whether such semantics would be actually
> useful for users such as PostgreSQL.

One issue might be the performance, especially if the atomic max unit is in the 
smaller end such as 16k or 32k (which is fairly common). But it will avoid the 
overlapping writes issue and can easily leverage the direct IO path.

But one thing that postgres really cares about is the integrity of a database 
block. So if there is an IO that is a multiple of an atomic write unit (one 
atomic unit encapsulates the whole DB page), it is not a problem if tearing 
happens on the atomic boundaries. This fits very well with what NVMe calls 
Multiple Atomicity Mode (MAM) [1].

We don't have any semantics for MaM at the moment but that could increase the 
performance as we can do larger IOs but still get the atomic guarantees certain 
applications care about.


[1] 
https://nvmexpress.org/wp-content/uploads/NVM-Express-NVM-Command-Set-Specification-Revision-1.1-2024.08.05-Ratified.pdf 

