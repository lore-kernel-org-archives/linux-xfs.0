Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n191UYZW208995 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 19:30:35 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6D1318F15C6
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 17:29:54 -0800 (PST)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id L9SAsXCT0F7hyeEj for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 17:29:54 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch 2/5] [PATCH] acl: various improvements for test/run
Date: Mon, 9 Feb 2009 02:29:47 +0100
References: <20090108015355.613058570@ifup.org>
	<20090108015418.699729152@ifup.org>
In-Reply-To: <20090108015418.699729152@ifup.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902090229.47550.agruen@suse.de>
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
To: xfs@oss.sgi.com
Cc: tes@sgi.com, Brandon Philips <bphilips@suse.de>, brandon@ifup.org

Brandon,

the version of the run script in the attr and acl packages is somewhat dated; 
I have made a few improvements since. I'll move this out of {acl,attr}/test 
and put the latest version into the libmisc/ directory.

Note that I recently rewrote the run script from scratch. Unlike the old 
version, the new one runs the whole script inside the same shell. There are 
still a few problems to be solved; most importantly, user switching doesn't 
work, yet. Eventually I want to replace the old version, though.

	http://savannah.nongnu.org/projects/shrun


On Thursday, 8 January 2009 2:53:57 brandon@ifup.org wrote:
> First move process_test to avoid a warning:
>
> main::process_test() called too early to check prototype at ./run line 47.
> main::process_test() called too early to check prototype at ./run line 60.

The new version had this fixed already.

> Create two ENV variables TUSER and TGROUP to get the user/group
> running the test.

Good idea. Added.

(Stuff like this will be obsolete with shrun.)

> Add a | test line that is similar to > but is interpreted as a regular
> expression.

I have been using ">~" instead of "|" for that. I'm still not sure that 
including regular expression matching was a good idea though, so shrun 
doesn't have any of that yet. We'll se how things develop.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
