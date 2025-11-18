Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3452F12D6
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 09:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763456723; cv=none; b=tpw1LRWo8kuihUnX4z7Fnl8IxagoXI71DCDikDy7YuKDSvqgvlcvtQmQ7JptUYM0wenOxM/sHKaBx62hCYTD1413ZCep9XY3wJZoAx8DoJ/a48Vk22tUjwDX1bapHIwnLOifkxSRQqMgfF0M8xGsFuqSU5WGpqXJdqhuCsKOs20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763456723; c=relaxed/simple;
	bh=DIw7f87+JauwrWEZ6CY9x6iovnqLew646AE1IiwLgs0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=LGGyguOS7LsIMA+iBL1Q8pEjYWFQcmp4Fx9WizXWGl1YzWiBjNicp1qEJwTmASH4Z2MFCV0dSvSNqLQZxsPcx6fKTvrKSHuXDimGIy5xGy3zEbkl60yfSvFgTCfemIWTHT/8LFuPc7/j3nRP1RscoYahyAoxHFMVK/gaJFPQ5rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id E88C7180F2C0;
	Tue, 18 Nov 2025 10:05:05 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id ofqlLsE2HGllBTkAKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 18 Nov 2025 10:05:05 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 18 Nov 2025 10:05:05 +0100
From: lukas@herbolt.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
In-Reply-To: <aRdco1GtU5BK2z6C@infradead.org>
References: <aRWB3ZCiCBQ8TcGR@infradead.org>
 <20251114085524.1468486-3-lukas@herbolt.com>
 <20251114164436.GE196370@frogsfrogsfrogs> <aRdco1GtU5BK2z6C@infradead.org>
Message-ID: <1fff1ff15d93adb5d2d7c45c3e160e76@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2025-11-14 17:45, Christoph Hellwig wrote:
> On Fri, Nov 14, 2025 at 08:44:36AM -0800, Darrick J. Wong wrote:
>> I think hch was asking for this indentation:
>> 
>> 		if (xfs_is_always_cow_inode(ip) ||
>> 		    !bdev_write_zeroes_unmap_sectors(
>> 				xfs_inode_buftarg(ip)->bt_bdev))
>> 			return -EOPNOTSUPP;
> 
> That would have been my first preference.  But the current version is
> readable enough, so I'm fine.


I see it now, sorry! Obviously roundcube, despite of being set to plain 
text,
mangled the white spaces. Let me correct it!
