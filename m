Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 01:45:34 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8E8jT4p029431
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 01:45:30 -0700
Date: Fri, 14 Sep 2007 04:45:31 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [UNSURE] can't remove dir
In-Reply-To: <20070914084125.GA31074@apartia.fr>
Message-ID: <Pine.LNX.4.64.0709140444131.752@p34.internal.lan>
References: <20070914080926.GA30150@apartia.fr> <Pine.LNX.4.64.0709140438130.752@p34.internal.lan>
 <20070914084125.GA31074@apartia.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Cc: linux-xfs@oss.sgi.com



On Fri, 14 Sep 2007, Louis-David Mitterrand wrote:

> On Fri, Sep 14, 2007 at 04:38:22AM -0400, Justin Piszcz wrote:
>>
>> On Fri, 14 Sep 2007, Louis-David Mitterrand wrote:
>>>
>>> While cleaning up /lost+found a directory resisted removal:
>>>
>>> 	sylla:/lost+found# rm 1879629858 -rf
>>> 	rm: cannot remove directory `1879629858': Directory not empty
>>>
>>> The directory _is_ empty and "-rf" should remove it anyway, so this
>>> looks like a fs error.
>>>
>>> This is on debian unstable with 2.6.23-rc6.
>>
>> what does "ls -al 1879629858" say?
>>
>
> I knew someone would ask, and this is slightly insulting ;-)
>
> sylla:/lost+found# ls -al 1879629858
> total 24
> drwxr-xr-x 2 root root   8192 2007-09-14 09:25 ./
> drwxr-xr-x 3 root root 299008 2007-09-14 10:05 ../
>
>

What happens if you reboot to (e.g., knoppix)

and run: xfs_check /dev/that_partition?

and/or:

xfs_repair -n /dev/that_partition?

        -n     No modify mode.  Specifies that xfs_repair should not modify the
               filesystem but should only scan the filesystem and indicate what
               repairs would have been made.

This would be useful to figure out what went wrong.

Justin.
