Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 07:31:13 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m14FV2GE001140
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 07:31:06 -0800
Received: from smtp02.lnh.mail.rcn.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45B8E59A228
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2008 07:31:22 -0800 (PST)
Received: from smtp02.lnh.mail.rcn.net (smtp02.lnh.mail.rcn.net [207.172.157.102]) by cuda.sgi.com with ESMTP id 4AlR8oIx7whUBTqT for <xfs@oss.sgi.com>; Mon, 04 Feb 2008 07:31:22 -0800 (PST)
Message-ID: <47A72FBC.9090701@pobox.com>
Date: Mon, 04 Feb 2008 09:31:08 -0600
From: Moshe Yudkowsky <moshe@pobox.com>
MIME-Version: 1.0
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net>
In-Reply-To: <47A72061.3010800@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Eric,

Thanks very much for your note. I'm becoming very leery of resiserfs at 
the moment... I'm about to run another series of crash tests.

Eric Sandeen wrote:
> Justin Piszcz wrote:
> 
>> Why avoid XFS entirely?
>>
>> esandeen, any comments here?
> 
> Heh; well, it's the meme.

Well, yeah...

> Note also that ext3 has the barrier option as well, but it is not
> enabled by default due to performance concerns.  Barriers also affect
> xfs performance, but enabling them in the non-battery-backed-write-cache
> scenario is the right thing to do for filesystem integrity.

So if I understand you correctly, you're stating that current the most 
reliable fs in its default configuration, in terms of protection against 
power-loss scenarios, is XFS?


-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "There is something fundamentally wrong with a country [USSR] where
   the citizens want to buy your underwear."  -- Paul Thereaux
