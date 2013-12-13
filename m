Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD0A029DF8
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:20:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD4F7304059
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:20:08 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id V9kBGfNO4dDJsowX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:20:00 -0800 (PST)
Date: Fri, 13 Dec 2013 03:19:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Handling of reviewed patch series
Message-ID: <20131213111959.GF23546@infradead.org>
References: <20131213053611.GQ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213053611.GQ10988@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


I'm a big fan of the for-next vs for-linux split for next release work
vs bugfixes which we've not applied yet.  The whole topic branches
scheme makes sense for large changes like the crc work, but seems
utterly confusing if applied to every little change, as now the amount
of branches you can conflict againt multiplies.  I'm defintively in
favour of a model that has less active branches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
