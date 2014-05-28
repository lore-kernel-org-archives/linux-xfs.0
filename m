Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AE257F4E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 00:39:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 23F31304043
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 22:39:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id kr4tm22csJUEIzVZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 22:39:14 -0700 (PDT)
Date: Tue, 27 May 2014 22:39:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2, RFC] xfsprogs: check fs sector size in
	platform_findsizes()
Message-ID: <20140528053912.GA13166@infradead.org>
References: <53852A05.5040006@redhat.com>
 <53852A61.90400@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53852A61.90400@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 27, 2014 at 07:14:25PM -0500, Eric Sandeen wrote:
> Try the xfs geometry ioctl if the mkfs target resides
> in a file; this gives us the equivalent of a device
> sector size.
> 
> This does, however, emit a warning if the target file
> exists on a non-XFS filesystem, and that might not be super.

You could simple not print the warning in case this bothers you..

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
