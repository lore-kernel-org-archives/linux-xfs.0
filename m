Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 17:39:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3T0cjWR026992
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 17:38:49 -0700
Message-ID: <48166E18.10008@sgi.com>
Date: Tue, 29 Apr 2008 10:38:48 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: Problems with xfs_grow on large LVM + XFS filesystem 20TB size
 check 2 failed
References: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL> <481650F5.40205@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F3718@bcmail1.VIDMARK.LOCAL> <481656F6.5030300@sandeen.net>
In-Reply-To: <481656F6.5030300@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lance Reed <lreed@brightcove.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



Eric Sandeen wrote:
> Lance Reed wrote:
>> Thanks for the quick response.
>>
>> Actually, I was able to run an xfs_repair and all was well.(took 45 minutes...)
>>
>> But I would love to be able to expand the XFS file system out to the max.
>>
>> I guess I could expand it in < 2TB increments then maybe?
>>
>> Thanks for the update and I will look around.
>>
>> I did find this which I think is related.
>>
>> http://oss.sgi.com/archives/xfs/2008-01/msg00097.html
>
> Yep, I think expanding it in, say, 1T increments should be fine, and it
>  should all (I think...) end up the same as if you'd done it all at once
> (modulo the bug, of course...)

I think we verified a while back that growing in 2T increments is an
effective workaround - the bug is due to a signed 32 bit overflow.
The fix has been available for some time now, but apparently hasn't
made it's way into Centos yet.

Cheers

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
