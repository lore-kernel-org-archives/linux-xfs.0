Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2813876B9
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 11:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778240893; cv=none; b=UVOAuWlbfQrANkuOJYKvrA3uXEYM9y//KZGbXQVOCyf7HsHVSMQJQtapyiGyaT3bSy68s/ANZGLV+e7zW6fl5bfExNpXvqP0EO7xG4ig/cGjfCnWsOXy7DYHODZjxyaUM9PhKl2f546o5IbRTieYSACxSRHoJkO4JNIChML6Q44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778240893; c=relaxed/simple;
	bh=nziNqBrsm2FeR1iC9Af05i2L3D0e2L4MvhONWf0OuKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pfuVrVXxA5r40YFe5y3RNldJzjCVilUMaUta5URTqfKuBS1jVVTiScfu7DQVHASq0HdwC9vxVZELwOU4Jf5dVpI88zRXLBhH9N0wV/CoERaFoqHAzmlCcWxtgpTf5Ag+B3ebHcxTfMvsZh3SIFLkyHi3PfXIG45xaAcZZ00jzs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FK1BbhDb; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FK1BbhDb"
Message-ID: <334a4d92-887d-4572-b153-25906148601e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778240889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wwbh1yNCb3Q2GmZSGcO8l454Q6r2eJjWWBpUU8tFR64=;
	b=FK1BbhDbd3L7gqcru5ZHK2BpskTeEZpGi+7hbZeGqW7WI3pGARkeWKCeUpABbhlSNocUg3
	NjAXQn2vH42cJMifQ9/sVMSHkH2LswvXzc1j1DWHXqAbgaRApMHzMwbKXU4OWiA7oOndXy
	txHMwQJbS7JrftjgP0vWMV7BGvHiWdk=
Date: Fri, 8 May 2026 13:47:58 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Increase in XFS journal flushes with (direct_write;fdatasync)+
To: Jeff Layton <jlayton@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Andres Freund <andres@anarazel.de>, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, Christian Brauner <brauner@kernel.org>,
 gost.dev@samsung.com, p.raghav@samsung.com
References: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r>
 <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6>
 <20260508081047.GA19748@lst.de>
 <610346dc-ba8d-471f-be38-2429c5646416@linux.dev>
 <20260508084346.GA19951@lst.de>
 <08a84b78e83a61b7dd661df32ac31d87b98ccc9c.camel@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <08a84b78e83a61b7dd661df32ac31d87b98ccc9c.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


>> The comment needs to explain the why and not the how.   AFAICS the
>> why is that lazytime is not propagated to the disk at this mount,
>> so incrementing i_version should not happen, but I'm adding Jeff
>> for insights.
>>
>>
> 
> That looks correct to me. I think the logic here is:
> 
> If we're going to disk anyway, then we might as well force an i_version
> update. In the case where we're not (dirty == I_DIRTY_TIME), then we
> only want to do an i_version update if someone has queried it. If an
> i_version update does occur, then we need to go to disk by setting
> I_DIRTY_SYNC.

Does this reflect the why:

diff --git a/fs/inode.c b/fs/inode.c
index 6a3cbc7dcd28..62c579a0cf7d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2124,7 +2124,13 @@ static int inode_update_cmtime(struct inode *inode, unsigned int flags)
                            inode_iversion_need_inc(inode))
                                return -EAGAIN;
                } else {
-                       if (inode_maybe_inc_iversion(inode, !!dirty))
+                       /*
+                        * Don't force iversion increment for pure lazytime
+                        * updates (I_DIRTY_TIME only), let I_VERSION_QUERIED
+                        * dictate whether the increment is needed.
+                        */
+                       if (inode_maybe_inc_iversion(inode,
+                                                    dirty != I_DIRTY_TIME))
                                dirty |= I_DIRTY_SYNC;
                }
        }


--
Pankaj
