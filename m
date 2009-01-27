Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RGsNfh059961 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 10:54:24 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B4A5AC00F
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 08:53:39 -0800 (PST)
Message-Id: <D600F33F-5B96-4F55-B8AA-9301AFBEA66B@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090126073202.440548000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 10/17] xfs: factor out attr fork reset handling
Date: Tue, 27 Jan 2009 10:53:37 -0600
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.440548000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Jan 26, 2009, at 1:31 AM, Christoph Hellwig wrote:

> We currently duplicate code to reset the attribute fork after the last
> attribute has been deleted.  Factor this out into a small helper.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
