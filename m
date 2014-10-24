Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 290DB7F74
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 01:17:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AC808AC003
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 23:17:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id uh0ustGmomqHpv6x (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Oct 2014 23:17:20 -0700 (PDT)
Date: Thu, 23 Oct 2014 23:17:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: enable sparse checking
Message-ID: <20141024061718.GA15341@infradead.org>
References: <54498F4A.9030207@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54498F4A.9030207@redhat.com>
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

On Thu, Oct 23, 2014 at 06:29:14PM -0500, Eric Sandeen wrote:
> Enable "make C=1" or "make C=2" to do sparse checking.
> Blatantly ripped off from djwong's patch in e2fsprogs to
> do the same.
> 
> Note, this requires unreleased sparse after v0.5, which
> enables the CHAR_BIT definition; otherwise it chokes.

I'm pretty sure I used to be able to do sparse checks on xfsprogs using

CC=cgcc make

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
