Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16E4YjP137750 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 08:04:34 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	c7YroGNP5Z0k8Ppe (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 06:04:31 -0800 (PST)
Date: Mon, 6 Feb 2012 09:04:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair segfaults with ag_stride option
Message-ID: <20120206140429.GA10395@infradead.org>
References: <4F293FCC.7010101@rhul.ac.uk>
	<20120202124248.GA12107@infradead.org>
	<4F2F23F3.9000402@rhul.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2F23F3.9000402@rhul.ac.uk>
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
To: Tom Crane <T.Crane@rhul.ac.uk>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Feb 06, 2012 at 12:50:59AM +0000, Tom Crane wrote:
> Hi Christoph,
>    Many thanks for the quick response and the patch.  It was a big
> help.  I was able to repair our 60TB FS in about 30 hours. I have a
> couple of questions;
> 
> (1) The steps in the progress report seem a little strange.  See the
> attachment. Is this expected?

Do you mean the out of order agno progress reports?  That's an artefact
of the ag_stride option which parallelizes processing of different
AGs, and expected.  It's not very nice but I don't have a smart idea
how to do much better either.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
