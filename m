Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B5CC7EE2A
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 04:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjFBEBK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jun 2023 00:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjFBEBJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2023 00:01:09 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B84199
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 21:01:07 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-6259c242c96so15128716d6.3
        for <linux-xfs@vger.kernel.org>; Thu, 01 Jun 2023 21:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685678467; x=1688270467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/AZuKGanlEr/ivvqo0884Pc/FmittyLF3Imw6inGrI=;
        b=BcLd94bXbpq4G/8mGSdrC4Rr3R+btIrfFTLDo8k8pYJQq6OKoa1oRd7I05xK3ijDZ8
         SuWuQJ5leG1Sq9sV88p6X+jWLBa10RpoW/LWm62w7qyn5C8rLrT5kgeWzXysGyOQ95aY
         NuzPN6B1VZDUfcVH/l0ciVW9QwRWkpUqtVGNEBH4rArTh1XjHCzzQ2fim2bM7AzZ00B/
         J6GacvibR7CSeJyRvAGC3WMRgaFzxKCUwiw1kBdKtAhMmLYgYvBFJK9+PMVBCCfFBBAM
         d5yLf8dz4MZBqY111HEvGTQ7RlyQapYTuWrXEhmZUygah4cHMlN1y2REgNtiCKYxCc0h
         pcnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685678467; x=1688270467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/AZuKGanlEr/ivvqo0884Pc/FmittyLF3Imw6inGrI=;
        b=fpcCsVpzvZVj40O5XEfJYvfyNqzaIMhoBSqu60bx4lfJiEEV0PMJO81oUdVER0gF2o
         6aH9A+od0K1yDaoOFZreC82MMBtG28zfW3wjtnYtgoTPENtqgbwIkxh7t9n1gQLUQJ12
         1O9Hw6aXfLhIBdWLU12WhfbuGKkj1IFHf1IngtQQUVSlzqvd1LPeX8E35oKsZeXbP6BR
         I6sie4F8IxMkrr6N9Qw61lmqiPWHIFlA9PmGlY6tc6qskfSEYoJpswyKabKzjGs1X/qI
         CdU+r7eKfc0a8McdmY4gLWKTf41E175vtr6/VHi5l3Od8LIryuWKJlbuBHP25lZ62yzA
         +4ag==
X-Gm-Message-State: AC+VfDwr7wKpGvbbfZg64Wx13E5dMnq+NdhvmMWjF8Yf5aBYgdjDGnGd
        kcnBtMg9Szrk2ZPVv+TDDjpkkde39TBW4Zcsn6o=
X-Google-Smtp-Source: ACHHUZ7MgOE5vSn4vUPJwLHbvTOgsPrVrV7zXaqXFK2aKwxMdbaU4qT7t4lSi1RQ1f4yKxdHtRKtEQ==
X-Received: by 2002:a05:6214:e48:b0:625:aa1a:b6db with SMTP id o8-20020a0562140e4800b00625aa1ab6dbmr12633626qvc.61.1685678466891;
        Thu, 01 Jun 2023 21:01:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id t5-20020a1709027fc500b001a183ade911sm203346plb.56.2023.06.01.21.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 21:01:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q4vyJ-006lUA-0A;
        Fri, 02 Jun 2023 14:01:03 +1000
Date:   Fri, 2 Jun 2023 14:01:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: collect errors from inodegc for unlinked inode
 recovery
Message-ID: <ZHlpf5BFFfQEELlx@dread.disaster.area>
References: <20230530001928.2967218-1-david@fromorbit.com>
 <20230602002500.GI16865@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602002500.GI16865@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 01, 2023 at 05:25:00PM -0700, Darrick J. Wong wrote:
> On Tue, May 30, 2023 at 10:19:28AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Unlinked list recovery requires errors removing the inode the from
> > the unlinked list get fed back to the main recovery loop. Now that
> > we offload the unlinking to the inodegc work, we don't get errors
> > being fed back when we trip over a corruption that prevents the
> > inode from being removed from the unlinked list.
> > 
> > This means we never clear the corrupt unlinked list bucket,
> > resulting in runtime operations eventually tripping over it and
> > shutting down.
> > 
> > Fix this by collecting inodegc worker errors and feed them
> > back to the flush caller. This is largely best effort - the only
> > context that really cares is log recovery, and it only flushes a
> > single inode at a time so we don't need complex synchronised
> > handling. Essentially the inodegc workers will capture the first
> > error that occurs and the next flush will gather them and clear
> > them. The flush itself will only report the first gathered error.
> > 
> > In the cases where callers can return errors, propagate the
> > collected inodegc flush error up the error handling chain.
> > 
> > In the case of inode unlinked list recovery, there are several
> > superfluous calls to flush queued unlinked inodes -
> > xlog_recover_iunlink_bucket() guarantees that it has flushed the
> > inodegc and collected errors before it returns. Hence nothing in the
> > calling path needs to run a flush, even when an error is returned.
> 
> Hmm.  So I guess what you're saying is that xfs_inactive now returns
> negative errnos, and everything that calls down to that function will
> pass the error upwards through the stack?

Yes. Effectively inodegc workers capture the errors from
xfs_inactive(), and the next xfs_inode_flush() call will gather the
errors, clear them and report them to the caller. It's then up to
the caller to decide what to do with an error from
xfs_inode_flush()...

> Any of those call paths that already could handle a negative errno will
> now fail on a corrupt inactive inode; and the only place that will
> silently "drop" the negative errno is unmount?

Yes. That is the largely the what I've tried to do. The main thing
was to make the unlinked inode error reporting work, and having
other paths (like remount,ro) also be able to fail and propagate
errors is a bonus.

> If 'yes' and 'yes' and the kbuild robot warnings get fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
