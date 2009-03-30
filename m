Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UGs1dk205094 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 11:54:11 -0500
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 414B11D5482
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 09:53:17 -0700 (PDT)
Received: from mail.ukfsn.org (mail.ukfsn.org [77.75.108.10]) by cuda.sgi.com
	with ESMTP id VFV4JIG1OxZLEVxy for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2009 09:53:17 -0700 (PDT)
Message-ID: <49D0F8F9.3010906@dgreaves.com>
Date: Mon, 30 Mar 2009 17:53:13 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: Regression? 2.6.27-rc3 segfault on cold boot; not on warm boot.
References: <48AD3921.5090709@dgreaves.com> <200808212026.17590.rjw@sisk.pl>
	<48AFDCE7.7010508@dgreaves.com> <49D0E28B.4090207@sandeen.net>
In-Reply-To: <49D0E28B.4090207@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com

Eric Sandeen wrote:
> David Greaves wrote:
>> Rafael J. Wysocki wrote:
>>> [Adding CCs]
>>>
>>> [The issue is probably present in 2.6.26 too]
>> Yes, below is a netconsole boot of 2.26.6.3
>>
>> I cold booted - lots of segfaults. I then did a ctrl-Alt-SysRq-S-U-B to a warm
>> boot. No segfaults
>> (lots of #### mark the split)
>>
>> I've just started 2.6.25.14 building for tomorrow to confirm how far back it
>> goes. (I'm 99% sure 2.6.25 is OK)
>>
>> David
> 
> (trimming cc's to xfs)
> 
> David, did you get anywhere with identifying this further?
> 
> Thanks,
> -Eric

Sorry, I didn't.

IIRC I spent a couple of weeks on it and found it too unpredictable to bisect.
I have been running 2.6.27.4 on that machine for a few months (checks... Nov 08)
and it's been good since then.

Linus suspected HW and we got into a habit of warming the machine up before
booting. That habit has long since gone and the last xfs hissy-fit was on 13 Sep 08.

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
