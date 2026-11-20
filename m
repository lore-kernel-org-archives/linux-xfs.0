Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795180283;
	b=EajUWIoGFwE0xgrVEBREOU8CBcVWDXoEB64S0ITORio/8Dg9n2kOdIG4OY1cSdZXxcAU
	 7UnMyvjtLOPcptpfTzOhKiuIhwitu2kMNEPw8S5sCZO/xm/qqFNXZrGtm35bgcNeBgJv4
	 XI8a9fP1NfkRoplQh1WrYkGKJLw2cG97GZkU8/TF3ZNfRPnkQiJNv9Q2o3y68naXb9Tf2
	 czrK1SrSnRClf+g1dw4vO+8L9sFgVVSVbNuUpJmkviIH6rDIyqFVmHdDelEt0crqpLwxp
	 IAbVGAn1StFhj0W6t1kzW1nVvChTRPj/Z8lkjEYE3fA1eZ3lGDf/SGfhO0g4A+cLhUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795180283;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=11EUqqsBHqKJhSEKaLjedxJRvUSCpiSlKRotGWVYopQ=;
	b=rrBin/y9NPFQwUqpbxAz72jE7bRn1IN++eKpu2vuMdiWHSjricCHOHby0Y9eJhKwVqAw
	 UkYhhJX+0c1KgG4WPir18DYTufTwMgNkSHfgusp+zzMGLczVHrqqaeNjd07dEHBn0ww8s
	 SoT+EWiwbk9Mvi9X+YJ1WJsHlGJDZubCQaBlo3s0UzRP75Tggeuxz5azlApHT3f38ori0
	 rWTBvhcjBnLRcnT4KX+PNh1x0NMsiAykgrecBXbMH9Ouh4hYdYOQ8Pnm8ja7yeCU4c+6O
	 Ef/j+2+9Brr2n/66nQbNa4Ml4w9lDzO9mTAafqQvKpt5ef4PEgZ3ZiSUki4XSQloBNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pcpMXMRk;
	arc=none smtp.remote-ip=91.218.175.178
Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BD1606A333
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 13:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8BD1606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pcpMXMRk
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AFN9OOtQlK1HJO8cWelVMtGeAQ6PKLi87EwwnhaP1iY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795180281; v=1; x=1795785081;
 b=pcpMXMRkQ4Ns6fd064vPWWatVGroU9IVtkGO3ROe58Y6pOfgmdrRaA8URbSyfTUF5AbEgZhD
 i68/L46VO8eq6YVzH9zTsvTRNPM0a79tLxALqyXzHBnW3aN7CqxWw7P6596t4l+BKqmEoxYpK8c
 D1wn0Zhz0yPrczpYDf0gH1hM=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1d043ee31403846b;
	Fri, 20 Nov 2026 13:11:20 +0000
X-Mizu-Trace-ID: 1d043ee31403846b
X-Migadu-Flow: FLOW_OUT
Date: Fri, 20 Nov 2026 14:11:11 +0100
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Andreas Gruenbacher <agruenba@redhat.com>, gfs2@lists.linux.dev, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, devel@lists.orangefs.org, Dave Kleikamp <shaggy@kernel.org>, 
	jfs-discussion@lists.sourceforge.net, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	linux-afs@lists.infradead.org, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, 
	linux-block@vger.kernel.org, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	linux-nfs@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org, 
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 02/13] xfs: Drop pointless I_DIRTY_PAGES check in
 xfs_can_free_cowblocks()
Message-ID: <awBGYTkywYFOaYOI@quentin>
References: <20261116171044.6938-1-jack@suse.cz>
 <20261118145941.1063127-15-jack@suse.cz>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118145941.1063127-15-jack@suse.cz>

On Wed, Nov 18, 2026 at 03:59:36PM +0100, Jan Kara wrote:
> PAGECACHE_TAG_DIRTY is the authoritative source of information about any
> folio being dirty in the mapping. I_DIRTY_PAGES is just an approximation
> used by writeback code that can get stale under certain situations. So
> just rely on the authoritative check.
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good,
Reviewed-by: Pankaj Raghav (Samsung) <pankaj.raghav@linux.dev>

> ---
>  fs/xfs/xfs_reflink.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 683c1841e640..1310cc9fe829 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -17,8 +17,7 @@ xfs_can_free_cowblocks(struct xfs_inode *ip)
>  {
>  	struct inode *inode = VFS_I(ip);
>  
> -	if ((inode_state_read_once(inode) & I_DIRTY_PAGES) ||
> -	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
> +	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
>  	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
>  	    atomic_read(&inode->i_dio_count))
>  		return false;
> -- 
> 2.53.0
> 
