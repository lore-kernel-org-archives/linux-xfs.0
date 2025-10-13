Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAF026E714
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 12:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760359738; cv=none; b=hB6Ssuo4Efh/7A2Lk5oiEIbH6xdHeFbROqw1kFyMJhbpcqNVTNuU9+S0ZNqmAbKKug8Lp9cd71D3kT83+P1PfZxnKPV+CzILFDu8PNNlzERquo/h0ACkbhchAB/+ZXuWb9ipp3+sHbYxnUgYA2jbU/C6pvh6LjX0uTGo90WDxWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760359738; c=relaxed/simple;
	bh=q1/1g1aOp688VA6iTlmc6G4Gt6IPhwQ6SlSbAlgfVko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zer+YgVzJbIVwqtwu4IWWqYJzJx5fPdGe8ySns4lV2plfopOqqESLkZP9/ikoUwXkI3H02WE9EOYBpu/QX9x2tgUIKiBncmVLIvEwYUWTqpaG9HXcu9QsSZZzXpHK3ckoL1TITmnz5TzSh9dw2TOuiV4i3USBpoP4xqeVrL5a0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gCeK9oDb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gCeK9oDb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760359734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V6YxR1nTJCDrfaOZFN3CnG2vV5jcoOfzGFCcTcZo0jw=;
	b=gCeK9oDbwUpVGMJ5X0xQoBymzfm5LIlOlFfHGArX5/g7WHLGr51MhRSij2X5tRlyKBSCae
	noFeR2Ep06+Y5IVIA08vsZ3x8Ro3M4Gw5OxZhmAO3pPVejO29nGTsMW3vk4spQnSUvfoXa
	vEyBf2buwCQswLRQJlF+bjUxusvbmVY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-cI6A0gHoPV-Jq71JgH4pdQ-1; Mon, 13 Oct 2025 08:48:53 -0400
X-MC-Unique: cI6A0gHoPV-Jq71JgH4pdQ-1
X-Mimecast-MFC-AGG-ID: cI6A0gHoPV-Jq71JgH4pdQ_1760359732
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e41c32209so22694265e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 05:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359732; x=1760964532;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V6YxR1nTJCDrfaOZFN3CnG2vV5jcoOfzGFCcTcZo0jw=;
        b=RGjHkQngaGvrgZpuJkMH7zid9PFAKGqeYtqQq9vLEnqTPUcl+mPDPrzfCtbcWgmV1p
         Tx66/YaSZnSzRcR85cdnaYwEGaxbIJFPKFin+s8gXIhCEjEsC7FFhSI66Cqo+kZ4qoaC
         DVov9HB3SlyXqOS/WibRSzpni7V+eLKgZQYhLBxW7zTet/TYlGEjI7Jx0kOIVU6kdxRh
         +jkZuwDTsHek1kthgKgqw6QLWasOM2bubhFUIJi2HTVW3Ste08dXjJvpobq5rQh16UC1
         nWsQbRHhbHTag3uyZm2G+bh4OHShCAcLqF7io291t/pk0Pi0XdnY4uv6hGcBP1LvMEFU
         Q5TQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn968p39zP67XKSlc9J3HKRweFlFujcHUk4xRCNILHaNZhkvpuu8DotCtu7VRvA8U8KNSIpQtYioU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5NJcyBiw7VAL7gmP5bKeXXk2MOCjmH453F0uXuz2ee6KKWmRy
	QYhC6T414LnD+Lwfn7PNbzsJSoBE/gCVdRE2MfVFmjFkCeqFKMQgDRvYoxMz27vpCtQNgDP34kE
	yhcBB321OYnCHYslgnymoMlnK1RDRvW6XVNjPWPkxQRk4qjB02vdI3nONdac26Q==
X-Gm-Gg: ASbGncsgbGJdGw1hzltwf0B3xgcjfQuf6zRpegnd01PwGgapiHQjRaRgab8Z8Qtc4QV
	tJg/LZ1lqO9urM0PWLbo801o5tiuKJfKhIE/6YNlez54O3grq/ZZW4GbC+duKQ1407utMjnLGyo
	+mEU+stQ986+Ut2rPv33+pGhDIFex3+/V9J+4bZAlN7EQ3xSm/ACckUVaKUwCIqt9HSegjg59CW
	/lJYPqFb5nbQFDX6uhDXZDCkB2ZV5r+fdqHNo+XfIdBZeSTmddRsqbKf4cjxVZHnbGh16qg2aJG
	CednxGX2Rum2plVxuXvtFGMNLVyksEy+KQEcK/ZWnDtkczFiGN2cAhdyFyWgKzHrSjkmovhA2S9
	kTRg=
X-Received: by 2002:a05:600c:530e:b0:46e:4c90:81d0 with SMTP id 5b1f17b1804b1-46fa9a8f1c5mr144086805e9.2.1760359731940;
        Mon, 13 Oct 2025 05:48:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGLnouyUlx2MAgaHkKm2L1dKdQ4wuo7Nrhykv7xLHekC80pf6DEJPuKh5QZvTCPV+to9J8TA==
X-Received: by 2002:a05:600c:530e:b0:46e:4c90:81d0 with SMTP id 5b1f17b1804b1-46fa9a8f1c5mr144086535e9.2.1760359731494;
        Mon, 13 Oct 2025 05:48:51 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb497aec2sm189420095e9.1.2025.10.13.05.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:48:51 -0700 (PDT)
Message-ID: <41f5cd92-6bd8-46d4-afce-3c14a1cd48dc@redhat.com>
Date: Mon, 13 Oct 2025 14:48:48 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
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
 <20251013025808.4111128-7-hch@lst.de>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013025808.4111128-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


> @@ -474,6 +474,28 @@ int filemap_flush(struct address_space *mapping)
>   }
>   EXPORT_SYMBOL(filemap_flush);
>   
> +/*
> + * Start writeback on @nr_to_write pages from @mapping.  No one but the existing
> + * btrfs caller should be using this.  Talk to linux-mm if you think adding a
> + * new caller is a good idea.
> + */

Nit: We seem to prefer proper kerneldoc for filemap_fdatawrite* functions.

> +int filemap_fdatawrite_kick_nr(struct address_space *mapping, long *nr_to_write)
> +{
> +	struct writeback_control wbc = {
> +		.nr_to_write = *nr_to_write,
> +		.sync_mode = WB_SYNC_NONE,
> +		.range_start = 0,
> +		.range_end = LLONG_MAX,
> +	};
> +	int ret;
> +
> +	ret = filemap_fdatawrite_wbc(mapping, &wbc);
> +	if (!ret)
> +		*nr_to_write = wbc.nr_to_write;
> +	return ret;
> +}
> +EXPORT_SYMBOL_FOR_MODULES(filemap_fdatawrite_kick_nr, "btrfs");
> +
>   /**
>    * filemap_range_has_page - check if a page exists in range.
>    * @mapping:           address space within which to check


I think there is still a discussion on the name, but in general LGTM

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb

