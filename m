Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 834B47F50
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 05:32:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B3EF8F8078
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 03:32:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id in4tySs6msK2xQY0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Mar 2014 03:32:31 -0700 (PDT)
Date: Wed, 12 Mar 2014 03:32:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfstests: shared/051: add filter to match the golden
	output for large acls
Message-ID: <20140312103230.GA4167@infradead.org>
References: <531FC057.70804@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <531FC057.70804@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> +# we return E2BIG if hit the max acl limits on new kernel, but EINVAL
> +# on old kernel. So we need to filter the error message out in order
> +# to make the current golden output works for both old and new kernels.

Hate to nitpick, but shouldn't the new one be in the golden output and
the old one fixed up?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
