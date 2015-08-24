Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD2D97F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 17:55:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF2978F8049
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 15:55:02 -0700 (PDT)
Received: from mail-yk0-f175.google.com (mail-yk0-f175.google.com
	[209.85.160.175]) by cuda.sgi.com with ESMTP id
	oC9xOLXb2JGoLVQH (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 15:55:01 -0700 (PDT)
Received: by ykdt205 with SMTP id t205so138713867ykd.1
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 15:55:00 -0700 (PDT)
Date: Mon, 24 Aug 2015 18:54:58 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824225458.GQ28944@mtj.duckdns.org>
References: <20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
	<20150824091959.GA2936@quack.suse.cz>
	<20150824145150.GA10029@mtj.duckdns.org>
	<20150824171144.GB27262@mtj.duckdns.org>
	<20150824190847.GA4234@quack.suse.cz>
	<20150824193242.GE28944@mtj.duckdns.org>
	<20150824210927.GA8823@quack.suse.cz>
	<20150824214535.GM28944@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824214535.GM28944@mtj.duckdns.org>
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
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

Hello,

On Mon, Aug 24, 2015 at 05:45:35PM -0400, Tejun Heo wrote:
> That isn't true for pages being dirtied through set_page_dirty().
> It's guaranteed that a dirty inode remains on one of the b_* lists
> till there's no dirty page and writeback is complete.

I got confused here.  inodes get removed from b_* once all IOs are
issued.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
