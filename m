Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from albireo.enyo.de ([5.158.152.32]:50733 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751725AbcJCRf0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Oct 2016 13:35:26 -0400
From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: Excessive xfs_inode allocations trigger OOM killer
References: <87a8f2pd2d.fsf@mid.deneb.enyo.de> <20160920203039.GI340@dastard>
        <87mvj2mgsg.fsf@mid.deneb.enyo.de> <20160920214612.GJ340@dastard>
        <20160921080425.GC10300@dhcp22.suse.cz>
        <878tuetvl6.fsf@mid.deneb.enyo.de>
        <20160926200209.GA23827@dhcp22.suse.cz>
Date: Mon, 03 Oct 2016 19:35:18 +0200
In-Reply-To: <20160926200209.GA23827@dhcp22.suse.cz> (Michal Hocko's message
        of "Mon, 26 Sep 2016 22:02:10 +0200")
Message-ID: <878tu5xrmx.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org

* Michal Hocko:

>> I'm not sure if I can reproduce this issue in a sufficiently reliable
>> way, but I can try.  (I still have not found the process which causes
>> the xfs_inode allocations go up.)
>> 
>> Is linux-next still the tree to test?
>
> Yes it contains all the compaction related fixes which we believe to
> address recent higher order OOMs.

I tried 4.7.5 instead.  I could not reproduce the issue so far there.
Thanks to whoever fixed it. :)
