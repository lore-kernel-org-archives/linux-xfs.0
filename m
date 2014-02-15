Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD93929DF8
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 17:50:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA9348F8039
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 15:50:31 -0800 (PST)
Received: from mail-vc0-f171.google.com (mail-vc0-f171.google.com
	[209.85.220.171]) by cuda.sgi.com with ESMTP id
	2nc3sl5zrPUv23WW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Feb 2014 15:50:30 -0800 (PST)
Received: by mail-vc0-f171.google.com with SMTP id le5so10360737vcb.2
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 15:50:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140214002427.GN13997@dastard>
References: <20140211210841.GM13647@dastard> <52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212071829.GE13997@dastard> <20140214002427.GN13997@dastard>
Date: Sat, 15 Feb 2014 15:50:29 -0800
Message-ID: <CA+55aFx=i6dbzCUZ6TwCMqniyS4C=tJx9+72p=EA+dU8Vn=2jQ@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>
Cc: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

[ Added linux-mm to the participants list ]

On Thu, Feb 13, 2014 at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Dave, the patch below should chop off the stack usage from
> xfs_log_force_lsn() issuing IO by deferring it to the CIL workqueue.
> Can you given this a run?

Ok, so DaveJ confirmed that DaveC's patch fixes his issue (damn,
people, your parents were some seriously boring people, were they not?
We've got too many Dave's around), but DaveC earlier pointed out that
pretty much any memory allocation path can end up using 3kB of stack
even without XFS being involved.

Which does bring up the question whether we should look (once more) at
the VM direct-reclaim path, and try to avoid GFP_FS/IO direct
reclaim..

Direct reclaim historically used to be an important throttling
mechanism, and I used to not be a fan of trying to avoid direct
reclaim. But the stack depth issue really looks to be pretty bad, and
I think we've gotten better at throttling explicitly, so..

I *think* we already limit filesystem writeback to just kswapd (in
shrink_page_list()), but DaveC posted a backtrace that goes through
do_try_to_free_pages() to shrink_slab(), and through there to the
filesystem and then IO. That looked like a disaster.

And that's because (if I read things right) shrink_page_list() limits
filesystem page writeback to kswapd, but not swap pages. Which I think
probably made more sense back in the days than it does now (I
certainly *hope* that swapping is less important today than it was,
say, ten years ago)

So I'm wondering whether we should remove that page_is_file_cache()
check from shrink_page_list()?

And then there is that whole shrink_slab() case...

               Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
