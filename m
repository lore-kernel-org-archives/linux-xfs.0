Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA7B50264
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 06:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715063629; cv=none; b=SmidSbNppjxZmcMEA1Pkf8S6muvui3RHEF4rHBhJps7lxhZYBsLoOK9FaS4qyT1HHTNTdll/i6178Aa3YDuni/l4nKjl3DW+pqW4NL7W4DKNOZTnNIWdyEiFLaf+yy/LUzrJpvuywzXBp2KXI3qb6a8Rkgv5Xk+EgZRqyb/GYD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715063629; c=relaxed/simple;
	bh=2tSt1cPD/UO58Gs2DE4g6wcOYjTWKRl2MUhi4dKWd7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hdghBGTJNp5Sk/eCZaepbfMJKibblBFtcWH3BqaJmQsIiHevpZNzYhpfgLaMl4emremg5KuqaQrQZs64eZXGfzCYP745l3Cm+LHg1q81VPE0FjJfGLZmRvQxLqbeAvPE6veh98pck50CknYIypcrSI0fSeNCCOXy0FFs8qcI/C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OjgkM5tp; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OjgkM5tp"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-41ecffed96cso14835115e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 May 2024 23:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715063626; x=1715668426; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZceNyQkkA5SipGRuhtz98PdxDwJKZgpzV7BnccqbLw=;
        b=OjgkM5tp8Sb98BxeStvjA1jNxQD8OT7lnEL7jIZqyM2qZUV1DG+ibeEXdtMAp2V3oc
         5ovF3MUk0MGVVTzOmNdM1xHD+L61pYLZL3S3RGcxENUpsVM+EjuiGK9YL2q2bKezi9mZ
         zvWrvmRGezMINa90ihWKC1rSjU7eYXo1CxZ0uhLlOd+eI6IHvOX3wfMKNved9nxnOe6u
         RjqTwmislUTKSCKyuFQK9AkOCWTa3UrjK8qFxipMu6qiD8drijjOJleCYboD5EsSN9Nt
         B+En6Y+hPIbHLXsMOZu8tfOK3wc9/Gt5Hq64fwc9HCrmZ6Y5FKGi/jHisV9uD2E7lbTE
         UGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715063626; x=1715668426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZceNyQkkA5SipGRuhtz98PdxDwJKZgpzV7BnccqbLw=;
        b=P+1jS8+fDK1bLRKTgfcSUZxo6Mzo/ThAR8WB8ypf9PWE6xL3FjkLyx4L6Xj8ilZ7K0
         3GZ53pbHvR3jL5WhZQdvWbQXsd2Id2vwEMyI73GpUMrgjpzqS76dtUosuSTTaDUD2ADI
         R64XV4MZUteag5LaSjCPfFbpT2sJILSSAzogD7fIO9T4cpnmV9UOv/WzbJGe1LXX9rtv
         8SISx0v4vUW9ki9rCAmnX9ytudk6E9jhAuQrq4m3AFc2FMIrcU1ZPPXVL6wjwaeW7/Pi
         Vnv4/cYMUOT6CosDDTkQVO3EaRESyG/hIuG8Whfuo6/lw0kE5oFWqxccp5i8ZtJiYJ2Z
         KfRg==
X-Forwarded-Encrypted: i=1; AJvYcCUJ840oIkThknOzY3X5T6ywpFfNGCql05AMTOOmqzK22GPte3ACC3oy72IJ7IBH2cN78IES2qlou0Xq/GHZf/83agUMskyYoX8h
X-Gm-Message-State: AOJu0YygrQzw34Hu/IRbMDzz+taEcXbQYX4lQMTTLkH65UlSo7FGZ716
	k0qahJ5oflBLcZT/23bvnVAWfM3olhzJEgB/vUVkm9IVDe1VWgEl6YM6NUjtsHk=
X-Google-Smtp-Source: AGHT+IG5xGMmKq41996Zvafki2sGa8A1qFQDqQcWnfzKnmpjsvJvBGxoRMoI0HOYlwRX3IOjzEI0Mw==
X-Received: by 2002:a05:600c:19d2:b0:419:f241:632f with SMTP id u18-20020a05600c19d200b00419f241632fmr9996714wmq.31.1715063625822;
        Mon, 06 May 2024 23:33:45 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id z18-20020adff752000000b0034e19861891sm12163393wrp.33.2024.05.06.23.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 23:33:45 -0700 (PDT)
Date: Tue, 7 May 2024 09:33:40 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: check for negatives in xfs_exchange_range_checks()
Message-ID: <d953392c-44d1-4c9f-a671-b25803181b97@moroto.mountain>
References: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
 <ZjnE2SjU7lGD0x5A@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjnE2SjU7lGD0x5A@infradead.org>

On Mon, May 06, 2024 at 11:06:17PM -0700, Christoph Hellwig wrote:
> On Sat, May 04, 2024 at 02:27:36PM +0300, Dan Carpenter wrote:
> > The fxr->file1_offset and fxr->file2_offset variables come from the user
> > in xfs_ioc_exchange_range().  They are size loff_t which is an s64.
> > Check the they aren't negative.
> > 
> > Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
> 
> In this commit file1_offset and file2_offset are u64.  They used to
> be u64 in the initial submission, but we changed that as part of the
> review process.

I've just checked again, and I think it was loff_t in that commit.
There are two related structs, the one that's userspace API and the
one that's internal.  The userspace API is u64 but internally it's
loff_t.

fs/xfs/libxfs/xfs_fs.h
   818  struct xfs_exchange_range {
   819          __s32           file1_fd;
   820          __u32           pad;            /* must be zeroes */
   821          __u64           file1_offset;   /* file1 offset, bytes */
   822          __u64           file2_offset;   /* file2 offset, bytes */
   823          __u64           length;         /* bytes to exchange */
   824  
   825          __u64           flags;          /* see XFS_EXCHANGE_RANGE_* below */
   826  };

fs/xfs/xfs_exchrange.h
    16  struct xfs_exchrange {
    17          struct file             *file1;
    18          struct file             *file2;
    19  
    20          loff_t                  file1_offset;
    21          loff_t                  file2_offset;
    22          u64                     length;
    23  
    24          u64                     flags;  /* XFS_EXCHANGE_RANGE flags */
    25  };

regards,
dan carpenter

