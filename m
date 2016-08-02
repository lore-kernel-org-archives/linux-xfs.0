Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E819B7CBA
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 07:28:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B81B7304032
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 05:28:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iguoL0KmdEdeZoJO (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 05:28:10 -0700 (PDT)
Date: Tue, 2 Aug 2016 05:28:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 RESEND] fs: return EPERM on immutable inode
Message-ID: <20160802122808.GF31492@infradead.org>
References: <1470139108-13115-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470139108-13115-1-git-send-email-guaneryu@gmail.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, "open list:GFS2 FILE SYSTEM" <cluster-devel@redhat.com>, Bob Peterson <rpeterso@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>

On Tue, Aug 02, 2016 at 07:58:28PM +0800, Eryu Guan wrote:
> In most cases, EPERM is returned on immutable inode, and there're only a
> few places returning EACCES. I noticed this when running LTP on
> overlayfs, setxattr03 failed due to unexpected EACCES on immutable
> inode.
> 
> So converting all EACCES to EPERM on immutable inode.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although maybe you'll have to split this into one patch per subsystems,
as otherwise no maintainer might be enticed to pick it up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
