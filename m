Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:42622 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdGOQgb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Jul 2017 12:36:31 -0400
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id 5225154A
        for <linux-xfs@vger.kernel.org>; Sat, 15 Jul 2017 16:36:31 +0000 (UTC)
From: "Tinguely, Mark" <mark.tinguely@hpe.com>
Subject: RE: Parent pointers
Date: Sat, 15 Jul 2017 16:36:27 +0000
Message-ID: <AT5PR84MB0163E6FA1BF71A12136E94EAE2A20@AT5PR84MB0163.NAMPRD84.PROD.OUTLOOK.COM>
References: <59680165.9020201@oracle.com>
 <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
 <817aafad-6b64-3700-6752-c63d7e5cdde7@sandeen.net>
 <59690307.9090407@oracle.com>
 <5d8fa5a7-110a-520f-9b13-b10627950bd3@sandeen.net>
 <20170714190740.GA43494@bfoster.bfoster> <20170714224658.GB4224@magnolia>
In-Reply-To: <20170714224658.GB4224@magnolia>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Allison Henderson <allison.henderson@oracle.com>, "cmaiolino@redhat.com" <cmaiolino@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

-----Original Message-----
From: linux-xfs-owner@vger.kernel.org [mailto:linux-xfs-owner@vger.kernel.org] On Behalf Of Darrick J. Wong
Sent: Friday, July 14, 2017 5:47 PM
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>; Allison Henderson <allison.henderson@oracle.com>; cmaiolino@redhat.com; linux-xfs@vger.kernel.org
Subject: Re: Parent pointers

On Fri, Jul 14, 2017 at 03:07:41PM -0400, Brian Foster wrote:
> On Fri, Jul 14, 2017 at 01:46:27PM -0500, Eric Sandeen wrote:
> > On 07/14/2017 12:44 PM, Allison Henderson wrote:
> > > On 7/14/2017 7:04 AM, Eric Sandeen wrote:
> > >>

<parent inode pointers returneth messages deleted>

> It's something to keep in mind, in any event. IIRC there were also 
> missing Signed-off-by's required for some of Mark's original patches.

That's also a problem; unless someone can get Mark to supply them, we probably have to get someone to rewrite them.  At a bare minimum I think we explicitly have to pass back a xfs_dir2_dataptr_t, not a bare uint32_t.

Me says:
The community can do what they want.  If you want to start with that code, permission for S-O-B: me (snickers at the pun)

> IMO, the best next step might be to just finish off the implementation 
> as-is such that we could have a fairly functional RFC to put on the 
> list and hash out whether there are in fact any remaining design 
> hurdles, but others might have a different opinion on that. :)

No one is asking me but I will add, IMO (definitely disclaiming the storage group and HPE):
 the PIP costs outweigh the benefits.
   Adding the redundant filename for recovery and an occasional output of the path pushes the cost to be *totally unreasonable*.
    If I had a say, I don't and won't, I would NAK any implementation that included it.
 Implementing with extended attributes is the wrong, wrong, wrong choice. It was done for hysterical :) reasons and even that appeasement bit me in the asterisk.

Good luck.

--Mark Tinguely 
  not representing anyone but myself.


