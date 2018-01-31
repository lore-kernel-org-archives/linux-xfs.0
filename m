Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752840AbeAaRza (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jan 2018 12:55:30 -0500
Message-ID: <1517421324.32569.15.camel@kernel.org>
Subject: Re: [PATCH v2] iversion: make inode_cmp_iversion{+raw} return bool
 instead of s64
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 31 Jan 2018 12:55:24 -0500
In-Reply-To: <CA+55aFxB6og=iRkRchiOrr8EW2=jgb_i4nUiPsvEa+8F64APxA@mail.gmail.com>
References: <20180130173126.2806-1-jlayton@kernel.org>
         <20180130203221.29310-1-jlayton@kernel.org>
         <CA+55aFw5Xf4V-BF1JK+SpjXnmrgeMe-k0wLaFc_=6ojbhfWEtQ@mail.gmail.com>
         <1517401762.3612.0.camel@kernel.org>
         <CA+55aFxB6og=iRkRchiOrr8EW2=jgb_i4nUiPsvEa+8F64APxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Trond Myklebust <trondmy@primarydata.com>, GoffredoBaroncelli <kreijack@libero.it>

On Wed, 2018-01-31 at 08:46 -0800, Linus Torvalds wrote:
> On Wed, Jan 31, 2018 at 4:29 AM, Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > Do you mind just taking it directly? I don't have anything else queued
> > up for this cycle.
> 
> Done.
> 

Thanks...and also many thanks for spotting the original issue. I agree
that this makes it much harder for the callers to get things wrong (and
is probably much more efficient on some arches, as Ted pointed out).

> I wonder if "false for same, true for different" calling convention
> makes much sense, but it matches the old "0 for same" so obviously
> makes for a smaller diff.
> 
> If it ever ends up confusing people, maybe the sense of that function
> should be reversed, and the name changed to something like
> "same_inode_version()" or something.
> 
> But at least for now the situation seems ok to me,
> 

G. Baroncelli suggested changing the name too, so maybe we should just
go ahead and do it. Let me think on what the best approach is and I may
try to send another patch or PR before the end of the merge window.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>
