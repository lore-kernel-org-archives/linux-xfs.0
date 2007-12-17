Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 17:48:56 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBH1mooI009086
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:48:51 -0800
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86B3B48CE4F
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:48:57 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id s47q29H8FZDbdfmY for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:48:57 -0800 (PST)
Received: from jdc.jasonjgw.net (ip6-localhost [IPv6:::1])
	by jdc.jasonjgw.net (8.14.2/8.14.2/Debian-2) with ESMTP id lBH1kRh7013913
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 12:46:27 +1100
Received: (from jason@localhost)
	by jdc.jasonjgw.net (8.14.2/8.14.2/Submit) id lBH1kRLo013912
	for xfs@oss.sgi.com; Mon, 17 Dec 2007 12:46:27 +1100
Date: Mon, 17 Dec 2007 12:46:27 +1100
From: Jason White <jason@jasonjgw.net>
Subject: Re: Installing grub onto a system with XFS root fs
Message-ID: <20071217014627.GA13692@jdc.jasonjgw.net>
References: <20071217004945.GA13335@jdc.jasonjgw.net> <4765CBBF.1020207@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4765CBBF.1020207@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Sun, Dec 16, 2007 at 07:07:11PM -0600, Eric Sandeen wrote:
 
> Hard to say - in a nutshell, grub just sucks w.r.t. how it (ab)uses the
> filesystem it's trying to install on.
> 
> In some invocations, it actually writes directly to the block device
> *while it is mounted* - this leads to data corruption and/or filesystem
> corruption.
> 
> In other cases, in a "verification" phase, it tries to directly read
> filesystem structures off the disk *while it is mounted* after a couple
> of wishful sync; sync;'s - this often can lead to a grub hang when it
> goes off in the weeds on inconsistent disk data that it finds.
> 
> I think various distros have tried to hack around these problems in
> different ways; the freeze above is probably an effort to coalesce the
> filesystem before grub goes groveling around the disk to verify what it
> just wrote(!).
> 

Thanks for the background. The most up to date bug report and discussion I
could find is here:
https://bugs.launchpad.net/debian/+source/grub/+bug/8058
(for Ubuntu).

There are also Debian bugs for this, such as
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=239111

Manually unfreezing the file system with xfs_freeze -u /
worked for me on one machine. (This was done while grub-install was executing,
after it executed xfs_freeze).
