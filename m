Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:4322 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752992AbcJLWMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2016 18:12:19 -0400
Date: Thu, 13 Oct 2016 07:59:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [bisected] Re: local DoS - systemd hang or timeout (WAS: Re:
 [RFC][CFT] splice_read reworked)
Message-ID: <20161012205901.GF27872@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20161007070838.GA16260@quack2.suse.cz>
 <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com>
 <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com>
 <1337864351.1107846.1475866582573.JavaMail.zimbra@redhat.com>
 <20161009215454.GM9806@dastard>
 <988281682.41395.1476108629872.JavaMail.zimbra@redhat.com>
 <20161010215714.GF23194@dastard>
 <885869771.578073.1476301836438.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <885869771.578073.1476301836438.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Sage Weil <sage@redhat.com>, Brian Foster <bfoster@redhat.com>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, tj <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>

On Wed, Oct 12, 2016 at 03:50:36PM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > Sent: Monday, October 10, 2016 5:57:14 PM
> > 
> > > http://people.redhat.com/qcai/tmp/dmesg
> > 
> > It's a page lock order bug in the XFS seek hole/data implementation.
> So reverted this commit against the latest mainline allows trinity run
> hours. Otherwise, it always hang at fdatasync() within 30 minutes.
> 
> fc0561cefc04e7803c0f6501ca4f310a502f65b8
> xfs: optimise away log forces on timestamp updates for fdatasync

Has nothing at all to do with the hang.

> PS: tested against the vfs tree's #work.splice_read with this commit
> reverted is now hanging at sync() instead which won't be  reproduced
> against the mainline so far.
> http://people.redhat.com/qcai/tmp/dmesg-sync

It is the same page lock vs seek hole/data issue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
