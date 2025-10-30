Received: from sender-op-o19.zoho.eu (sender-op-o19.zoho.eu [136.143.169.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84861287507
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 12:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761825746; cv=pass; b=lBwcwceKfdJ4c3aFR9PasEMfKUhgl0LSfkA724RhgmdrZdCWxGvTvkspIx7V/b9sJ2xzfKuWhYf/HReIeBpg1EOuYntHf4626NO1RdZ9Qu5Q+pgtsbzHVe6r+36Y0d94mwe05GfLtOovzP5OFXPBJ9vd+CKM06t+SPwhsCRkZk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761825746; c=relaxed/simple;
	bh=84iQb1dwCxC9xyLsfKemUeFDBxUHPjVNNi+3KgD/8cA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LLM7CawvU9zwtFsizaNi8Qi/BD2xhqXKMMLNDcMsMizGCErgz4xMZk9hz36c8IYSkWEDLJ2+hUylfUX4+1lLZbUqtJVo/qWcyUfo2G4lw1c3DtmFO/g9eWbIYHAbxvgFIqEXf1ZiibYG3CjB6czSXLhRPq7sYppFdnkDFoPI9gE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=demonlair.co.uk; spf=pass smtp.mailfrom=demonlair.co.uk; dkim=pass (1024-bit key) header.d=demonlair.co.uk header.i=geoff@demonlair.co.uk header.b=Ufb36xN+; arc=pass smtp.client-ip=136.143.169.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=demonlair.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=demonlair.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=demonlair.co.uk header.i=geoff@demonlair.co.uk header.b="Ufb36xN+"
ARC-Seal: i=1; a=rsa-sha256; t=1761825631; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Q8wrnbr+0lfEvwTSqeyHL3Em7bzliJUURbPvs5hnVRyLqY2+d7w7GNwBO5kh0k5URJmU89T7xNdN/fXk3FeYE5Yd4yXIaIVipX0oT+YxWzFGvZMszCjfUl6IOStM/ZkKWY3JpgEMBexG6p0tGZ84sMJdksvVh23FtuerOsfOyNo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1761825631; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EB0cp732OsDDfGOv/Hf8MnYe8fEWnlwPkpeCR1Zt+zo=; 
	b=aoRdijVbvJYUfeufQw9Z8itd/Ye8AzamDWPy/YZdQnCHkiVd8Czk0IRy3pO+xNlifw6o3JdD1o6hFK96mR3bmC56m9llP3vAGuw0quQzk19fER4Vhgc/sEfZcqoiRK9DQGLl/o5OMUgrgGLIw3ldBX86FFSZNyzcaK5NtFGkPfI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=demonlair.co.uk;
	spf=pass  smtp.mailfrom=geoff@demonlair.co.uk;
	dmarc=pass header.from=<geoff@demonlair.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761825631;
	s=zmail; d=demonlair.co.uk; i=geoff@demonlair.co.uk;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EB0cp732OsDDfGOv/Hf8MnYe8fEWnlwPkpeCR1Zt+zo=;
	b=Ufb36xN+wsixKFppcR3FAeR8y8d0qKpHvgwwklV+AfMJV+Rb7Jw+vfudTsIET5LD
	E9lNthtSwhk4yb4lIj4mgzEDFdKP6K3UbPZXMa9ZZk+Yn2csO20u50E5fMq+lJqaRzQ
	NA+Etv36fZzmADqlaC7kLvfN66NsAPFhM+qdXuDE=
Received: by mx.zoho.eu with SMTPS id 1761825628575601.0401082169022;
	Thu, 30 Oct 2025 13:00:28 +0100 (CET)
Message-ID: <5ac7fb86-07a2-4fc6-959e-524ff54afebf@demonlair.co.uk>
Date: Thu, 30 Oct 2025 12:00:26 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fall back from direct to buffered I/O when stable writes are
 required
Content-Language: en-GB
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20251029071537.1127397-1-hch@lst.de>
 <aQNJ4iQ8vOiBQEW2@dread.disaster.area>
From: Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <aQNJ4iQ8vOiBQEW2@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On 30/10/2025 11:20, Dave Chinner wrote:
> On Wed, Oct 29, 2025 at 08:15:01AM +0100, Christoph Hellwig wrote:
>> Hi all,
>>
>> we've had a long standing issue that direct I/O to and from devices that
>> require stable writes can corrupt data because the user memory can be
>> modified while in flight.  This series tries to address this by falling
>> back to uncached buffered I/O.  Given that this requires an extra copy it
>> is usually going to be a slow down, especially for very high bandwith
>> use cases, so I'm not exactly happy about.
> How many applications actually have this problem? I've not heard of
> anyone encoutnering such RAID corruption problems on production
> XFS filesystems -ever-, so it cannot be a common thing.
>
> So, what applications are actually tripping over this, and why can't
> these rare instances be fixed instead of penalising the vast
> majority of users who -don't have a problem to begin with-?
I don't claim to have deep knowledge of what's going on here, but if I
understand correctly the problem occurs only if the process submitting
the direct I/O is breaking the semantic "contract" by modifying the page
after submitting the I/O but before it completes.  Since the page
referenced by the I/O is supposed to be immutable until the I/O
completes, what about marking the page read only at time of submission
and restoring the original page permissions after the I/O completes? 
Then if the process writes to the page (triggering a fault) make a copy
of the page that can be mapped back as writeable for the process - i.e.
normal copy-on-write behaviour - and write a once-per-process dmesg
warning that the process broke the direct I/O "contract".  And maybe tag
the process with a flag that forces all future "direct I/O" requests
made by that process to be automatically made buffered?

That way, processes that behave correctly still get direct I/O, and
those that do break the rules get degraded to buffered I/O.

Unfortunately I don't know enough to know what the performance impact of
changing the page permissions for every direct I/O would be.

>
>> I suspect we need a way to opt out of this for applications that know
>> what they are doing, and I can think of a few ways to do that:
> ....
>
>> In other words, they are all kinda horrible.
> Forcing a performance regression on users, then telling them "you
> need to work around the performance regression" is a pretty horrible
> thing to do in the first place. Given that none of the workarounds
> are any better, perhaps this approach should be discarded and some
> other way of addressin the problem be considered?
>
> How about we do it the other way around? If the application is known
> to corrupt stable page based block devices, then perhaps they should
> be setting a "DIO is not supported" option somewhere. None of them
> are pretty, but instead of affecting the whole world, it only
> affects the rare applications that trigger this DIO issue.
>
> That seems like a much better way to deal with the issue to me;
> most users are completely unaffected, and never have to worry about
> (or even know about) this workaround for a very specific type of
> weird application behaviour...
Yes, I completely agree that we should not be penalising processes that
obey the direct I/O rules for the benefit of those that do not.

>
> -Dave.
>
Regards,

Geoff.

