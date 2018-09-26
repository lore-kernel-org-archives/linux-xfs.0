Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:22826 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbeIZHKl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 03:10:41 -0400
Date: Wed, 26 Sep 2018 10:59:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Strange behavior with log IO fake-completions
Message-ID: <20180926005935.GC31060@dastard>
References: <CA+1E3r+crZ6suDtTheOysm_dzZ2FeU=z4R-aQQw7etk1yuxOLQ@mail.gmail.com>
 <20180910235827.GD5631@dastard>
 <CA+1E3r+Lggw9JJymdhoyzkqQfqGETZE=R=WG09s7FOhY3Snb5g@mail.gmail.com>
 <20180912004259.GJ5631@dastard>
 <CA+1E3r+gd57nOv=S0gjrbU8df2qXa67njPP=KK1oPqLmsO5thQ@mail.gmail.com>
 <20180917025601.GE16550@dastard>
 <20180921002336.GO27618@dastard>
 <CA+1E3rJ5d9ie8z79ph-71P-w1hSiR1Rdz7vAugv0vELF=sb5aA@mail.gmail.com>
 <CA+1E3rL1JA1PWC+53aU+RQcxFucccXu7M-K-m9AiEXaCjfCF=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rL1JA1PWC+53aU+RQcxFucccXu7M-K-m9AiEXaCjfCF=w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joshi <joshiiitr@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 24, 2018 at 07:55:02PM +0530, Joshi wrote:
> > I changed all log wait queues (ic_force_wait, ic_write_wait, and
> xc_commit_wait) into completion variables (despite knowing that it is
> also implemented using wait_queue).
> 
> Sorry, ignore this and subsequent part of the text. I think replacing
> with completion requires more work than I did.Calling "complete_all"
> is tricky, given the need of calling "reinit_completion" which may get
> executed by multiple threads in this case.

Yup.

Perhaps 
you might like to look at this recent patch set aimed at reducing
spurious wake-ups and lock contention in the log reservation code:

https://marc.info/?l=linux-kernel&m=153531683127094&w=2

Not sure it applies to this case, but it still may be useful to you.

BTW, when posting benchmark results, can you also include a baseline
result from a completely unmodified kernel and the patches you are
testing? Nobody can evaluate the correctness or effectiveness of the
changes you are testing without these things....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
