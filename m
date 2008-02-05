Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 14:51:36 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m15MpSua031723
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 14:51:29 -0800
Received: from malkusch.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19D9F5A43BB
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 14:51:49 -0800 (PST)
Received: from malkusch.de (malkusch.de [217.171.203.96]) by cuda.sgi.com with ESMTP id UdEK31tYV6kbtH2H for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 14:51:49 -0800 (PST)
From: Markus Malkusch <markus@malkusch.de>
Subject: Re: xfs_repair progress
Date: Tue, 5 Feb 2008 23:51:40 +0100
References: <200802051525.25101.markus@malkusch.de> <20080205172414.GA801@puku.stupidest.org>
In-Reply-To: <20080205172414.GA801@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802052351.40553.markus@malkusch.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

Chris Wedgwood:

> is it swapping?  (run vmstat)

I can't run vmstat, as I cancelt the xfs_repair before your mail. I remember 
that one CPU was fully loaded (Top said 107% CPU for xfs_repair). The system 
doesn't feel that it was swaping. But I also remember that there were about 
300M in Swap.

Anyway, I deleted all those hardlinks which reduced the number of inodes from 
about 1.5 million to 325735. Now I can run xfs_repair in two minutes.

Markus Malkusch
