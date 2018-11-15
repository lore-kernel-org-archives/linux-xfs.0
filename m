Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388293AbeKPDoE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Nov 2018 22:44:04 -0500
Date: Thu, 15 Nov 2018 12:35:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs remove / unlink extremely slow ?
Message-ID: <20181115173516.GC27656@bfoster>
References: <3927644F-734A-4A2A-BACB-DE44CBC812EB@berlin.de>
 <14251045-1CCF-4E35-95F1-F6597FD8FD8C@berlin.de>
 <20181114144511.GB19257@bfoster>
 <20181115153815.GA27512@bfoster>
 <6102464C-F8C6-4BB0-AB98-FD11310BDF5E@berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6102464C-F8C6-4BB0-AB98-FD11310BDF5E@berlin.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Arndt <Michael.Arndt@berlin.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 15, 2018 at 06:07:46PM +0100, Michael Arndt wrote:
> Brian,
> 
> Info, supporting your remark about VFS layer: 
> 
> I did a reboot of cluster headnode and after that the remove was „fast“ meanig the typical millsecond /single file  to seconds /  removal of whole trees.
> 
> What does your intuition say, what could be suspected in the VFS layer / lvm2 layer or below to trigger this problem 
> ( just to collect ideas, where to search). ?
> 

If the problem only occurs after a period of time like this, I suppose
that could suggest some kind of cache effect is contributing to it. You
could see if an 'echo 2 > /proc/sys/vm/drop_caches' clears the problem
once it occurs, for example, but note that will clear all cached
dentries/inodes on the system.

I'm not familiar enough with the VFS code and associated caching to
speculate much beyond that. Other things that might be interesting are
whether other operations on said file take the same amount of time
(i.e., an mv before an rm?), whether this is a common filename pattern
that sees a lot of create/delete operations (perhaps polluting a lookup
cache with unlinked entries? i.e., does changing the filename have any
effect?), whether a relocation of the file to another directory changes
anything, whether other operations in the same dir on unrelated files
show the same problem, etc.

Your best bet is probably to collect as much trace data as you can and
then possibly report this to the general linux-fsdevel mailing list.
Note that if you're using a distro kernel, it might be more appropriate
to report an issue with your distro vendor than an upstream list.

Brian

> Caused by the fact, that the problem was seen also two times before, the issue will reappear after some time.
> 
> Off topic: is the mount option delaylog still functional or obsoleted, because already default behaviour ?
> 
> best
> Micha
> thx for extremely friendly help
> 
