Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:55362 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfBTOQK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Feb 2019 09:16:10 -0500
Date: Wed, 20 Feb 2019 15:09:32 +0100 (CET)
From: =?ISO-8859-15?Q?Holger_Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH 4/3] generic: posix acl extended attribute memory corruption
 test
In-Reply-To: <20190220132952.GW9874@twin.jikos.cz>
Message-ID: <alpine.LNX.2.21.9999.1902201501470.8769@tux.applied-asynchrony.com>
References: <154993784038.1948.7502664832930298472.stgit@magnolia> <20190213204814.GB6477@magnolia> <20190220132952.GW9874@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Sterba <dsterba@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org


On Wed, 20 Feb 2019, David Sterba wrote:

> On Wed, Feb 13, 2019 at 12:48:14PM -0800, Darrick J. Wong wrote:
>> +#include <attr/xattr.h>
>
> This does not compile on some systems, sys/xattr.h works (it's provided
> by glibc) and is also used by other fstests' sources. I'm not sure where
> does attr/xattr.h come from, my devel package for libattr provides only
> attr/libattr.h.

This was removed from attr back in 2015 [1] but apparently caused
many aplications to no longer compile, so some packagers added 
attr/xattr.h back, completing the cycle of confusion.
I just randomly remembered because Gentoo fell into the same sinkhole
and is still climbing out [2].

AFAIK sys/xattr.h is the preferred thing now unless you are building on 
an ancient distro.

cheers
Holger

[1] http://git.savannah.nongnu.org/cgit/attr.git/commit/?id=7921157890d07858d092f4003ca4c6bae9fd2c38
[2] https://bugs.gentoo.org/648864
