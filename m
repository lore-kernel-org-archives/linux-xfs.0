Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3AA077F56
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 05:30:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A0EB8F8071
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 03:30:40 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Zk8wyofpkqpsg4vb for
	<xfs@oss.sgi.com>; Tue, 17 Mar 2015 03:30:36 -0700 (PDT)
Date: Tue, 17 Mar 2015 11:30:33 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150317103033.GA22472@lst.de>
References: <20150303221033.GB19439@fieldses.org>
	<20150315125821.GA10655@lst.de>
	<20150316142721.GA12231@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150316142721.GA12231@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Mar 16, 2015 at 10:27:21AM -0400, J. Bruce Fields wrote:
> > I've been trying ot get a baseline, but even withotu CONFIG_NFSD_PNFS set
> > I start to run into other prolems early on, so I suspect the reproducer might
> > be something else?
> 
> What other problems?

See the "nfsd use after free in 4.0-rc" thread on linux-nfs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
