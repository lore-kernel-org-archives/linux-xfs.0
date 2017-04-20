Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35803 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938900AbdDTWEf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 18:04:35 -0400
Date: Thu, 20 Apr 2017 15:04:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/5] fs, xfs refcount conversions
Message-ID: <20170420220428.GG5205@birch.djwong.org>
References: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
 <2236FBA76BA1254E88B949DDB74E612B41C8D726@IRSMSX102.ger.corp.intel.com>
 <20170420172404.GE23371@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170420172404.GE23371@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>

On Thu, Apr 20, 2017 at 10:24:04AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 20, 2017 at 08:11:41AM +0000, Reshetova, Elena wrote:
> > 
> >  
> > > v3:
> > >  * fixed header file inclusion
> > 
> > I don't think I have heard anything back on this v3 patch set. 
> > Is there still smth here to fix or could you take the changes in?
> 
> Generally I think it looks ok; it's running through shakedown testing as
> we speak.

Well, it survives the shakedown testing all right, but I can't shake the
feeling that this is overkill.  The xfs_{ef,bu,cu,ru}i_log_item
structures should only ever be referenced by the log itself and the
log-update-done log item: the refcount should only ever go 2 -> 1 -> 0.
We set the refcount to 2 and never increment it.

Given that I've seen occasional refcounting problems with the log intent
items, I think it would suffice to ASSERT in xfs_*i_release that the
refcount isn't already zero.  Using ASSERT is particularly useful
because ASSERT compiles out in release builds.

As for the xlog_ticket, we increment its refcount as part of duplicating
a transaction as a part of committing one transaction (which decrements
the xlog_ticket's refcount) and reusing the log reservation to create a
new transaction.  In this case the refcounting already seems to have
sufficient non-zero checks, and since only one thread can hold a
transaction at any given time, I don't see how overflow protection helps
here.

In other words, I'm ok with better refcount checking but need convincing
that we need to do more than what a simple ASSERT would provide.

--D

> 
> --D
> 
> > 
> > Best Regards,
> > Elena.
> > 
> > > 
> > > Now when new refcount_t type and API are finally merged
> > > (see include/linux/refcount.h), the following
> > > patches convert various refcounters in the xfs susystem from atomic_t
> > > to refcount_t. By doing this we prevent intentional or accidental
> > > underflows or overflows that can led to use-after-free vulnerabilities.
> > > 
> > > 
> > > Elena Reshetova (5):
> > >   fs, xfs: convert xfs_bui_log_item.bui_refcount from atomic_t to
> > >     refcount_t
> > >   fs, xfs: convert xfs_efi_log_item.efi_refcount from atomic_t to
> > >     refcount_t
> > >   fs, xfs: convert xlog_ticket.t_ref from atomic_t to refcount_t
> > >   fs, xfs: convert xfs_cui_log_item.cui_refcount from atomic_t to
> > >     refcount_t
> > >   fs, xfs: convert xfs_rui_log_item.rui_refcount from atomic_t to
> > >     refcount_t
> > > 
> > >  fs/xfs/xfs_bmap_item.c     |  4 ++--
> > >  fs/xfs/xfs_bmap_item.h     |  2 +-
> > >  fs/xfs/xfs_extfree_item.c  |  4 ++--
> > >  fs/xfs/xfs_extfree_item.h  |  2 +-
> > >  fs/xfs/xfs_linux.h         |  1 +
> > >  fs/xfs/xfs_log.c           | 10 +++++-----
> > >  fs/xfs/xfs_log_priv.h      |  2 +-
> > >  fs/xfs/xfs_refcount_item.c |  4 ++--
> > >  fs/xfs/xfs_refcount_item.h |  2 +-
> > >  fs/xfs/xfs_rmap_item.c     |  4 ++--
> > >  fs/xfs/xfs_rmap_item.h     |  2 +-
> > >  11 files changed, 19 insertions(+), 18 deletions(-)
> > > 
> > > --
> > > 2.7.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
