Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BAF0E7F3F
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 14:46:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D861AC001
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 12:46:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ymBNWeD7bLmzsrpQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 13 Sep 2014 12:46:01 -0700 (PDT)
Date: Sat, 13 Sep 2014 12:45:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] xfs_io: add mremap command
Message-ID: <20140913194559.GA28479@infradead.org>
References: <54111610.4080604@redhat.com>
 <54132553.9090202@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54132553.9090202@sandeen.net>
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

On Fri, Sep 12, 2014 at 11:54:43AM -0500, Eric Sandeen wrote:
> This adds a simple mremap command to xfs_io.
> 
> It does not take a start address; it uses the existing
> start address, so the sized passed will be the new total
> size of the mapping.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me, but I'd feel much more comfortable about merging it
if we had an xfstests test case that actually exercises it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
