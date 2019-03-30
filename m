Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40838 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730477AbfC3KL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Mar 2019 06:11:58 -0400
Date: Sat, 30 Mar 2019 18:11:52 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] generic: prohibit fstrim on journalled filesystems with
 norecovery
Message-ID: <20190330101152.GB2824@desktop>
References: <20190323003532.GB1180@magnolia>
 <CAL3q7H4Un5e5xOkTgAVXthfr-N1CXwf6e4qOyQ9WeXQoj3E8Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4Un5e5xOkTgAVXthfr-N1CXwf6e4qOyQ9WeXQoj3E8Uw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Filipe David Manana <fdmanana@apache.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Tue, Mar 26, 2019 at 12:21:20PM +0000, Filipe David Manana wrote:
> On Sat, Mar 23, 2019 at 12:35 AM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > This test makes sure that we can't use stale unrecovered fs metadata to
> > drive a DISCARD festival on a disk and thereby destroy user data by
> > accident.
> 
> It would help to have listed the name of the patches that fix the
> issues on xfs/ext4/btrfs, to make it faster.

Yeah, I'm about to do that :)

> 
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Looks good, thanks for doing this. Just one question below.

Thanks for reviewing!

Eryu
