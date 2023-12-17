Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB4946B86
	for <linux-xfs@vger.kernel.org>; Sun, 17 Dec 2023 21:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0szPBMdo"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7b6fe5d67d4so112627839f.3
        for <linux-xfs@vger.kernel.org>; Sun, 17 Dec 2023 13:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702847537; x=1703452337; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dBoU/aqv5Q7r6RvTt+B4s9YAPzT49dENQ7Rnf/QSJ9s=;
        b=0szPBMdo6oY4mmY7OsAupfFq0Q3Q+ld/a66Ci27ojrwuxOsrbryWNtcAwcF37htivu
         4jdmq8CYNQiuLQwzA4YSVJuEY63/r2pvnmVgEzeKAZuTC2jHLbq2A7Rx7aZdAZgyTqVC
         M00mP/G5i/BsZZch2/dqTJp1AtZuLWaXXCSUKvg0VzpzWLg8lQuAPRX7vGAG9YrE9iAq
         QtBSrLMdnu3dYh6rUkZrNMVFzkdH16k9wBhFb8R7HVKLrb2GBn4lzRej0UfESwj7SKBo
         NVJzpico266X2nKjWvK7lQTNeqJ1cBFbLOKBzq6oeZqaUwu7UR2/mOmWQEFyLH+nS13N
         r6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702847537; x=1703452337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBoU/aqv5Q7r6RvTt+B4s9YAPzT49dENQ7Rnf/QSJ9s=;
        b=j5Utm0K+TPOvtBeFKOJUlztVwzXCkTRJD2SZRO+akPgQJtKbokHIXFAJ/hcUJu0qti
         Hn4HCUkvFG4HTo2UKOutgnoWUKv27oshXJ7QxMhNdarUvznXse37v2dKv8wG420RYobD
         Yd/kn3nMZQSGN1sheerQORBITIFgT+ei5QH2OKKr5u+uDdla4eBBQXg1AOr20YTRxdHJ
         KC8eQLxdklHE9PmQ4HUV90ZXfbUxwTDdDs95s3HOqFPe41PETlJy/n9W8XkgPdRWVGna
         ECx4v7j/o112yGsfplUyZbDB8F3D+6dugWKtvWfI+MyIL0sb8T+R0iNEM9yKJk0EjgEJ
         yiFA==
X-Gm-Message-State: AOJu0Yz/YsZSC7LLK/MF5h7vDJX6iZwIkgAvIxbHCHvlK6/jahOORZeo
	J/JsBd+wwIeNkUcsBen2RwWTuA==
X-Google-Smtp-Source: AGHT+IHBxJXb1rqGHg72tFZCFiqFuuDilEyQFgLjY5r752uXTzHmJwAoAMVMC3kaNkoyzjRA5AwfNg==
X-Received: by 2002:a05:6e02:170f:b0:35d:7058:5ef0 with SMTP id u15-20020a056e02170f00b0035d70585ef0mr19949750ill.51.1702847537035;
        Sun, 17 Dec 2023 13:12:17 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id ja13-20020a170902efcd00b001d3a9676973sm1558361plb.111.2023.12.17.13.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Dec 2023 13:12:16 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rEyQm-009hFy-1n;
	Mon, 18 Dec 2023 08:12:12 +1100
Date: Mon, 18 Dec 2023 08:12:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: remove struct xfs_attr_shortform
Message-ID: <ZX9kLBb6vYGsQMhy@dread.disaster.area>
References: <20231217170350.605812-1-hch@lst.de>
 <20231217170350.605812-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231217170350.605812-8-hch@lst.de>

On Sun, Dec 17, 2023 at 06:03:49PM +0100, Christoph Hellwig wrote:
> sparse complains about struct xfs_attr_shortform because it embedds a

embeds

> structure with a variable sized array in a variable sized array.
> 
> Given that xfs_attr_shortform is not a very useful struture, and the dir2
> equivalent has been removed a long time ago, remove it as well and
> instead provide a xfs_attr_sf_firstentry helper that returns the first
> xfs_attr_sf_entry behind a xfs_attr_sf_hdr.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

....

> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index f9015f88eca706..650fedce40449e 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -580,18 +580,17 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
>  /*
>   * Entries are packed toward the top as tight as possible.
>   */
> -struct xfs_attr_shortform {
> -	struct xfs_attr_sf_hdr {	/* constant-structure header block */
> -		__be16	totsize;	/* total bytes in shortform list */
> -		__u8	count;	/* count of active entries */
> -		__u8	padding;
> -	} hdr;
> -	struct xfs_attr_sf_entry {
> -		uint8_t namelen;	/* actual length of name (no NULL) */
> -		uint8_t valuelen;	/* actual length of value (no NULL) */
> -		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
> -		uint8_t nameval[];	/* name & value bytes concatenated */
> -	} list[];			/* variable sized array */
> +struct xfs_attr_sf_hdr {	/* constant-structure header block */
> +	__be16	totsize;	/* total bytes in shortform list */
> +	__u8	count;	/* count of active entries */
> +	__u8	padding;
> +};
> +
> +struct xfs_attr_sf_entry {
> +	__u8	namelen;	/* actual length of name (no NULL) */
> +	__u8	valuelen;	/* actual length of value (no NULL) */
> +	__u8	flags;		/* flags bits (see xfs_attr_leaf.h) */

May as well correct the comment while you are touching this
structure; xfs_attr_leaf.h has not existed for a long time. Perhaps
just "/* XFS_ATTR_* flags */" as they are defined a little further
down this same file...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
