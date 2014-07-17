Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A6A97FD5
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 04:05:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A8FA30404E
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 02:05:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id gy4Mw9sIKKEz6ZuH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 02:05:50 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1X7hdO-000498-8Z
	for xfs@oss.sgi.com; Thu, 17 Jul 2014 09:05:50 +0000
Date: Thu, 17 Jul 2014 02:05:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsrestore -t and default location of housekeeping dir
Message-ID: <20140717090550.GB27425@infradead.org>
References: <20140714071935.GB29541@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140714071935.GB29541@teal.hq.k1024.org>
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
To: xfs@oss.sgi.com

On Mon, Jul 14, 2014 at 09:19:35AM +0200, Iustin Pop wrote:
> Hi,
> 
> While testing a just-made dump with via 'xfsrestore -t', I learned that
> the default housekeepingdir path is still under the original filesystem.
> My xfsrestore therefore failed, since that filesystem was read-only.
> 
> Since '-t' should denote a pure no-op operation, with no changes, would
> it make more sense to default the housekeeping location to a temporary
> location if it is used?

It seems to me like -t shouldn't recreate the files in the housekeeping
directory at all.  I did take a brief look at the code and is a huge
mess that seems to recreate files unconditionally, so I don't really
have a good solution for this yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
