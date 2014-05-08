Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 161BB7F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 07:54:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0DA33304064
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 05:54:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Ab2KvCllVITIiIga (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 05:54:07 -0700 (PDT)
Date: Thu, 8 May 2014 05:54:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140508125405.GA8096@infradead.org>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
	<20140507144822.GA4061@bfoster.bfoster>
	<20140507224755.GR5421@dastard> <20140508011256.GS5421@dastard>
	<20140508120228.GA47272@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140508120228.GA47272@bfoster.bfoster>
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

On Thu, May 08, 2014 at 08:02:28AM -0400, Brian Foster wrote:
> Missing a $ here...
> 
> Adding that, the single threaded build still breaks for me. E.g.,
> 
> - rm -rf fs/xfs
> - git checkout -- .
> - make

The kernel build systems doesn't support building a single module from
multiple makefiles.  Take a look how to handle a subdirectory in the
older XFS versions that still had that linux-2.6 subdirectory, it just
pulls the files in the subdirectory in from the main makefile, which
requires some tiny hacks for the include path.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
