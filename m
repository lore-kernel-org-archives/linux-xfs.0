Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29DE17F50
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 00:35:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0161D8F8039
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2013 22:35:58 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id s9N3J9g0i2N5CYxB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Feb 2013 22:35:57 -0800 (PST)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	r136ZtUa030945 for <xfs@oss.sgi.com>; Sat, 2 Feb 2013 22:35:57 -0800
Message-ID: <510E054B.2070500@tlinx.org>
Date: Sat, 02 Feb 2013 22:35:55 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs deadlock on buffer semaphore while reading directory
References: <20130202192007.GS30577@one.firstfloor.org>
	<510D6EDE.1080409@sgi.com>
In-Reply-To: <510D6EDE.1080409@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



Mark Tinguely wrote:
> On 02/02/13 13:20, Andi Kleen wrote:
>>
>> On a older 3.6-rc9 opensuse kernel I had the following deadlock with
>
> That looks like a hang fixed by the series:
> 
>     http://oss.sgi.com/archives/xfs/2012-12/msg00071.html
----

That may be so -- I used to see things like that on some older
kernels with random progs but with traces down in xfs..

Seemed to be rare and not cause problems....but don't notice those any
more...

Odd thing about my current probs -- my current system has been
up 12 days...but before that it had been up 43 days...


I can't get the buffers to 'free' no matter what
echo 3> /proc/sys/vm/drop_caches does nothing.

so I may be rebooting soon...

The large number of from that log (was from 2/1 4:30am)
was that it was level 0 backup day....

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
