Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3C8na5L132785 for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 03:49:36 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ykZYtAD0S4alEqdV
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 01:49:35 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id ADAE86C105
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 03:49:34 -0500 (CDT)
Message-ID: <4F86971A.1030507@hardwarefreak.com>
Date: Thu, 12 Apr 2012 03:49:30 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [PATCH] disable tags in post-receive hook
References: <20120411162627.GJ1802@sgi.com>
In-Reply-To: <20120411162627.GJ1802@sgi.com>
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
To: xfs@oss.sgi.com

On 4/11/2012 11:26 AM, Ben Myers wrote:
> Hey Folks,
> 
>     Yesterday I pushed tags to the oss.sgi.com xfs git repository and forgot to
>     disable the post-receive hook which generates email to the list at commit
>     time.  You probably saw the resulting mailbomb.  I'm sorry about that.  In
>     order to make sure it doesn't happen again next time, I have applied the
>     following patch to our post-receive hook:

I curse you for the error Ben and praise you for this correction.
Mailman unsubbed me sometime yesterday according to a subject line.
There was no body, no reason give.  But, I know the cause.

I was limiting concurrent SMTP connections to 1 to fight runaway bots.
Was working great until this bombing run.  The OSS list server runs
Sendmail, which is dumb and opens a new connection for every message
delivery.  This behavior can potentially bring an MX to its knees due to
smtpd process starvation.

Postfix on the other hand will open one connection and keep sending
until all mail queued for the destination MX has been sent, or until
there is more than a 2 second delay between deliveries.

I understand Brent Bice of SGI is building an 'evidence file' to justify
a rebuild of OSS to use Postfix and the latest Mailman.  Maybe you could
lend your support or blessing.

The current OSS list server has other problems as well, including large
delays between receiving posts and sending them back out.  I'm assuming
I'm not the only one to notice this.

Thanks.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
