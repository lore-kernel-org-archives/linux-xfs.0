Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 06:14:50 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m14EEhq0030047
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 06:14:47 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E6735998AA
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2008 06:10:26 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id yai2tMuDXcE0xJHQ for <xfs@oss.sgi.com>; Mon, 04 Feb 2008 06:10:26 -0800 (PST)
Date: Mon, 4 Feb 2008 09:09:53 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk
 crash)
In-Reply-To: <47A7188A.4070005@msgid.tls.msk.ru>
Message-ID: <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, sandeen@sandeen.net



On Mon, 4 Feb 2008, Michael Tokarev wrote:

> Moshe Yudkowsky wrote:
> []
>> If I'm reading the man pages, Wikis, READMEs and mailing lists correctly
>> --  not necessarily the case -- the ext3 file system uses the equivalent
>> of data=journal as a default.
>
> ext3 defaults to data=ordered, not data=journal.  ext2 doesn't have
> journal at all.
>
>> The question then becomes what data scheme to use with reiserfs on the
>
> I'd say don't use reiserfs in the first place ;)
>
>> Another way to phrase this: unless you're running data-center grade
>> hardware and have absolute confidence in your UPS, you should use
>> data=journal for reiserfs and perhaps avoid XFS entirely.
>
> By the way, even if you do have a good UPS, there should be some
> control program for it, to properly shut down your system when
> UPS loses the AC power.  So far, I've seen no such programs...
>
> /mjt

Why avoid XFS entirely?

esandeen, any comments here?

Justin.
