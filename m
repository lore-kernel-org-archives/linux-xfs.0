Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 07:51:21 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m54EpHsN008069
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 07:51:18 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF11B177B77B
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2008 07:52:10 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id kvRwmqgUpzW34sHk for <xfs@oss.sgi.com>; Wed, 04 Jun 2008 07:52:10 -0700 (PDT)
Date: Wed, 4 Jun 2008 16:52:14 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Questions for article
Message-ID: <20080604165214.31dceeaa@harpe.intellique.com>
In-Reply-To: <19868.143.166.226.57.1212507288.squirrel@tomslinux.homelinux.org>
References: <19868.143.166.226.57.1212507288.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas King <kingttx@tomslinux.homelinux.org>
Cc: xfs@oss.sgi.com

Le Tue, 3 Jun 2008 10:34:48 -0500 (CDT)
Thomas King <kingttx@tomslinux.homelinux.org> écrivait:

> I am writing an article to answer Henry Newman's at
> http://www.enterprisestorageforum.com/sans/features/article.php/3749926.
> I've already been bugging folks on the ext4 mailing list and one of
> them mentioned I should also send some of the same questions to this
> list. Please let me know if I may do so.

Seems like a good idea. This guy doesn't even mention XFS, while it's
more or less the only viable option for big filesystems (more than 8TB).
I currently use 30, 40TB XFS filesystems that work just fine.

I've already compared all filesystems : XFS works great for big
filesystems. JFS works well too, however it lacks a defragmenting
utility which is quite a problem for big filesystems with lots of write
activity. reiserfs 3.6 simply breaks over 4TB; mkfs.ext3 is so slow
than it's a problem from the start, then the performance is abysmal.


-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
