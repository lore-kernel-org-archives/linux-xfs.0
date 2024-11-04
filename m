Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E711B0F2B
	for <linux-xfs@vger.kernel.org>; Mon,  4 Nov 2024 12:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730722925; cv=none; b=kAPS+SUVtkoQJjTa6sa1pcwGnw9NKVG6/eW+53u+RqinuaV4mvD5oHQGA21Rx+dnLSKZ9MEsFrx6Pc5HRjxUFApEGnAzbFDD2sauuQca0Kd2tE1hHdnkxwvsPIkNBIBELMQD1SEZDBdlxsxaWXFjUv5qAWwmO+GVBmNaMWMJpoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730722925; c=relaxed/simple;
	bh=I1ndr0aWA7myGho8sWTP+cYroslurz7V+mkmqrNkB/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlu1d0kVgdCh+TobP1aik+rkrma5VRkE7g2apUF4D9N2tV5uLDwMQEdGeDyB/GANxha+DA1+s2xMHkShEAlXfT29njOzwF1PuMPNHTiiG8WBrtItvFqvccWUl23SMjoDsmepu9zcopzTFaRKqWWLSdeY/urVE8nSGMV3NJxCwrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nsv4zbg5; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nsv4zbg5"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3e6048bc23cso2257787b6e.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2024 04:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730722922; x=1731327722; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/sZu1hahYDVwARP6c7VfSbT+R7Hv7ndqTcVFryowN4w=;
        b=nsv4zbg5DqEWFtWFksWA5LIv29X1XWFlec7PyBLdv4DJGoObLZvT7rUiVJqrk3ifGP
         Oty1F2MZqFgrl+Qt3jaiQfrsyt7RaucFxKCL3iTd5+uOanHyDa2J27jo7PDET3do6vlV
         MzXT3lX0l5m9dkWdXWrexSYO2AiDzQAzWYsm5oLGiOHeivfUEjOTegyqvQ1P+CBJRgu1
         Z5/NXlQStcF6YTro8UzHVc2rxgk2yu98UvdzXIjspbPKN3fRhPZyOH/KEm5gAqtuNstH
         T9ekl0OlOKSpFYWdeJ5DD7sJqUTs98PLBSjmwydX4rHdQA6Q5tRbK7jSyOa7itb0CD80
         WNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730722922; x=1731327722;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/sZu1hahYDVwARP6c7VfSbT+R7Hv7ndqTcVFryowN4w=;
        b=TbGml3SC6vcYG+T7+qGwBCkVkOwoHcErPd0y3fqETDN3HJ1lrBhnN1cMm7g2Yi9P63
         2vKultjdlzNr/ZePz9Br9zBpH9uEgqtRovwDwK+CrbLoBPXsT3i4NglT6ks0gaWF/uo6
         h0sOim5Y77ds01ytOE54WkNbbH6JWg/ST9gaJTESrhm6qWTIBIsRH7A6JKJORq1OEvpq
         drt1Fpvoubtl0/4RZxWF0pHjH1NubwHjBTeSbpS1jZIAK9AWiTll4YjbtQLBQqDcfelR
         CNoTYtnXsKqpofs5LLcYW2PS1zFpCK33kKYnT7pCy1hGcW6VjPaU0ZR04wJ4UPVKL8Pe
         pu3Q==
X-Forwarded-Encrypted: i=1; AJvYcCW+WbfHgllJ33o9Jbh1MeG01p/AjHYMLu6Q/qp1ZBLEn/alzdgMytYgEvX+xXcv9Wf0AD5OBpqc8WY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh+uPeUZjrT4n+6jyFZisg4ZDm5AgxdZ4jAYCpcGaHmTyIq+2P
	XFovetyhty8uv+Uj+XeaBHbAVDXA8U/U64Rh3LOPF0cEJ7QSgf9fdoUsnQzn7Wk=
X-Google-Smtp-Source: AGHT+IHmBO35x++W6+rQSfmrJpm5WkO7NNilpxfIHFw5XDrx+96pTQ0tI5dpbL/LGhdQU+y+ppWc3Q==
X-Received: by 2002:a05:6808:3c44:b0:3e6:61f0:4797 with SMTP id 5614622812f47-3e661f049ccmr10206679b6e.40.1730722922622;
        Mon, 04 Nov 2024 04:22:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ee459f9288sm6831460a12.65.2024.11.04.04.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 04:22:02 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t7w5n-00A2Wg-1W;
	Mon, 04 Nov 2024 23:21:59 +1100
Date: Mon, 4 Nov 2024 23:21:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: zhangshida <starzhangzsd@gmail.com>
Cc: dchinner@redhat.com, djwong@kernel.org, leo.lilong@huawei.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	osandov@fb.com, wozizhi@huawei.com, xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com, zhangshida@kylinos.cn
Subject: Re: frag.sh
Message-ID: <Zyi8Z7upAZf1sbMN@dread.disaster.area>
References: <20241104014046.3783425-1-zhangshida@kylinos.cn>
 <20241104065214.3831364-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104065214.3831364-1-zhangshida@kylinos.cn>

On Mon, Nov 04, 2024 at 02:52:14PM +0800, zhangshida wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> #usage: ./frag.sh $dev $dir $size_k $filename 
> #!/bin/bash
.....
> # Create a big file with allocated space
> xfs_io -f -c "falloc 0 $((TOTAL_SIZE))k" $FILE
> 
> # Calculate total number of punches needed
> NUM_PUNCHES=$(( TOTAL_SIZE / (CHUNK_SIZE * 2) ))
> 
> last_percentage=-1
> # Punch holes alternately to create fragmentation
> for ((i=0; i<NUM_PUNCHES; i++)); do
>     OFFSET=$(( i * CHUNK_SIZE * 2 * 1024 ))
>     xfs_io -c "fpunch $OFFSET ${CHUNK_SIZE}k" $FILE
>     
>     # Calculate current percentage and print if changed
>     PERCENTAGE=$(( (i + 1) * 100 / NUM_PUNCHES ))
>     if [ "$PERCENTAGE" -ne "$last_percentage" ]; then
>         #echo "Processing...${PERCENTAGE}%"
>         last_percentage=$PERCENTAGE
>     fi
> done

Yup, that re-invents fstests::src/punch-alternating.c pretty much
exactly.

The fact that there is a production workload that is generating this
exact operational pattern and running it to ENOSPC repeatedly is
horrifying....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
