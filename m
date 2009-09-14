Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8EF8Poa062134 for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 10:08:25 -0500
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5422164364F
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 08:09:38 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by cuda.sgi.com with ESMTP id kqxEHPCreqeQUCWK for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2009 08:09:38 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id 16so926679fgg.14
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 08:09:37 -0700 (PDT)
Message-ID: <4AAE5CAB.6090602@gmail.com>
Date: Mon, 14 Sep 2009 17:09:31 +0200
From: Tomek Kruszona <bloodyscarion@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_log_force: error 5 returend
References: <20090914100548.45440@gmx.net>
In-Reply-To: <20090914100548.45440@gmx.net>
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
To: Steffen Knauf <Steffen.Knauf@gmx.net>
Cc: xfs@oss.sgi.com

Steffen Knauf wrote:
> hello,
> 
> sometimes, our server crashed with xfs_log_force: error 5.
> It isn't reproducible and a xfs_check / xfs_repair don't find some errors.
> 
> Perhaps it's a bug?  
> 
> Version: Linux version 2.6.26-bpo.1-amd64 (Debian 2.6.26-9~bpo40+1) (nobse@debian.org) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21
> 
> greets
> 
> Steffen
Hello!

Look at http://oss.sgi.com/bugzilla/show_bug.cgi?id=840
Please provide your dmesg output regarding kernel oops message (maybe
there is similar issue in your case as I had)
It seems that in my case it was a problem of HBA configuration (using
LVM2 and caches) as Christoph Hellwig replied. After proper
configuration I had similar issues still, but last Friday I upgraded HBA
firmware because I've found that there was an issue with cache mode
report (software reported that write caches are disabled but they were
still enabled). I hope this will help in my case - for now I had no
crash. We'll see within next week (it occurs about once a week).

In your case without oops message it's really hard to tell what's wrong.

Best regards,
Tomasz Kruszona

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
