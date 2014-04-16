Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5D997F5A
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 05:43:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 546C8AC003
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 03:43:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CdjBE1bgmHuVmSen for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 03:43:41 -0700 (PDT)
Date: Wed, 16 Apr 2014 12:43:09 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
In-Reply-To: <20140416063618.GA12498@infradead.org>
Message-ID: <alpine.LFD.2.00.1404161242480.2586@localhost.localdomain>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<20140416063618.GA12498@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com, Michael Kerrisk <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, 15 Apr 2014, Christoph Hellwig wrote:

> Date: Tue, 15 Apr 2014 23:36:18 -0700
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org,
>     linux-ext4@vger.kernel.org, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
>     xfs@oss.sgi.com
> Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
>     fallocate
> 
> On Mon, Feb 17, 2014 at 04:08:17PM +0100, Lukas Czerner wrote:
> > Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> > functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> 
> Lukas, can you please also send a man page update for
> FALLOC_FL_ZERO_RANGE now that is has been merged?

Right, I'll do that.

Thanks!
-Lukas

> 
> > 
> > It can be used to convert a range of file to zeros preferably without
> > issuing data IO. Blocks should be preallocated for the regions that span
> > holes in the file, and the entire range is preferable converted to
> > unwritten extents - even though file system may choose to zero out the
> > extent or do whatever which will result in reading zeros from the range
> > while the range remains allocated for the file.
> > 
> > This can be also used to preallocate blocks past EOF in the same way as
> > with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> > size to remain the same.
> > 
> > You can test this feature yourself using xfstests, of fallocate(1) however
> > you'll need patches for util_linux, xfsprogs and xfstests which you
> > can find here:
> > 
> > http://people.redhat.com/lczerner/zero_range/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
