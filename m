Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0BF187F7B
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 18:05:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE3038F804B
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 16:05:36 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rrVjY4LtqhaFYlmE for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 16:05:35 -0800 (PST)
Message-ID: <5107124E.70607@sandeen.net>
Date: Mon, 28 Jan 2013 18:05:34 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
In-Reply-To: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
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

On 1/28/13 5:28 PM, Tom wrote:
> 
> Dear XFS folks,
> 
> I have been using XFS for many years, starting on IRIX and then on RedHat
> 7.2, and now on CentOS/RHEL and Ubuntu.  Last time I posted to this
> mailing list was 12 years ago.  :-)  I've been a happy customer!
> 
> I understand that RedHat does not formally support XFS as a root filesystem
> on RHEL.  

That's correct.  However, I have run xfs root on Centos5, and am
currently running xfs root on RHEL6.  On md raid1 in both instances. ;)

> However, up until now, I've been using it very successfully for
> years on both CentOS and Ubuntu.  On CentOS, I've successfully patched
> Anaconda since CentOS 5.6 to allow XFS root file system support directly
> from Anaconda (on both bare metal and Xen VMs).  Prior to that, I had code
> in %post that would simply migrate an ext3 fs to XFS.  And I always run
> md raid1 (except with Xen, since I use mirroring on the dom0).  I never use
> hardware RAID since I want to keep my provisioning as generic as possible.
> 
> I've deployed many servers using XFS this way and it has always been
> superior for my workloads....  and superior to ext3, and ext4.
> 
> ....until CentOS 5.9 came out.  Now any systems that are running the stock
> CentOS 5.9 kernel (including 5.X systems upgraded to this kernel) hang
> on reboot.  If I downgrade to the 5.8 kernel, the problem is resolved.

Just to be absolutely sure, do you have any xfs-kmod or kmod-xfs installed?
If so, remove it.

> I have taken an engineering approach to testing this problem in efforts
> to help resolve it.  I filed a bug with CentOS, but it's probably not
> going to go anywhere upstream since RedHat probably won't support XFS on
> the root filesystem (why I still don't understand, since I fixed the
> issues with Anaconda for myself and can Kickstart systems with XFS all
> day long).

It's for non-technical reasons.

> Therefore I hope anyone here can help.  In fact, I was specifically hoping
> to catch Eric Sandeen's attention since this seems like a pretty serious
> regression.  It's further aggravated by the fact that RedHat stays behind
> with kernel version and backports modern fixes.  I scanned over the
> 2.6.18-348.el5 (stock 5.9 kernel) changelog, and I see a few suspicious
> things, but I'm not sure.
> 
> Much more detail is available here (CentOS bug id 0006217) including steps
> to reproduce the problem.  Also testing with and without md raid.
> http://bugs.centos.org/view.php?id=6217

so it's hanging on the way down I guess?

I see:  "md: md1 switched to read-only mode"

Was that there before?

> The one thing I haven't provided is a traceback.  I can provide that if it
> would be helpful.

of course it would be . . . 

I don't see anything obvious between the two kernels you mention, and I
can't spend a ton of time digging into this, since most of my day is
taken up supporting the RHEL customers who pay my salary, nudge nudge. ;)

I'd look at the kernel changelogs for xfs & md, and see if anything
seems plausible.  Maybe diff the sources & see what changed, etc.

-Eric

> I am not in a big hurry for help, on the contrary I just want to open up
> a dialog since perhaps others might be suffering from this.  And I want to
> help resolve it if I can.
> 
> Any insight is appreciated.
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
