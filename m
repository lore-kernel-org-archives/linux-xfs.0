Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92KGQjH083349 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 15:16:26 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xUIAfQiLbYhboVwT for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 13:17:49 -0700 (PDT)
Date: Wed, 3 Oct 2012 06:17:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
Message-ID: <20121002201748.GQ23520@dastard>
References: <506B1A03.7030600@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506B1A03.7030600@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 02, 2012 at 09:44:51AM -0700, Linda Walsh wrote:
> Something I've long wished for and wondered why it wasn't
> there -- was the ability to edit or re-edit a typed line,
> or recall a previous line from history.
> 
> I'd really find it useful to even have the ability for it to
> save previous command sessions / tool.
> 
> Given the usefulness of such, I was wondering why it had
> never been done?   Just it never rose to the top of some
> task list?  Or was there some desire to keep the tools
> less friendly and thus make them more difficult to use for
> casual use (i.e. it might have been a conscious design
> decision at some point).  Is that reasoning still a strong
> enough factor to keep things like that out of the mainline
> code?

xfsprogs has had this support via readline since, well, before I
started working on XFS....

$ sudo xfs_db -r /dev/vdb
xfs_db> inode 128
(reverse-i-search)`in': inode 128
....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
