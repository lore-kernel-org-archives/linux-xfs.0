Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Jun 2007 16:02:16 -0700 (PDT)
Message-ID: <4661EFBB.5010406@dgreaves.com>
Date: Sat, 02 Jun 2007 23:31:23 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl>
In-Reply-To: <200706020122.49989.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Linus Torvalds <torvalds@osdl.org>, xfs@oss.sgi.com
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, netdev@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>

This started as a non-regression bug-report about wakeonlan
During tests I found a real regression and this email is only about 2.6.22-rc3
without Rafael's patches - which I'll happily come back to later :)

Rafael J. Wysocki wrote:
> On Saturday, 2 June 2007 00:37, David Greaves wrote:
>> Rafael J. Wysocki wrote:
>>> On Friday, 1 June 2007 23:23, David Greaves wrote:
>> The real situation is worse :(
> 
> Ouch.
>  
>> 2.6.22-rc3 (no patches) just hangs on suspend at:
>> Suspending consoles
>>
>> console switching works but needs a hard reset to reboot.
>>
>> 2.6.22-rc3-skge (with Rafael's patches)
> Can you set CONFIG_DISABLE_CONSOLE_SUSPEND in .config and see where exactly it
> fails?

Given that I expected it to fail I unmounted my 1Tb array data before suspending.
It succeeded... so I started digging...

So I tried again.
2.6.22-rc3 (vanilla) suspended OK this time but on resume hung at:
Stopping tasks done
Shrinking memory done (0 pages freed)
Freed 0 kb in 0.0 secs (0.0MB/s)
Suspending console(s)

Then 2.6.22-rc3 again but CONFIG_DISABLE_CONSOLE_SUSPEND=y
It suspended again.
Froze on restore.
Screen photo here:
http://www.dgreaves.com/pub/2.6.21-rc3-resume-failure.jpg

Then 2.6.22-rc3 again but CONFIG_DISABLE_CONSOLE_SUSPEND=y
This time, before suspending I unmounted my xfs/lvm/raid6 filesystem.
Just a umount, I left the devices/array up.
It suspended again.
This time it resumed without fault.

The machine has another xfs filesystem :
/dev/hdb2 on /scratch type xfs (rw)

I've started bisecting... any other info needed?

David

Added Linus as it's a regression
Added xfs as unmounting an xfs filesystem 'fixes' it.
