Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f47.google.com ([209.85.160.47]:40776 "EHLO
        mail-pl0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966232AbeCTAxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 20:53:53 -0400
Date: Tue, 20 Mar 2018 08:53:46 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfs: test agfl reset on bad list wrapping
Message-ID: <20180320005346.GS30836@localhost.localdomain>
References: <20180316162602.GE1757@magnolia>
 <20180319173447.GB64748@bfoster.bfoster>
 <20180320000842.GC4866@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320000842.GC4866@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, fstests <fstests@vger.kernel.org>

On Mon, Mar 19, 2018 at 05:08:42PM -0700, Darrick J. Wong wrote:

> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/xfs
> > > +. ./common/filter
> > > +. ./common/populate
> > > +
> > 
> > Do we need the xfs and populate includes?
> 
> common/populate has the helpers for getting/setting metadata object fields.
> 
> common/xfs has _require_scratch_xfs_crc

Just a quick chime in, common/xfs is sourced automatically in common/rc
when $FSTYP is xfs, you don't need to source it in test.

Thanks,
Eryu
