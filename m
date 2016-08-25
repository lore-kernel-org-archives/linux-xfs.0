Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 037287CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 03:06:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9ACA304048
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 01:06:34 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id aA30ek8sklqlzgfu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 01:06:33 -0700 (PDT)
Date: Thu, 25 Aug 2016 01:06:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/033: source mkfs output again if isize less than 512
Message-ID: <20160825080631.GD28747@infradead.org>
References: <1471790859-26077-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471790859-26077-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Sun, Aug 21, 2016 at 10:47:39PM +0800, Zorro Lang wrote:
> I moved the mkfs_xfs output to /dev/null, because:
>   1. I think it's not necessary.
>   2. The case maybe do and output mkfs once or twice(not sure). So it'll be
>   hard to keep consistent golden image.

I agree.  If for some reaoson we care about the info we should just
do a xfs_info later, but I can't see one.

But with this change I think we can also consolidate the output files
into a single 033.out file, can't we?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
