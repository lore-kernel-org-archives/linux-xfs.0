Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B81B2DC768
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 11:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760439895; cv=none; b=tZs5lDQM2b3Uts45JjcrkOBII8ZKfuI3K6thM7zcD/lIqXmaKj9QiCP3CFJF4az7PGEVCw9GyjtI95cklB79Gpw1sM27UMYebGx3m4mDGjTE5f+s4OWgrxWMlmFO8ZOhzgN1+e1uzOX9LqAUIKqJhNPbO+WoYF1hMmfcrysnhWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760439895; c=relaxed/simple;
	bh=h5AS+Zjy6zDJe2tBjWwkhuIXONAErINCK4EC2Qd/Awk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C/4cBHaO09jA0zjeJBT6dXwqW1c50eKZ9VXr3vm6q2/hL+W1qIFfNGZLUo60kWPX8aKSbeI9aDmoolvipD3kDLO2XcxIIxWF6LBEgUnGMoPsZnuK8CFO8rNzigFHpRRFbhW/eDgIO2se5Lfxb0gKVEfbrhDikBn0XcT9ofd+Z2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ICFBk2in; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ICFBk2in"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760439892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9Mvh4ql8Y8BBLDK18emWlEI/npE8s1LEzxvuBeQPUok=;
	b=ICFBk2inemDdyTwCJguCPxlNcWAvlsFG5w+4YhfSqyq2yl9lPGx+JqRDhkWTO6cqZGAob4
	3dUBTrW9iokEJg4Og5iBrwty1rVe0wsgfOWs41AHdTUexrtNktDZWwezQekWE+5fJrCtZj
	j5zPrgmfDatJG5nYIjR/uHx75IUWZrI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-kp7wAzAcMDOKQNdcynRvdw-1; Tue, 14 Oct 2025 07:04:51 -0400
X-MC-Unique: kp7wAzAcMDOKQNdcynRvdw-1
X-Mimecast-MFC-AGG-ID: kp7wAzAcMDOKQNdcynRvdw_1760439890
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e36686ca1so48303305e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 04:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760439890; x=1761044690;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Mvh4ql8Y8BBLDK18emWlEI/npE8s1LEzxvuBeQPUok=;
        b=eZuPV58kEvw7Dh/p0qhDh0TmalKWDFjwVmFkEA8k9UvcnRjtPCKdsGqHk7UPkI2kqd
         HLAidjHt0yUyc9Yibuf7o8U7dyvGn01HVvf5Pt1w9jSnt+uxjiTkfI83YR2k4NQr2oZH
         v85G3mAHi2DowowE9kW6vLgxVIIyn55SbVdjnEG+p9ijHR6/YTGdMrGMMKfSXDBhrN0W
         RpOsXGowTDAHmNaYRCv70uRwl22eO2JhkqolLKzNrbWGvNikcON79AM/EZsSjE/p8ygB
         hx1WLkBZUdNxkHd1++qp+CBDZtkalJqW8YmESr/kDnkqEOIB0E1yeeWjbZMUzAk+ENO4
         neCw==
X-Forwarded-Encrypted: i=1; AJvYcCWAfY4aM8G1PK66kUinFy61FbSkmCoo7woGoQgtDjRR8ULGAr0JgP2LSRsIwWW4sWb8ZmaiSC9oSPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgYpCRHU3KMFi56FRqcsYF5ylqd3NIV7KvNGgV1Kk7jOK6mCFs
	1MjEd+tBNIbctWzyouemk3TzN+naA/76n82lZKQoZ9LiHzdHqAy0zr52aQosso+E/4pk3nL3VQ4
	v64OHRWe/GJluLi6FqDfW5KL0OJ2NgxFG7HmF87wKTzohZNPZcKKiNdWnWW1xBw==
X-Gm-Gg: ASbGnctvMMDe6qMC5Phd/71R+Ne8T/Nn/z7wDd7HjjxNndZ6TvWT5lXwFtwaVtLGdKz
	UQ58rkwRYeYI0WYo+tATvEroZc4TCmomQdUYYP0uZ5Va027R4qC5DEF7U8CgiLxYSE8TVWWL6vk
	rvj8la39QpoPE+ch1FnvP58P4hFuUBoABo3nz/YTK7S30gu+pvW3MCxDo3KLzbufMyAJxKK2N/E
	Svi5ACSEloE/LmgK4oo1J3IB4koUZm68fyKrgoBHclFDnFs0G0LMjw3ecLLaJPiCsT3KSBzAsxJ
	qf4PJ/nSh6s/MWppDzIYVB2LFgrGNhhwl5zsauw3iyRdtZVCZ/2MA/n2d/60Zff61ob4aH7Adw=
	=
X-Received: by 2002:a05:600c:3b07:b0:46e:1fb9:5497 with SMTP id 5b1f17b1804b1-46fa9af84fdmr170865605e9.18.1760439890094;
        Tue, 14 Oct 2025 04:04:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzx/Z7wqxSbdzibLnTtJ/UYmUM/D1LJV37loBqc1rTNfI1+V20N8hWD4xaH9pYVYV0jbb3AQ==
X-Received: by 2002:a05:600c:3b07:b0:46e:1fb9:5497 with SMTP id 5b1f17b1804b1-46fa9af84fdmr170865285e9.18.1760439889704;
        Tue, 14 Oct 2025 04:04:49 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb48a5bf9sm235616575e9.18.2025.10.14.04.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 04:04:49 -0700 (PDT)
Message-ID: <34b482e6-2360-4d65-9996-1513bcf12ffb@redhat.com>
Date: Tue, 14 Oct 2025 13:04:47 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
To: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-7-hch@lst.de>
 <41f5cd92-6bd8-46d4-afce-3c14a1cd48dc@redhat.com>
 <20251014044906.GB30978@lst.de>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014044906.GB30978@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.10.25 06:49, Christoph Hellwig wrote:
> On Mon, Oct 13, 2025 at 02:48:48PM +0200, David Hildenbrand wrote:
>>>    +/*
>>> + * Start writeback on @nr_to_write pages from @mapping.  No one but the existing
>>> + * btrfs caller should be using this.  Talk to linux-mm if you think adding a
>>> + * new caller is a good idea.
>>> + */
>>
>> Nit: We seem to prefer proper kerneldoc for filemap_fdatawrite* functions.
> 
> Because this is mentioned as only export for btrfs and using
> EXPORT_SYMBOL_FOR_MODULES I explicitly do not want it to show up in
> the generated documentation, so this was intentional.  Unless we want
> to make this a fully supported part of the API, in which case the export
> type should change, and it should grow a kerneldoc comment.


Ah okay, mentioning the intention with not adding kernel doc in the 
patch description would have been nice :)

-- 
Cheers

David / dhildenb

