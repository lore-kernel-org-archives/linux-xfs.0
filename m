Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5AE547F4E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 00:41:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6842AC005
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 22:41:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id I7Iuzv2cABCxLk3e (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 22:41:43 -0700 (PDT)
Date: Tue, 27 May 2014 22:41:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2, RFC] xfsprogs: try to handle mkfs of a file on 4k
	sector device
Message-ID: <20140528054142.GC13166@infradead.org>
References: <53852A05.5040006@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53852A05.5040006@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

> We can modify platform_findsizes() to use the fsgeom call to get the
> "sector size" which should be used here, and warn that mismatches
> might exist if it fails.
> 
> This does mean there'll be a new warning emitted on fs images hosted
> on non-xfs filesystems; I'm not really quite sure it's worth it,
> hence the RFC nature of this lightly tested 2-patch series...

Might be time to introduce some generic VFS-level ioctl for the sector
size and dio alignment.  Any beer or chocolate that could motivate you
to get this done? :)

Also it would be nice to have a test case that exercises this new code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
