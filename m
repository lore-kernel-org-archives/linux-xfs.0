Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ECD1D68D
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6TRl8Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A01C433C7;
	Thu,  4 Jan 2024 06:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704351312;
	bh=GhliB2+i6ivMC5eLBdvRqy6WYTaYt0Dyon9VLhK2D14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N6TRl8FvrTiOGd9V/6/KmHjpvNJoLdP8TzonR0zpkWnJu5qgQFb0O++9S7GQhbknt
	 FcutXGeF/y2kMPJnd8kbXb/irRUbwIWVysmTMqdDK+viHVu8gG636/yonjfnitQCwJ
	 0XSbce0yXBjZGa8DjzjPs05payeXefkW8J0xeLEAmCpjw1d8O4vbYnbj+iC4N9W6Z+
	 Qt9SzDvvlF+JRhl7cv0sNDD/zKUQ1yZxdY9eD6kv+dL9ezW1cRoN4mfoS0aCwCUjdI
	 SqyxxA+nwZN9x8ZD315/hAVNOn/3oideA74P8jzn7uvcC72/i9NTfripVPJf8EAV9v
	 /IoRJVcsCaUlA==
Date: Wed, 3 Jan 2024 22:55:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/15] xfs: remove xfile_stat
Message-ID: <20240104065511.GV361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-5-hch@lst.de>
 <20240103234533.GX361584@frogsfrogsfrogs>
 <20240104061415.GB29011@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104061415.GB29011@lst.de>

On Thu, Jan 04, 2024 at 07:14:15AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 03:45:33PM -0800, Darrick J. Wong wrote:
> > > +		__entry->bytes = inode->i_bytes;
> > 
> > Shouldn't this be (i_blocks << 9) + i_bytes?
> 
> Actually this should just be doing:
> 
> 	__entry->bytes = inode->i_blocks << SECTOR_SHIFT;
> 
> The bytes name here really confused me.

Me too.  It looks like some weird way to encode the bytes used by the
file using a u64 sector count and a u16 byte count for ... some reason?
XFS (and thankfully tmpfs) seem to ignore all that entirely.

> Or we could change the trace
> point to just report i_block directly and not rename it to bytes and
> change the unit?

I prefer to keep the tracepoint in bytes because that's a little easier
than rshifting by 9 in my head.

--D
