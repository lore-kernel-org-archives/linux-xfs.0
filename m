Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA58F7CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 10:02:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 92E3A8F8035
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 08:02:17 -0700 (PDT)
Received: from resqmta-ch2-02v.sys.comcast.net
	(resqmta-ch2-02v.sys.comcast.net [69.252.207.34]) by
	cuda.sgi.com with ESMTP id oh210bTuBXxYApq9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Sep 2016 08:02:13 -0700 (PDT)
Subject: Re: [INFO] xfs: kernel debugging with trace_printk()
References: <20160906082045.GJ30056@dastard>
From: Joshua Kinard <kumba@gentoo.org>
Message-ID: <e5b07fd7-3c4e-e183-008b-877b0c237b72@gentoo.org>
Date: Tue, 13 Sep 2016 11:02:01 -0400
MIME-Version: 1.0
In-Reply-To: <20160906082045.GJ30056@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 09/06/2016 04:20, Dave Chinner wrote:
> Hi folks,
> 
> I learnt something today that made my life immediately better:
> trace_printk(). After I discovered it, Darrick mentioned on #xfs
> that he didn't know about it either, hence I figured I should send
> an email to the list so that everyone working with XFS knows about
> it....
> 
> Yes, this community service starts with me admitting I am a heavy
> user of printk() for debugging code, and I'm about to go cold
> turkey.
> 
> "Me Ugg, Caveman. Big Club mine. Hit Stuff Hard. Fix It Good."
> 
> But, really, everyone does the same thing - anyone what says they
> don't is lying. :P
> 
> You all know the drill: add a printk, recompile, test, see what gets
> output on the console, go back to step one. It starts like this:
> 
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> 
> Then if there's lots of output, you turn off the console output with
> 'dmesg -n X' and look at the output in /var/log/messages instead, or
> directly run dmesg to see it. You spend time wading through reams of
> output.
> 
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> 
> Then you start going mad because the code runs so slow and it's
> extremely hard to correlate with other diagnostic information (such
> as trace events) that you're also using to try work out what is
> going on. And then you end up adding so much debug that it turns
> into a heisenbug and you think you're going insane...
> 
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> 
> And, finally, when you think you've fixed the problem, you remove
> the debug printk()s and find the problem is still there....
> 
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> Eat, sleep, printk(), repeat.
> 
> So, avoid the existential crisis and the hard liquor and drugs:
> use trace_printk() and `trace-cmd record -e printk` to maintain your
> sanity!
> 
> (You all know about trace-cmd, right?)
> 

[snip]

But this assumes one can even get to a working shell prompt from which one can
run commands, like 'trace-cmd'.  I've been trying to hunt down and fix various
bugs in running Linux on some of the old SGI machines (which is an appropriate
statement for this list), and some of them, you never even get as far as a
working shell prompt that accepts keyboard or serial input (thanks, IOC3!).

Usually, I'm not only doing the "Eat, sleep, printk(), repeat." dance.  In some
instances, my only workable debugging aid is printk() (or actually the pr_*()
versions), and a DSLR mounted on a tripod with a fast shutter speed, high ISO,
and a remote trigger to try and catch error messages as they zoom by on the
screen.  Luckily, I have a really old LCD flat panel that has a slow refresh
rate, so I can sometimes read the fading text of the errors as they're
overwritten by new output.

Now I just need to figure out how to write a kgdb shim driver for the IOC3 chip
so I can get GDB to do remote debugging over serial.  That will *really* help
hunt down some of the really screwy bugs I've run into (like Onyx2's mysterious
hard-lockup NUMA bug).

And yes, the SGI machines that do work well all use XFS as their Linux
filesystem of choice :)

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
6144R/F5C6C943 2015-04-27
177C 1972 1FB8 F254 BAD0 3E72 5C63 F4E3 F5C6 C943

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
