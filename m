Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E52277F51
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 11:43:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C0B608F8035
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 09:43:10 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id L2Gg9663D1UN6Lf9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2015 09:43:03 -0800 (PST)
Date: Mon, 12 Jan 2015 18:42:58 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/6] xfs: truncate vs page fault IO exclusion
Message-ID: <20150112174258.GN4468@quack.suse.cz>
References: <1420669543-8093-1-git-send-email-david@fromorbit.com>
	<20150108122448.GA18034@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150108122448.GA18034@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com

On Thu 08-01-15 04:24:48, Christoph Hellwig wrote:
> > This patchset passes xfstests and various benchmarks and stress
> > workloads, so the real question is now:
> > 
> > 	What have I missed?
> > 
> > Comments, thoughts, flames?
> 
> Why is this done in XFS and not in generic code?
  I was also thinking about this. In the end I decided not to propose this
since the new rw-lock would grow struct inode and is actually necessary
only for filesystems implementing hole punching AFAICS. And that isn't
supported by that many filesystems. So fs private implementation which
isn't that complicated looked like a reasonable solution to me...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
