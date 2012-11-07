Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7Lbp4s182814 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 15:37:51 -0600
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id 0aVQFfmGNw2zmbnf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 13:39:48 -0800 (PST)
Date: Wed, 7 Nov 2012 22:39:46 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] xfs: add CRC infrastructure
Message-ID: <20121107213946.GB16230@one.firstfloor.org>
References: <1352295452-4726-1-git-send-email-david@fromorbit.com>
	<1352295452-4726-2-git-send-email-david@fromorbit.com>
	<m2ehk5qt88.fsf@firstfloor.org> <20121107203105.GE6434@dastard>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121107203105.GE6434@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

> Why would that be necessary? We never include the checksum field in
> the calculation when setting it or verifiying it, and the
> verification uses exactly the same method as the original
> calculation to check the CRC, so it doesn't matter if the CRC value
> is zero or not - if it matches (zero or otherwise), the validation
> passes....

I thought zero meant the checksum is not there? You stated that
somewhere else.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
