Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:43345 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751996AbeCMSFl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 14:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgWuS-=mR8+_+vHMkD7szrXTgnnMPtbx2nj88-MgzLa9w@mail.gmail.com>
References: <CA+EzBbCtp9wKC=KeN+N1iZDa2+TsWxVho3aUkeXJXguVswkChA@mail.gmail.com>
 <20180313042126.GB18129@dastard> <CAOQ4uxgWuS-=mR8+_+vHMkD7szrXTgnnMPtbx2nj88-MgzLa9w@mail.gmail.com>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Tue, 13 Mar 2018 13:05:39 -0500
Message-ID: <CA+EzBbDXWPFiOzL1T+LDFo11SzUYoVVBRW462PWDB8F+JHQmUg@mail.gmail.com>
Subject: Re: XFS crash consistency bug : Loss of fsynced metadata operation
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>, Theodore Tso <tytso@mit.edu>, fstests <fstests@vger.kernel.org>

Hi Amir,

We reported these bugs separately on the two mailing lists because,
though the workload was the same, the behavior/bug was different on
the two filesystems. On ext4 there was data loss, while on xfs the
fzero operation was not persisted even after a fsync.

On Tue, Mar 13, 2018 at 1:36 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Since the exact same report was sent to the ext4 list, CC'ing Dave's response to
> Ted and fstests, which seems an appropriate crowd for this discussion.
> I think that future CrashMonkey findings should be CC'ed to either fsdevel
> or fstests, especially if more than one filesystem is affected.

Thanks for the suggestion. We will CC our future reports to these lists.

Thanks,
Jayashree
