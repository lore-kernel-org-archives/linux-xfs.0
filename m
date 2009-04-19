Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JLcBvE010750 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 16:38:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB5881CD0AFA
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 14:38:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HiP1LUDcatF3arpE for
	<xfs@oss.sgi.com>; Sun, 19 Apr 2009 14:38:05 -0700 (PDT)
Date: Sun, 19 Apr 2009 17:38:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: skip dump tests if dump utils not found
Message-ID: <20090419213804.GB10191@infradead.org>
References: <49EB8F90.20705@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EB8F90.20705@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Apr 19, 2009 at 03:54:40PM -0500, Eric Sandeen wrote:
> I was running xfstests on a NAS box which had no xfsdump,
> and any tests which required xfsdump were failing in not-so-nice
> ways:
> 
> > xfsdump not found
> 038      [failed, exit status 1] - output mismatch (see 038.out.bad)
> 
> I think using _notrun is a lot better:
> 
> 038      [not run] xfsdump not found
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
