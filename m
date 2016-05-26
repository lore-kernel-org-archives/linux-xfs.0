Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8339E7CA1
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 03:08:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED5FAAC005
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 01:08:40 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id vuqcKSJRAjoWlsJd (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 01:08:37 -0700 (PDT)
Date: Thu, 26 May 2016 01:08:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs/104: don't enospc when ag metadata overhead grows
Message-ID: <20160526080835.GB20307@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<146424222875.6278.15144771781299434088.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146424222875.6278.15144771781299434088.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

> +for i in `seq 125 -1 90`; do
> +	fillsize=`expr $i \* 1048576`
> +	out="$(_fill_scratch $fillsize 2>&1)"
> +	echo "$out" | grep -q 'No space left on device' && continue
> +	test -n "${out}" && echo "$out"
> +	break
> +done

That's a bit of an odd loop, and it would seem an inverted grep
would seem more obvious.  But otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
