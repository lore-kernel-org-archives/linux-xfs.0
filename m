Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:30518 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932316AbdBVLUk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Feb 2017 06:20:40 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 1/7] fs, xfs: convert xfs_bui_log_item.bui_refcount from
 atomic_t to refcount_t
Date: Wed, 22 Feb 2017 11:20:31 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C4EB40@IRSMSX102.ger.corp.intel.com>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
 <1487692147-17066-2-git-send-email-elena.reshetova@intel.com>
 <20170221225534.GB23007@dastard>
In-Reply-To: <20170221225534.GB23007@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

> On Tue, Feb 21, 2017 at 05:49:01PM +0200, Elena Reshetova wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> 
> I'm missing something: how do you overflow a log item object
> reference count?

We are currently converting all reference counters present in kernel to a safer refcount_t type. 
Agreed, in some cases it might be easier or harder to actually create/trigger an overflow, but since it can be caused even by a bug in the legitimate code (current version or its future iterative), it is good idea to do "safe defaults" and stop worrying about the problem. 

Do you have any reasons why it should not be converted? 

Best Regards,
Elena.
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
