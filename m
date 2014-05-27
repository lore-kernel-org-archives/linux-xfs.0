Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BDE5B7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 05:44:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6CC08AC004
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 03:44:30 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id IkLzukVfuXlFHL5v (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 03:44:28 -0700 (PDT)
Date: Tue, 27 May 2014 03:44:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] xfs: add scan owner field to xfs_eofblocks
Message-ID: <20140527104428.GC1440@infradead.org>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
	<1400845950-41435-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400845950-41435-2-git-send-email-bfoster@redhat.com>
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

On Fri, May 23, 2014 at 07:52:28AM -0400, Brian Foster wrote:
> The scan owner field represents an optional inode number that is
> responsible for the current scan. The purpose is to identify that an
> inode is under iolock and as such, the iolock shouldn't be attempted
> when trimming eofblocks. This is an internal only field.

xfs_free_eofblocks already does a trylock, and without that calling it
from one iolock holding process to another would be a deadlock waiting
to happen.

I have to say I'm still not very easy with iolock nesting, even if it's
a trylock.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
