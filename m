Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AA1C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 14:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbjFBOrH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jun 2023 10:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbjFBOrD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2023 10:47:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814E4132
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2023 07:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F38CD61531
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2023 14:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D512C4339B;
        Fri,  2 Jun 2023 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685717220;
        bh=bl+hHLs+xyUJdvy620w/WvSGAFeAzMACoMdFeATu0J4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rjUVJdi/QMKitPsBqzhTzwJjpW5ZFY7YrOii53+6IQl4m+cr8273SH4+d9Gy7S7h+
         4ISh8CMD1WgSKRCaYrXgiP16/9+6PonqK4FthECXyO8jbx+y0qdRxBtNS0CMy+sCr2
         rsBll09B1aRDkHpmqARZQY5CZIkQHJ5DGisKsEVEVJk9v8fTCu6c8mxeif4hMgeaRU
         21n6iOH4IfrIHCjrkynadxRDYqTgcUH9w9j9y8htMrkjD8eWQ8Ww0rC0WdX6qV21PS
         mPGgtTMOIGjYKF5jKe4rMFrAe5W29zTcrl39N/jKEhW0pexJDNtIQnByS3lwDN/Jpx
         D8MdKdGriOXPA==
Date:   Fri, 2 Jun 2023 07:46:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] metadump: Define metadump v2 ondisk format
 structures and macros
Message-ID: <20230602144659.GL16865@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-12-chandan.babu@oracle.com>
 <20230523173435.GR11620@frogsfrogsfrogs>
 <87h6rzjx1v.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6rzjx1v.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 02:56:38PM +0530, Chandan Babu R wrote:
> On Tue, May 23, 2023 at 10:34:35 AM -0700, Darrick J. Wong wrote:
> > On Tue, May 23, 2023 at 02:30:37PM +0530, Chandan Babu R wrote:
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> ---
> >>  include/xfs_metadump.h | 32 ++++++++++++++++++++++++++++++++
> >>  1 file changed, 32 insertions(+)
> >> 
> >> diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
> >> index a4dca25cb..1d8d7008c 100644
> >> --- a/include/xfs_metadump.h
> >> +++ b/include/xfs_metadump.h
> >> @@ -8,7 +8,9 @@
> >>  #define _XFS_METADUMP_H_
> >>  
> >>  #define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
> >> +#define	XFS_MD_MAGIC_V2		0x584D4432	/* 'XMD2' */
> >>  
> >> +/* Metadump v1 */
> >>  typedef struct xfs_metablock {
> >>  	__be32		mb_magic;
> >>  	__be16		mb_count;
> >> @@ -23,4 +25,34 @@ typedef struct xfs_metablock {
> >>  #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
> >>  #define XFS_METADUMP_DIRTYLOG	(1 << 3)
> >>  
> >> +/* Metadump v2 */
> >> +struct xfs_metadump_header {
> >> +	__be32 xmh_magic;
> >> +	__be32 xmh_version;
> >> +	__be32 xmh_compat_flags;
> >> +	__be32 xmh_incompat_flags;
> >> +	__be64 xmh_reserved;
> >
> > __be32 xmh_crc; ?
> >
> > Otherwise there's nothing to check for bitflips in the index blocks
> > themselves.
> 
> The user could generate a sha1sum of the metadump file and share it with the
> receiver for verifying the integrity of the metadump file right?

Heh, sorry, this is another erroneous comment based on me thinking that
xfs_metadump_header would be followed by an array of xfs_meta_extent,
like how v1 does things.  Question withdrawn.

> >
> >> +} __packed;
> >
> > Does an array of xfs_meta_extent come immediately after
> > xfs_metadump_header, or do they go in a separate block after the header?
> > How big is the index block supposed to be?
> >
> 
> A metadump file in V2 format is structured as shown below,
> 
>      |------------------------------|
>      | struct xfs_metadump_header   |
>      |------------------------------|
>      | struct xfs_meta_extent 0     |
>      | Extent 0's data              |
>      | struct xfs_meta_extent 1     |
>      | Extent 1's data              |
>      | ...                          |
>      | struct xfs_meta_extent (n-1) |
>      | Extent (n-1)'s data          |
>      |------------------------------|
> 
> If there are no objections, I will add the above diagram to
> include/xfs_metadump.h.

Yes, please.

> >> +
> >> +#define XFS_MD2_INCOMPAT_OBFUSCATED	(1 << 0)
> >> +#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
> >> +#define XFS_MD2_INCOMPAT_DIRTYLOG	(1 << 2)
> >
> > Should the header declare when some of the xfs_meta_extents will have
> > XME_ADDR_LOG_DEVICE set?
> >
> 
> I will add a comment describing that extents captured from an external log
> device will have XME_ADDR_LOG_DEVICE set.

<nod> I get that, but I'm asking about declaring in the
xfs_metadump_header that eventually there will be an xfs_meta_extent
with XME_ADDR_LOG_DEVICE in it.

The scenario that I'm thinking about is on the mdrestore side of things.
mdrestore reads its CLI arguments, but it doesn't know if the log device
argument is actually required until it reads the metadump header.

Once it has read the metadump header, it ought to be able to tell the
user "This metadump has external log contents but you didn't pass in
--log-device=/dev/XXX" and error out before actually writing anything.

What I think we ought to avoid is the situation where mid-stream we
discover a meta_extent with XME_ADDR_LOG_DEVICE set and only /then/
error out, having already written a bunch of stuff to the data device.

> >> +
> >> +struct xfs_meta_extent {
> >> +        /*
> >
> > Tabs not spaces.
> >
> 
> >> +	 * Lowest 54 bits are used to store 512 byte addresses.
> >> +	 * Next 2 bits is used for indicating the device.
> >> +	 * 00 - Data device
> >> +	 * 01 - External log
> >
> > So if you were to (say) add the realtime device, would that be bit 56,
> > or would you define 0xC0000000000000 (aka DATA|LOG) to mean realtime?
> >
> 
> I am sorry, the comment I have written above is incorrect. I forgot to update it
> before posting the patchset. Realtime device has to be (1ULL << 56).
> 
> But, Your comments on "[PATCH 22/24] mdrestore: Define mdrestore ops for v2
> format" has convinced me that we could use the 2 bits at bit posistions 54 and
> 55 as a counter. i.e 00 maps to XME_ADDR_DATA_DEVICE and 01 maps to
> XME_ADDR_LOG_DEVICE.

<nod>

> >> +	 */
> >> +        __be64 xme_addr;
> >> +        /* In units of 512 byte blocks */
> >> +        __be32 xme_len;
> >> +} __packed;
> >> +
> >> +#define XME_ADDR_DATA_DEVICE	(1UL << 54)
> >> +#define XME_ADDR_LOG_DEVICE	(1UL << 55)
> >
> > 1ULL, because "UL" means unsigned long, which is 32-bits on i386.
> 
> Ok. I will fix that.

<nod>

--D

> 
> -- 
> chandan
