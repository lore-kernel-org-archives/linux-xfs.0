Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Feb 2007 10:06:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1DI5qm7009228
	for <xfs@oss.sgi.com>; Tue, 13 Feb 2007 10:05:53 -0800
Received: from [172.16.145.22] (sjcc176x121.sjccnet.com [216.1.176.121])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id C109B1805FF93
	for <xfs@oss.sgi.com>; Tue, 13 Feb 2007 12:05:50 -0600 (CST)
Message-ID: <45D1FDFC.20407@sandeen.net>
Date: Tue, 13 Feb 2007 10:05:48 -0800
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: a modest proposal for 4kstacks & xfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

XFS continues to come up against 4k stacks, despite the best efforts of 
several people to slim down xfs a bit (and in fact it seems ok over 
simple storage these days), people are always able to stack up enough IO 
path to push the limits of a 4k stack.

What would people think of adding a module parameter to xfs, i.e.

modprobe xfs 4kstacks_may_break=1

or somesuch; and without this modprobe would fail on a 4kstacks kernel 
with a "helpful" message.  This would at least require some positive 
action on the admin's part to acknowledge that there is some risk to 
using xfs with 4k stacks.  (unfortunately something like the Fedora 
installer would of course have to add this by default when installing on 
xfs, maybe it could also warn the user of the risk...)

I hate to further the meme of "xfs won't work with 4kstacks" but the 
truth is that there are IO path scenarios where it can lead to problems.

What do folks think; useful?  pointless?  too heavy-handed?

-Eric
