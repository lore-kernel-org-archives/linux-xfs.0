Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841882BB0D
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 21:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711835733; cv=none; b=L8xJvInlQILr/gqdCV1VHwNlTri3UZdWj/zZyioHuHjZUBLwCvwRju6g/fV4P5k67bUp1sSWYw1GjfmKKA04ZrcUBEtj2I+JU+8zKlBEZU4fx6U1ivcnDTYGIxD9nVlhrSmuyJXrNKf8CbGkWz/Sy7t8wUWovD5W8NvU23hU+K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711835733; c=relaxed/simple;
	bh=5r8sJIemE+Mnyg094XVD5O7pwCTv5Q23LHfDbCia6EM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEhnsM/sU6Qe6+ycBWxC0XScp/MmaJ7Z2b5T3W4VttDGHo075nU0bIyxpEaQlLUyrhk6QyV6+j3FhwcogWNm4jhzpI+GcWi1RS7iezn4/wUAQpjtFxvXeJhQw1lXnR1uETlpFQwjOpFP05rIcwYDJx7yFDDii4+0udh53u9XrIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zk0L+KZX; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zk0L+KZX"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5a4859178f1so1998297eaf.0
        for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 14:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711835730; x=1712440530; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S6bohNj+20oa0cG/tmn7xBM9CPkQbGLyqS8I6V8mkRA=;
        b=zk0L+KZXXz+vNS7pOxO5QwmE6k9BX5ZrVkvDkvCHUpSDwrBHQAxoRujowe2OHZS2ph
         OnQgqcK6ugg79+nLVP4A7SlL474zgV4VWFxb4Kjek5YzSgUlv1uoDcBlvR92gB8viWZn
         O0arQIRo/jO2271cEe+5WWdOxTU+8LUY90N7JTJ+jxpo1n0aiffJF73JZDVLZrPXs5se
         qTFyticNWX0wEC4IOgq2noYbdgtqkvhlPOrkoP7iVD2INMU08yImV2K+zXpDvtqyPidw
         YRfYNwESMiett/56njOs5gABLcRHvHqUn96DBIxfyn+o7i+ghVcIV58dkxqz9F2U60z/
         3gIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711835730; x=1712440530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6bohNj+20oa0cG/tmn7xBM9CPkQbGLyqS8I6V8mkRA=;
        b=Ad+QiSZ0sZukTZtxgazRWfxZBunaNucdwjkF+c9KPnSh3c6lY4/PJPsqe1zrUNuWDw
         ougu9tCsGZoUkV1ivPREjjD7wGkbIJUe1BTN1Ws+RhoE05l2lnzG5m8oEMExVO4uXtDE
         u+VjVetzVgAMhLzc2e3PcbMcF59xiK7/UJzbXU/R1IopnnsA/DHkg6NKq/Uz8fRE9vXo
         Ruw52hBr2LugPATbu2CHMNevUN1yyFCsiiBJBZBiIBqTRe0WMZisgfKvmV0gnvWQ/OeO
         Rbekb1AWgbON9DCea/hDdSiP2yozq9C2DPvxGfoRhlgNgv3PQEGNL0/LKzfCy2eL998q
         SSVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1Wy+u2hfZN/5alVkriwjzMId5aVsKB9qo/jqxpKzxQbfoTl5P558c/igqtvShXWKM4P/m0xcIZ7KjGdP0VmWViwDos62AEqRe
X-Gm-Message-State: AOJu0Yx3n2wV/DKNl42fvWkJ395wj0IC9mvYcO5V1JQr09ldntOpdDpE
	4ibkjyd9vUMi6jcaVQtX+bp6FYeH6oz1hGtQMZZ+yzXR9wAeCfvL5yG94Y9ZLEhNtj9vlFJkHAB
	a
X-Google-Smtp-Source: AGHT+IHKJ+R3D/vfTxcY4uJzkoMoYamRjqGt3dtyUU6YQW0u1XLX5UxY7s9fk0l1v3HwUzOGBSwy5Q==
X-Received: by 2002:a05:6359:4c15:b0:183:a0ac:b638 with SMTP id kj21-20020a0563594c1500b00183a0acb638mr2222557rwc.11.1711835729664;
        Sat, 30 Mar 2024 14:55:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id i18-20020a63cd12000000b005e438ea2a5asm5010137pgg.53.2024.03.30.14.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Mar 2024 14:55:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rqgfe-00FtCB-2F;
	Sun, 31 Mar 2024 08:55:26 +1100
Date: Sun, 31 Mar 2024 08:55:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: free RT extents after updating the bmap btree
Message-ID: <ZgiKTmYU8349lK7l@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-4-hch@lst.de>
 <ZgTuWIIMrtupCRav@dread.disaster.area>
 <20240329041426.GA18850@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329041426.GA18850@lst.de>

On Fri, Mar 29, 2024 at 05:14:26AM +0100, Christoph Hellwig wrote:
> FYI, I've picked up your comments with minor edits for the commit
> message, let me know if that is ok with you:
> 
> http://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=445d786ae6e50f6631118e0fa378ad0cd72076a9

Yes, that's fine. It certainly can't hurt having some of the
historic context of the code in new commits as it avoids the need
for archive spelunking to make sense of the change...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
