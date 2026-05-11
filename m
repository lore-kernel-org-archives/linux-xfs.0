Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876CF314B63
	for <linux-xfs@vger.kernel.org>; Mon, 11 May 2026 10:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778495511; cv=none; b=LluLEoBn3cQUBccCHB8dcZSW6G7IP+Phzom6pzmCPLWQL2yclD8+j6cBjmkQPPpe5QxfzLYd7cuzqCh2EjcFr3aJDaCL/GliZMQglTryAZBR7XPKOYiC+vvxs91oMr5TQZWrQNDrs8v/5frpeojOMWCNSNik5sQnptkYZetEQL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778495511; c=relaxed/simple;
	bh=WHJj7z0KzKiWgpxd+oo71/sT+q/6VvMVAAVsO4YSiEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDDaIygfwfhu9pinVReP/W/4m2prY3zOpozDhYzhy3aJcQIj9k5madnNXBA5mWFV4xGOna6PhE5MFTFaXzidyRwPPtfdB8lyEi2UXWAXcnCVi2DXx7T2v2d+Ommb0aEe9G3VFBD4WLGzY1dQH5mB8/0Q3Dus3u5PK64UhU7n2g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j8i97EkC; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j8i97EkC"
Message-ID: <6ace1bbe-be82-427d-8fa4-0eafe6b821d5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778495507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RmyjIjXuhfvqhFKE3os8SS3B/+9CSVVcBpNK05dIB+U=;
	b=j8i97EkCIwAGBPqU7D0g9LsBwVjwA9CxyDxsLGJVp9qWh37Wz2lkdlpi/ODIvGkI5qea6J
	3SkPK+F4LvvHA/Tig9RbHBlztfprJN6kvZdnveVpmeyYbl0X3FKj2NV9GbHtccY1ai2WPS
	9ItSsy/vChSfwLivaJoowTghC2IlUHI=
Date: Mon, 11 May 2026 12:31:28 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Increase in XFS journal flushes with (direct_write;fdatasync)+
To: Christoph Hellwig <hch@lst.de>
Cc: Jeff Layton <jlayton@kernel.org>, Andres Freund <andres@anarazel.de>,
 linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 Christian Brauner <brauner@kernel.org>, gost.dev@samsung.com,
 p.raghav@samsung.com
References: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r>
 <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6>
 <20260508081047.GA19748@lst.de>
 <610346dc-ba8d-471f-be38-2429c5646416@linux.dev>
 <20260508084346.GA19951@lst.de>
 <08a84b78e83a61b7dd661df32ac31d87b98ccc9c.camel@kernel.org>
 <334a4d92-887d-4572-b153-25906148601e@linux.dev>
 <20260511085645.GA1186@lst.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260511085645.GA1186@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 5/11/26 10:56, Christoph Hellwig wrote:
> On Fri, May 08, 2026 at 01:47:58PM +0200, Pankaj Raghav wrote:
>> -                       if (inode_maybe_inc_iversion(inode, !!dirty))
>> +                       /*
>> +                        * Don't force iversion increment for pure lazytime
>> +                        * updates (I_DIRTY_TIME only), let I_VERSION_QUERIED
>> +                        * dictate whether the increment is needed.
>> +                        */
>> +                       if (inode_maybe_inc_iversion(inode,
>> +                                                    dirty != I_DIRTY_TIME))
> 
> Looks good, thanks!

Perfect. I will send a separate patch with the Fixes tag in it.

--
Pankaj
