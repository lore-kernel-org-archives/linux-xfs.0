Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834F543E08B;
	Tue, 21 Jul 2026 22:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673508; cv=none; b=MUguhLAY1VznadJrInScHU/Zuyp76bAVZ6mhta77G0J3U28uYX5BphYRFEZ3ODDIM5pn6WRTDz74DZE6moeTFqf/xGrFM0o2YGVd+0lsuhsYBsrwTBQG2qyoqIvhSIIfIeAVV6K06tI2fInhz0SXywRpORhXbs1ugaIDAe/4wAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673508; c=relaxed/simple;
	bh=nms3C/WQRisy62ZSBYHVTz/QOw5vK+4C8rQ7PSulkjQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=FTthH8kLSjnd2JLtpVZBG0dWIbv6NQCgPXHcqKWK9UenOkTP5dGtIg0udgyc5agD2hQ7iwxtrh/Fvo8f5NgEjyZIKj5FPCK0LRcKoHkToim/k7k2Nevl6E+2CC3XQc0LzK9CGx6IyXSPgdbn4QUpfc9hRGX4Ed7XMaGEPW7Fvng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARtcLoJz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARtcLoJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3901F00A3F;
	Tue, 21 Jul 2026 22:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784673498;
	bh=WDmDZTIDZNcAFuhGz8dTh3etu6wdnO4DjLK0ii8Wyzk=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=ARtcLoJzABGhjsRsl43Z8c5OfbhrPDdPrGHmNzke9lhWPAi769ClK25YbAUsSPM46
	 G68nyYdRIURws4B22ZoP0ftvrwtCLv0Nr0u0ktF07WWJAoZJ19gDfGo3Aq9g6Qkuyp
	 6rm0XRu3Uz0j1XrFVqGmYCXluJ6rc9RoSX8cUZmNLQ4ZdofPeM11yD3BW4I/99lde3
	 U+eANkIjik5L4lDFo6QF9pWBHXqcOETMLerNDP3pqLMN+ZVhekwVlYuHbgfsOTfrM6
	 yUW+a5us7kufuQxLLcrjn2DCFKpHpuoVM0z7HXQE8X4G7ZD8ocT7oFG2whgGepucM9
	 1oIO9UA681Zvg==
Message-ID: <10f50eff-3d65-4e58-af4c-977e786617b8@kernel.org>
Date: Wed, 22 Jul 2026 06:38:15 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Suveer Jain <asj@kernel.org>
Subject: Re: [PATCH v7 01/11] fstests: add _loop_image_create_clone() helper
To: "Darrick J. Wong" <djwong@kernel.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, hch@infradead.org
References: <cover.1781694879.git.asj@kernel.org>
 <421c7cdd5aae27b99d04dddf08c5d9df79c2f790.1781694879.git.asj@kernel.org>
 <20260701170713.GE6517@frogsfrogsfrogs>
Content-Language: en-US
In-Reply-To: <20260701170713.GE6517@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


>> +		_mkfs_dev "-s size=4096" ${loop_devs[0]}
> 
> Not sure why you pass two separate cli arguments as a quoted string, but
> my guess is it "doesn't matter" because _try_mkfs_dev uses $* unquoted,
> which separates them again.
> 
> I HATE BASH.
>> +		;;
>> +	btrfs)
>> +		_mkfs_dev ${loop_devs[0]}
> 
> And while I'm whining:    ^^^^^^^^^^^^^^^ actually should be quoted.
> Not that fstests is at all good at getting this right.
> 

Damn! Fixed the two issues above.

>> +		;;
>> +	*)
>> +		_mkfs_dev ${loop_devs[0]}
>> +		;;
>> +	esac
>> +
>> +	# Only execute if the function argument is not empty
>> +	if [ -n "$pre_clone_tune_func" ]; then
>> +		$pre_clone_tune_func ${loop_devs[0]}
>> +	fi
>> +
>> +	sync ${loop_devs[0]}
>> +	cp $img_file $img_file_clone
> 
> What if cp doesn't create a reflink copy?  Can we fill up the $TEST_DIR
> despite having checked it for sufficient free space?  Especially on
> filesystems that don't support sparse holes?
> 

We have _require_fs_space a few lines above (yes, I have doubled the
size requirement). If we reach this point, cp is unlikely to fail, but
if it does, it will be messy.

        _require_fs_space $TEST_DIR $((size * 1024 * 2))

Added a call to _fail to be more direct.

        cp $img_file $img_file_clone || _fail "Failed to copy cloned image"



>> +
>> +	loop_devs="$loop_devs $(_create_loop_device $img_file_clone)"
>> +
>> +	_ret=($loop_devs)
> 
> Hmm.  Should this function return nonzero if any part of the clone
> creation fails?  Or are callers expected to notice that _ret only has
> one element?
> 

If we are here, both images have been created successfully; otherwise,
we would have called _fail.

> --D

Thanks for the reviews Darrick.
-Anand

