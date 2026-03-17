Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E753988FB;
	Tue, 17 Mar 2026 08:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773736075; cv=none; b=leFWYEWb3fnzP/9TYmyN1d7aW81HfL1dY1ivC+++G+4QzUp6GglEZQSZLFx//2YAis8znXL4l6GSUUhvZJdTgLiyt3+xCcB6N8uh6FJsewFlCoTC3dd/Nm8xB1FInN60XRwL3f4dW1IYM7O5oCRo75SP3PrCfdDtX3CNC4xBVY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773736075; c=relaxed/simple;
	bh=5J7bm5yZK2SOAa9ngMWjA/xHVCb4YicboOTrm+PNtwU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=rI/6cKYgQN90CA0vKrt53DKnxW2Ke41h3yZXBoS/uqseo5yTk3M6/o7kY44e6U7gtwmLAQ7Vw4xwpL6UsLISX98EA2rx+dEW5RqChBV6MOfolGZNEmJSmBWqDPlYZvnOetFBvc8YJZsNAGILh8xNBi1Phac35vn5bvN+MXE9Jb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rPHlFxRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rPHlFxRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B08AC4CEF7;
	Tue, 17 Mar 2026 08:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773736074;
	bh=5J7bm5yZK2SOAa9ngMWjA/xHVCb4YicboOTrm+PNtwU=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=rPHlFxRm+xTAI1x38mz3jSy00ZKkrVmPpnz40uyihNJE5MPDov1WHJdJUitOMXLrJ
	 un6A8dglaKzNMTlYW8p7vZW0d/oZcVWwNHhf/Jc3EQk9CIAxFAO/TV0PTJBAU+xMX4
	 4SBdtLTLv0tJnRV+H5bHNxvG3TGygef8kayz+xsC/OhwS6JmnTucI7EVfjQhUW5fnz
	 k3HNS0/A8/i+4SKgBrqCtG5hCNiS/Mi7XpynSOplR0cxRbCaHa5k0NLGFDr8WykDK6
	 iDppdA+7VLxcxSyM0fPEPfd6hcmf9cf2OqNpnno0ACsAJBsUbqlJQ5m8sBErpDSyAz
	 PJg3HBBRH7D1A==
Message-ID: <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
Date: Tue, 17 Mar 2026 09:27:50 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
To: changfengnan <changfengnan@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, guzebing <guzebing1612@gmail.com>,
 brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, guzebing@bytedance.com,
 syzbot@syzkaller.appspotmail.com, linux-mm@kvack.org
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
 <aWh06YoiJrR3-J-X@dread.disaster.area>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
 <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
Content-Language: en-US
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/17/26 08:28, changfengnan wrote:
> 
>> That suggests in that test you used larger capacity than the automatically
>> calculated.
> The 10% improvement is due to the every cache has sheaves.
> When I tested 256-byte objects, default sheaf_capacity is 26, allocating and
> freeing 32 objects did not show a noticeable difference, but allocating and
> freeing 128 objects resulted in a significant improvement, about 3-4x in a 
> multithreaded environment.  about 12% improvement in single thread.

Great!

>>  
>> > I'm thinking that maybe these improvements may not be significant enough to
>> > see the effect in the io flow.
>> > Using a simple list seems to be the most efficient approach.
>> 
>> I think the question is, what improvement do you now see with your added
>> pcpu cache vs kmalloc() when 7.0-rc4 is used as the baseline?
> 
> On 7.0-rc4, pcpu get 1.20M IOPS , kmalloc get 1.19M IOPS, new cache with set sheaf_capacity 256, 1.19M IOPS
> On 6.19, pcpu get 1.20M IOPS,  kmalloc get 1.17M IOPS, new cache with set sheaf_capacity 256, 1.19M IOPS.

Thanks a lot for that data. My conclusion is that kmalloc before sheaves did
indeed worse and custom pcpu cache improved it relatively more. Kmalloc with
sheaves does better, and the improvement of custom pcpu cache is smaller.
Also the default sheaf capacity seems to be enough for this workload.

IO is not my area but getting from 1.19M to 1.20M doesn't look like it's
worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).
