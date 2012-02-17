Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HHLE7u098354 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 11:21:17 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	h71gpOgwNED9boX4 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 09:21:11 -0800 (PST)
Date: Fri, 17 Feb 2012 12:21:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: more careful size grep in 256
Message-ID: <20120217172110.GA21610@infradead.org>
References: <4F3AA739.1000009@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3AA739.1000009@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 14, 2012 at 10:26:01AM -0800, Eric Sandeen wrote:
> Removing the "-F" flag in xfs_io changed stat output.
> 
> Before the change when -F was used, whether or not the file
> was on xfs, it skipped the extra FSGEOM call.  Now that -F is 
> removed, it calls FSGEOM if the file is on an xfs fs.  The "size" 
> grep in test 256 was a bit too loose and matched 2 lines if the
> FSGEOM output was present, breaking the test.
> 
> A more specific grep for stat.size fixes this.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
