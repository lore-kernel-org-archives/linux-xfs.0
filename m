Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805093C198C;
	Fri, 27 Mar 2026 06:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774593931; cv=none; b=MHMq0KdNqpdcvnuF9q1vcK5d+SiEwc+6g+YbvfMjs9SDf/dneJ1BmE68esC/bBCcAFKa7GPmA8ljz3NYXhG6F/rq/VQ6KqtIczBbkiQaG1ppDJ2ZSBYod6USUbuvHKzwWRhx7aFYD+8zkzEvzU20nDmk20ENp8X7GICdkRPO2AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774593931; c=relaxed/simple;
	bh=Ja2csVPtsYEKlHxHsruNohtl8dByNCtYLgLBh3ftEH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kbxejUP0VEqlh2bRQemn6/dCTiyO9wg/knMcFP97obzks8OuhYZ1WiT1dpcN9HM7Xx4yxgjTNxBqBwz87QMm8E0xXEFDIBZcVlqgCLYymgLFIgAEn053izkb+QrwsSMfOgtD2fRT7KXQKFmm9BzOKdRGpbFomhyHAmEf1CtF2Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gQnpPoXl; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gQnpPoXl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774593914; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O0bPPvK7Mw1LToaM78FrGCA/5WXVTaQ0nyJTHS3nh8U=;
	b=gQnpPoXlEdPHUoWf2SkRTeALhBW9Vj8jamrK0LdjvcpMC3IrzsKRkZy+ja9ANRNMUsGQUh6+4mduvcrz61bUS4W3jvzYY1fNO0YlU9HTvHO/heuhbk+DGoTz3K21gf/Y98QCDp+hC6kkr86MbERpw6xKixp5dKnNwnFrH3YW88U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X.nKRnf_1774593912;
Received: from 30.221.131.128(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.nKRnf_1774593912 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 14:45:13 +0800
Message-ID: <9e83a4b5-ac4f-46d1-9510-a24e7ef54b87@linux.alibaba.com>
Date: Fri, 27 Mar 2026 14:45:12 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
 Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRG5f9QjdEKg2JB@dread> <acYe1oCInkDLWGGu@infradead.org>
 <9e8061a5-980e-4e6a-a349-8a89f9eb1ba6@linux.alibaba.com>
 <acYjSMkz9MdWQKoJ@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <acYjSMkz9MdWQKoJ@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/27 14:27, Christoph Hellwig wrote:
> On Fri, Mar 27, 2026 at 02:24:02PM +0800, Gao Xiang wrote:
>>   - use EROFS directly, in that case, we still need process
>>     contexts to decompress, but due to Android latency
>>     requirements, they really need per-cpu RT threads instead,
>>     otherwise it will cause serious regression too; but I'm not
>>     sure that case can be replaced by this work since workqueues
>>     don't support RT threads and I guess generic block layer
>>     won't be bothered with that too.
> 
> All of the I/O completions should be latency sensitive.  So I think it
> would be great if you could help out here with the requirements and
> implementation.

Yes, especially for sync read completion. Our requirement can
be outlined as:

   - a mark to make the whole bio completion in task, so that
     we ensure that the bio completion is in the task context
     so that we don't need to worry about that;

   - another per-CPU RT thread flag (or similiar) relates to
     a bio or some other things, so that bio completion can be
     handled by per-cpu RT threads instead of workqueues
     instead.

If they meet, I think that would be very helpful to clean
up our internal codebase at least.

Thanks,
Gao Xiang
