Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D86577F76
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 07:37:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5CD0304039
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 05:37:03 -0800 (PST)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	o3pJzdaaXMZQ5K7o (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 05:37:01 -0800 (PST)
Received: by mail-wi0-f180.google.com with SMTP id h11so2967989wiw.1
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 05:37:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150220091326.GD21248@dhcp22.suse.cz>
References: <20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150219110124.GC15569@phnom.home.cmpxchg.org>
	<20150219122914.GH28427@dhcp22.suse.cz>
	<20150219125844.GI28427@dhcp22.suse.cz>
	<201502200029.DEG78137.QFVLHFFOJMtOOS@I-love.SAKURA.ne.jp>
	<20150220091326.GD21248@dhcp22.suse.cz>
Date: Fri, 20 Feb 2015 14:37:00 +0100
Message-ID: <CAAxjCEzWJy4+VoJ51A46ioF7NJqumy+RtCRRHnSVN0_1=gi7yQ@mail.gmail.com>
Subject: Re: How to handle TIF_MEMDIE stalls?
From: Stefan Ring <stefanrin@gmail.com>
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
To: Michal Hocko <mhocko@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, dchinner@redhat.com, oleg@redhat.com, Linux fs XFS <xfs@oss.sgi.com>, linux-mm@kvack.org, mgorman@suse.de, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, rientjes@google.com, akpm@linux-foundation.org, fernando_b1@lab.ntt.co.jp, torvalds@linux-foundation.org

>> We don't know how many callers will pass __GFP_NOFAIL. But if 1000
>> threads are doing the same operation which requires __GFP_NOFAIL
>> allocation with a lock held, wouldn't memory reserves deplete?
>
> We shouldn't have an unbounded number of GFP_NOFAIL allocations at the
> same time. This would be even more broken. If a load is known to use
> such allocations excessively then the administrator can enlarge the
> memory reserves.
>
>> This heuristic can't continue if memory reserves depleted or
>> continuous pages of requested order cannot be found.
>
> Once memory reserves are depleted we are screwed anyway and we might
> panic.

This discussion reminds me of a situation I've seen somewhat
regularly, which I have described here:
http://oss.sgi.com/pipermail/xfs/2014-April/035793.html

I've actually seen it more often on another box with OpenVZ and
VirtualBox installed, where it would almost always happen during
startup of a VirtualBox guest machine. This other machine is also
running XFS. I blamed it on OpenVZ or VirtualBox originally, but
having seen the same thing happen on the other machine with neither of
them, the next candidate for taking blame is XFS.

Is this behavior something that can be attributed to these memory
allocation retry loops?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
