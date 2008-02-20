Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 01:56:08 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1K9txop006171
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 01:56:04 -0800
Received: from mail2.syneticon.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 175515F75DD
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 01:56:21 -0800 (PST)
Received: from mail2.syneticon.net (mail.syneticon.net [213.239.212.131]) by cuda.sgi.com with ESMTP id ic3LxrJWNJrClV37 for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 01:56:21 -0800 (PST)
Message-ID: <47BBF937.2020104@wpkg.org>
Date: Wed, 20 Feb 2008 10:56:07 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
Subject: Re: is xfs good if I have millions of files and thousands of hardlinks?
References: <47BADF75.2070004@wpkg.org> <47BB5873.6040703@sgi.com>
In-Reply-To: <47BB5873.6040703@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: xfs@oss.sgi.com

Peter Grandi wrote:

> mangoo> In general, because new files and hardlinks are being
> mangoo> added all the time and the old ones are being removed,
> mangoo> this leads to a very, very poor performance.
> 
> That is not the cause of the poor performance. The ultimate
> cause is rather different.

Well, adding new files and hardlinks all the time leads to that that the 
inodes are scattered all over the disk.


> mangoo> When I want to remove a lot of directories/files (which
> mangoo> will be hardlinks, mostly), I see disk write speed is
> mangoo> down to 50 kB/s - 200 kB/s (fifty - two hundred
> mangoo> kilobytes/s) - this is the "bandwidth" used during the
> mangoo> deletion.
> 
> How is bandwidth relevant for that? OK that there are quotes,
> but it seems very very stranget regardless.

The filesystem is available via iSCSI, so it's easy to measure the 
current performance. But iSCSI is not a problem here - performance is 
very good on an empty filesystem on that very same iSCSI/SAN device.

What I mean, is that when I remove large amount of files, the bandwidth 
used for writing to the disk is only down to 50-200 kB/s. Down from 
what, one might ask? Let me paste here yet another quotation from 
linux-fsdevel list, it may shed some more light:

   Recently I began removing some of unneeded files (or hardlinks) and
   to my surprise, it takes longer than I initially expected.

   After cache is emptied (echo 3 > /proc/sys/vm/drop_caches) I can
   usually remove about 50000-200000 files with moderate performance.
   I see up to 5000 kB read/write from/to the disk, wa reported by top
   is usually 20-70%.

   After that, waiting for IO grows to 99%, and disk write speed is down
   to 50 kB/s - 200 kB/s (fifty - two hundred kilobytes/s).


> mangoo> Also, the filesystem is very fragmented ("dd
> mangoo> if=/dev/zero of=some_file bs=64k" writes only about 1
> mangoo> MB/s).
> 
> Then more the merrier.

Umm, no.
Usually, one is merrier when these numbers are high, not low ;)


> mangoo> Will xfs handle a large number of files, including lots
> mangoo> of hardlinks, any better than ext3?
> 
> It shows consideration to consult the archives of a mailing list
> before aking a question. It may be a good idea to do it even
> after posting a question :-).

Oh, I did consult the archive. There are not many posts about hardlinks 
here on this xfs list (or, at least I didn't find many).

There was even a similar subject last year: someone had a 17 TB array 
used for backup, which was getting full, and asked if xfs is or will be 
capable of transparent compression.
As xfs will not have transparent compression in a foreseeable future, it 
was suggested to him that he should use hardlinks - that alone could 
save him lots of space.

I wonder if the guy uses hardlinks now, and if yes, how does it behave 
on this 17 TB array (my filesystem is just 1.2 TB, but soon, I'm about 
to create a bigger one on another device - and hence my questions).



-- 
Tomasz Chmielewski
http://wpkg.org
