Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Aug 2006 08:46:01 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7BFjfDW030488
	for <xfs@oss.sgi.com>; Fri, 11 Aug 2006 08:45:41 -0700
Received: from [82.41.152.154] (helo=[192.168.10.36])
	by mail.g-house.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.50)
	id 1GBZC8-0006xP-D1
	for xfs@oss.sgi.com; Fri, 11 Aug 2006 17:45:08 +0200
Date: Fri, 11 Aug 2006 16:44:56 +0100 (BST)
From: Christian <evilninja@gmx.net>
Subject: Re: File problem question
In-Reply-To: <44DC44FA.4060401@rentalia.com>
Message-ID: <Pine.LNX.4.64.0608111637290.7492@prinz64.housecafe.de>
References: <44DC44FA.4060401@rentalia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, 11 Aug 2006, Ruben Rubio wrote:
> root@rigodon log # ls -al lastlog
> - -r--------  1 root root 146292 ago 11 10:44 lastlog
---^
    is that a typo or is there a space in the permission field?

> I have a file witch size is 7,6 GB. However, if I ls -al is another
> file. Seems like filesystems is being corrupted.

What does xfs_check say? Which (linux?-)kernel are you using? If you are 
about to xfs_*, please make sure you have the *latest* xfsprogs[0], 
which is 2.8.10-1 right now...

Christian.
[0] ftp://oss.sgi.com/projects/xfs/cmd_tars/
-- 
BOFH excuse #68:

only available on a need to know basis
