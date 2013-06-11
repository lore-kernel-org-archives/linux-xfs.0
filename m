Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DAC0729DF8
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 08:35:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54A8DAC004
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 06:35:38 -0700 (PDT)
Received: from mail-we0-f169.google.com (mail-we0-f169.google.com
	[74.125.82.169]) by cuda.sgi.com with ESMTP id Z5bqSMqOvesAoqin
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 06:35:36 -0700 (PDT)
Received: by mail-we0-f169.google.com with SMTP id n57so5966350wev.0
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 06:35:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130611T112155-970@post.gmane.org>
References: <loom.20130611T112155-970@post.gmane.org>
Date: Tue, 11 Jun 2013 15:35:35 +0200
Message-ID: <CAAxjCEyjhz7kK5oTLvRGsVK+7QPd-Jw5T4AhRergqk9_Lh7OZw@mail.gmail.com>
Subject: Re: Questions about XFS
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-xfs@oss.sgi.com

> I have a few questions about XFS that didn't make the XFS FAQ. I'm trying to
> get a feel for where I might want to use it on my servers (or at home). A
> mix of ext3 & ext4 has worked well for me. But I'd like to get to know XFS a
> bit better. The target OS would be RHEL6.

That's what I'm using as well. Answers are obviously biased by my
limited experience. I'm not an XFS veteran and have only started using
it after delaylog was added.

> 1. I don't have "lots and large". Why should I run XFS?

For me, the main reason is this: on a multi-user system with a decent
amount of memory (let's say >= 32GB), a single user untarring a large
source tarball, checking out a large source repository etc. will
effectively stall an ext3/4 filesystem for minutes on end. This does
not happen with XFS. Maybe this has been solved with recent kernels,
but it used to be a major nuisance for several years with kernels in
the 2.6.25-2.6.30 range at least.

> 2. I don't have "lots and large". Why shouldn't I run XFS?

Cache/memory accounting as well as displayed % wait time in top are "strange".

XFS performance is more sensitive to free space fragmentation than
ext4. For this reason, I find that it is not overly problematic to
fill an ext filesystem 95%, while with XFS I would stay below 85%.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
