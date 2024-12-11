Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CA0259498
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733951325; cv=none; b=A4uBm2MCf/x6wlCL14vh555L2ZB34rn3AF8SAJMfbZYfQ2cBIbFuOzqD7qWWmlrH3XHtRuFITJYURRIUhkDfL5N+tC6lBZLFpu5faArzRMt332GEh9wR2XSdv467Iy/R0t3SDW1jp4bkLhfwtZaIvo1G6FtDoe74Gb07vMm/C6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733951325; c=relaxed/simple;
	bh=sqH8M2zUvVs6P6H9D9SOYnL4pCU1yES0De3AmBoIkUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pw7/Dqgxf45c4dN8aaJwfrL2GMiNSLndr9WtKZfkwLuV0lxH6s4hLtZbdVffEdGJKb7vHP2pjnXjcoK4gK8CXT9Czc0c01Z1oE+OMl+SfGiRdncApz8L3MYbBGpE+wXS9Iv8R9AYfzo5u+uMOznYFQoQI/98Xhyp+T53Jh0c1lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHaUejsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHaUejsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E45DC4CED2;
	Wed, 11 Dec 2024 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733951324;
	bh=sqH8M2zUvVs6P6H9D9SOYnL4pCU1yES0De3AmBoIkUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nHaUejsR2x4sOCZi4XqN2gWuVxDAenPXqzS9JHOyMLUBs0sLEHrN/OazTHv+8KUJK
	 AaHS0Ii9KN9jYMGbUldPwbyFNg9Nwq9T+baYuoX9oxrsZW9ONshK4MZgZ2cd/Uq60c
	 4GlZm2SEh8W/Q1DyRRpAgUyTJdNGfci99sU3qXvvok/vr5vkxu4CY1pXT83ay+4PZI
	 XPYLy5Ikti9xN5JrBAI0vcFwTO11DcxgeqlhCNZY/MOF7ni1HhxMs9NtcAGOXs7H6Z
	 2ZHIogZjksYtJNzDbsr5wfdhxoqNIsrzKsEZ1ONzRcaJtl9pU0E6HQpO/j/pJOc08h
	 MX7z4axlIxyNg==
Date: Wed, 11 Dec 2024 13:08:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/41] xfs_io: support the bulkstat metadata directory
 flag
Message-ID: <20241211210843.GL6678@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748467.122992.7994504931432399626.stgit@frogsfrogsfrogs>
 <Z1fLHNNSMpmoKRKa@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fLHNNSMpmoKRKa@infradead.org>

On Mon, Dec 09, 2024 at 09:01:16PM -0800, Christoph Hellwig wrote:
> s/support the bulkstat/support bulkstat of the/
> 
> ?

How about:
"xfs_io: support flag for limited bulkstat of the metadata directory" ?

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
