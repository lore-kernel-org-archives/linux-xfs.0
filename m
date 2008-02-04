Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Feb 2008 20:50:11 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m144o4qf023528
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2008 20:50:08 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EB42596874
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2008 20:50:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id pfkDJEY8p4t4HI2O for <xfs@oss.sgi.com>; Sun, 03 Feb 2008 20:50:27 -0800 (PST)
Message-ID: <47A69990.3030501@sandeen.net>
Date: Sun, 03 Feb 2008 22:50:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: unpushed 4-month-old mods?
References: <47A694F3.9010307@sandeen.net> <20080204044611.GF155407@sgi.com>
In-Reply-To: <20080204044611.GF155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Sun, Feb 03, 2008 at 10:30:43PM -0600, Eric Sandeen wrote:
>> At least these three mods which I did back in September to get Fedora 8
>> / 2.6.23 into shape on 4k stacks, and a bugfix, are still not pushed to
>> kernel.org, and are missing in 2.6.24...
>>
>> Is there any reason for the holdup?  Makes me wonder what else isn't
>> pushed...
> 
> The holdup is that we drew a line in the sand for the 2.6.24 before
> 2.6.23 was released. We did this because of the massive amount of invasive
> change we already had queued up for 2.6.24.  All those mods that got
> held up will be pushed into 2.6.25 release.
> 
> Given the problems with the readdir changes (which still isn't 100% right
> given we've had at least one bug report of a crash in the readdir code
> post 2.6.24 release), we couldn't have handled much more change in that
> release.....

Ok, as long as you guys know what's up :)

I just spent the evening sorting out why Fedora 9 was blowing up on
install, when Fedora 8 was working so well... :(

-Eric
