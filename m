Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 00:40:10 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T7e1tL019463
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 00:40:03 -0700
Message-ID: <4684B750.5030001@dgreaves.com>
Date: Fri, 29 Jun 2007 08:40:00 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <200706281727.35430.rjw@sisk.pl> <20070628220045.GA4521@elf.ucw.cz> <200706290016.45719.rjw@sisk.pl> <20070629050024.GO31489@sgi.com>
In-Reply-To: <20070629050024.GO31489@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>, linux-pm <linux-pm@lists.osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, David Robinson <zxvdr.au@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>

David Chinner wrote:
> On Fri, Jun 29, 2007 at 12:16:44AM +0200, Rafael J. Wysocki wrote:
>> There are two solutions possible, IMO.  One would be to make these workqueues
>> freezable, which is possible, but hacky and Oleg didn't like that very much.
>> The second would be to freeze XFS from within the hibernation code path,
>> using freeze_bdev().
> 
> The second is much more likely to work reliably. If freezing the
> filesystem leaves something in an inconsistent state, then it's
> something I can reproduce and debug without needing to
> suspend/resume.
> 
> FWIW, don't forget you need to thaw the filesystem on resume.

I've been a little distracted recently - sorry. I'll re-read the thread and see 
if there are any test actions I need to complete.

I do know that the corruption problems I've been having:
a) only happen after hibernate/resume
b) only ever happen on one of 2 XFS filesystems
c) happen even when the script does xfs_freeze;sync;hibernate;xfs_thaw

What happens if a filesystem is frozen and I hibernate?
Will it be thawed when I resume?

David
