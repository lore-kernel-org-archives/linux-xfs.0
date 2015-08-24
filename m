Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F19A7F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 17:54:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 681448F804B
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 15:54:00 -0700 (PDT)
Received: from mail-yk0-f181.google.com (mail-yk0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	4qoVKOcIQ67VrRlV (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 15:53:59 -0700 (PDT)
Received: by ykdt205 with SMTP id t205so138692590ykd.1
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 15:53:58 -0700 (PDT)
Date: Mon, 24 Aug 2015 18:53:56 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824225356.GP28944@mtj.duckdns.org>
References: <20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150820061224.GG17933@dhcp-13-216.nay.redhat.com>
	<20150820143626.GI17933@dhcp-13-216.nay.redhat.com>
	<20150820143735.GJ17933@dhcp-13-216.nay.redhat.com>
	<20150820165537.GA2044@mtj.duckdns.org>
	<20150820230451.GT714@dastard>
	<20150824181038.GA28944@mtj.duckdns.org>
	<20150824222720.GD714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824222720.GD714@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

Hello, Dave.

On Tue, Aug 25, 2015 at 08:27:20AM +1000, Dave Chinner wrote:
> > I'm still a bit confused.  What prevents the following from happening?
> > 
> > 1. io completion of last dirty page of an inode and work item for
> >    xfs_setfilesize() is queued.
> > 
> > 2. inode removed from dirty list.
> 
> The inode has already been removed from the dirty list - that
> happens at inode writeback submission time, not IO completion.

Ah, yeah, right, somehow was thinking requeue_io() was being called
from completion path.  That's where I was confused.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
