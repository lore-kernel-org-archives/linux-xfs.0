Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:37758 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbeCUO1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 10:27:22 -0400
Date: Wed, 21 Mar 2018 22:27:15 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 3/3] fstests: generic: Check the fs after each FUA writes
Message-ID: <20180321142715.GT30836@localhost.localdomain>
References: <20180321080125.30404-1-wqu@suse.com>
 <20180321080125.30404-3-wqu@suse.com>
 <CAOQ4uxidqwrKvVZSPysY_Rz6=pmBNr4G6F=oA+1Qn+=NEYn85g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxidqwrKvVZSPysY_Rz6=pmBNr4G6F=oA+1Qn+=NEYn85g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>

On Wed, Mar 21, 2018 at 02:22:29PM +0200, Amir Goldstein wrote:
> > +
> > +_log_writes_mount
> > +$FSSTRESS_PROG $fsstress_args > /dev/null 2>&1
> 
> You should run fsstress with run_check() so output will go to $seqres.full
> this way if you are able to catch a bug, you can take the random seed
> from fsstress output and repeat the same event sequence, which
> doesn't guaranty, but can increase the chances of reproducing the bug.

I suggested dropping run_check, as I don't think we care about the
fsstress return value here (and I always try to avoid new run_check
usage), but I agree that it might be useful to save the fsstress output
to $seqres.full.

Thanks,
Eryu
