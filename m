Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6DEhQP2053842 for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 09:43:26 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ADD2A4B322
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 07:51:29 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 8FHAC0Pxqe7YLsMm for
	<xfs@oss.sgi.com>; Mon, 13 Jul 2009 07:51:29 -0700 (PDT)
Message-ID: <4A5B4833.9070300@sandeen.net>
Date: Mon, 13 Jul 2009 09:44:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to simulate journal corruption
References: <SNT109-W2390816D3EF297CE0D07DEEC220@phx.gbl>
In-Reply-To: <SNT109-W2390816D3EF297CE0D07DEEC220@phx.gbl>
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
To: crow al <al-john@hotmail.com>
Cc: xfs@oss.sgi.com

crow al wrote:
> Hi, there
> 
> I'm a QA engineer from Cisco. I'm working on a test case concerning XFS
> journal playback failure, which needs to manually inject error to XFS.
> 
> I did some google work but get no luck. Then I think maybe XFA-QA could
> give me some advice. That why I come to here.
> 
> Is there anyone could tell me how to inject error into XFS or is there
> any tool could be used?
> 
> Wish for your response.
> 
> Thanks & Regards.
> Lv Wentao.

test 044 in xfstests runs something called "loggen" which will generate
log traffic to be replayed on mount, if I'm reading it right.  Of course
that's an uncorrupted log ...

There is another tool called "fsfuzzer" which writes random junk over a
filesystem.  You could probably combine the two tools to create valid
logs to replay, and then write varying degrees of junk on top with
fsfuzzer, and try to replay the result.

You could probably even use fsfuzzer "stock" and just restrict the
fuzzing to the log portion of the filesystem.

I'm not sure what kinds of errors you are trying to catch - oopses,
hangs, improperly replaying a corrupted log, etc - but it sounds well
worth doing.  FWIW when I used fsfuzzer, it often ran into problems in
the log, so I imagine you'll uncover some interesting things; if you do,
please share.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
