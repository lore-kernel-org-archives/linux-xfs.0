Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8699852F6B
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 07:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709710671; cv=none; b=mrGB8Sgc+IJFQ6ZS0DjiWPEzNFEjtonwH+A/T8Ji3DpyoU4OXp3Gkpmwo+oC33ZjkDcjLbb0NBZni20qyezoIiVKadxMows8vt1qiNoTyDo0BbvUmvakpdoBGJC/bJAbNb4A/KVv2njniGitUTPpZn49Is4iCb6DpLMKTNPmkC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709710671; c=relaxed/simple;
	bh=kseJw6hPvG4N69ZjKMrpqobcBPEmvNYivHI5BY0aG0E=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=ELEhxgjr+9QZ2EVLQYno1ceWz/7lDoN/+BWfZMoWnXXV9N7RAjDUFhQuZXLzWnf3JwOAbYcmm41jXsqi0W5uogh7JWkJsnGAkwMPMWOK3bgYYYH7qu2zVs5UFXbfNvMQwtXFRj6YQvWyytrby/sUcQFD6rYywbrNuoWCbZsRymA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awtec9b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awtec9b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEF8C433C7;
	Wed,  6 Mar 2024 07:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709710671;
	bh=kseJw6hPvG4N69ZjKMrpqobcBPEmvNYivHI5BY0aG0E=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=awtec9b03fDH8d6jLYswv/1RWVIOKdvM9siEQSz54vDgTCTT4dK65YUwunSzATuTW
	 t7qRlcC59GKWToELxsYmnd8tNNWrUzB6nwOrsFEK7TXyopjjQEAfhIXfeXQ3pmgTcK
	 ZaF1JuBA3G/z6BqYzl7TDX+o2XW5DHXqcFi+VZVdHdEIVNpoThErh3UM33VkK/ah/J
	 MkJMXYNZ31AapB1GuJ9NVlV3SMeGdeKLCMV1/Sa6nZ8kNJjLUfSbqyoiq4w1KUVKtR
	 +6MEIQfmU2apLTYCEXkJY7ouqxejb66sXd37LxOuHvwMbv6zaFjyAkqxbMpZUYPyDM
	 2mcPyabG6DSiQ==
References: <87frx5mfqi.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zea8ja0atOktTl5z@dread.disaster.area>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] Deadlock when executing xfs/168 on XFS' previous
 for-next
Date: Wed, 06 Mar 2024 13:06:14 +0530
In-reply-to: <Zea8ja0atOktTl5z@dread.disaster.area>
Message-ID: <87ttljlsj8.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


On Tue, Mar 05, 2024 at 05:32:45 PM +1100, Dave Chinner wrote:
> On Tue, Mar 05, 2024 at 10:18:45AM +0530, Chandan Babu R wrote:

>> [18460.730782] XFS (loop5): Mounting V5 Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
>> [18460.742765] XFS (loop5): Ending clean mount
>> [18461.786504] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
>> [18679.145200] INFO: task fsstress:230900 blocked for more than 122 seconds.
>> [18679.147164]       Tainted: G        W          6.8.0-rc6+ #1
>> [18679.148710] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [18679.150423] task:fsstress        state:D stack:0     pid:230900 tgid:230900 ppid:230899 flags:0x00000002
>> [18679.152186] Call Trace:
>> [18679.153257]  <TASK>
>
> Ugh - those stack traces are unreadable because of all the unwinder
> false positives (all the ? entries) in them. Can you either change
> the unwinder config in your builds to get rid of them or
> post-process the stack dumps so they are human readable?
>
> /me selects everything and runs `:'<,'>!grep -v "?"` make it
> somewhat more readable and then trims manually:
>

I am sorry about that. I should have cleaned up the irrelevant entries in the
call traces.

-- 
Chandan
