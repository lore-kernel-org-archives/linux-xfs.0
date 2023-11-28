Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADE44412
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 17:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YosUdrrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3334EC433C8;
	Tue, 28 Nov 2023 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701191271;
	bh=1nQ9+MMXkNPs/vWjAfbbZ+M6trBndFwp6itWz9R73I0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YosUdrrz00o6+XkxALQ2WwmQCQTAcmU9oOfV+KAOt4JtBgGbt3Cv4Z/D5w8ADW8V8
	 6nVCpGguLO0teE1D/pdemm/NF1gYG9u2I/9E9q9b1lKKVxgJeA0nbiPi/UVwURTeAq
	 fogmbUV0giFm0Z6l0RG42l184/YRrZSDtqQM8po8x4zGoOPwpUzyNEdzYcHDle9PgA
	 AdXBqyQQ3/O+yuNQYmZrCKhnLgihf2Ukh+2RS6nKfcma7YwM5B33IU8r00Vl3IGzvE
	 0K8yO7/vrqQ+WM3deYKzjUmXZCH2KaqLqOojVdwfeNgG1K/qrtBsu6P9NveZDkqVPD
	 CvMZvY9XzDvvQ==
Date: Tue, 28 Nov 2023 09:07:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: add debug knobs to control btree bulk load
 slack factors
Message-ID: <20231128170750.GA2766956@frogsfrogsfrogs>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926609.2770816.18279950636495716216.stgit@frogsfrogsfrogs>
 <ZWGLH786QzH5KpUj@infradead.org>
 <20231128014437.GN2766956@frogsfrogsfrogs>
 <ZWV9zdT7aQxhMEAa@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWV9zdT7aQxhMEAa@infradead.org>

On Mon, Nov 27, 2023 at 09:42:37PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 27, 2023 at 05:44:37PM -0800, Darrick J. Wong wrote:
> > They're not generally useful for users, obviously.  For developers, it
> > might be useful to construct btrees of various heights by crafting a
> > filesystem with a certain number of records and then using repair+knobs
> > to rebuild the index with a certain shape.
> > 
> > Practically speaking, you'd only ever do that for extreme stress
> > testing.
> 
> Please add this to the commit message.

Done.

--D

> 
> 
