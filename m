Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C901DFEC
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 21:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ek2NRXiq"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3ba52d0f9feso35788b6e.0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 13:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1703106169; x=1703710969; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B9WdUJ8DHVL5p/mAN9B6mtU5aFHmW+LUmwUgowVPr90=;
        b=ek2NRXiq39AoiBhr1PZ5dqUf6XOCZ9HgwNGhxlGnRC6TAqYXgxi3lZDjf4U12n6fEc
         9a/jJgqhymIaUUcNypvGkAWUBFgBB1PoBVIXNMpp0onFBBwzKKHiMsiiBwM4sLfhTxcN
         JCaHEVeGqvAtFUMpz6UAcTdd42vYx5ic4Ln0X/Sd8DS9o+odt8nsKFQfkjKBpftDePie
         XYVtHcBca5VRD7DuQnUiJ1hi47cm/jMCCId8UASrO1jj2jj9dO6FZRdAenIYisXzCHXi
         wu3cHMnUTxlccB3ulb/ePzx68Jc7s3s5z/5qimjgD6jDrbYZmxWgz7Jhfid4NhgiuWY0
         sr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703106169; x=1703710969;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B9WdUJ8DHVL5p/mAN9B6mtU5aFHmW+LUmwUgowVPr90=;
        b=eSRukKVaUlQs4IUo/QjRSkOcgXcYsbwG1IVelZyvS3iSdVawwBUNIi1y4suVn4S1uw
         j+dCNoiafitbpDvbs3jm2FSPVtJN0wuUZ+ce9OjLJ4vBM0j7XeJ40+MV0gqJ3r5dJtDL
         2dm+koizRi1OoTO6ZCII3Jy4O9vgYUhfZFktcOcUDcgrXlCOHnuf4vlSaqe+t4egLrCZ
         KW5hAVKKpQuM0bxSzis+HrD53z0TXsU4r1xJJtSGYoiyj0GObeikECYY6v2XgITDwN7C
         uzO4ZcTfkKE8o4NM9AKmkkBCI8POL4I1QHHFD3OzsndkCUzuDCoeDD+SI67cg2T4jiTi
         Qcug==
X-Gm-Message-State: AOJu0Yxh62Jxfb3u841R2Isrvj7KL9qKOY90KnAZtJO5JAyznIXgrVsW
	90jpr+NQvfG/0Va6tppYuKzTjg==
X-Google-Smtp-Source: AGHT+IGTgc1Ck/2wwSSzHyViPkLjLJ9TWaCkKWbw8jlh+IwiR54sUXlxU3nCmq2XxjW1Z0gqQTnYYw==
X-Received: by 2002:a05:6358:7247:b0:173:219:bf90 with SMTP id i7-20020a056358724700b001730219bf90mr336867rwa.47.1703106169404;
        Wed, 20 Dec 2023 13:02:49 -0800 (PST)
Received: from dread.disaster.area (pa49-180-111-17.pa.nsw.optusnet.com.au. [49.180.111.17])
        by smtp.gmail.com with ESMTPSA id 2-20020a630d42000000b005cd64ff9a42sm209521pgn.64.2023.12.20.13.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Dec 2023 13:02:48 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rG3iG-000MNm-28;
	Thu, 21 Dec 2023 08:02:44 +1100
Date: Thu, 21 Dec 2023 08:02:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: attr cleanups v3
Message-ID: <ZYNWdPTrK8dkvf4g@dread.disaster.area>
References: <20231220063503.1005804-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220063503.1005804-1-hch@lst.de>

On Wed, Dec 20, 2023 at 07:34:54AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series started by trying to remove xfs_attr_shortform as sparse
> complains about it due using a variable sized array in struct using in a
> variable sized array.  I ended up cleaning a lot more code around it
> once I started looking into it, including some basic cleanups for the
> inode fork inline data memory management (I'll have another series for
> more work there at a later time).

Series looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
