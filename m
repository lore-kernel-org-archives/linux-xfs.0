Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54295 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753283AbcJZK2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:28:14 -0400
Date: Wed, 26 Oct 2016 03:28:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/39] xfs_db: dump refcount btree data
Message-ID: <20161026102813.GG29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743667365.11035.7315587935264063644.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743667365.11035.7315587935264063644.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

> @@ -47,7 +47,7 @@ const field_t	agf_flds[] = {
>  	{ "versionnum", FLDT_UINT32D, OI(OFF(versionnum)), C1, 0, TYP_NONE },
>  	{ "seqno", FLDT_AGNUMBER, OI(OFF(seqno)), C1, 0, TYP_NONE },
>  	{ "length", FLDT_AGBLOCK, OI(OFF(length)), C1, 0, TYP_NONE },
> -	{ "roots", FLDT_AGBLOCK, OI(OFF(roots)), CI(XFS_BTNUM_AGF),
> +	{ "roots", FLDT_AGBLOCK, OI(OFF(roots)), CI(XFS_BTNUM_AGF) + 1,
>  	  FLD_ARRAY|FLD_SKIPALL, TYP_NONE },

Please replace XFS_BTNUM_AGF with a proper XFS_NUM_AG_BTREES or
similar define.  Without that this line and the ones below are black
magic.

Otherwise this looks fine to me.
