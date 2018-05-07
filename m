Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bullwinkle.deer-run.com ([50.23.32.3]:58467 "EHLO
        bullwinkle.deer-run.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbeEGLhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 07:37:01 -0400
Date: Mon, 7 May 2018 06:35:34 -0500
From: hal@deer-run.com
Subject: Re: [PATCH] xfs_db: add -R option
Message-ID: <20180507113534.GB2486@deer-run.com>
References: <20180504140244.GA32161@deer-run.com>
 <20180504153255.GI26569@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180504153255.GI26569@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> Why skip the warning?  I think xfs_db should always warn on a dirty log,
> but perhaps we could relax the 'return 0' at the end of this hunk if the
> fs was opened readonly?
> 
> i.e.
> 
> dbprintf(_("ERROR: The filesystem has..."));
> return (x.isreadonly & LIBXFS_ISREADONLY) ? 1 : 0;
> 
> which would also make adding the -R option unnecessary.

I like this solution very much. I'll send in this patch in a
separate email.

Hal Pomeranz
