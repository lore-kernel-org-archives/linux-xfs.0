Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2F9JGir092480 for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 04:19:16 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id k4RjOwmF2Pde3CCz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Mar 2012 02:19:14 -0700 (PDT)
Date: Thu, 15 Mar 2012 10:19:12 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] xfs: Fix oops on IO error during
	xlog_recover_process_iunlinks()
Message-ID: <20120315091912.GC32209@quack.suse.cz>
References: <1331801705-1145-1-git-send-email-jack@suse.cz>
	<20120315090800.GA2887@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120315090800.GA2887@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, stable@kernel.org, xfs@oss.sgi.com

On Thu 15-03-12 05:08:00, Christoph Hellwig wrote:
> > +		xfs_buf_hold(agibp);
> > +		xfs_buf_relse(agibp);
> 
> This is a very awkward way to write
> 
> 		xfs_buf_unlock(agibp);
  Hmm, looking into the functions you are right. I'll change this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
