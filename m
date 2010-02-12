Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CH1lCQ006789 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 11:01:47 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CBE61CC76B7
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:03:00 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	N3nrzPaglmOrosuC for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 09:03:00 -0800 (PST)
Received: by ewy27 with SMTP id 27so2802137ewy.18
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:02:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>
	<4B75738D.80108@sandeen.net>
	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>
Date: Fri, 12 Feb 2010 18:02:59 +0100
Message-ID: <2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>
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

On Fri, Feb 12, 2010 at 17:45, Richard Hartmann
<richih.mailinglist@gmail.com> wrote:

> I thought about that, but I fear that I will flood my terminal off with crap
> and/or that I somehow impair xfs_repair while doing so.

Running it for ten minutes gives me:

root@grml ~ # strace -p13629
Process 13629 attached - interrupt to quit
futex(0xa381b4cc, FUTEX_WAIT_PRIVATE, 2, NULL^C <unfinished ...>
Process 13629 detached
root@grml ~ #


Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
