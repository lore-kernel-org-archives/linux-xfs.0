Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 23:25:07 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0G7P008020986
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 23:25:04 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83E44C5678D
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 23:25:18 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.177]) by cuda.sgi.com with ESMTP id R2c0oTmlMZZEADmt for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 23:25:18 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so276931waf.18
        for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 23:25:17 -0800 (PST)
Message-ID: <d711080c0801152325g3d57965dm92e3687a5f98c5f6@mail.gmail.com>
Date: Wed, 16 Jan 2008 12:55:17 +0530
From: "Gopala Krishna" <gopalakrishna.n.m@gmail.com>
Subject: Re: Question related to XFS sync , especially fsync
In-Reply-To: <20080116064840.GA5725@puku.stupidest.org>
MIME-Version: 1.0
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
	 <20080114224245.GT155259@sgi.com>
	 <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com>
	 <478CCEAC.9010008@sandeen.net>
	 <1200436012.9463.184.camel@edge.scott.net.au>
	 <d711080c0801152243h7613bbean9daeab8658f75408@mail.gmail.com>
	 <20080116064840.GA5725@puku.stupidest.org>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: nscott@aconex.com, xfs@oss.sgi.com

Thank you Chris.
While  replying  to Eric, I mentioned why we are doing that. We are
basically providing interfaces to back up applications in a pure storage
environment that deals with the  back up at block level (sector level) and
hence depending upon different file system, we need to get information about
file like it's extent information and associated block numbers etc. To
extract these there is no system call and hence we are depending on disk
layout published by file system vendors and the header file provided by
them.
If there is a user level system call to deal with the extent information
etc, we can use , but many file system is not providing that. Basically if
we give file it should eb in aposition to display metadata informations
including extents and corresponding logical block numbers and device
offsets.

I have to do it programitically and hence if I have some system call rather
than command, that would be helpful. Freeze/unfreeze is a command it seems
right?

Thanks,
Gopal.





On 1/16/08, Chris Wedgwood <cw@f00f.org> wrote:
>
> On Wed, Jan 16, 2008 at 12:13:54PM +0530, Gopala Krishna wrote:
>
> > Is there any XFS call from user level to flush metadata for a given
> > file or complete log to disk?
>
> like a said earlier, try freeze/unfreeze
>
> you've not explained what you're doing (well, why you're doing it)
>
> it sounds very problematic by design
>


[[HTML alternate version deleted]]
