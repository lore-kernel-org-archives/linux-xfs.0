Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 07:24:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2EEO4e4001632
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 07:24:08 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72B3D1156ED0
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 07:24:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id G7AuI9guKHRB0oZP for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 07:24:35 -0700 (PDT)
Message-ID: <47DA8AA0.3020902@sandeen.net>
Date: Fri, 14 Mar 2008 09:24:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair on root filesystem
References: <1205496795.16829.6.camel@AXALTO-9A9B4636.homelinux.doma>
In-Reply-To: <1205496795.16829.6.camel@AXALTO-9A9B4636.homelinux.doma>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Massimiliano Adamo <maxadamo@gmail.com>
Cc: xfs@oss.sgi.com

Massimiliano Adamo wrote:
> Hi all,
> 
> I have seen that it's possible to run xfs_check on filesystems mounted
> read-only, but in order to use xfs_repair the filesystem must be
> unmounted.
> I can't even imagine how to run xfs_repair on root filesystem, without
> booting from a live cd.
> 
> Do you think it would be possible to implement xfs_repair on 'ro'
> filesystem, or on filesytems frozen with xfs_freeze?

Like this, from the xfs_repair manpage? :)

       -d     Repair dangerously.  Allow  xfs_repair
              to  repair  an  XFS filesystem mounted
              read only. This is typically done on a
              root  fileystem from single user mode,
              immediately followed by a reboot.

For an added bonus, you could create a "rescue initrd" which contains
repair.  I always thought this would be a neat trick.

> The other question would be about the possibility to shrink a XFS
> filesystem... but as I can see this is a work already in progress.

It is (slowly) in progress I think, and something of a FAQ by now :)

-Eric

> cheers
> Massimiliano Adamo
> 
> 
