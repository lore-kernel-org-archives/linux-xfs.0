Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 816617F3F
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 14:47:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 62DA38F8033
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 12:47:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id eiHzpFqpFGsZEHcL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 13 Sep 2014 12:47:13 -0700 (PDT)
Date: Sat, 13 Sep 2014 12:47:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfsrestore: use utimensat() to provide atime/mtime
	with ns resolution
Message-ID: <20140913194713.GB28479@infradead.org>
References: <1409866939-1480-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409866939-1480-1-git-send-email-bfoster@redhat.com>
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

On Thu, Sep 04, 2014 at 05:42:19PM -0400, Brian Foster wrote:
> xfsdump encodes and stores the full atime and mtime for each file with
> nanosecond resolution. xfsrestore uses utime() to set the times of each
> file that is restored. The latter supports resolution of 1 second, thus
> sub-second timestamp data is lost on restore.
> 
> Add the associated configure checks for and use utimensat() when
> available to restore timestamps with nanosecond resolution. Create a new
> helper to facilitate conditional support for utimensat().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
