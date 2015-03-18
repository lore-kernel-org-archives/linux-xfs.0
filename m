Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 089317F47
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 05:50:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DCE278F8052
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 03:50:38 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id G9LU9ElKSLGtZHfI for
	<xfs@oss.sgi.com>; Wed, 18 Mar 2015 03:50:33 -0700 (PDT)
Date: Wed, 18 Mar 2015 11:50:30 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150318105030.GA21390@lst.de>
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
> 	NFS_MOUNT_OPTIONS="-overs=4.1"
> 	EOF
> 	./check -nfs -g auto -E ~/xfstests-skip
> 
> where xfs-tests-skip is:

Seems like you're excluding a lot of tests.

Either way, both generic/011 and generic/013 cause the bug I reported earlier,
so at least on 4.0-rc I don't really get close to running into these
pnfs issues.

Do you have a commit you're runing on that's before the nfs client merge
and somewhat stable?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
