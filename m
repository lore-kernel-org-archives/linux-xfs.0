Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Apr 2008 09:16:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3TGFiUd022130
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 09:15:52 -0700
Received: from mail.brightcove.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A80510DAEC7
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 09:16:27 -0700 (PDT)
Received: from mail.brightcove.com (mail.brightcove.com [38.113.27.188]) by cuda.sgi.com with ESMTP id mBx5ga6DN0BgmjFe for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 09:16:27 -0700 (PDT)
From: Lance Reed <lreed@brightcove.com>
Date: Tue, 29 Apr 2008 12:15:45 -0400
Subject: RE: Problems with xfs_grow on large LVM + XFS filesystem 20TB size
 check 2 failed
Message-ID: <6A32BC807C106440B7E23208F280DDAF01D21F384B@bcmail1.VIDMARK.LOCAL>
References: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL>
 <481650F5.40205@sandeen.net>
 <6A32BC807C106440B7E23208F280DDAF01D21F3718@bcmail1.VIDMARK.LOCAL>
 <481656F6.5030300@sandeen.net> <48166E18.10008@sgi.com>
 <48166F42.50104@sandeen.net>
In-Reply-To: <48166F42.50104@sandeen.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "markgw@sgi.com" <markgw@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks so much for all the info!

I am currently looking over the
http://oss.sgi.com/archives/xfs/2008-01/msg00097.html
post to figure  out if I need to do antyhing manual to finish expanding the filesystem.

If it is possible to expand in increments less than 2 TB, is there a way to do this via xfs_growfs?  I am a bit confused by the -D and -R options and which one would be relevant here.  Or do I have to shrink the LVM Logical Volume first and then just run "xfs_grow /mntpoint".
Also, can I run with the "-n" option to confirm if the xfs_growfs command "should" complete correctly each time? (looking for docs on this...)

Is there any reason I couldn't grab a newerer release of the XFS tools, etc, and compile for CentOs 5.0 and use them in this case?


Thanks in advance for the help.


Lance

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net]
Sent: Monday, April 28, 2008 8:44 PM
To: markgw@sgi.com
Cc: Lance Reed; xfs@oss.sgi.com
Subject: Re: Problems with xfs_grow on large LVM + XFS filesystem 20TB size check 2 failed

Mark Goodwin wrote:
>
> Eric Sandeen wrote:
>> Lance Reed wrote:
>>> Thanks for the quick response.
>>>
>>> Actually, I was able to run an xfs_repair and all was well.(took 45 minutes...)
>>>
>>> But I would love to be able to expand the XFS file system out to the max.
>>>
>>> I guess I could expand it in < 2TB increments then maybe?
>>>
>>> Thanks for the update and I will look around.
>>>
>>> I did find this which I think is related.
>>>
>>> http://oss.sgi.com/archives/xfs/2008-01/msg00097.html
>> Yep, I think expanding it in, say, 1T increments should be fine, and it
>>  should all (I think...) end up the same as if you'd done it all at once
>> (modulo the bug, of course...)
>
> I think we verified a while back that growing in 2T increments is an
> effective workaround - the bug is due to a signed 32 bit overflow.
> The fix has been available for some time now, but apparently hasn't
> made it's way into Centos yet.

Honestly, I think nothing makes its way back to Centos... I really don't
have the time to maintain it.  If anyone on the list uses Centos + xfs
and wants to backport patches that appear to be bugfixes, I'm sure it'd
be welcomed.  I'd be happy to facilitate w/ review or whatnot, but
probably won't have time to actually take on this task myself (despite
being the instigator of the centos module originally, which was, in
retrospect, perhaps a tad irresponsible...)  :)

-Eric
