Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1CF0C7CB7
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 06:08:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E501F304032
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 04:08:23 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Fp9Y418dBjsWaGnl (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 04:08:21 -0800 (PST)
Date: Tue, 1 Mar 2016 04:08:14 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove impossible condition
Message-ID: <20160301120814.GA5217@infradead.org>
References: <1456404237-18169-1-git-send-email-luisbg@osg.samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456404237-18169-1-git-send-email-luisbg@osg.samsung.com>
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
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: cmaiolino@redhat.com, darrick.wong@oracle.com, namjae.jeon@samsung.com, bfoster@redhat.com, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, billodo@redhat.com

On Thu, Feb 25, 2016 at 12:43:57PM +0000, Luis de Bethencourt wrote:
> bp_release is set to 0 just before the breakpoint of the for loop before
> the conditional check (in line 458). The other breakpoint is a goto that
> skips the dead code.

Yes, this looks correct:

Reviewed-by: Christoph Hellwig <hch@lst.de>

The whole code around this is rather grotty and could use some more
work, though..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
