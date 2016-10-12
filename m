Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:53590 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755920AbcJLTv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2016 15:51:27 -0400
Date: Wed, 12 Oct 2016 15:50:36 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <885869771.578073.1476301836438.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161010215714.GF23194@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20161007070838.GA16260@quack2.suse.cz> <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com> <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com> <1337864351.1107846.1475866582573.JavaMail.zimbra@redhat.com> <20161009215454.GM9806@dastard> <988281682.41395.1476108629872.JavaMail.zimbra@redhat.com> <20161010215714.GF23194@dastard>
Subject: [bisected] Re: local DoS - systemd hang or timeout (WAS: Re:
 [RFC][CFT] splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Sage Weil <sage@redhat.com>, Brian Foster <bfoster@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, tj <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> Sent: Monday, October 10, 2016 5:57:14 PM
> 
> > http://people.redhat.com/qcai/tmp/dmesg
> 
> It's a page lock order bug in the XFS seek hole/data implementation.
So reverted this commit against the latest mainline allows trinity run
hours. Otherwise, it always hang at fdatasync() within 30 minutes.

fc0561cefc04e7803c0f6501ca4f310a502f65b8
xfs: optimise away log forces on timestamp updates for fdatasync

PS: tested against the vfs tree's #work.splice_read with this commit
reverted is now hanging at sync() instead which won't be  reproduced
against the mainline so far.
http://people.redhat.com/qcai/tmp/dmesg-sync

   CAI Qian
