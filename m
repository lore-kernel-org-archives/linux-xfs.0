Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:45330 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756141AbdKCMTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 08:19:17 -0400
Received: by mail-yw0-f193.google.com with SMTP id j4so2225228ywb.2
        for <linux-xfs@vger.kernel.org>; Fri, 03 Nov 2017 05:19:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171103112626.GA19974@bfoster.bfoster>
References: <20171026083322.20428-1-david@fromorbit.com> <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard> <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard> <20171101141720.GB11709@bfoster.bfoster>
 <20171101235300.GT5858@dastard> <20171102112533.GA15748@bfoster.bfoster>
 <20171102233017.GX5858@dastard> <20171103112626.GA19974@bfoster.bfoster>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 3 Nov 2017 14:19:15 +0200
Message-ID: <CAOQ4uxjEUAR1-1ikZSN2e99gK4k_mEMnhGGYvw=2Zj6oLOPVuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 3, 2017 at 1:26 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Fri, Nov 03, 2017 at 10:30:17AM +1100, Dave Chinner wrote:
>> On Thu, Nov 02, 2017 at 07:25:33AM -0400, Brian Foster wrote:
...
>>
>> As such, trying to determine a future proof growfs interface change
>> right now is simply a waste of time because we're not going to get
>> it right.
>>
>
> I'm not sure where the flags proposal thing came from, but regardless...
> I'm not trying to future proof/design a shrink interface. Rather, just
> reviewing the (use of the) interface as it already exists. I suppose I
> am kind of assuming that the current interface would enable some form of
> functionality in that hypothetical future world where physical shrink
> exists. Perhaps that is not so realistic, however, as you suggest.
>

Guys,

Can we PLEASE stop talking about physical shrink?
I get it, it's unlikely to happen, I sorry I brought up this example
in the first place.

Whether or not we implement physical shirk is not the main issue.
The main issue is implicitly changing the meaning of an existing API.
What can go wrong? I don't know and I rather not give examples,
because then people address the examples and not the conceptual flaw.

This is how I propose to smooth in the new API with as little pain as
possible for existing deployments, yet making sure that "usable block"
is only modified by new programs that intend to modify it:

----------------------
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8f22fc579dbb..922798ebf3e8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -171,10 +171,25 @@ xfs_growfs_data_private(
        xfs_rfsblock_t          nfree;
        xfs_agnumber_t          oagcount;
        int                     pct;
+       unsigned                ver;
        xfs_trans_t             *tp;

        nb = in->newblocks;
-       pct = in->imaxpct;
+       pct = in->imaxpct & 0xff;
+       ver = in->imaxpct >> 8;
+       if (ver > 1)
+               return -EINVAL;
+
+       /*
+        * V0 API is only allowed to grow sb_usable_dblocks along with
+        * sb_dblocks.  Any other change to sb_usable_dblocks requires
+        * V1 API to prove that userspace is aware of usable_dblocks.
+        */
+       if (ver == 0 && xfs_sb_version_hasthinspace(mp->m_sb) &&
+           (mp->m_sb.sb_usable_dblocks != mp->m_sb.sb_dblocks ||
+            nb < mp->m_sb.sb_dblocks))
+               return -EINVAL;
+
        if (nb < mp->m_sb.sb_dblocks || pct < 0 || pct > 100)
                return -EINVAL;

----------------

When xfs_grow WANTS to change size of fs known to be thin, it should set
in->imaxpct |= 1 << 8;

Dave,

Is that the complication of implementation you were talking about?
Really?

Don't you see that this is the right thing to do w.r.t. API design?
If it were you on the other side of review, I bet you would argued the
same as Brian and myself and use the argument that "The syscall and ioctl
APIs are littered with examples and we should pay heed to the lessons those
mistakes teach us." to oppose implicit API change.

Seriously, my opinion does not carry enough weight in the xfs community
to out weight your opinion and if it weren't for Brian who stepped in to
argue in favor of my claims, I would have given up trying to convince you.

Sorry if this is coming off as too harsh of a response.
The sole motivation behind this argument is to prevent pain in the future.
And you are right, we can never predict the future correctly, except for one
thing - that we WILL encounter use cases that none of us can see right now.

Cheers,
Amir
