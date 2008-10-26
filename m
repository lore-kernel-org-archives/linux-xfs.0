Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 20:01:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9Q31oNx030284
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 20:01:50 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14E1B12AA59F
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 20:01:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id b3E5UuBUQH5HDmc0 for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 20:01:50 -0700 (PDT)
Message-ID: <4903DD9C.60000@sandeen.net>
Date: Sat, 25 Oct 2008 22:01:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: check for dmapi headers
References: <490362FB.5000300@sandeen.net> <20081025201840.GB28002@infradead.org> <49037F50.3010400@sandeen.net> <20081025233231.GB11948@disturbed>
In-Reply-To: <20081025233231.GB11948@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Sat, Oct 25, 2008 at 03:19:28PM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> On Sat, Oct 25, 2008 at 01:18:35PM -0500, Eric Sandeen wrote:
>>>> I'm no autoconf wizard, but I think this does the trick to allow
>>>> xfstests build to succeed when dmapi headers are missing, as
>>>> they probably will be for any distro that doesn't ship with
>>>> dmapi in the kernel, or dmapi userspace.
>>>>
>>>> AFAIK the dmapi-related tests all fail gracefully with "not run."
>>> Looks sane to me, although the dmapi library can of course be shipped
>>> without kernel support - it's just rather useless that way :)
>> true, but very, very little motivation for that :)
> 
> $ dpkg -l libdm0\*
> Desired=Unknown/Install/Remove/Purge/Hold
> | Status=Not/Inst/Cfg-files/Unpacked/Failed-cfg/Half-inst/trig-aWait/Trig-pend
> |/ Err?=(none)/Hold/Reinst-required/X=both-problems (Status,Err: uppercase=bad)
> ||/ Name               Version            Description
> +++-==================-==================-====================================================
> ii  libdm0             2.2.8-1            Data Management API runtime environment
> ii  libdm0-dev         2.2.8-1            Data Management API static libraries and headers
> $

I meant my motivation ;)

-Eric
