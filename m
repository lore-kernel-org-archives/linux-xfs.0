Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DECD2D3725
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 09:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770025059; cv=none; b=QSlGkwUJ42eOlJZMWiSBN//DtyP/QM30E/QAxc2ZzP+VW+pFlxi4vM2wdIU4pgPkCFCTB1KsYrfAM9JvEZAlRZyW8HxUKLcQt1oIl9o9wpom8T9RSHdoiuPzePAI1GVH74TytGCxMpZ2Acrqsqb5YtNMT7jsLr6X3ZxDqIXHyOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770025059; c=relaxed/simple;
	bh=n8wesrmpdW5kumktEz28ftshXFKfK/RNJ0iKjwC5WGg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=ehaTZbqrUzsj3CZpBJ/IYH1y2LZMYrWtc1h2tybhzdVJRRmiJk0fOcul87ap+/1xat0kiuDJ8JvdkDFMtiQZdUCLD1U0bsBTdo+Og5d/fK25/o5yJqmJNBasvETaMG1kban6eoL/FypR5sd34trV9PF1JE+8vHXEWDkPXhgMYCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id AADB3180F2D5;
	Mon, 02 Feb 2026 10:37:23 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id AvHYJlNwgGnmaRsAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 02 Feb 2026 10:37:23 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 02 Feb 2026 10:37:23 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 cem@kernel.org
Subject: Re: [PATCH] xfs: Use xarray to track SB UUIDs instead of plain array.
In-Reply-To: <aYBSzg3IhFffphuI@infradead.org>
References: <20260130154206.1368034-2-lukas@herbolt.com>
 <20260130154206.1368034-4-lukas@herbolt.com>
 <20260130165534.GG7712@frogsfrogsfrogs> <aYBSzg3IhFffphuI@infradead.org>
Message-ID: <698e4433ee0b01978deed124792c7e57@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-02-02 08:31, Christoph Hellwig wrote:
> On Fri, Jan 30, 2026 at 08:55:34AM -0800, Darrick J. Wong wrote:
>> > +		xa_erase(&xfs_uuid_table, index);
>> > +	}
>> 
>> Why not store the xarray index in the xfs_mount so you can delete the
>> entry directly without having to walk the entire array?
> 
> Yeah, that makes a lot of sense.
> 
I did not want to touch the xfs_mount but if there is no objection 
against,
I will add the index there.

>> And while I'm on about it ... if you're going to change data 
>> structures,
>> why not use rhashtable or something that can do a direct lookup?
> 
> rhashtables require quite a bit of boilerplate.  Probably not worth
> if for a single lookup in a relatively small colletion once per
> mount.  But yeah, if only we had a data structure that allows
> directly lookups without all that boilerplate..

I do not have strong preference here.

-- 
-lhe
