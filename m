Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B4C87F4C
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:48:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B7F28F804C
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 13:48:01 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id g360j9QqB4xCm4Xr for
	<xfs@oss.sgi.com>; Tue, 29 Jan 2013 13:48:00 -0800 (PST)
Message-ID: <20821.192.104.24.222.1359496079.squirrel@secure.skymagik.net>
Date: Tue, 29 Jan 2013 16:47:59 -0500 (EST)
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
In-Reply-To: <5107124E.70607@sandeen.net>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<5107124E.70607@sandeen.net>
MIME-Version: 1.0
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
To: sandeen@sandeen.net
Cc: xfs@oss.sgi.com

In a previous message, Eric Sandeen wrote:
>
> That's correct.  However, I have run xfs root on Centos5, and am
> currently running xfs root on RHEL6.  On md raid1 in both instances. ;)
>

Eric,

Try it with 5.9 and md raid1.  I bet you won't be running it very
much longer.  ;-)

Unless of course you can't reproduce it.


>
> Just to be absolutely sure, do you have any xfs-kmod or kmod-xfs
> installed? If so, remove it.
>

No kmod.  I only use the kmod on 32-bit platforms.  As you know, it is
not needed on 64-bit.

This system is a freshly kickstarted system with only about 200 packages
installed (minimal base system just for stability testing):

[root@test9][/root]# rpm -qa | fgrep xfs
xfsprogs-2.9.4-1.el5.centos
xfsdump-2.2.46-1.el5.centos
[root@test9][/root]# rpm -qa | fgrep kmod
[root@test9][/root]# uname -a
Linux test9.xxxx.xxx 2.6.18-348.el5 #1 SMP Tue Jan 8 17:53:53 EST 2013 x86_6
4 x86_64 x86_64 GNU/Linux


>> (why I still don't understand,
>> since I fixed the issues with Anaconda for myself and can Kickstart
>> systems with XFS all day long).
>
> It's for non-technical reasons.
>

Hmmm, yeah, well I do understand.  ;-)  Just drives me nuts.


>
> so it's hanging on the way down I guess?
>
> I see:  "md: md1 switched to read-only mode"
>
> Was that there before?

Yes.  It's the very last thing printed when using any newer 5.X system.
Then it's supposed to physically reboot or shutdown.  But this is where it
hangs.  I will reply back to the xfs list (to a message from Ben) later
tonight with some more output from the serial console including a
traceback.

I'll also add these details in the open CentOS bug.


>
> I don't see anything obvious between the two kernels you mention, and I
> can't spend a ton of time digging into this, since most of my day is
> taken up supporting the RHEL customers who pay my salary, nudge nudge.
> ;)

Any help is appreciated.  Finding this bug may possibly help
ferret out another more possibly nefarious bug, which is why I don't
need instant gratification here.  I'm only looking to assist with the
solution, not cause more stress.

The "company" that I work for from 9-5 has an extensive RHEL 5.X and 6.X
deployment with Satellite, channels, full support, the whole nine yards.
They don't color outside the lines as I do -- they use ext3 for the root
filesystem instead.  Their loss.  :-)

So don't worry, said "company" "gives" plenty to the "cause".  ;-)

However, after 5pm, I do unrelated personal work and projects unrelated
to said "company", and one of those things is working with CentOS and
Ubuntu.  Using XFS quite extensively.


>
> I'd look at the kernel changelogs for xfs & md, and see if anything
> seems plausible.  Maybe diff the sources & see what changed, etc.
>

Yeah, I took a half-hearted look already.  But didn't diff any source
code yet.  I saw a freeze/thaw change and a few other md changes that
were suspect.  But haven't had a chance to dig deeper.

Thanks again.

-- Tom


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
