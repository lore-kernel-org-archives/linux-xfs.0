Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFD513AA20;
	Fri, 17 Jan 2025 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130447; cv=none; b=M52Uh+BRbia6A0tfO7Xh0v0WoBAeR9mE30dJePLniimrNhw4jjwuzKqq5JoCL89xjj0v3asq1O5XLv2K+/tTRyHhkcprCEzXtBrQKWjSt57QFxjhc7Xwx4fMtgE1t26etI2o21fRWnFKyFv00cPHo97y+0emIjNzX7+xhRA9Aos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130447; c=relaxed/simple;
	bh=6k24Z0mpRMr0gE6gAryOXqu3zyyrsqW+XRqXD3HELQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PX/Ez+N47Ytkv+E2jt5qJm4oe+Ur9sP+XVT/tpo3AghyfaZgPsdGTSRjqYo9jr9ryMEbihHH6hbkFQDyZ1G65xXKhMK42XzPvb8MbqcVjbk1XMSbUS9zAsT34dQB76RpmoqavPXNsWjVPOEU5qbIRIqk77eXAY9uqMXtfU9NJbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AewDqURU; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AewDqURU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=Ch1hRi5XFULxD9RboB90Vauu9c2ESuaWrGAPtjM2xpE=;
	b=AewDqURURRK0RJPsTSXIkUwHV00PNyXP5nLjvF1T8Kv4yZmAck7HqN9fs7Kanj
	PgnisXIDQW8R1P63HGqRMIL7W53grTL5uFWGheeGyWIY6N9HfTW4UnJOgoG+3MMb
	NL80c4djEEdlmIda9PAdeWOjsHb22IKGzK2SDWEevcImk=
Received: from [192.168.5.16] (unknown [58.20.14.26])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAnjrZygYpnX9YFJg--.46693S2;
	Sat, 18 Jan 2025 00:12:35 +0800 (CST)
Message-ID: <fcab0612-2211-40be-a837-e8969d795617@163.com>
Date: Sat, 18 Jan 2025 00:12:34 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>, John Garry <john.g.garry@oracle.com>
References: <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs> <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org> <Z4grgXw2iw0lgKqD@dread.disaster.area>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <Z4grgXw2iw0lgKqD@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PigvCgAnjrZygYpnX9YFJg--.46693S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxur43AF47ZrWkGr1rKr1UGFg_yoWrWw1xpF
	WrKa9rGr1DJrykArn7uw48XFy0y393JrW3CFZ8Xr97Ca98WFWSqF4kt3WYvrWDCr4xJF1Y
	vrW09a4fWa4YvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U5Oz3UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBawDXnWeKgQkGIgAAsg

On 2025/1/16 05:41, Dave Chinner wrote:
> On Tue, Jan 14, 2025 at 09:55:21PM -0800, Christoph Hellwig wrote:
>> On Mon, Jan 13, 2025 at 08:40:51AM -0500, Brian Foster wrote:
>>> Sorry if this is out of left field as I haven't followed the discussion
>>> closely, but I presumed one of the reasons Darrick and Christoph raised
>>> the idea of using the folio batch thing I'm playing around with on zero
>>> range for buffered writes would be to acquire and lock all targeted
>>> folios up front. If so, would that help with what you're trying to
>>> achieve here? (If not, nothing to see here, move along.. ;).
>>
>> I mostly thought about acquiring, as locking doesn't really have much
>> batching effects.  That being said, no that you got the idea in my mind
>> here's my early morning brainfart on it:
>>
>> Let's ignore DIRECT I/O for the first step.  In that case lookup /
>> allocation and locking all folios for write before copying data will
>> remove the need for i_rwsem in the read and write path.  In a way that
>> sounds perfect, and given that btrfs already does that (although in a
>> very convoluted way) we know it's possible.
> 
> Yes, this seems like a sane, general approach to allowing concurrent
> buffered writes (and reads).
> 
>> But direct I/O throws a big monkey wrench here as already mentioned by
>> others.  Now one interesting thing some file systems have done is
>> to serialize buffered against direct I/O, either by waiting for one
>> to finish, or by simply forcing buffered I/O when direct I/O would
>> conflict.
> 
> Right. We really don't want to downgrade to buffered IO if we can
> help it, though.
> 
>> It's easy to detect outstanding direct I/O using i_dio_count
>> so buffered I/O could wait for that, and downgrading to buffered I/O
>> (potentially using the new uncached mode from Jens) if there are any
>> pages on the mapping after the invalidation also sounds pretty doable.
> 
> It's much harder to sanely serialise DIO against buffered writes
> this way, because i_dio_count only forms a submission barrier in
> conjunction with the i_rwsem being held exclusively. e.g. ongoing
> DIO would result in the buffered write being indefinitely delayed.
> 
> I think the model and method that bcachefs uses is probably the best
> way to move forward - the "two-state exclusive shared" lock which it
> uses to do buffered vs direct exclusion is a simple, easy way to
> handle this problem. The same-state shared locking fast path is a
> single atomic cmpxchg operation, so it has neglible extra overhead
> compared to using a rwsem in the shared DIO fast path.
> 
> The lock also has non-owner semantics, so DIO can take it during
> submission and then drop it during IO completion. This solves the
> problem we currently use the i_rwsem and
> inode_dio_{start,end/wait}() to solve (i.e. create a DIO submission
> barrier and waiting for all existing DIO to drain).
> 
> IOWs, a two-state shared lock provides the mechanism to allow DIO
> to be done without holding the i_rwsem at all, as well as being able
> to elide two atomic operations per DIO to track in-flight DIOs.
> 
> We'd get this whilst maintaining buffered/DIO coherency without
> adding any new overhead to the DIO path, and allow concurrent
> buffered reads and writes that have their atomicity defined by the
> batched folio locking strategy that Brian is working on...
> 
> This only leaves DIO coherency issues with mmap() based IO as an
> issue, but that's a problem for a different day...
> 
>> I don't really have time to turn this hand waving into, but maybe we
>> should think if it's worthwhile or if I'm missing something important.
> 
> If people are OK with XFS moving to exclusive buffered or DIO
> submission model, then I can find some time to work on the
> converting the IO path locking to use a two-state shared lock in
> preparation for the batched folio stuff that will allow concurrent
> buffered writes...
> 

I really think it's time for someone to submit the basic patch, and then
we can continue with the discussion and testing. :)

BTW, I support the solution with folio batch and two-state shared lock.


Thanks,
Chi Zhiling

