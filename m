Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36007 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752813AbdHOA61 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 20:58:27 -0400
Received: by mail-qk0-f193.google.com with SMTP id d136so10845954qkg.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 17:58:27 -0700 (PDT)
Date: Mon, 14 Aug 2017 21:58:21 -0300
From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170815005818.GA1700@debian.home>
References: <20170814081806.GA3924@debian.home>
 <20170814222827.GC4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170814222827.GC4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>, Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?= <ernesto.mnd.fernandez@gmail.com>

On Mon, Aug 14, 2017 at 03:28:27PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 14, 2017 at 05:18:10AM -0300, Ernesto A. Fernández wrote:
> > The test won't exactly pass after this patch is applied. It will fail
> > differently, this time claiming that the filesystem is inconsistent. This
> 
> I disagree that corrupting the filesystem is an acceptable strategy for
> dealing with insufficient space to handle setfacl.
> 
> > probably has something to do with setting too many extended attributes, as
> > it goes away if you change the attribute size in the test from 1k to 64k.
> 
> Hadn't you better look into why it does that and handle it?

Hi Darrick, thank for your quick reply.

I think I failed to explain myself properly. The inconsistency issue is NOT
being caused by my patch. It was already there, and my patch just makes it
visible. I'll try to be more clear. The test generic/449 essentially goes
like this:

  1) It sets as many extended attributes as possible so the filesystem will
     run out of space for the ACL.
  2) It tries to set the ACL, which will fail because of (1).
  3) It checks that the mode was not altered by the failed setfacl.
  4) It checks that the filesystem was not corrupted.

The filesystem becomes corrupted after step (1). Before my patch, the test
was failing in step (3), so step (4) was never run. Once the ACL issue is
fixed, step (3) will pass and the test will get to (4). So now the test
announces the inconsistency, while before it was silent about it.

If the test is run without applying my patch, but changing it slightly so it
passes step (3), the end result will be the same: inconsistent filesystem. A
simple way to try this is to comment out the whole if block that deals with
the call to setfacl.

So whatever this issue is, it seems to be a general problem with extended
attributes in xfs. It has nothing to do with the bug my patch intends to
fix, other than the fact that generic/449 accidentally checks for both
problems.

My suggestion to adjust the attribute size in the test was so that we could
focus on the issue at hand, not so we could ignore the other one. Of course
it needs to be fixed as well. I will try to figure out what is going on and
hopefully send another patch. But both issues are independent, so please
take a look at my patch on its own merits. It does fix the ACL bug even if
the test does not pass.

Thank you for your attention,
Ernest
