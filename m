Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 20:34:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7C3YBkh014712
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 20:34:11 -0700
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E03B7F2E40A
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 20:35:10 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id gq7X60tq8Ahz2nH2 for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 20:35:10 -0700 (PDT)
Message-ID: <48A104EB.6040509@tlinx.org>
Date: Mon, 11 Aug 2008 20:35:07 -0700
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net> <48A0F686.2090700@tlinx.org> <48A0F9FC.1070805@sandeen.net>
In-Reply-To: <48A0F9FC.1070805@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> I haven't looked closely at #2 but there have been so many lockdep
> reports for xfs, and so many explanations of why they don't always get
> along, you'll probably be able to find something with some searching.
>   
----

      So in debugging mysterious 'lockups' where I've, at least once, 
noticed a
hangcheck_timer elapse, this lock-checking stuff is just nonsensical?  
It is very
frustrating trying to turn on debug tools in the kernel and get so many 
false positives.

Would it be possible or, perhaps, desirable to eliminate the buggy 
lock-checks in the
xfs code?

Meanwhile...back to finding reasons for the semi-random, periodic hanging...
;^/
