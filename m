Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 90BAA7CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 15:03:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22883AC002
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 13:03:09 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id QFF93vrD1LIolEDF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 13:03:00 -0800 (PST)
Date: Thu, 28 Jan 2016 13:02:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: a couple xfstests fixes for reflinks
Message-ID: <20160128210255.GA6431@birch.djwong.org>
References: <1454001236-2600-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454001236-2600-1-git-send-email-hch@lst.de>
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

On Thu, Jan 28, 2016 at 06:13:52PM +0100, Christoph Hellwig wrote:
> See http://www.infradead.org/rpr.html

Hrmm, have I been sending junk again?  I've noticed a few transient problems
with Oracle's mailservers lately...

> The patches (against Darrick's for-dave branch) fix various failures I see
> during testing XFS and NFS.

I've integrated your fixes with my dev tree and pushed to github.

There's a bunch of new tests in there to look at quota behaviors.  Evidently
btrfs doesn't support classic usr/group quotas(?) and ocfs2 exploded when I
tried it, so for now I'll just charge each quota at reflink time; copy on write
is therefore "free".

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
