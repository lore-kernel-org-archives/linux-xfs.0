Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 09:15:51 -0700 (PDT)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9HGFeIw029237
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 09:15:43 -0700
Received: from localhost (localhost.intra.frontsite.de [127.0.0.1])
	by mail.pawisda.de (Postfix) with ESMTP id B1EF6F161
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 17:48:43 +0200 (CEST)
Received: from mail.pawisda.de ([127.0.0.1])
 by localhost (ndb [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 19122-03 for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 17:48:37 +0200 (CEST)
Received: from [192.168.51.2] (lw-pc002.intra.frontsite.de [192.168.51.2])
	by mail.pawisda.de (Postfix) with ESMTP id B86E8E822
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 17:48:37 +0200 (CEST)
Message-ID: <47162ED4.6000108@linworks.de>
Date: Wed, 17 Oct 2007 17:48:36 +0200
From: Ruben Porras <ruben.porras@linworks.de>
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_reno #2
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> A couple changes from the first xfs_reno:
>
>  - Major one is that symlinks are now supported, but only
>    owner, group and extended attributes are copied for them
>    (not times or inode attributes).
>
>  - Man page!
>
>
> To make this better, ideally we need some form of
> "swap inodes" function in the kernel, where the entire
> contents of the inode themselves are swapped. This form
> can handle any inode and without any of the dir/file/attr/etc
> copy/swap mechanisms we have in xfs_reno.
>

If everything goes as planned I will have time next month to look at 
xfs_reno.

-- 
Rubén Porras
LinWorks GmbH
