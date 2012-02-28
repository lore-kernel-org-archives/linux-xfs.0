Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1S8Ykqk169726 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 02:34:46 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	W8XULG0a7B3E2UPB (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 00:34:46 -0800 (PST)
Date: Tue, 28 Feb 2012 03:34:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Warning from unlock_new_inode
Message-ID: <20120228083444.GB22995@infradead.org>
References: <20120222220137.GB3650@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120222220137.GB3650@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, Feb 22, 2012 at 11:01:37PM +0100, Jan Kara wrote:
>   Hello,
> 
>   while running fsstress on XFS partition with 3.3-rc4 kernel + my freeze
> fixes (they do not touch anything relevant AFAICT) I've got the following
> warning:

That's stressing including freezes or without?  Do you have a better
description of te workload?

Either way it's an odd one, I can't see any obvious way how this would
happen.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
