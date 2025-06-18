Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A652D7DA6D
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 05:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750223431; cv=none; b=UT5F44BBhFfhIeROIMG8PZVhU8aW3F2Dz+mAS0MSjyETjK2UlRzv35VP3IH/AfcD66SIJR5/3i/E0PDHN+gAh+iDeUeWIkcumMHE1YnscAZnz5jNnJ7/pHbxAfqLTnttN6Eb3ikJPl7Iy54uR1sDADbUa82ZdRjU9Tgc31vO9Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750223431; c=relaxed/simple;
	bh=zpszAN/ZJRQkCVrEvBaluyW/1FljPqlhbOBPkRUOslw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDl9HFlAA/IeL+ife2u2bvcPbo7hCHAQ5CA1sO/wSYjtnIkK3Bl4yWE7rSsG/niXz2rlkP59Uw2hnQW9vfvhpOSW6GN2w0BYlaqjOthom79JG6lIq/DEuP7ASZUgKnOVZlqCBVdvk/XGE+bb6+yqvYKkLm/zv13ENUvBxNNjT9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3E20E68D0E; Wed, 18 Jun 2025 07:10:25 +0200 (CEST)
Date: Wed, 18 Jun 2025 07:10:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: rename the bt_bdev_* buftarg fields
Message-ID: <20250618051024.GD28260@lst.de>
References: <20250617105238.3393499-1-hch@lst.de> <20250617105238.3393499-6-hch@lst.de> <1ef589fb-a8c2-4b2c-a401-a1e2987d21ba@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ef589fb-a8c2-4b2c-a401-a1e2987d21ba@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 17, 2025 at 01:02:16PM +0100, John Garry wrote:
> On 17/06/2025 11:52, Christoph Hellwig wrote:
>> The extra bdev_ is weird, so drop it.  The maximum size is based on the
>> bdev hardware limits, so add a hw_ component instead.
>
> but the min is also based on hw limits, no?

Yes.

> I also note that we have request queue limits atomic_write_unit_max and 
> atomic_write_hw_unit_max
>
> and bt_awu_max_hw is written with request queue limit atomic_write_unit_max
>
> But I don't think that this will cause confusion.

Should we switch to the request_queue names instead of the nvme
spec names here entirely?

