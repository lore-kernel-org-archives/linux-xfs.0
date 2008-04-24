Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 08:39:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3OFd34c001755
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 08:39:04 -0700
Received: from rn-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C035D15CDF64
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 08:39:40 -0700 (PDT)
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.184]) by cuda.sgi.com with ESMTP id BfZo3afZS8n9ROS5 for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 08:39:40 -0700 (PDT)
Received: by rn-out-0910.google.com with SMTP id e24so1499976rng.8
        for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 08:39:39 -0700 (PDT)
Message-ID: <c33e4330804240839x60dad34elaad6459aeef00d98@mail.gmail.com>
Date: Thu, 24 Apr 2008 11:39:39 -0400
From: "Michael Darling" <darlingm@gmail.com>
Subject: Re: XFS drops create/delete files to 6.6% of EXT3 (software raid) and to 0.6% of EXT3 (3ware hardware raid)
In-Reply-To: <20080424063102.GX103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>
	 <4810062F.50100@sandeen.net> <20080424053358.GW103491721@sgi.com>
	 <c33e4330804232323p1b6d5121oc56b0c43663a4e84@mail.gmail.com>
	 <20080424063102.GX103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Thu, Apr 24, 2008 at 2:31 AM, David Chinner <dgc@sgi.com> wrote:
> Are you using write caching on the RAID card? If yes, then you need a BBU
> for the card if you want to enable the write cache safely.

I am using write caching.  Without write caching, the 3ware
9650SE-4LMPL crawls along at 5MB/sec writing.  3ware tech support said
awful write performance without write caching to a RAID 5 was typical,
that write caching really needs to be on for a RAID 5.

Is nobarrier safe to use, as long as before putting real data on the
RAID I obtain a BBU for the 3ware card, in addition to the existing
battery backup for the server as a whole?


On Thu, Apr 24, 2008 at 10:20 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Which program is this that you are using to measure this, bonnie++, or?

I'm also using bonnie++, v1.03 from http://www.coker.com.au/bonnie++/
