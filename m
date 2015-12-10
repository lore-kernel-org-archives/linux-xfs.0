Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 07AD67F51
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 13:15:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD802304032
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 11:15:12 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id pKtRQnroodnTYaee (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2015 11:15:08 -0800 (PST)
Date: Thu, 10 Dec 2015 11:14:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] reflink: more tests
Message-ID: <20151210191429.GN10580@birch.djwong.org>
References: <20151208062844.21871.23644.stgit@birch.djwong.org>
	<20151208062904.21871.30589.stgit@birch.djwong.org>
	<20151210163449.GA15774@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151210163449.GA15774@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Thu, Dec 10, 2015 at 08:34:49AM -0800, Christoph Hellwig wrote:
> The new 849 fails reliably on btrfs, which makes me wonder if either
> the test is doing something wrong, or the btrfs whole file clone
> behavior is broken, which wouldn't be very reasuring.  I didn't have
> time to look into why it's failing yet.

Huh.  Works reliably for /me; could you send me the output from 849?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
