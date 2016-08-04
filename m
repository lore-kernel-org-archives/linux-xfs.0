Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AAFE97CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 10:48:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6E7D68F8035
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 08:48:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eP8IAOt2jcfKD0II (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 08:48:06 -0700 (PDT)
Date: Thu, 4 Aug 2016 08:48:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [4.8 hang] xfstests generic/361 hangs on dax enabled filesystems
Message-ID: <20160804154805.GA24025@infradead.org>
References: <20160803003354.GP16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803003354.GP16044@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com

Just send a fix that you're Cc'ed on.  But now xfs/049 hangs, although
only on pmem devices, loop on non-pmem seems to be fine.  4.7 was fine
as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
