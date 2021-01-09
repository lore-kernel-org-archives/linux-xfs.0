Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD87C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 21:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52908235FF
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 21:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbhAIVOb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 16:14:31 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:34269 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbhAIVOb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 16:14:31 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id E5A4BE69760;
        Sun, 10 Jan 2021 08:13:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kyLYR-004mhq-4Y; Sun, 10 Jan 2021 08:13:47 +1100
Date:   Sun, 10 Jan 2021 08:13:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "L.A. Walsh" <xfs@tlinx.org>
Cc:     xfs-oss <linux-xfs@vger.kernel.org>
Subject: Re: suggested patch to allow user to access their own file...
Message-ID: <20210109211347.GL331610@dread.disaster.area>
References: <5FEB204B.9090109@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FEB204B.9090109@tlinx.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=Zh8UF6euKYRQSDcZ9McA:9 a=CjuIK1q_8ugA:10 a=nxFJi58FgSUA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 29, 2020 at 04:25:47AM -0800, L.A. Walsh wrote:
> xfs_io checks for CAP_SYS_ADMIN in order to open a
> file_by_inode -- however, if the file one is opening
> is owned by the user performing the call, the call should
> not fail.

No. xfs_open_by_handle() requires root permissions because it
bypasses lots of security checks, such as parent directory
permissions, ACLs and security labels.

e.g. backups under a root-only directory heirarchy should not be
accessible to users because users are not allowed to traverse into
those root:root 0700 backup directories because permissions on the 
directory inodes do not allow non-root users to enter them.

Hence ...

> (i.e. it opens the user's own file).

... the user doesn't actually own that file, even though it has
their own UID in it...

> It gets rid of some unnecessary error messages if you
> run xfs_restore to restore one of your own files.

That's not really a user case xfs_restore is intended to support.
It's an admin tool to be run by admins, not end users....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
