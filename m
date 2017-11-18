Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161678AbdKRGRF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 18 Nov 2017 01:17:05 -0500
Date: Sat, 18 Nov 2017 14:17:03 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH v4 3/4] dm-log-writes: allow DAX to be used when
 possible
Message-ID: <20171118061703.GD2749@eguan.usersys.redhat.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
 <20171117202828.25472-4-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171117202828.25472-4-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

On Fri, Nov 17, 2017 at 01:28:27PM -0700, Ross Zwisler wrote:
> Enhance _require_dm_target so that a user can request a minimum version of a
> given dm target.
> 
> DAX support was added to v1.1.0 of the dm-log-writes kernel module, so
> allow the DAX mount option starting with that version.

Is is possible not relying on the version numbers but actually trying
what you want to do and _notrun if that fails? Currently fstests does no
version number checking at all, and it'd be great if we keep that
tradition.

Thanks,
Eryu
