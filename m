Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5TLd0j6170546 for <xfs@oss.sgi.com>; Fri, 29 Jun 2012 16:39:00 -0500
Received: from mail-gg0-f181.google.com (mail-gg0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	yTfKnd5RLauXteiI (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Jun 2012 14:38:58 -0700 (PDT)
Received: by ggnv5 with SMTP id v5so4055683ggn.26
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2012 14:38:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANoMt5OqDhkgvux7fOqp7ZEUDHrdvt2NtKszebFeheApi+RF0g@mail.gmail.com>
References: <CANoMt5NBie68Auyj_V-6QZBbtLPzKu_sWsTFCceO3dYhJu5uZg@mail.gmail.com>
	<4F763734.9040906@sandeen.net>
	<CANoMt5O5T+FTrmL-2c5tsT=wm434iVNeFarPdybcs1q_oPtW=g@mail.gmail.com>
	<4F79E9F3.6010305@sandeen.net>
	<CAPnto6zUScA9u0rBW4i-BqeBnY1MK09J_H8J2R1KCtE1cYy0Rg@mail.gmail.com>
	<6B9C8E2F-0AD3-4C99-A671-5FB603F8577A@sandeen.net>
	<CAPnto6yxng9chxFW6UogxUMKuNAFqu6cJY5xgax0dgsNucosNg@mail.gmail.com>
	<CANoMt5OqDhkgvux7fOqp7ZEUDHrdvt2NtKszebFeheApi+RF0g@mail.gmail.com>
Date: Fri, 29 Jun 2012 23:38:58 +0200
Message-ID: <CAAxjCEzOMEwQP0mERQvmT8zOvS6a0LjDKMB5bQj7pDRjDvkKXw@mail.gmail.com>
Subject: Re: XFS Kernel Panics in CentOS
From: Stefan Ring <stefanrin@gmail.com>
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
To: Mark Rechler <mrechler@brightcove.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> It turned out in my case to be related to:
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=840
>
> Write barriers were not passed when using LVM/XFS/MegaRAID combined. After
> upgrading the kernel to 2.6.39 (used packages from
> http://elrepo.org/tiki/tiki-index.php) all XFS issues were resolved. The
> other solution was not using LVM.

I fail to see how missing write barriers can make a difference to what
the filesystem reads from the block layer. How is this possible? Does
the block layer not take the pending writes into account when handling
read requests?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
