Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 16:31:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2INUt5x003815
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 16:30:57 -0700
Received: from rv-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BA226BA6F6
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 16:31:27 -0700 (PDT)
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.187]) by cuda.sgi.com with ESMTP id XYtdvnO1QH2F5Im3 for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 16:31:27 -0700 (PDT)
Received: by rv-out-0910.google.com with SMTP id k20so66322rvb.32
        for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 16:31:27 -0700 (PDT)
Message-ID: <b1b17e290803181631x60a3e921l836b115c3b026773@mail.gmail.com>
Date: Tue, 18 Mar 2008 23:31:27 +0000
From: "Andre Draszik" <xfs@andred.net>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

(I just subscribed, so I can't reply correctly :-(

In fact,, the last two evenings I spent making XFS work on arm eabi,
where things are much better than with the old API, but still XFS
won't work out of the box.

So, Eric, if you go for the #if defined(__arm__) &&
!defined(__ARM_EABI__) approach, arm eabi will still be broken.

EABI basically behaves like other 'normal' arches/abis, but sometimes
structures get padded to have a size of a multiple of 8, i.e. padding
is added at the end of the struct, which as far as I can see for now
affects 5 structs: xfs_dir2_data_entry_t, xfs_dinode_t, xfs_sb_t,
xfs_dsb_t, and xfs_log_item_t

I must say, I like Jeff's approach of explicitly telling gcc about
alignment much better :-) It makes it a) much easier to find structs
that are in fact representations of on-disk data and thus might need
tweaking, and b) as somebody already said you fix such problems once
and forever.
E.g. for me as an absolute outsider, it was quite time consuming
finding out which structs are actually on-disk.


That said, Jeff, you mentioned that your changes don't work yet
completely - could this be because (at least from the comments) struct
xfs_sb needs to match struct xfs_dsb and you only change xfs_dsb?


Cheers,
Andre'
