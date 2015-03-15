Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A057B7F59
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2015 07:58:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8F5F78F8049
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2015 05:58:28 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id ilF3RrSw8FVb6Gut for
	<xfs@oss.sgi.com>; Sun, 15 Mar 2015 05:58:25 -0700 (PDT)
Date: Sun, 15 Mar 2015 13:58:21 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150315125821.GA10655@lst.de>
References: <20150303221033.GB19439@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150303221033.GB19439@fieldses.org>
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

On Tue, Mar 03, 2015 at 05:10:33PM -0500, J. Bruce Fields wrote:
> I'm getting mysterious crashes on a server exporting an xfs filesystem.

Can you shared the setup used to reproduce the various issues in this thread?
I've been trying ot get a baseline, but even withotu CONFIG_NFSD_PNFS set
I start to run into other prolems early on, so I suspect the reproducer might
be something else?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
