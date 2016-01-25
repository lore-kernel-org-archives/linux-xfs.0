Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CB2E7CA1
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 13:33:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B3D28F8039
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 11:33:21 -0800 (PST)
Received: from legacy.ddn.com (legacy.ddn.com [64.47.133.206]) by cuda.sgi.com
	with ESMTP id B0o0yMoj2cxzkElK (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 11:33:15 -0800 (PST)
From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: xfs and swift
Date: Mon, 25 Jan 2016 19:33:13 +0000
Message-ID: <56A67878.3080803@ddn.com>
References: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
	<56A66869.3080506@ddn.com>
	<CAC2B=ZEJ7cSnpzpfRBfwfEnZUsLBQe=YW2fuvbVF75OjmYmOOw@mail.gmail.com>
In-Reply-To: <CAC2B=ZEJ7cSnpzpfRBfwfEnZUsLBQe=YW2fuvbVF75OjmYmOOw@mail.gmail.com>
Content-Language: en-US
Content-ID: <2BC931E86097324EAB665FE219A1FE1C@ddn.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Seger <mjseger@gmail.com>
Cc: Laurence Oberman <loberman@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

Hi Mark!

On 01/25/2016 08:00 PM, Mark Seger wrote:
> hey bernd, long time no chat.  it turns out you don't have to know what
> swift is because I've been able to demonstrate this behavior with a very
> simple python script that simply creates files in a 3-tier hierarchy.  the
> third level directories each contain a single file which for my testing are
> all 1K.

So what is the script exactly doing? Does it create those files
sequentially per dir or randomly between those dirs?

Btw, I had been talking about that issue at linux plumbers in 2013

https://www.youtube.com/watch?v=N_bZOGZAb-Y

> 
> I have played wiht cache_pressure and it doesn't seem to make a difference,
> though that was awhlle ago and perhaps it is worth revisiting. one thing

There are several patches from Mel Gorman in 3.11, which really made a
difference for me. So unless you tested with >= 3.11 you should probably
re-test.

> you may get a hoot out of, being a collectl user, is I have an xfs plugin
> that lets you look at a ton of xfs stats either in realtime or after the
> fact just like any other collectl stat.  I just havent' added it to the kit
> yet.


Hmm, I currently don't have good a test system for that. I'm working on
an entirely different project now and while this is also a parallel file
system, it does not have a linux file system in between, but has its own
(log rotated) layout.


Cheers,
Bernd
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
