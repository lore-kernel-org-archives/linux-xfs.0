Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1D4vPYe108037 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 22:57:26 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6302F1922C3B
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 20:56:50 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id QRvwLANhyZmmJngu for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2009 20:56:50 -0800 (PST)
Message-ID: <4994FD8C.5020303@sandeen.net>
Date: Thu, 12 Feb 2009 22:56:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: BUG: soft lockup detected on CPU#1!
References: <3453.33822.qm@web30203.mail.mud.yahoo.com>
In-Reply-To: <3453.33822.qm@web30203.mail.mud.yahoo.com>
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
To: raksac@yahoo.com
Cc: xfs@oss.sgi.com

raksac@yahoo.com wrote:
> Guys,
> 
> Thank you for taking the time to write. Having said
> where I stand and we are kind of on the same page. Is
> there something I can expect which would put me on a
> track of nailing down the problem. It maybe a wild
> goose chase but something that I can start with would
> be much appreciated.

Just random debugging thoughts...

Try stock 2.6.28.4, to see if you have the same problem.  If so, and
esp. if you also see it on 2.6.29, then you'll get a lot more attention
here.  :)

If not, then it's something with your backport most likely.  Figure out
what you had to backport and see if it's possibly causing the error(s).

If it's locked up, try sysrq-w (echo w > /proc/sysrq-trigger) and look
at dmesg to see if other threads are locked against it.  Figure out why.

On the oops try memory debugging etc, see if you're referencing freed
memory, using corrupt lists, etc.

Look for other errors in the logs prior to this.

See if your filesystem is corrupted.

Bug Red Hat for XFS support, assuming you're actually buying RHEL5
support from them.  :)

> Unfortunately there is no distro which gets closer to
> where mainline lives today. Reading the changelog
> there are several problems that I have already come
> across and has convincingly driven me to take on this
> task.

well certainly there are distros with kernels newer than 2.6.18, but it
depends on your needs & goals I guess.

Good luck,
-Eric

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
