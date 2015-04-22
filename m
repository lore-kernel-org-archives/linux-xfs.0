Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 975007F37
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 11:15:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25311AC001
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 09:15:12 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id tEvTjnVNiOiVsXY8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 09:15:10 -0700 (PDT)
Date: Wed, 22 Apr 2015 09:15:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't trigger fsync log force based on inode pin
	count
Message-ID: <20150422161509.GA27237@infradead.org>
References: <1429713466-22137-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429713466-22137-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 22, 2015 at 10:37:46AM -0400, Brian Foster wrote:
> There are probably a couple different ways to handle this. We could log
> the inode in the bmap cases in order to preserve the pincount check.

I'd favor that.  For one performance should be better, second we really
need to dirty the inode anyway for v5 file systems as that's the
mechanism used to increment di_changecount.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
