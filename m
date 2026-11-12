Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490796;
	b=1Ojj2ZuBUN3hRw5WpEhtbI6b721pBhWHUgs++DJgbMsHP5Q7paDPEAimiebPR6gU/Pcn
	 JK2Efa08zrb9n1NFsZNUP7pBK00k7B4Yyd0JWoEHWxnuCjPdSapSINfDIf7upGeQ27rxh
	 /EGVJW7D2bX+1TT4L8mz6BaEUVnBvSpm5BXFICE0A5BmnB/fKTwwk7wbzWRuPqHnQqpu4
	 H+8F07EkKlogeUKutWBDKmMd8kfh/8GxTBgwGy0kNHgqkFDidyxkwmS14bq/ljXRUQjul
	 Rioq97LWqfwzLaS2CG9KxjcuQuK5959oMvntL2B+PuOJw/RwUgnRLygiei10uXQouaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490796;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=NQFIYysb2hWKuro6zw4pfUd0EAxD2lKYbXMorN8G9OA=;
	b=4auf83Dqd5CxxLTZ3tLQQpfnQC18nadAEBgn5Qo7uuv6+BZ0TMaYP113UEgdX4dxhemK
	 Sy8Xo7HeZf0sVVSW1m/LePoZxc3alasoDrlW6WoSA94Z6JyuR/H0lc0SeqSCnNGUlawGC
	 5kdvx/C7OaDJu38ZyspxIKHZgrwKLpetrvTkbRyr18JbGpzNRLVCdmhijgCt4USh/ZVeG
	 ZNBRMRryeTLRif6AgAvuzhgRfYcCL/nCabmf5FooZiYyT515i/103nZ9EMqE+dP31Ar6R
	 QhNYbm+lqkxSAqi5/IV5jKBajpwxfdhil42yLl4+5F4Bfjt0Z33VtFVaoB0xGlqZQig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8A3606A335;
	Thu, 12 Nov 2026 13:39:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB8A3606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6CF1F6732A; Thu, 12 Nov 2026 14:39:50 +0100 (CET)
Date: Thu, 12 Nov 2026 14:39:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v8 15/15] xfs: don't enable DAX on zoned inodes
Message-ID: <20261112133950.GE22165@lst.de>
References: <20261112010229.51029-1-mason@kernel.org> <20261112010229.51029-16-mason@kernel.org>
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
In-Reply-To: <20261112010229.51029-16-mason@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 11, 2026 at 08:02:44PM -0500, Chris Mason wrote:
> A store through a shared mapping can dereference a NULL pointer if the
> file is zoned and has S_DAX.
> 
> DAX writes in place,

DAX does not actually require in-place writes, we had patches to
support DAX with reflink for example.

> and zoned inodes are only written out of place, so
> the two can't work together. XFS doesn't check for this: with dax=always
> or FS_XFLAG_DAX, an inode gets S_DAX if its device does DAX, and an
> internal zoned section on pmem does. The write fault then takes the
> zoned path:
> 
>     xfs_filemap_fault()
>       xfs_write_fault()
>         xfs_write_fault_zoned()
>           page_folio(vmf->page)     /* NULL in a DAX fault */

but this is real issue, and xfs_write_fault_zoned would need to
find a way to deal with pfn faults.

I think thi could be supported, but there's no real reason to bother
as there is no good use yet (at least right now).  So I think your
change is fine, but the commit log and comments are not.  Just say
that the zone code does not support DAX, and maybe mention this
callchain.
