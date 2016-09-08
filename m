Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:49434 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbcIHP3T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 11:29:19 -0400
Date: Thu, 8 Sep 2016 11:29:11 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
In-Reply-To: <20160903003919.GI30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com> <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com> <20160903003919.GI30056@dastard>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "linux-xfs" <linux-xfs@vger.kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Al Viro"
> <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com
> Sent: Friday, September 2, 2016 8:39:19 PM
> Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
> 
> On Fri, Sep 02, 2016 at 01:02:16PM -0400, CAI Qian wrote:
> > Spice seems start to deadlock using the reproducer,
> > 
> > https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/splice/splice01.c
> > 
> > This seems introduced recently after v4.8-rc3 or -rc4, so suspect this xfs
> > update was one to blame,
> > 
> > 7d1ce606a37922879cbe40a6122047827105a332
> 
> Nope, this goes back to the splice rework back around ~3.16, IIRC.
Right. FYI, revert the commit below fixes the regression,

8d02076 : ->splice_write() via ->write_iter()

   CAI Qian
