Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 327697CC9
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 09:26:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB082304048
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 07:26:20 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id siDBxQrAETxEnXZT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 07:26:17 -0700 (PDT)
Date: Fri, 26 Aug 2016 16:26:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] xfs: make xfs_inode_set_eofblocks_tag cheaper for
	the common case
Message-ID: <20160826142616.GA21535@lst.de>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-4-git-send-email-hch@lst.de>
	<20160825123808.GC25041@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160825123808.GC25041@bfoster.bfoster>
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

On Thu, Aug 25, 2016 at 08:38:09AM -0400, Brian Foster wrote:
> I'm guessing the lockless check is intentional, but is that really
> necessary? E.g., it doesn't seem like using ->i_flags_lock
> unconditionally should affect performance in the way the AG lock or
> radix tree work does, particularly since we're already holding
> IOLOCK_EXCL in the current implementation. I could be wrong, but FWIW,
> we do already have xfs_iflags_test_and_set() sitting around as well...

I don't think taking it should be too bad, but given the ops ordering
it also seems entirely pointless to even take it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
