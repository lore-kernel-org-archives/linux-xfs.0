Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D2jUV3243423 for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 21:45:30 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id at8kPEinDdB0StQz
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 19:45:29 -0700 (PDT)
Message-ID: <4F879344.1070702@hardwarefreak.com>
Date: Thu, 12 Apr 2012 21:45:24 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [PATCH] disable tags in post-receive hook
References: <20120411162627.GJ1802@sgi.com>
	<4F86971A.1030507@hardwarefreak.com> <4F86FFAC.6030904@thebarn.com>
In-Reply-To: <4F86FFAC.6030904@thebarn.com>
Reply-To: stan@hardwarefreak.com
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Brent Bice <bbice@sgi.com>, xfs@oss.sgi.com

On 4/12/2012 11:15 AM, Russell Cattelan wrote:
> On 4/12/12 3:49 AM, Stan Hoeppner wrote:
>> On 4/11/2012 11:26 AM, Ben Myers wrote:
>>> Hey Folks,
>>>
>>>     Yesterday I pushed tags to the oss.sgi.com xfs git repository and forgot to
>>>     disable the post-receive hook which generates email to the list at commit
>>>     time.  You probably saw the resulting mailbomb.  I'm sorry about that.  In
>>>     order to make sure it doesn't happen again next time, I have applied the
>>>     following patch to our post-receive hook:
>>
>> I curse you for the error Ben and praise you for this correction.
>> Mailman unsubbed me sometime yesterday according to a subject line.
>> There was no body, no reason give.  But, I know the cause.
>>
>> I was limiting concurrent SMTP connections to 1 to fight runaway bots.
>> Was working great until this bombing run.  The OSS list server runs
>> Sendmail, which is dumb and opens a new connection for every message
>> delivery.  This behavior can potentially bring an MX to its knees due to
>> smtpd process starvation.
> Hmm yes and no.
> There was some config issues with with queues on oss that hopefully I
> have significantly improved. Sendmail does do connection caching and
> will deliver as much mail as possible on the same connection as
> possible. The problem was that the queue runnners was set to 400 runners
> which was essentially was causing oss to grind itself into the ground
> and causing enough delays that most connection caches where probably
> timing out.

I don't use Sendmail so my apologies if I mischaracterized its
features/behavior.  I was merely describing what I was seeing here.  It
seems that description may have been helpful in troubleshooting/tuning
this, and in the end that's what counts.

> Also the queue sorting has been changed from the default "priority" sort
> which basically will be a time sort in this case to "host" sort which
> will try to optimize envelope address delivery. For a mail list server
> this should be a significant win since it should be able to better take
> advantage of the connection cache. (especially when "tag" bombs happen).

Awesome.

> The queue run time has been changed from the default of 30m to 1m which
> should cut the mail list delays down significantly.

Times two.

> Changed the drive queue scheduler from cfq to deadline

And again.

> I've been watching the headers since the change and the turn around
> times for mail leaving the originating host to landing in my mail server
> is about 1 - 2 min. Occasionally there is a delay on sgi's barracuda box
> but that is whole other box of worms.

Anything under 5 minutes, regardless of where any delays are occurring,
seems acceptable in my book, and much better than the previous setup.

> Please send me any observations  + or - so I know if the tuning is
> headed in the right direction.

I sure will Russel.  A short while back when problems hit a threshold
here, I searched the whois records for the appropriate contact and went
from there, ended up working with Brent, who was eager to help if he
could, but made it clear the list had another responsible party/owner.
I guess that would be you. :)

Apologies if I've inadvertently stepped on anyone's toes, asked anyone
to employ a can opener against his will.  I just wanted to bring some
long standing issues to attention and hopefully get them resolved.  It
appears that has happened.

Thanks for addressing these issues Russel.  I'm sure others will be
pleased by your efforts here as well.  Whether the MTA is Sendmail or
Postfix is irrelevant as long as it works properly.

Thanks again.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
