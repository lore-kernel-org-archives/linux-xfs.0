Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CGi6g0005532 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 10:44:06 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2017A13A2E04
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 08:45:20 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	032xZutwcvXZnUXH for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 08:45:20 -0800 (PST)
Received: by ewy27 with SMTP id 27so2782437ewy.18
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 08:45:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B75738D.80108@sandeen.net>
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>
	<4B75738D.80108@sandeen.net>
Date: Fri, 12 Feb 2010 17:45:08 +0100
Message-ID: <2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
From: Richard Hartmann <richih.mailinglist@gmail.com>
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
Cc: xfs@oss.sgi.com

On Fri, Feb 12, 2010 at 16:28, Eric Sandeen <sandeen@sandeen.net> wrote:

> to see if it's moving, I'd try stracing the process or examining it
> with gdb if you are able.

I thought about that, but I fear that I will flood my terminal off with crap
and/or that I somehow impair xfs_repair while doing so.


> You didn't say which version of xfsprogs you have; IIRC at least one known
> problem with hanging has been fixed upstream.

root@grml ~ # xfs_repair -V
xfs_repair version 3.0.4
root@grml ~ #

I seriously do hope that I am not affected...


Thanks,
Richard

PS: If you need any other debug info, please tell me

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
