Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8932BE658;
	Mon,  3 Nov 2025 07:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762155038; cv=none; b=be/p9uqpe24xQ5nwq0xCY7RTZdqdJmkmd8uYQg3yUg5UTH9l/4nKwubl3UViSY5IcmyCChN82+xHtFPY2qCsv/2t+BptEryKVJtWBgW0izTJX+FA1iwvnlzw8ea6UmFrqkXrhW8hRJ3Tg2VlwwJFBd0QZwQCwoGoVwqycB/oQwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762155038; c=relaxed/simple;
	bh=fNPEgWhmKcSfXgHxY8vQ6zDm8hy1QN8YPkQR/O50gEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmYwWlqeMWkKaSsUSbrlfIa7R5Bw+HSf9Iw/5ftSiN1Abegx+au4v4qX3KY0oqQiuZOs40wOMpPn104vxV6Oes0GM6Yx/KjzCWH9sujgdCcKo5Y8BHqqlRXw/Bf58ohE129sG41JlTZUoCS+s0pB7eYKlNJdXunFZ1XeihuzVKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwOFFC0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwOFFC0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC116C4CEE7;
	Mon,  3 Nov 2025 07:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762155038;
	bh=fNPEgWhmKcSfXgHxY8vQ6zDm8hy1QN8YPkQR/O50gEk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GwOFFC0Qu1g/MgQu4yB4BGazeSYVXu7QOTJ+EMkLVI5N1EIFimk3bn1scoQrD6vLC
	 Evn9J2oxFzNX2KdKVdDmZ0XS4naB8WkFv1YBXXniCy7oV8GIcNkU4AVFd7VZm0pOeH
	 E/dIFrMTSQ0q9jnaWOTnNGr2oUBbpYqhm3LzpVaqG93dMBejtWBMCCq4T0Xylgzj0+
	 k4KReocg/4eFiPA9zBQK+mq2IbffujegIuTfbQq1WUEHY7Fv4BrDVgc6gtp2NyP0AI
	 wbtkqReZ9p8BS+4ut/UwgOmK1SbuBxOt7mSCer/fPybYFflSsYlOsUJ6rnOlMbUfPs
	 RsxmdR54fDyvg==
Message-ID: <f0124d2d-880a-4c44-bd42-178838891b20@kernel.org>
Date: Mon, 3 Nov 2025 16:30:34 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] block: freeze queue when updating zone resources
To: Daniel Vacek <neelx@suse.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>
References: <20251031061307.185513-1-dlemoal@kernel.org>
 <20251031061307.185513-2-dlemoal@kernel.org>
 <55887a39-21ee-4e6c-a6f3-19d75af6395a@acm.org>
 <bd71691f-e230-42ca-8920-d93bf1ea6371@kernel.org>
 <CAPjX3FebPLu_P=-BuP63VuaiAnC62rthcQ0vb+J8b-w0OckyqA@mail.gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CAPjX3FebPLu_P=-BuP63VuaiAnC62rthcQ0vb+J8b-w0OckyqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/25 16:18, Daniel Vacek wrote:
> On Mon, 3 Nov 2025 at 06:55, Damien Le Moal <dlemoal@kernel.org> wrote:
>>
>> On 11/1/25 02:48, Bart Van Assche wrote:
>>> Hi Damien,
>>>
>>> disk_update_zone_resources() only has a single caller and just below the
>>> only call of this function the following code is present:
>>>
>>>       if (ret) {
>>>               unsigned int memflags = blk_mq_freeze_queue(q);
>>>
>>>               disk_free_zone_resources(disk);
>>>               blk_mq_unfreeze_queue(q, memflags);
>>>       }
>>>
>>> Shouldn't this code be moved into disk_update_zone_resources() such that
>>> error handling happens without unfreezing and refreezing the request
>>> queue?
>>
>> Check the code again. disk_free_zone_resources() if the report zones callbacks
>> return an error, and in that case disk_update_zone_resources() is not called.
>> So having this call as it is cover all cases.
> 
> I understand Bart's idea was more like below:
> 
>> @@ -1568,7 +1572,12 @@ static int disk_update_zone_resources(str
> uct gendisk *disk,
>>       }
>>
>>   commit:
>> -     return queue_limits_commit_update_frozen(q, &lim);
>> +     ret = queue_limits_commit_update(q, &lim);
>> +
>> +unfreeze:
> 
> +       if (ret)
> +               disk_free_zone_resources(disk);
> 
>> +     blk_mq_unfreeze_queue(q, memflags);
>> +
>> +     return ret;
>>   }
>>
>>   static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,
> 
> And then in blk_revalidate_disk_zones() do this:
> 
>         if (ret > 0) {
>                 ret = disk_update_zone_resources(disk, &args);
>         } else if (ret) {
>                 unsigned int memflags;
> 
>                 pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
> 
>                memflags = blk_mq_freeze_queue(q);
>                disk_free_zone_resources(disk);
>                 blk_mq_unfreeze_queue(q, memflags);
>         }
> 
> The question remains if this looks better?

Rereading everything, I think that Bart has a good point: moving the call to
disk_free_zone_resources() in the error path of disk_update_zone_resources()
allows doing the error handling without unfreezing and re-freezing the queue.
That's better.


-- 
Damien Le Moal
Western Digital Research
