Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D1FD97CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:03:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80ABC304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 14:03:53 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id KPki8zBeDyLoYQxI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 14:03:49 -0700 (PDT)
Date: Thu, 25 Aug 2016 14:03:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/7] xfsprogs: reverse mapping fixes
Message-ID: <20160825210345.GC22760@birch.djwong.org>
References: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 23, 2016 at 07:24:24PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This is a roll-up of a few fixes[1] for reverse-mapping in xfsprogs 4.8.
> 
> The patches have been xfstested with the 'auto' group on x64
> and (afaict) don't cause any regressions.
> 
> This is an extraordinary way to eat your data.  Enjoy! 
> Comments and questions are, as always, welcome.

Just FYI I rolled the updated Coverity fix patch into a new branch:
https://github.com/djwong/xfsprogs/tree/for-dave-for-4.8-7

--D

> 
> --D
> 
> [1] https://github.com/djwong/xfsprogs/tree/for-dave-for-4.8-6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
