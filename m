Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06JWOJ3106399 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 13:32:25 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D83661471E3
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 11:33:15 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id 1iXfclKCjnur1CVH for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2010 11:33:15 -0800 (PST)
Date: Wed, 6 Jan 2010 20:33:12 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH V3] sort: Introduce generic list_sort function
Message-ID: <20100106193312.GB31857@basil.fritz.box>
References: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com>
	<87eim4dbzw.fsf@basil.nowhere.org>
	<20100105122101.GR13802@discord.disaster>
	<20100105125234.GD1778@basil.fritz.box>
	<20100106172319.GA25046@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100106172319.GA25046@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>, Adrian Hunter <adrian.hunter@nokia.com>

> lib-y doesn't work together with EXPORT_SYMBOL, having the export
> outside would also always pull it in.  These days the whole lib-y mess
> doesn't make sense anymore - if we really need an optional library
> symbol we can just pull it in through a Kconfig variable.

It works for non modular kernels with CONFIG_MODULES turned off.

See also the other patch I posted yesterday to fix this for 
lib/*

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
