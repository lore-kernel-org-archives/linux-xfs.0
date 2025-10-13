Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9922D94B2
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760359590; cv=none; b=L75ANjhCkqwvslUW+tsh2BidekfqUE4ptdVO6/J7TbGUaZ71/rDl9wnAzlFm1x/YICvF+cvHcvC86Hq3NhpiKskGk1dRyd4ZhCfWtmhPBl0oBAd/PGvLesNZeJdUfKnq+1Khe0ZKTgDU2TfkA2S6I4ZUAcpzy2Hbvh0yJnx0NfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760359590; c=relaxed/simple;
	bh=9EPsCaTwQQz8b5W6hCG+5fpl4hKwJmfvAj1XnjFgJuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L+U1SnpgpEzXsne9chf8/TFxo8dg5j9mW37IPBo4pbhyK+4LMEpQukZe+z9nViDQwfd1lCOZ9g5vip10IKmsZxGqDF9M4Rka3m9c5GvH9Yq3voIPVNMyyXLMDZpPpIM/dI2hdnCcyxo4ARlDdEI0LK5XY5WkbxtFHEPxhDvfKD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c6SoZIg1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c6SoZIg1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760359588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DOWtspxQFntLxn3tZgWb3b+wVou4f2oHZHARZ/GY+qM=;
	b=c6SoZIg1rD62HcdUAadi7hycqYiS1Z+oPaE5ym4JJeblgY6ACEouiN8qGneQiiEcFB2M4Z
	jkDaAFbmpr2YHJMUMljVkMzfp962BtEWmwzEhEuZmeBCqtIaOAyRd+JH76b89dwDwtzEKr
	0wGLILuNL8oCQUXuMtMR2B1XNLXsi5U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-lkbNC9okPaK0qFCoTq9Y8Q-1; Mon, 13 Oct 2025 08:46:26 -0400
X-MC-Unique: lkbNC9okPaK0qFCoTq9Y8Q-1
X-Mimecast-MFC-AGG-ID: lkbNC9okPaK0qFCoTq9Y8Q_1760359582
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-40fd1b17d2bso2526601f8f.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 05:46:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359581; x=1760964381;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DOWtspxQFntLxn3tZgWb3b+wVou4f2oHZHARZ/GY+qM=;
        b=YZT7Hnq+fQsolx6KUQgd3CDcImprnTQv+N6VgTd+dzmdVB/rxQuKvEjTpL507KkYj0
         XQSu7SGumJrkSbY0f+FN0tS7t/ojD2RolBAIL701bPioUL7KE4EZOl3DtE9eTfHCYodW
         BqDN7Gmgy30mGmVlDOYYKBBX5FM6ABM9Qgm4xwemdEPGtlksuUTCEQ/pN3eTff9BQhQF
         LuwQRUItmtxVKLH8E8ydAmGR/O7mVqG45I/1za2RfDzDmAXakLGfPF56J7ZNDS+9DjOW
         Rewg45S6+H9BTvgyTI2ddVIFPehfuPAvnf+q15yWLoRMCBXN+84ukOq6HE8tdAcXBh2N
         hxRg==
X-Forwarded-Encrypted: i=1; AJvYcCVivI1s64hVQB/FadihZr5W1o126d67RsiWvemQrivmOJ/QoWY5CPnUrGLg+NtPDLH4t0WXDtSA3jM=@vger.kernel.org
X-Gm-Message-State: AOJu0YymfFJUQ6hNgnALnclizuhky+A8+PSncqQvNk5un6g7rXifoiIG
	3c2p0Ejn3Du1dccpRVvWCgu2kfuOB1TH2SY+U1XE/18YaIFITOuqxLlVANvyzlN/ynje6Zgeuay
	st7uqahT0qqSyLVV9+9Qi88qkISteb6DhRGfGWb35AcVSgDBFn7iAnG3ZmZLgUw==
X-Gm-Gg: ASbGncv+fLhD5haIZDy5bGxpjIEP652YxOveg/p1DC12bUleJyEdsdNUBR5W0Z63Ho9
	VnetcIdhnm0+Z2h4Pc5cNMuqt/2kaO60Y7GZciLgK2ydOXnFd45Jp6bouIhbWdvmY6cjdPpfmxV
	obj4pSnDqPKmHNUAAg+enpeMtHxYwbUNpqVMbd9lpSTTgCfdKJyJlq8Z/qffupSzKc68+/qyjzL
	zAN+qrPCvJ5hhuYQZTKKXFgaIBIkJE/y8ziX6DxW1JbWjK9dgOw7Er6cF4uuDzQQ7Sy/9gNrAg9
	FlRvDT5bW6RJzXS7u8b9dOKAoOnIyKPr7f2CN9roQ383qNSjklBpliMT9MrQZM1L0PKjw8Sq151
	4M2o=
X-Received: by 2002:a5d:5d02:0:b0:425:7c1b:9344 with SMTP id ffacd0b85a97d-42666ab87c3mr12660094f8f.15.1760359581538;
        Mon, 13 Oct 2025 05:46:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8UhyE1zcOzwvyZxntvIRmTrppgW1S8a55KmrUdjOiVEiYyQgg0jajjwhannoKAXqQXoZQ2Q==
X-Received: by 2002:a5d:5d02:0:b0:425:7c1b:9344 with SMTP id ffacd0b85a97d-42666ab87c3mr12660066f8f.15.1760359581095;
        Mon, 13 Oct 2025 05:46:21 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e82dfsm18142892f8f.52.2025.10.13.05.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:46:20 -0700 (PDT)
Message-ID: <a5ba4cdf-5da9-4e3e-af06-ad4ea5c3f659@redhat.com>
Date: Mon, 13 Oct 2025 14:46:17 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] mm: don't opencode filemap_fdatawrite_range in
 filemap_invalidate_inode
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-2-hch@lst.de>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013025808.4111128-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.10.25 04:57, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range instead of opencoding the logic using
> filemap_fdatawrite_wbc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb

