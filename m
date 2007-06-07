Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 08:20:17 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l57FK6Wt019413
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 08:20:07 -0700
Message-ID: <46682221.8070705@dgreaves.com>
Date: Thu, 07 Jun 2007 16:20:01 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <46608E3F.4060201@dgreaves.com> <46609FAD.7010203@dgreaves.com>	 <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com>	 <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org>	 <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com>	 <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com>	 <4667DE2D.6050903@dgreaves.com> <e9e943910706070645p29519138i7e76b3a9649d387@mail.gmail.com> <46680F69.60105@dgreaves.com> <46681094.4070103@gmail.com> <466817EF.7090707@rtr.ca>
In-Reply-To: <466817EF.7090707@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Lord <lkml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>, Duane Griffin <duaneg@dghda.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

Mark Lord wrote:
> Tejun Heo wrote:
>>
>> Can you setup serial console and/or netconsole (not sure whether this
>> would work tho)?
> 
> Since he has good console output already, capturable by digicam,
> I think a better approach might be to provide a patch with extra 
> instrumentation..
> You know.. progress messages and the like, so we can see at what step
> things stop working.  Or would that not help ?
> 
> David, does scrollback work on your dead console?

hmmmm, scrollback doesn't currently _do_ anything.

But the messages didn't scroll there, they just appear (as the memory is 
restored I assume). The same messages appear during the fail-to-suspend case too.

Linus said at one point:
 > Ok, it wasn't a hidden oops. The DISABLE_CONSOLE_SUSPEND=y thing sometimes
 > shows oopses that are otherwise hidden, but at other times it just causes
 > more problems (hard hangs when trying to display something on a device
 > that is suspended, or behind a bridge that got suspended).

 > In your case, the screen output just shows normal resume output, and it
 > apparently just hung for some unknown reason. It *may* be worth trying to
 > do a SysRQ + 't' thing to see what tasks are running (or rather, not
 > running), but since you won't be able to capture it, it's probably not
 > going to be useful.

So I've since removed DISABLE_CONSOLE_SUSPEND=y
Should I put it back?

I was actually doing the netconsole anyway - but skge is currently a module - 
I've avoided making any changes to the config during all these tests but what 
the heck...

And wouldn't you know it.
Get netconsole working (ie new kernel with skge builtin) and I get the hang on 
suspend. Here's the netconsole output...

swsusp: Basic memory bitmaps created
Stopping tasks ... done.
Shrinking memory... done (0 pages freed)
Freed 0 kbytes in 0.03 seconds (0.00 MB/s)
Suspending console(s)


Given that moving something from module to builtin changes the behaviour I 
thought I'd bring these warnings up again (Andrew or Alan mentioned similar 
warnings being problems in another thread...)
Now, I have mentioned these before but there's been a lot going on so here you go:

   MODPOST vmlinux
WARNING: arch/i386/kernel/built-in.o(.text+0x968f): Section mismatch: reference 
to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0x9781): Section mismatch: reference 
to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0x9786): Section mismatch: reference 
to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0xa25c): Section mismatch: reference 
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.text+0xa303): Section mismatch: reference 
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.text+0xa31b): Section mismatch: reference 
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.text+0xa344): Section mismatch: reference 
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.exit.text+0x19): Section mismatch: 
reference to .init.text: (between 'cache_remove_dev' and 'powernow_k6_exit')
WARNING: arch/i386/kernel/built-in.o(.data+0x2160): Section mismatch: reference 
to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mce_work')
WARNING: kernel/built-in.o(.text+0x14502): Section mismatch: reference to 
.init.text: (between 'kthreadd' and 'init_waitqueue_head')


David
PS Gotta go - back in a couple of hours - let me know if there are any more 
tests to try.
