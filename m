Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3073B351C31
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 17:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772557793; cv=none; b=Z7xB3+XFDFVrm9L3gnGTLTipIE5kn7p0rC8MzrB/Xem/HdL3ESeAcfrfrAGMW79h19TrJjVUrHawOV/l8Ni7wIKEHOQga1PAYLiIUkE1DnYXlfyUS1JR72bzcgi/TRiZr1yUE2k/iZr7UfbFtymb9KVdW8kGtZGe0U8Ww5N1DWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772557793; c=relaxed/simple;
	bh=XXgW8UZ91eEWy8kJ1DblE1oVE5mVs6S2YXoo5CIeZIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LA2aSlBYNw/xR/K5Gpv2qZda5wuKNiXQEwLAWFQL511WSB29rizlPbcN2YsSeBxYMj2nmp6zW3XmHd/0S1E6GtUI8cCtuUs143ngU0DLmM0ABsXIcgH64kBdpmZ/8pYm5Xxriayw963dhVOi0aRdaeBbX9aDGi0t6+kaTACU2So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hwukqqs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hwukqqs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9C3C116C6;
	Tue,  3 Mar 2026 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772557792;
	bh=XXgW8UZ91eEWy8kJ1DblE1oVE5mVs6S2YXoo5CIeZIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hwukqqs54WObxZPaxSS0dfpgSM4qRe2Yh26zh9RgXQl0XWpzOlozS23kd1PV/8GYy
	 qHR9lokJVh3IgFMdfyq6CuF2CUIPFvLKnDrBCVYqmJUBBGqaKKkj9tYN8+DcUJUku5
	 2vFExS6ng1Qy/+GoSlfhAr2wNA9UnJn6eDr68XV+ydKwsAFT1YQNxaq/dC+HpUWGkb
	 fQO08X40HCR4NKcp/7+uRT27vdQ5IYw3661hXE7EXzJc9LbIRko3dvpLQ1iaS41kSV
	 jAtFH+lwTxYTZipKGaOfR51mxrqKu1iKZHW/qqiv0d3RzpRBKhOWdJTMj1ndOffe8q
	 GcnP76eGVOXFA==
Date: Tue, 3 Mar 2026 09:09:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/26] debian/control: listify the build dependencies
Message-ID: <20260303170952.GO57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783766.482027.4988973426565666068.stgit@frogsfrogsfrogs>
 <aacFPGYApuygDtHD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacFPGYApuygDtHD@infradead.org>

On Tue, Mar 03, 2026 at 07:58:52AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 04:40:36PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This will make it less gross to add more build deps later.
> 
> Looks good, but should this go to the beginning of the series?

Fine with me.

--D
