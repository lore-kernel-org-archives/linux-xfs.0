Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA17B7CBB
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 03:46:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1795EAC004
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 01:46:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9hXNbEPy8JoAow9Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 01:46:00 -0800 (PST)
Date: Wed, 2 Mar 2016 01:45:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfs; for-next branch updated to 31bb236
Message-ID: <20160302094559.GB18130@infradead.org>
References: <20160301231511.GM30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160301231511.GM30721@dastard>
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

> Mateusz Guzik (1):
>       [2e83b79] xfs: fix two memory leaks in xfs_attr_list.c error paths

This didn't seem to address the comment about using a goto for
error handling?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
