Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A62CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 15:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347050AbjJLPCh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 11:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347132AbjJLPCe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 11:02:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE29DD8
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 08:02:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F752C433C8;
        Thu, 12 Oct 2023 15:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697122952;
        bh=2TiwwYz46r6kzZBaW+sT1SADgAQj9WBO8Yqz/0HFbwg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Us5GDHlbzgO1iaSGMUKWcpJaFY5xlXRJtstZp/f6IY+zN/uvssFqH3evIXG7QP7Fg
         nqI7Slg8ULbLnmCykKC1JWrKoOk5C3CkAU+CsWFvyrpVtSAUs3sBwIwpyQUPxo5llf
         h1mder2lQ0YdI4RsJxLBg8VG5/8t8/sA7XFD5NjOBqE0RzjpiK8b5Rdq5ePoW2au4z
         /HkvstbyQem933ocAeSAuLgQ32rqAr2J7fW2n5vxek9ySunHpM2GV5t35UtChqifRn
         x4vR2cn+o+FzVfNzWixCC9t7XW5wM7A7BYqMfNWLL5qTMHapnq7/jYf8fJz4o+5jM4
         GoixEpQfUSAGw==
Date:   Thu, 12 Oct 2023 08:02:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <20231012150231.GE21298@frogsfrogsfrogs>
References: <20231012010845.64286-1-catherine.hoang@oracle.com>
 <ZSevmga8j3dNl34J@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSevmga8j3dNl34J@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 01:34:34AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 06:08:45PM -0700, Catherine Hoang wrote:
> > Clone operations and read IO do not change any data in the source file, so they
> > should be able to run concurrently. Demote the exclusive locks taken by FICLONE
> > to shared locks to allow reads while cloning. While a clone is in progress,
> > writes will take the IOLOCK_EXCL, so they block until the clone completes.
> 
> FYI, the first two lines are too long for the normal commit log format.
> 
> Can you provide a justification for the change, i.e. worksloads for
> which this matters, and what metrics are improved?

Catherine started with this,
https://lore.kernel.org/linux-xfs/8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com/

and the rest of us whittled it down to the single patch you see here.
Sections 1-2 are still relevant; S3 was the path not taken.

The commit message should Link: to that.

--D
