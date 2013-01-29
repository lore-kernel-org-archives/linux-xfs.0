Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 944897F4C
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:55:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 20E4CAC006
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 13:55:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nWuqZ2mA5Sb4lij0 for <xfs@oss.sgi.com>;
	Tue, 29 Jan 2013 13:55:16 -0800 (PST)
Message-ID: <51084544.6050907@sandeen.net>
Date: Tue, 29 Jan 2013 15:55:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<5107124E.70607@sandeen.net>
	<20821.192.104.24.222.1359496079.squirrel@secure.skymagik.net>
In-Reply-To: <20821.192.104.24.222.1359496079.squirrel@secure.skymagik.net>
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
To: Tom <storm9c1@skymagik.com>
Cc: xfs@oss.sgi.com

On 1/29/13 3:47 PM, Tom wrote:
> In a previous message, Eric Sandeen wrote:

...

>> I don't see anything obvious between the two kernels you mention, and I
>> can't spend a ton of time digging into this, since most of my day is
>> taken up supporting the RHEL customers who pay my salary, nudge nudge.
>> ;)
> 
> Any help is appreciated.  Finding this bug may possibly help
> ferret out another more possibly nefarious bug, which is why I don't
> need instant gratification here.  I'm only looking to assist with the
> solution, not cause more stress.
> 
> The "company" that I work for from 9-5 has an extensive RHEL 5.X and 6.X
> deployment with Satellite, channels, full support, the whole nine yards.
> They don't color outside the lines as I do -- they use ext3 for the root
> filesystem instead.  Their loss.  :-)
> 
> So don't worry, said "company" "gives" plenty to the "cause".  ;-)
> 
> However, after 5pm, I do unrelated personal work and projects unrelated
> to said "company", and one of those things is working with CentOS and
> Ubuntu.  Using XFS quite extensively.

Sorry for hassling you ;)

>>
>> I'd look at the kernel changelogs for xfs & md, and see if anything
>> seems plausible.  Maybe diff the sources & see what changed, etc.
>>
> 
> Yeah, I took a half-hearted look already.  But didn't diff any source
> code yet.  I saw a freeze/thaw change and a few other md changes that
> were suspect.  But haven't had a chance to dig deeper.

I'd suspect the md changes were the trigger, though maybe it reveals
an xfs problem.  I don't see anything in xfs that changed which should
be causing this.

The backtrace will help, I think.

Thanks,
-Eric

> Thanks again.
> 
> -- Tom
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
