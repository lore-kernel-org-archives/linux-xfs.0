Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759B9EC8740
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Sep 2023 15:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjIGPmh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 11:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344526AbjIGPdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2023 11:33:23 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8C119B4
        for <linux-xfs@vger.kernel.org>; Thu,  7 Sep 2023 08:32:57 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id a1e0cc1a2514c-7a294a4ee4bso632062241.0
        for <linux-xfs@vger.kernel.org>; Thu, 07 Sep 2023 08:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694100728; x=1694705528; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dTQo+qXo8NRE4/g2NGMF8EJv7KRZFT/DO+LZ8OddsYA=;
        b=KivwWswIBBVQI0cmQQKW4nUqgBPiA1TV0+mxFLPrMtZVmob00ySJh/w8a/TOxxg0im
         vuRzto33YEIe8pppgNC1tvr1A/kIf//E8qnUZI4sEKNol7JLGRbI9IgQqCBDt3FyklLF
         NGpB11RNVkTxmbtpItzqxKmwz5+dR51nOV8oOXjonOaSvFE8oJVbIj9HhpZn5G3VYsmR
         xDkXG3XPvGk2tV7cn+A9ccuopZzveKTaFHRY/btpi+c9NDc1gmsFHfx/UiBubKy8XvPt
         rEEYYxzsVS/dyVQF11HSEVv+uSqNpCij9OTtGJBRfKkcSGdQZmstQsXU3nUhuiPPnKzG
         i2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694100728; x=1694705528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTQo+qXo8NRE4/g2NGMF8EJv7KRZFT/DO+LZ8OddsYA=;
        b=h9gIzlhTzp1wlzaqk6XPSDaRudmPJ2NzOqLTemYGPdSzEHMG67zXgKchE7CA49uwQZ
         Ebkr8lSzvtT+lTrFym6iPg1emXA/gUNs0VmCEgF+JGbBUSJsD7SeB+S+XS+naSgbWQXe
         W8GAS7uXhruBnNiZNuSTz/Eg6CGVS5z3DMQ0oJQi7F4a11Y0EUe5QD0/3tUnU5ecYBnz
         oZkAPd0Rp1RlItpIx+fXWlOQkOEaH+RMbFkFNnm76//V6q0vHeqfGVDjP54ZrsZFUeC7
         QK0Me1siWrYO+WVSnoAqPSxC4YXF6HveNQiwC3oDahUEDCOExsMatvEsKJgcC107u9yr
         xjSw==
X-Gm-Message-State: AOJu0YzFweN9sTNjitY0Mb5QBlq3lnHgVIG0cyux6q/yPKa0PO7kykSs
        /YH6/2Et6h1AGTpYC8TlnXjp376EMPZ9EeURyss=
X-Google-Smtp-Source: AGHT+IE9KjOT51JDRa3yNlcO+48vk1BQhgmnlt8crTvpUwNaUsbQ3XR6sIOZtS5c3ZKROx56nkOB7g==
X-Received: by 2002:a17:902:d4c1:b0:1c0:cbaf:6954 with SMTP id o1-20020a170902d4c100b001c0cbaf6954mr2050033plg.25.1694068051172;
        Wed, 06 Sep 2023 23:27:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id w1-20020a170902e88100b001bafd5cf769sm12035229plg.2.2023.09.06.23.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 23:27:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qe8UB-00BuvJ-2n;
        Thu, 07 Sep 2023 16:27:27 +1000
Date:   Thu, 7 Sep 2023 16:27:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: use i_prev_unlinked to distinguish inodes that
 are not on the unlinked list
Message-ID: <ZPltT6prfr/vboeP@dread.disaster.area>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
 <169375775334.3323693.5974014335978928981.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169375775334.3323693.5974014335978928981.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2023 at 09:15:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Alter the definition of i_prev_unlinked slightly to make it more obvious
> when an inode with 0 link count is not part of the iunlink bucket lists
> rooted in the AGI.  This distinction is necessary because it is not
> sufficient to check inode.i_nlink to decide if an inode is on the
> unlinked list.  Updates to i_nlink can happen while holding only
> ILOCK_EXCL, but updates to an inode's position in the AGI unlinked list
> (which happen after the nlink update) requires both ILOCK_EXCL and the
> AGI buffer lock.
> 
> The next few patches will make it possible to reload an entire unlinked
> bucket list when we're walking the inode table or performing handle
> operations and need more than the ability to iget the last inode in the
> chain.
> 
> The upcoming directory repair code also needs to be able to make this
> distinction to decide if a zero link count directory should be moved to
> the orphanage or allowed to inactivate.  An upcoming enhancement to the
> online AGI fsck code will need this distinction to check and rebuild the
> AGI unlinked buckets.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |    2 +-
>  fs/xfs/xfs_inode.c  |    3 ++-
>  fs/xfs/xfs_inode.h  |   20 +++++++++++++++++++-
>  3 files changed, 22 insertions(+), 3 deletions(-)

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
