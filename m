Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B85FC7619A
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 22:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjDEWvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 18:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjDEWvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 18:51:31 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616AB1BDB
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 15:51:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 185so11545804pgc.10
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 15:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1680735089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dLSxfaMFCVS8468KN/z0VwXJmbpcmKd5R8VPq1b2igA=;
        b=DKNaEMAvLoxgxcW7C/DG2hGwlybNwuFNi7Q8qY482/jzM9d4xL2UjV2S9BGfeJcIDr
         MA5ql8Ba3dLnaVVaPhzE2O1VDUcT7iJ/QxiGopWq24vyCi9gjKBCmMqTVc80ZzvfS+zT
         y1i56dDgdCCa+DALwBNBfN3/jA9Mdt2k/DUFQJQwT8rTqbxQlLXKbG94azFShwTCHrRC
         j2vDIirPUgjQi/BpGinlJPvMNSyzo5n0IBLLvknGncJH3Tm1MZO+xIiGDixxqlk3i4Bo
         R1xKFWnLl5NxzMVulcM3Ebj7nNcXnWCd0yodUgm1mhmBHJF1ocZct58oemW+AHAqXqk9
         /VPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680735089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLSxfaMFCVS8468KN/z0VwXJmbpcmKd5R8VPq1b2igA=;
        b=fXeC7qiQiNAwqrlhQUF9gxGHr9mqUcp7ViBBkGiW/UK04PegOc/Ivdq6US06CJZn6u
         YZwmDJpYrqyQTazSzDmTx1VEqRY89sxsZMNVhXcBlrIwfBuvV7qr3nhF7ed4nvvYmUUf
         7b6KJs5HXczv0mJaKdcVlG5PgAkLxY9gwmyirHxMZop+OcnTVoW+KNvhBXF2IJnFE7TW
         tUtAubxCiYitw51flK99kJgTJiTl8XbEN4Bm63qYUsR7hxR0/RBU6IyjCH4RBeSXInlx
         PrX6vydpQedw6VKcZYVzTsrHP19QuyVFxRTfZuujqgNmL5iFyg6XQIvtFxG0fMFNy6sn
         P2Ew==
X-Gm-Message-State: AAQBX9dGhcYgtNlryJVnFcIZ14ZmkeScx7V/5x8e36San7t4dYq0D4gz
        o+gRjlsIIs2zTzvQ+mh5o41p7g==
X-Google-Smtp-Source: AKy350byI2dOXAx2UUhieoBDXlt6kMcfX++CjjnLqbSOozpqmQEUOmvJ7mOnsddzMAKRV6q6VXMDHg==
X-Received: by 2002:a62:7b8b:0:b0:625:cc03:df33 with SMTP id w133-20020a627b8b000000b00625cc03df33mr7050385pfc.31.1680735088792;
        Wed, 05 Apr 2023 15:51:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id m3-20020aa79003000000b006260645f2a7sm11619498pfo.17.2023.04.05.15.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:51:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pkByP-00HV2h-IA; Thu, 06 Apr 2023 08:51:25 +1000
Date:   Thu, 6 Apr 2023 08:51:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, djwong@kernel.org,
        dchinner@redhat.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev, rpeterso@redhat.com, agruenba@redhat.com,
        xiang@kernel.org, chao@kernel.org,
        damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com
Subject: Re: [PATCH v2 21/23] xfs: handle merkle tree block size != fs
 blocksize != PAGE_SIZE
Message-ID: <20230405225125.GS3223426@dread.disaster.area>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404145319.2057051-22-aalbersh@redhat.com>
 <20230404233224.GE1893@sol.localdomain>
 <20230405151234.sgkuasb7lwmgetzz@aalbersh.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405151234.sgkuasb7lwmgetzz@aalbersh.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 05, 2023 at 05:12:34PM +0200, Andrey Albershteyn wrote:
> Hi Eric,
> 
> On Tue, Apr 04, 2023 at 04:32:24PM -0700, Eric Biggers wrote:
> > Hi Andrey,
> > 
> > On Tue, Apr 04, 2023 at 04:53:17PM +0200, Andrey Albershteyn wrote:
> > > In case of different Merkle tree block size fs-verity expects
> > > ->read_merkle_tree_page() to return Merkle tree page filled with
> > > Merkle tree blocks. The XFS stores each merkle tree block under
> > > extended attribute. Those attributes are addressed by block offset
> > > into Merkle tree.
> > > 
> > > This patch make ->read_merkle_tree_page() to fetch multiple merkle
> > > tree blocks based on size ratio. Also the reference to each xfs_buf
> > > is passed with page->private to ->drop_page().
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > > ---
> > >  fs/xfs/xfs_verity.c | 74 +++++++++++++++++++++++++++++++++++----------
> > >  fs/xfs/xfs_verity.h |  8 +++++
> > >  2 files changed, 66 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_verity.c b/fs/xfs/xfs_verity.c
> > > index a9874ff4efcd..ef0aff216f06 100644
> > > --- a/fs/xfs/xfs_verity.c
> > > +++ b/fs/xfs/xfs_verity.c
> > > @@ -134,6 +134,10 @@ xfs_read_merkle_tree_page(
> > >  	struct page		*page = NULL;
> > >  	__be64			name = cpu_to_be64(index << PAGE_SHIFT);
> > >  	uint32_t		bs = 1 << log_blocksize;
> > > +	int			blocks_per_page =
> > > +		(1 << (PAGE_SHIFT - log_blocksize));
> > > +	int			n = 0;
> > > +	int			offset = 0;
> > >  	struct xfs_da_args	args = {
> > >  		.dp		= ip,
> > >  		.attr_filter	= XFS_ATTR_VERITY,
> > > @@ -143,26 +147,59 @@ xfs_read_merkle_tree_page(
> > >  		.valuelen	= bs,
> > >  	};
> > >  	int			error = 0;
> > > +	bool			is_checked = true;
> > > +	struct xfs_verity_buf_list	*buf_list;
> > >  
> > >  	page = alloc_page(GFP_KERNEL);
> > >  	if (!page)
> > >  		return ERR_PTR(-ENOMEM);
> > >  
> > > -	error = xfs_attr_get(&args);
> > > -	if (error) {
> > > -		kmem_free(args.value);
> > > -		xfs_buf_rele(args.bp);
> > > +	buf_list = kzalloc(sizeof(struct xfs_verity_buf_list), GFP_KERNEL);
> > > +	if (!buf_list) {
> > >  		put_page(page);
> > > -		return ERR_PTR(-EFAULT);
> > > +		return ERR_PTR(-ENOMEM);
> > >  	}
> > >  
> > > -	if (args.bp->b_flags & XBF_VERITY_CHECKED)
> > > +	/*
> > > +	 * Fill the page with Merkle tree blocks. The blcoks_per_page is higher
> > > +	 * than 1 when fs block size != PAGE_SIZE or Merkle tree block size !=
> > > +	 * PAGE SIZE
> > > +	 */
> > > +	for (n = 0; n < blocks_per_page; n++) {
> > > +		offset = bs * n;
> > > +		name = cpu_to_be64(((index << PAGE_SHIFT) + offset));
> > > +		args.name = (const uint8_t *)&name;
> > > +
> > > +		error = xfs_attr_get(&args);
> > > +		if (error) {
> > > +			kmem_free(args.value);
> > > +			/*
> > > +			 * No more Merkle tree blocks (e.g. this was the last
> > > +			 * block of the tree)
> > > +			 */
> > > +			if (error == -ENOATTR)
> > > +				break;
> > > +			xfs_buf_rele(args.bp);
> > > +			put_page(page);
> > > +			kmem_free(buf_list);
> > > +			return ERR_PTR(-EFAULT);
> > > +		}
> > > +
> > > +		buf_list->bufs[buf_list->buf_count++] = args.bp;
> > > +
> > > +		/* One of the buffers was dropped */
> > > +		if (!(args.bp->b_flags & XBF_VERITY_CHECKED))
> > > +			is_checked = false;
> > > +
> > > +		memcpy(page_address(page) + offset, args.value, args.valuelen);
> > > +		kmem_free(args.value);
> > > +		args.value = NULL;
> > > +	}
> > 
> > I was really hoping for a solution where the cached data can be used directly,
> > instead allocating a temporary page and copying the cached data into it every
> > time the cache is accessed.  The problem with what you have now is that every
> > time a single 32-byte hash is accessed, a full page (potentially 64KB!) will be
> > allocated and filled.  That's not very efficient.  The need to allocate the
> > temporary page can also cause ENOMEM (which will get reported as EIO).
> > 
> > Did you consider alternatives that would work more efficiently?  I think it
> > would be worth designing something that works properly with how XFS is planned
> > to cache the Merkle tree, instead of designing a workaround.
> > ->read_merkle_tree_page was not really designed for what you are doing here.
> > 
> > How about replacing ->read_merkle_tree_page with a function that takes in a
> > Merkle tree block index (not a page index!) and hands back a (page, offset) pair
> > that identifies where the Merkle tree block's data is located?  Or (folio,
> > offset), I suppose.

{kaddr, len}, please.

> > 
> > With that, would it be possible to directly return the XFS cache?
> > 
> > - Eric
> > 
> 
> Yeah, I also don't like it, I didn't want to change fs-verity much
> so went with this workaround. But as it's ok, I will look into trying
> to pass xfs buffers to fs-verity without direct use of
> ->read_merkle_tree_page(). I think it's possible with (folio,
> offset), the xfs buffers aren't xattr value align so the 4k merkle
> tree block is stored in two pages.

I don't think this is necessary to actually merge the code. We want
it to work correctly as the primary concern, performance is a
secondary concern.

Regardless, as you mention, the xfs_buf is not made up of contiguous
pages so the merkle tree block data will be split across two
(or more) pages.  AFAICT, the fsverity code doesn't work with data
structures that span multiple disjoint pages...

Another problem is that the xfs-buf might be backed by heap memory
(e.g. 4kB fs block size on 64kB PAGE_SIZE) and so it cannot be
treated like a page cache page by the fsverity merkle tree code. We
most definitely do not want to be passing pages containing heap
memory to functions expecting to be passed lru-resident page cache
pages....

That said, xfs-bufs do have a stable method of addressing the data
in the buffers, and all the XFS code uses this to access and
manipulate data directly in the buffers.

That is, xfs_buf_offset() returns a mapped kaddr that points to the
contiguous memory region containing the metadata in the buffer.  If
the xfs_buf spans multiple pages, it will return a kaddr pointing
into the contiguous vmapped memory address that maps the entire
buffer data range. If it is heap memory, it simply returns a pointer
into that heap memory. If it's a single page, then it returns the
kaddr for the data within the page.

If you move all the assumptions about how the merkle tree data is
managed out of fsverity and require the fielsystems to do the
mapping to kaddrs and reference counting to guarantee life times,
then the need for multiple different methods for reading merkle tree
data go away...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
