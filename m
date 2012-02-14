Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1EJje2Q119853 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 13:45:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZWsWxbLAzo4LGP1F (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Feb 2012 11:45:39 -0800 (PST)
Date: Tue, 14 Feb 2012 14:45:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
Message-ID: <20120214194535.GB7399@infradead.org>
References: <4F394116.8080200@cape-horn-eng.com>
	<20120214000924.GF14132@dastard> <4F3A5440.409@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3A5440.409@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 14, 2012 at 01:32:00PM +0100, Richard Ems wrote:
> > You won't if the directory traversal is seek bound and that is the
> > limiting factor for performance.
> 
> *Seek bound*? *When* is the directory traversal *seek bound*?

You read the inode for the directory first, then the external attribute
block for the ACLs, then if the directory isn't tiny you'll start reading
directory blocks, the more the larger the directory is, and if the
filesystem is close to beeing full they often will be non-contiguous.
Then you read the inode for each file/directory in it, then the external
attribute block, then the extent list, and so on.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
