Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5917DA6D
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 05:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750223488; cv=none; b=HI9B6OTdl8BHdmMbE/wWBECYZSvjDj03S2Hu6L71+vp9gOGAxZtzQiso4jgNGyuExHU4i2MrbVMbuYOvpLdg5vLG5eEX9h1qNpBaldkNO2V4uy7Yg6Q2Fm3+K8eoLevrmDeM5CXJjXxArmkbOGDbxb5Fp6dN+5m2adSk1pJeP4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750223488; c=relaxed/simple;
	bh=pR5i0DvL5MhUQu4qLU8wyLUyknJWP86G5oQNWznuygA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajWBmLXofVHQnYvQXUxCET6TkFtvO+vzs9pf+UazJ3mwxr3iu4gD431fy0XtOO2QcBgUiSuZXq/y1K3GO3i5pFUtJH6S6aCGE9P93lN5Z/jFoPGvfJrPR68cWUll5EsHEqXlH3lmjWr3vg6U7RZllXNehUN6xMGg4O7LdXXMmCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6942068D15; Wed, 18 Jun 2025 07:11:23 +0200 (CEST)
Date: Wed, 18 Jun 2025 07:11:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <20250618051122.GE28260@lst.de>
References: <20250617105238.3393499-1-hch@lst.de> <20250617105238.3393499-8-hch@lst.de> <ca7663ee-f6a7-412a-96b6-605e9e0e967d@oracle.com> <fde4bac6-c8ec-4e6c-881e-abf7bde406ff@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fde4bac6-c8ec-4e6c-881e-abf7bde406ff@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 17, 2025 at 01:21:38PM +0100, John Garry wrote:
> On 17/06/2025 13:15, John Garry wrote:
>> On 17/06/2025 11:52, Christoph Hellwig wrote:
>>>   xfs_configure_buftarg(
>>> -    struct xfs_buftarg    *btp,
>>> -    unsigned int        sectorsize)
>>> +    struct xfs_buftarg    *btp)
>>>   {
>>
>> This is now just really a wrapper for calling 
>> xfs_configure_buftarg_atomic_write() - is that ok?
>
> And the bdev_can_atomic_write() call [not shown] is superfluous already, as 
> we have that same check in bdev_atomic_write_unit_{min,max}_bytes()

I'll look into it, that should simplify things further.
