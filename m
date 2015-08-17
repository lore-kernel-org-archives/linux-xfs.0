Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A174D7F37
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 15:03:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86BE5304032
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 13:03:01 -0700 (PDT)
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com
	[209.85.213.175]) by cuda.sgi.com with ESMTP id
	UxUEbEEPeKce04Ua (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 13:03:00 -0700 (PDT)
Received: by igui7 with SMTP id i7so63974000igu.0
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 13:03:00 -0700 (PDT)
Date: Mon, 17 Aug 2015 16:02:54 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150817200254.GG21075@mtj.duckdns.org>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150814111408.GB8710@quack.suse.cz>
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

Hello, Jan.

On Fri, Aug 14, 2015 at 01:14:09PM +0200, Jan Kara wrote:
> So the patch looks good to me. But the fact that is fixes Eryu's problem
> means there is something fishy going on. Either inodes get wrongly attached

Seriously, it shouldn't affect size syncing or xfs but then again my
understanding of xfs is severely limited.

> to b_dirty_time list or bdi_has_dirty_io() somehow misbehaves only
> temporarily and we don't catch it with the debug patch.
> 
> Can we add a test to wb_has_dirty_io() to also check whether it matches
> bdi_has_dirty_io()? Since Eryu doesn't use lazytime (I assume, Eryu, please
> speak up if you do), we could also warn if b_dirty_time lists get
> non-empty. Hmm?

Sure, will prep a patch soon.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
