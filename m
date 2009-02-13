Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1D0eLcR095848 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 18:40:21 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FCE1192A5E6
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 16:39:45 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id GW6eK4v9Nb8dv7HV for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2009 16:39:45 -0800 (PST)
Message-ID: <4994C14E.5090402@sandeen.net>
Date: Thu, 12 Feb 2009 18:39:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Does XFS support the sync mount option?
References: <884979c90902050643m78d2e0dbt85aa7f4369e243ef@mail.gmail.com>	<20090206230502.GQ24173@disturbed>
	<884979c90902121546g35f594b1s592859ac7b832533@mail.gmail.com>
In-Reply-To: <884979c90902121546g35f594b1s592859ac7b832533@mail.gmail.com>
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
To: Ewan Chalmers <ewan.chalmers@gmail.com>
Cc: xfs@oss.sgi.com

Ewan Chalmers wrote:
> Thanks for your detailed reply.
> 
>> And "sync" only works if you turn drive write caches off or have
>> barriers enabled. There are many people out there that  have systems
>> that are suseptible to fatal filesystem corruption that could be
>> triggered by doing this (because critical metadata is lost from
>> the volatile write cache on the drive when you power it off).
> 
> According to the FAQ, barriers are enabled by default since 2.6.17.

That's kernel version

> I
> have 2.9.8, 

that's xfsprogs version.

> so I guess barriers are enabled. I have checked and dmesg
> contains no errors relating to barriers.
> 
> Also according the FAQ... "With a single hard disk and barriers turned
> on (on=default), the drive write cache is flushed before an after a
> barrier is issued. A powerfail "only" loses data in the cache but no
> essential ordering is violated, and corruption will not occur."
> 
> So it sounds like pulling the plug on the disk should not cause
> corruption in this case (sync mount and barriers default enabled). Or
> am I just plain wrong?

It should not cause metadata corruption

> (BTW, I've done an xfs_repair which reported no errors.)

... which is what repair will check for.

-Eric

> Thanks,
> Ewan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
