Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 17:43:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3T0h534027383
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 17:43:07 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0314E10D0B7D
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 17:43:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id lkbseXJseshRulof for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 17:43:48 -0700 (PDT)
Message-ID: <48166F42.50104@sandeen.net>
Date: Mon, 28 Apr 2008 19:43:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problems with xfs_grow on large LVM + XFS filesystem 20TB size
 check 2 failed
References: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL> <481650F5.40205@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F3718@bcmail1.VIDMARK.LOCAL> <481656F6.5030300@sandeen.net> <48166E18.10008@sgi.com>
In-Reply-To: <48166E18.10008@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Lance Reed <lreed@brightcove.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

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
