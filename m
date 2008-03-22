Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Mar 2008 04:58:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2MBvtMv019778
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 04:57:57 -0700
Received: from node1.t-mail.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D50A6D427F
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 04:58:28 -0700 (PDT)
Received: from node1.t-mail.cz (node1.t-mail.cz [62.141.0.166]) by cuda.sgi.com with ESMTP id fVXHgG3NhbG8eOl6 for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 04:58:28 -0700 (PDT)
Subject: Re: serious problem with XFS on nvidia IDE controller
From: Massimiliano Adamo <maxadamo@gmail.com>
In-Reply-To: <20080322005528.GA917@puku.stupidest.org>
References: <1206125778.6867.14.camel@dasa-laptop>
	 <20080321230609.GA31222@puku.stupidest.org>
	 <1206141665.6636.23.camel@dasa-laptop>
	 <20080322005528.GA917@puku.stupidest.org>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 12:57:47 +0100
Message-Id: <1206187067.6595.15.camel@dasa-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com


Il giorno ven, 21/03/2008 alle 17.55 -0700, Chris Wedgwood ha scritto:
> On Sat, Mar 22, 2008 at 12:21:05AM +0100, Massimiliano Adamo wrote:
> 
> > let's say the problem is: "ubuntu people" are neither hacker or
> > guru, and majority of people just use the default filesystem.
> 
> they have a bug tracker and kernel people, i'm sure if you have
> module problems there is someone who can look into it
> 

I have found this:
https://answers.launchpad.net/ubuntu/+question/7694
It's not completely true in my case (as I have /dev/sdxx), but it says
that this driver is not  there anymore.

The reason for removing that driver could be this one:
https://bugs.launchpad.net/ubuntu/+source/initramfs-tools/+bug/191007

Anyway, I wouldn't mind about the reason, and the point is that I should
recompile the kernel.
And no way, I am not using ubuntu to waste time recompiling kernels :)

> > Agree, but why no problems like this with reiser?
> 
> xfs don't journal data, by design, that might be what you are seeing,
> or something else, it's not clear without more information

Now for me it's difficult to reproduce this bug, as the installation
with XFS was completetely unsable (i was able to boot no more then
two/three times). At least I should create a new partition with xfs and
run tests over it. 


-- 
cheers
Massimiliano
