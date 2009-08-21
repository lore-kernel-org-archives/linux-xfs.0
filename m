Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7LHx7Qg185933 for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 12:59:17 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E62293EB73A
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 10:59:44 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id Q32mFlI46yJTFkx7 for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2009 10:59:44 -0700 (PDT)
Date: Fri, 21 Aug 2009 19:59:43 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 13/17] xfs: Convert sync_page_range() to simple
	fdatawrite_range()
Message-ID: <20090821175943.GB10145@duck.novell.com>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-14-git-send-email-jack@suse.cz>
	<20090821172801.GA30254@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090821172801.GA30254@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri 21-08-09 19:28:01, Christoph Hellwig wrote:
> On Fri, Aug 21, 2009 at 07:24:03PM +0200, Jan Kara wrote:
> > +		error2 = filemap_fdatawrite_range(mapping, pos, pos + ret - 1);
> 
> I think this should be a filemap_write_and_wait_range
  Ah true, I somehow misinterpretted what xfs_write_sync_logforce() does.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
