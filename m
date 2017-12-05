Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46398 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751847AbdLEXVh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Dec 2017 18:21:37 -0500
Date: Tue, 5 Dec 2017 16:21:36 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH v4 3/4] dm-log-writes: allow DAX to be used when
 possible
Message-ID: <20171205232136.GA9541@linux.intel.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
 <20171117202828.25472-4-ross.zwisler@linux.intel.com>
 <20171118061703.GD2749@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171118061703.GD2749@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

On Sat, Nov 18, 2017 at 02:17:03PM +0800, Eryu Guan wrote:
> On Fri, Nov 17, 2017 at 01:28:27PM -0700, Ross Zwisler wrote:
> > Enhance _require_dm_target so that a user can request a minimum version of a
> > given dm target.
> > 
> > DAX support was added to v1.1.0 of the dm-log-writes kernel module, so
> > allow the DAX mount option starting with that version.
> 
> Is is possible not relying on the version numbers but actually trying
> what you want to do and _notrun if that fails? Currently fstests does no
> version number checking at all, and it'd be great if we keep that
> tradition.

Yep, and I agree that this is better.  I'll be fixed in the next version.
Thanks for the feedback.
