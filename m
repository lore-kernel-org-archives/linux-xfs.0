Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AE617A922;
	Tue, 10 Sep 2024 19:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725995252; cv=none; b=JQz8Upg0eQvyEWv4QOrv1u1RgFo7hk0L1uM7d32LPDGsBZD1zZ3N0tkM6qjNw8eIZjhfe4XKjCVJtKs0M4yNYzJdS9UrHtyjPRlQQz14TGyec69aTSnklLTtMnyEoQ1Fjx+wt3d/5HR9E2mtcbWA4KlqCoX0lPXamBgxcg18obA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725995252; c=relaxed/simple;
	bh=9MXRs95DQcimz91oW+gbRYOEAqs4CYjnCQx/Xo8u6VM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nHqND8kJWCSUcMmtaJouGzsNNNCVJnqpHOHbdGc+ZmYtRPNt5T3lXNweJuniAbA0xTK129Watzh9Hv9IJ3ZcrjeaAi69b34tiCRIfaAAmhJuUJAZP+G549QEbuTQzAtVN55Yn9pcNF4oneh4Fydt7LkANJafiHcvsbtqVEs18S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPrkcKHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPrkcKHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40409C4CEC3;
	Tue, 10 Sep 2024 19:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725995252;
	bh=9MXRs95DQcimz91oW+gbRYOEAqs4CYjnCQx/Xo8u6VM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sPrkcKHQr71nNFlip2CxixSQhQ+3lOFy1hwBpHlmLxB80KPp4qmraA9UWGtm4pvbz
	 +aT2lMXfr+DCtmo07SCirWB/NDrd/+mgpQzgYocJ3Ct9M5WEY414QzrMR/HJOTOohY
	 GeCcbPJdOFBTtCHRRV+WN3DAiWq5iTUDnMn43wcsJ15hjUIXPkeWxQqD5PyxaR5iTH
	 sRvbw2dDZ/UnzXO0bf/LvDtAZSgUrjHhrjAuMca/mdrGQXlWb6lkpIMm1oBTz96PVQ
	 hSt8geLn3ILiADo9VsIG5uJwBypFEp+ynNE6BAKaD1U7qZH1Z6Wmx5jGbEXMyldK8R
	 RdC7HZ5NWCU5g==
Message-ID: <5428ec4f-a961-4ef4-b9d0-e689fa3d00bd@kernel.org>
Date: Tue, 10 Sep 2024 21:07:27 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Regression v6.11 booting cannot mount harddisks (xfs)
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Netdev <netdev@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org, cassel@kernel.org,
 handan.babu@oracle.com, djwong@kernel.org,
 Linux-XFS <linux-xfs@vger.kernel.org>, hdegoede@redhat.com,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 kernel-team <kernel-team@cloudflare.com>
References: <0a43155c-b56d-4f85-bb46-dce2a4e5af59@kernel.org>
 <d2c82922-675e-470f-a4d3-d24c4aecf2e8@kernel.org>
 <ee565fda-b230-4fb3-8122-e0a9248ef1d1@kernel.org>
 <7fedb8c2-931f-406b-b46e-83bf3f452136@kernel.org>
 <CAHk-=wgO9kMbiKLcD3fY0Yt5PJSPD=9NVH0cs=xQFSk8dU9Z1Q@mail.gmail.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <CAHk-=wgO9kMbiKLcD3fY0Yt5PJSPD=9NVH0cs=xQFSk8dU9Z1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/09/2024 20.30, Linus Torvalds wrote:
> On Tue, 10 Sept 2024 at 10:53, Jesper Dangaard Brouer <hawk@kernel.org> wrote:
>>
>> af2814149883e2c1851866ea2afcd8eadc040f79 is the first bad commit
> 
> Just for fun - can you test moving the queue freezing *inside* the
> mutex, ie something like
> 
>    --- a/block/blk-sysfs.c
>    +++ b/block/blk-sysfs.c
>    @@ -670,11 +670,11 @@ queue_attr_store(struct kobject *kobj, struct
> attribute *attr,
>            if (!entry->store)
>                    return -EIO;
> 
>    -       blk_mq_freeze_queue(q);
>            mutex_lock(&q->sysfs_lock);
>    +       blk_mq_freeze_queue(q);
>            res = entry->store(disk, page, length);
>    -       mutex_unlock(&q->sysfs_lock);
>            blk_mq_unfreeze_queue(q);
>    +       mutex_unlock(&q->sysfs_lock);
>            return res;
>     }
> 
> (Just do it by hand, my patch is whitespace-damaged on purpose -
> untested and not well thought through).
> 
> Because I'm wondering whether maybe some IO is done under the
> sysfs_lock, and then you might have a deadlock?
> 
>                Linus

Tested the patch (manually applied change) and it did NOT help.

More likely the patch/fix Jens pointed to is the culprit.

--Jesper
