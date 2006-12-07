Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 15:10:08 -0800 (PST)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7NA0aG010906
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 15:10:01 -0800
Message-ID: <45789ED4.5000203@falconstor.com>
Date: Thu, 07 Dec 2006 18:08:04 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com>	 <457854CB.5030507@sandeen.net>  <45787ED4.5070801@falconstor.com>	 <1165525906.30459.25.camel@edge>  <45788927.4030207@falconstor.com>	 <1165527628.30459.31.camel@edge>  <45788CD1.9010509@falconstor.com> <1165529205.30459.36.camel@edge> <457892BB.1000203@falconstor.com> <45789341.6000809@sandeen.net> <457894DF.70603@falconstor.com> <457895FA.9010203@sandeen.net> <45789B27.1050507@falconstor.com> <45789B83.5010800@sandeen.net>
In-Reply-To: <45789B83.5010800@sandeen.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, nscott@aconex.com

Eric Sandeen wrote:
> 
> You don't have multiple concurrent freezes happening do you....
> 
> -Eric
> 

Nope, I don't need to. Now it happens on the first call to xfs_freeze. 
Sometimes in the past I did freeze, unfreeze, and then freeze before it 
happened, but this was still serialized from the same terminal window.

Oh, could strace be the reason as to why it now always happens on the 
first invocation of the freeze command? Maybe it affects the wait 
calls... Well, without strace it would probably just happen on the 
second invocation of freeze (after unfreeze) like it did on RHELAS4U2...

My test case is very simple, the only thing special is that I simplified 
my test case so much that I end up using a file as my disk (setup as a 
loopback device). However, the problem was initially discovered using a 
real disk, so I don't think that is the problem.

If you're interested I can forward the test case involving probably less 
than 10 commands and a simple Perl script of maybe 20 lines.

-- 

Geir A. Myrestrand
