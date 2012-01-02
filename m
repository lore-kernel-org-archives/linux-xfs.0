Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q02G8oRB203657 for <xfs@OSS.SGI.com>; Mon, 2 Jan 2012 10:08:51 -0600
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id DfU7htmPgbf2QZCw for
	<xfs@OSS.SGI.com>; Mon, 02 Jan 2012 08:08:49 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by anakin.london.02.net (8.5.140)
	id 4EEB63D200418F31 for xfs@OSS.SGI.com;
	Mon, 2 Jan 2012 16:08:48 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RhkRI-0006wI-K6
	for <xfs@OSS.SGI.com>; Mon, 02 Jan 2012 16:08:44 +0000
MIME-Version: 1.0
Message-ID: <20225.54924.482210.587313@tree.ty.sabi.co.UK>
Date: Mon, 2 Jan 2012 16:08:44 +0000
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
In-Reply-To: <4F0181A2.5010505@univ-nantes.fr>
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
	<4EF21DD2.3060004@univ-nantes.fr> <20111221222623.GF23662@dastard>
	<4EF2F702.4050902@univ-nantes.fr> <4EF30E5D.7060608@univ-nantes.fr>
	<4F0181A2.5010505@univ-nantes.fr>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

>> On two particular server, with recent kernels, I experience a
>> much higher load than expected, but it's very hard to tell
>> what's wrong. The system seems more in I/O wait. Older
>> kernels (2.6.32.xx and 2.6.26.xx) gives better results.
[ ... ]
> When I go back to older kernels, the load go down. With newer
> kernel, all is working well too, but load (as reported by
> uptime) is higher.
[ ... ]
>> birnie:~/TRACE# uptime
>>   11:48:34 up 17:18,  3 users,  load average: 0.04, 0.18, 0.23

>> penderyn:~/TRACE# uptime
>>   11:48:30 up 23 min,  3 users,  load average: 4.03, 3.82, 3.21
[ ... ]

But 'uptime' reports the load average, which is (roughly)
processes actually running on the CPU. If the load average is
higher, that usually means that the file system is running
better, not worse. It looks as if you are not clear whether you
have a regression or an improvement.

For a mail server the relevant metric is messages processed per
second, or alternatively median and maximum times to process a
message, rather than "average" processes running.

[ ... ]

>> As those servers are critical for us, I can't really test,
>> hardly give you more precise numbers, and I don't know how to
>> accurately reproduce this platform to test what's wrong. I
>> know this is NOT a precise bug report and it won't help much.
>> All I can say IS : - read operations seems no slower with
>> recent kernels, backups take approximatively the same time ;
>> - I'd say (but I have no proof) that delivery of new mails
>> takes more time and is more synchronous than before, like
>> nobarrier have no effect.

> Did someone had time to examine the 2 blktrace ? (and, by
> chance, can see the root cause of the increased load ?)

So you are expecting for a large system critical problem for
which you yourself do not have the resource to do testing to see
quick response times over the Christmas and New Year period.
What's your XFS Platinum Psychic Support Account number? :-)

> One of my server is still running 3.1.6. In the coming days
> I'll see a very important load increase (today is still
> calm). Is there anything I can do to go further ?

As it is not clear whether you are complaining about better XFS
performance, it is hard to help.

However you can probably test a bit your systems by running
while things are still calmer Postmark on both machines, as that
reports relevant metrics.

[ ... ]

BTW rereading the description of the setup:

>>>>> Thoses servers are mail (dovecot) servers, with lots of
>>>>> simultaneous imap clients (5000+) an lots of simultaneous
>>>>> message delivery. These are linux-vservers, on top of LVM
>>>>> volumes. The storage is SAN with 15k RPM SAS drives (and
>>>>> battery backup). I know barriers were disabled in older
>>>>> kernels, so with recents kernels, XFS volumes were mounted
>>>>> with nobarrier.

>>>> 1. What mailbox format are you using?  Is this a constant
>>>> or variable?
>>> Maildir++

I am stunned by the sheer (euphemism alert) audacity of it all.
This setup is (euphemism alert) amazing.

However at least it is Linux-VServers, while there are clueless
sysadms who setup mail servers over virtual machines (and
amazingly VMware encourages that for Zimbra, which is a terrible
combination as Zimbra also uses something like Maildir for the
IMAP mailstore). The use of 15k drives is also commendable.

Unfortunately the problem of large busy mailstores is vastly
underestimated by many, and XFS has little to do with it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
