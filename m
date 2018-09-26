Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:52740 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725733AbeI0Aiv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 20:38:51 -0400
Date: Wed, 26 Sep 2018 19:24:26 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-ID: <20180926192426.472360ea@alans-desktop>
In-Reply-To: <20180926013329.GD31060@dastard>
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
        <20180926013329.GD31060@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: TongZhang <ztong@vt.edu>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

On Wed, 26 Sep 2018 11:33:29 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Sep 25, 2018 at 08:51:50PM -0400, TongZhang wrote:
> > Hi,
> > 
> > I'm bringing up this issue again to let of LSM developers know the situation, and would like to know your thoughts.
> > Several weeks ago I sent an email to the security list to discuss the issue where
> > XFS's ioctl interface can do things like vfs_readlink without asking LSM's
> > permission, which we think is kind of weird and this kind of operation should be
> > audited by LSM.  
> 
> These aren't user interfaces. They are filesystem maintenance and
> extension interfaces.  They are intended for low level filesystem
> utilities that require complete, unrestricted access to the
> underlying filesystem via holding CAP_SYSADMIN in the initns.

CAP_SYS_ADMIN is meaningless in an environment using a strong LSM set up.
So what if I have CAP_SYS_ADMIN ? In a secure environment low level
complete unrestricted access to the file system is most definitely
something that should be mediated.

CAP_SYS_ADMIN is also a bit weird because low level access usually
implies you can bypass access controls so you should also check
CAP_SYS_DAC ?

Alan
