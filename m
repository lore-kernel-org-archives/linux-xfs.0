Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB0CA7CA6
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 11:41:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A9DF68F8037
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:41:13 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 5b35dGIt1kfwizIn (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:41:11 -0700 (PDT)
Date: Wed, 13 Apr 2016 09:41:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] xfs: we don't need no steekin ->evict_inode
Message-ID: <20160413164110.GA8475@infradead.org>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
	<1460525492-1170-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460525492-1170-2-git-send-email-david@fromorbit.com>
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
Cc: viro@zeniv.linux.org.uk, xfs@oss.sgi.com

Al has been very unhappy about our destroy_inode abuse, and I'd
reluctant to make it worse.

Why do we need to play games with i_mode when freeing?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
