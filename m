Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 97BCC7CA0
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2016 11:34:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19F12AC002
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2016 09:34:49 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id fI8T4cnVv3onImjf (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Mar 2016 09:34:44 -0800 (PST)
Date: Tue, 8 Mar 2016 09:34:43 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: pad xfs_attr_leaf_name_remote to avoid tripping
	on m68k
Message-ID: <20160308173443.GA21965@infradead.org>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
	<1457300990-18300-7-git-send-email-david@fromorbit.com>
	<20160307162858.GE19784@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160307162858.GE19784@infradead.org>
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
To: Dave Chinner <david@fromorbit.com>, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

So I looked into this, and it seems we really don't care about the
size - xfs_attr_leaf_entsize_remote pad it to the next multiple of
4 anyway.  So I think we really should simply remove the size check
here.  Assuming all architectures pad up a structure that isn't
word aligned the same way just isn't a sensible assumption.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
