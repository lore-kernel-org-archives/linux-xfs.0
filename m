Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B478C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 15:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbjKIPYU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 10:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbjKIPYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 10:24:20 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3921F30DC;
        Thu,  9 Nov 2023 07:24:18 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 40FE467373; Thu,  9 Nov 2023 16:24:13 +0100 (CET)
Date:   Thu, 9 Nov 2023 16:24:12 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.g.garry@oracle.com>
Cc:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org,
        chandan.babu@oracle.com, dchinner@redhat.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-api@vger.kernel.org
Subject: Re: [PATCH 12/21] fs: xfs: Introduce FORCEALIGN inode flag
Message-ID: <20231109152412.GA1521@lst.de>
References: <20230929102726.2985188-1-john.g.garry@oracle.com> <20230929102726.2985188-13-john.g.garry@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929102726.2985188-13-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 29, 2023 at 10:27:17AM +0000, John Garry wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Add a new inode flag to require that all file data extent mappings must
> be aligned (both the file offset range and the allocated space itself)
> to the extent size hint.  Having a separate COW extent size hint is no
> longer allowed.
> 
> The goal here is to enable sysadmins and users to mandate that all space
> mappings in a file must have a startoff/blockcount that are aligned to
> (say) a 2MB alignment and that the startblock/blockcount will follow the
> same alignment.

This needs a good explanation of why someone would want this.

