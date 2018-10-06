Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60812 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeJFROJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:14:09 -0400
Date: Sat, 6 Oct 2018 03:11:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/15] xfsprogs: minor endian annotation fixes
Message-ID: <20181006101128.GF28114@infradead.org>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-7-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538712196-13625-7-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

>  	if (xfs_sb_version_hascrc(sb) && !xfs_sb_version_hasmetauuid(sb) &&
>  	    !uuid_equal(&tcarg->uuid, &sb->sb_uuid)) {
> -		__be32 feat;
> +		__u32 feat;

Don't we normally use uint32_t now?

> -		/* Off by one.. */
> -		crc = cpu_to_be32(crc + 1);
> +		/* Off by one, ignore endianness - we're just corrupting it. */
> +		crc++;

It also looks like crc should be an unsigned int or uint32_t while we
are at it..
