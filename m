Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 09:19:01 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9HGIuht030520
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 09:18:58 -0700
Date: Wed, 17 Oct 2007 12:18:58 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: can't remove dir
In-Reply-To: <20071017161504.GA13077@apartia.fr>
Message-ID: <Pine.LNX.4.64.0710171218510.3750@p34.internal.lan>
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net>
 <20071017161504.GA13077@apartia.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Cc: linux-xfs@oss.sgi.com



On Wed, 17 Oct 2007, Louis-David Mitterrand wrote:

> On Fri, Sep 14, 2007 at 09:14:25AM -0500, Eric Sandeen wrote:
>> Louis-David Mitterrand wrote:
>>> Hello,
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
>> Any errors in the system logs?  I'd try most recent xfs_repair next.  If
>> that doesn't fix it, make an xfs_metadump for Barry to look at.  :)
>> Make a backup first if you're paranoid.
>
> Hi again,
>
> Using a 2.6.23 kernel and after a clean xfs_repair-2.9.4 run I can't
> remove that file:
>
> sylla:/# rm /lost+found/3912672557
> rm: cannot remove `/lost+found/3912672557': Operation not permitted
>
> sylla:/# ls -li /lost+found/3912672557
> 3912672557 lrwxrwxrwx 1 root root 9 2006-04-09 19:10 /lost+found/3912672557 -> unix.7.gz
>
>

lsattr -l /lost+found/3912672557

Shows?
