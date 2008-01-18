Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 10:34:24 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0IIYFKs009471
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 10:34:19 -0800
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB268C8EF82
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 10:34:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id CAoe1MxY9DZhN7GP for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 10:34:34 -0800 (PST)
Message-ID: <4790F137.7000700@sandeen.net>
Date: Fri, 18 Jan 2008 12:34:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local>
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Mark Magpayo wrote:
>>> So is this all I need then prior to an xfs_repair?:
>>>
>>>> # for i in `seq 0 1 63`; do
>>>>> xfs_db -x -c "sb $i" -c 'write agcount 64' -c 'write dblock
>> 4761733120'
>>>> /dev/vg0/lv0
>> Yes, I think that is all that is necessary (that+repair was what fixed
>> the problem at the customer site successfully).
>>
> 
> Is this supposed to be the proper output to the command above?
> 
> purenas:~# for i in `seq 0 1 63`; do xfs_db -x -c "sb $i" -c 'write
> agcount 64' -c 'write dblock 4761733120' /dev/vg0/lv0; done
> agcount = 64
> field dblock not found

...

I think dave had a typo, should be dblocks with an "s" on the end.

Feel free to wait for his confirmation, though, since this is surgery,
after all :)

-eric
