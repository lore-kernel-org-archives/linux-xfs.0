Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36760 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdLFMxm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 07:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <20171206003744.28587-2-ross.zwisler@linux.intel.com>
References: <20171206003744.28587-1-ross.zwisler@linux.intel.com> <20171206003744.28587-2-ross.zwisler@linux.intel.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 6 Dec 2017 14:53:41 +0200
Message-ID: <CAOQ4uxj1Y-qWU_9joBVEhzDwGOpmvBYK0Ew0D1Qh=xyEOW3ihw@mail.gmail.com>
Subject: Re: [fstests PATCH v5 1/2] dm-log-writes: only replay log to marks
 that exist
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>

On Wed, Dec 6, 2017 at 2:37 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> The 'replay-log' executable will replay the dm-log-writes log until the
> given mark, or until the end of the log if the mark isn't found.
>
> This means that if the mark you're looking for was never inserted in the
> log or if you give garbage to _log_writes_replay_log() the entire log will
> be replayed.  This can cause unexpected test results.
>
> Fix this by making sure that the mark we're given actually exists in the
> log before we allow the replay.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
Looks good.

Amir.
