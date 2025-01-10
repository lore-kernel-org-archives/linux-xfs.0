Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C4742A99
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 07:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736492605; cv=none; b=Qm9ZvFq0nGJiAClaFqRL2s8ZGthgBLP22iyNf/qey4Wb7SesI/LIYISt15xVjsTbHbWSz7PQPF8KU7ICX/LfxQjy08u+RaqdpOFpgnJTNyMq4EZvqImHUJ5aSmOGftnfFpuUcabQ2XDFfLzz6RZR4sGudT/5h0dR0FLZtRx+pkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736492605; c=relaxed/simple;
	bh=hex4ypC+FCSmA485hMGRw5iNZ5bEmYWHTofKlHEg48U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UTWMD7vN5xGxVkd50TNX5syQhhx5ZG+EeTJaaxgX4amRZ11WcNzQMzintndqKXV2oMbjbEOx8t84CVvPghtcBenyXwZz4vBChzX7O7UH0ILjPcWpZ2QmF1gbQ77tYsr2wTsxf2TeNPQdeKFJSMRB87L85LGqN5QtSiwR+2I7CeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h/AKfgAf; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h/AKfgAf"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4363ae65100so18399385e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2025 23:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736492602; x=1737097402; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ezAZOm6OL5eyRXSOvAxwbCcLDKZt3ZjZwEpt2r1jdg=;
        b=h/AKfgAfNT4Qwic0M8m3hJyd4Q4EAiAvTUi+FdF1Vt4a39c+4bcz0VCxbFG1vaTw5R
         DYiVGVxytXTnAFgj2EhbU5kKi5IqZI9UzTyTbxLK1XpqFXA6dVRKuCEwd0UcDcq9nKfV
         ZOZF3BtgQ3GQArckoPHuDTYWZjjcZQ5QYpSsOpC3SXUQUiTqm1+RjDt61YAQyGrtAVGx
         21hpWldTkaKFz+3Jx6WXIXFNbc0Yq6Ie7d/wKqwB9lt+1I3ncxpSbCVeNhldS7NeYRdI
         BmKNH4RJbLw7vwzoJCCgUeWq1MQigysafj4tvVnO0nokxXFHjBREVS0qAL6/HGn/h7tc
         igSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736492602; x=1737097402;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ezAZOm6OL5eyRXSOvAxwbCcLDKZt3ZjZwEpt2r1jdg=;
        b=TNi/OLblT0CnW4PvkgFEQpJZqVNJ8F7vbFoFe/wiT1rStaFVHzVI5NytsOE+jKP+qY
         z7Md2tvqu5ffyf0YB9j3fm+MYgmD0humqG8pe9u1P1GXUlpOXOQmEytNGPKcFSnxmAmR
         o8CjIH4CubS+f336NU/EtlBdoAszbGqu7HV4rVtphtyaUqacKXlzt5UTJfI0/+h/S1/Z
         Yxj9lZFsyqaWO2qRNXTVAXVL/sTIXgLpKa8ucmMKeehdWQj4thioR/cOI8DIRokvMQiN
         ylNw0RlA9FZLq90OR54Vxjbva9WWXoIyfwMYTBOxRWT10dY/4OZgwzPzqDQCMyklxv3H
         Lb8Q==
X-Gm-Message-State: AOJu0YzD8R0sQ/Nlfbnin5eQuCUe++JtkRTxGmUKQ9RBts2nMRQ+4qyW
	SSyFr1kr9xPKxzu3CI5ZzqHHVSYE3BDosusfY5rYubntE7yxgEvbtlRPKFZdumoiQdKv/tZcE0e
	M
X-Gm-Gg: ASbGnct01Hx+bqBQuaJmyVemOb/IWjUGyvi2v3JfZ/Yw+5ZzKsH/cBAgC9wjvxyHYAq
	pRznyZqEPfUenlePn6k55lYFaYL2HlcGgG7D1dCaxUrdmw2u++UiyObLNBpOMtZ1NVRO78EymDe
	T7yO7r2V6+/fo4xfHcNX99Qnd0w1znpsp5XH9Js1ZgaeQb9HVFg60KvlADJaUsc4s5aFQO3XFJ8
	r0OO+klFcITAASDp6FfvLKcGfFc+6BDU4maxM/C58jQ/zdv2lemjdKMXA1uMw==
X-Google-Smtp-Source: AGHT+IESBq7XFvUAiSKRqLDostoE+xKTgRfCWQcYE1V7GVdsaELASYry9IfRtaMDRUsq3LWYVH+tuw==
X-Received: by 2002:a05:600c:450d:b0:434:a734:d279 with SMTP id 5b1f17b1804b1-436e26a8927mr102896525e9.16.1736492601966;
        Thu, 09 Jan 2025 23:03:21 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e383965sm3768938f8f.31.2025.01.09.23.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 23:03:21 -0800 (PST)
Date: Fri, 10 Jan 2025 10:03:18 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-xfs@vger.kernel.org
Subject: [bug report] fs/dax: create a common implementation to break DAX
 layouts
Message-ID: <accc103b-01c9-49a5-b840-43f55c91b1bb@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Alistair Popple,

Commit 738ec092051b ("fs/dax: create a common implementation to break
DAX layouts") from Jan 7, 2025 (linux-next), leads to the following
Smatch static checker warning:

	fs/xfs/xfs_inode.c:3034 xfs_break_layouts()
	error: uninitialized symbol 'error'.

fs/xfs/xfs_inode.c
    3009 int
    3010 xfs_break_layouts(
    3011         struct inode                *inode,
    3012         uint                        *iolock,
    3013         enum layout_break_reason reason)
    3014 {
    3015         bool                        retry;
    3016         int                        error;
    3017 
    3018         xfs_assert_ilocked(XFS_I(inode), XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL);
    3019 
    3020         do {
    3021                 retry = false;
    3022                 switch (reason) {
    3023                 case BREAK_UNMAP:
    3024                         if (xfs_break_dax_layouts(inode))
    3025                                 break;

What about if we hit this break on the first iteration?

    3026                         fallthrough;
    3027                 case BREAK_WRITE:
    3028                         error = xfs_break_leased_layouts(inode, iolock, &retry);
    3029                         break;
    3030                 default:
    3031                         WARN_ON_ONCE(1);
    3032                         error = -EINVAL;
    3033                 }
--> 3034         } while (error == 0 && retry);
    3035 
    3036         return error;
    3037 }

regards,
dan carpenter
