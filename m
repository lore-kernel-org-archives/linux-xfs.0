Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 17:42:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O0gNv9025408
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 17:42:24 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21D5B1B159B4
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 17:44:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id gYbGmc9QoHzIy2Bo for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 17:44:09 -0700 (PDT)
Message-ID: <49011A58.9040403@sandeen.net>
Date: Thu, 23 Oct 2008 19:44:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] convert xfs_getbmap to take formatter functions
References: <490103C9.9080900@sandeen.net> <20081023233538.GG18495@disturbed>
In-Reply-To: <20081023233538.GG18495@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs mailing list <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Oct 23, 2008 at 06:07:53PM -0500, Eric Sandeen wrote:
>> Preliminary work to hook up fiemap, this allows us to pass in an
>> arbitrary formatter to copy extent data back to userspace.
> 
> Is there a fiemap test program around anywhere?
> 
> If so, would it be appropriate to include it in xfstests and write
> a quick regression test for it? We'd probably need to also check
> xfs_bmap gives the same output as fiemap....

I have a very hacky app/test that can exercise the interface; there is
nothing, as far as I know, that will create "every" possible combination
of output and test for correct output ... but yes, this interface should
get at least something in the test suite.

-Eric

> Cheers,
> 
> Dave.
