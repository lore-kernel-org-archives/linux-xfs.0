Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CFFE07F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 14:52:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DD00AC004
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 12:52:11 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 6jpQFCVF9vjM37gm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 12:52:09 -0800 (PST)
Date: Wed, 13 Jan 2016 12:52:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: a reflink fix
Message-ID: <20160113205204.GA5892@birch.djwong.org>
References: <1452701629-11537-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452701629-11537-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jan 13, 2016 at 05:13:48PM +0100, Christoph Hellwig wrote:
> This fixes the issues I saw with generic/168 over NFS.  Turns out it
> wasn't anything specific to that particular test cases, we just needed
> a sufficiently aged refcount btree to trigger it.

Thanks for the patch; I've worked the fixes into the overall patchset.

I also wrote a quick reproducer which will appear as xfs/807 in my next
xfstests drop.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
