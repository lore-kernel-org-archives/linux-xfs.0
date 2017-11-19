Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from gozora.sk ([83.167.232.19]:38794 "EHLO gozora.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbdKSKkG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 19 Nov 2017 05:40:06 -0500
Date: Sun, 19 Nov 2017 11:40:04 +0100 (CET)
From: Vladimir Gozora <c@gozora.sk>
Subject: Re: Illegal value 0 for -l sunit option ?
In-Reply-To: <20171118215140.GL5858@dastard>
Message-ID: <alpine.DEB.2.10.1711191100230.19352@gozora.sk>
References: <alpine.DEB.2.10.1711181547110.14549@gozora.sk> <20171118215140.GL5858@dastard>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hello Dave,

Thanks for your reply!

> Yup, old mkfs would accept values that were illegal and could do 
> completly unpredictable things with them. We tightened up the input 
> parsing to only accept valid values xfsprogs in 4.7.0

I fully agree here, you can't allow illegal values to enter file system 
structures. What is somehow confusing for me (as a user who don't have 
deep knowledge of XFS internals) is xfs_info output who proclaims XFS file 
system options that are set and in use (so I'd consider them valid), but 
on the other hand are evaluated by mkfs.xfs as invalid :-/.

Apart from that when I omit "-l sunit=0" in my mkfs.xfs command, 
file system is successfully created and consecutive call to xfs_info 
returns that my file system was created with "sunit=0 blks" ... This 
somehow don't feels right to me.

> Why not just use xfs_copy? I mean, if all you're trying to do is
> make a space efficient block-level clone of an XFS filesytem, then
> we've already got a tool to do that...

Honestly I've did not know much about this tool until you've mentioned it. 
I've tried it today for first time in my life and despite its certain 
usefulness I can't really use it for solving problem of mine. ReaR can 
operate in multiple modes where xfs_copy could be implemented, 
unfortunately I'm trying to solve problems in mode that is most frequently 
used by our users and implementing xfs_copy could cause havoc. The mode 
I'm talking about just collects information about your current 
partitioning, file systems, mount points etc, and stores them as config 
file into bootable ISO (which does not contains actual OS data). Once you 
boot ISO, all these data are pull out and passed to appropriate user space 
programs for structure recreation. So this is the main reason why I need 
to have original file system values at hand ...

Best regards!

Vlado
