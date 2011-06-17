Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HC8t40117443 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 07:08:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 229BE10F8FBA
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 05:08:54 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	IygPw8DRAFGr9NOt for <xfs@oss.sgi.com>;
	Fri, 17 Jun 2011 05:08:54 -0700 (PDT)
Date: Fri, 17 Jun 2011 08:08:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3 v5] XFS TESTS: Expand 252 punch hole test
Message-ID: <20110617120853.GB20714@infradead.org>
References: <4DED63DE.1070000@vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DED63DE.1070000@vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Allison Henderson <achender@vnet.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 06, 2011 at 04:33:50PM -0700, Allison Henderson wrote:
> This patch adds additional punch hole tests to 252
> that were used to test ext4 punch hole. The _test_generic_punch
> routine has been modified to accept two new flags:
> 
> -k To keep the test file between tests.
>    This will test the handling of existing holes
> 
> -d To not sync the file between tests.
>    This will test the handling of delayed extents
> 
> Four new corner cases have also been added to the routine:
> 14. data -> hole @ EOF
> 15. data -> hole @ 0
> 16. data -> cache cold ->hole
> 17. data -> hole in single block file

Looks good, I'll put it in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
