Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEA8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Dec 2022 07:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiLJHnv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Dec 2022 02:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiLJHnu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Dec 2022 02:43:50 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7ECBF76
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 23:43:49 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id fu10so5424641qtb.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Dec 2022 23:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leadboat.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ceoTV6nZoXR/X37nHZ9qBDyb3e6ell1iBJCJZyL9Mo=;
        b=QcD5cZE0tHolv34mlKxWoBIJnBeNdorH/7Rt08qNKdJw/bNcSmf4OEfrhI4Cu5Aup+
         RlXNr3bnPojvk7U+mbct0R8QuYVVAnrVk90y56aay8OkrBiztilla68cX/ZfeYOyb7JJ
         vuIu31jPcjQ/VNllsGznsbRwEWCt8Zvz5YYaU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ceoTV6nZoXR/X37nHZ9qBDyb3e6ell1iBJCJZyL9Mo=;
        b=5WSsnoT/FSKwBI0qa7FDn0Bp42ZyB0SvWnHF1Z25v6hI1vgRxY/FvJevc2jLewvI9X
         OqWno87Y92kMamo6vR5RkpLwCB44DOOPxHrCDEnpdj99pTdNusFRQFeqZZhrSb7iR3K0
         P1UqioUmbGRdIUvfT3S5EDBoaYgkJqe6nO9iDOI9zIUZASvdiDsmG6jI4Law++5s3Ew8
         88tsA7eDIuXshH5Tgq6Cf1SWi+FKHVOH3ajCpaHBO00cOXLkgwb2AT37xZiwvgCVNUBG
         0tv8CmXLN9nmoxVqyteI0mfkzpgIse24mWM7GQpnzsUwBCnzWiTxDktEYU72YVeaaNFz
         HAEQ==
X-Gm-Message-State: ANoB5pnOTtVB95S4SqwRdvTqnOYMHS6/kVc5nhCm3uep2BnPFVPCvF1t
        TJ5bPLupU8mx8/lKt7YBA56Kgg==
X-Google-Smtp-Source: AA0mqf5xv+bR2Hy/+6La9ZNg5z3TILjB5yd9UesoqNXrXUM03ErDCAfidt2ooI8JmzBkVtEff0IJOA==
X-Received: by 2002:ac8:7d01:0:b0:3a7:e22d:e316 with SMTP id g1-20020ac87d01000000b003a7e22de316mr15497407qtb.21.1670658228052;
        Fri, 09 Dec 2022 23:43:48 -0800 (PST)
Received: from rfd.leadboat.com ([2600:1702:a20:5750::2e])
        by smtp.gmail.com with ESMTPSA id y8-20020a05620a25c800b006fa8299b4d5sm1621475qko.100.2022.12.09.23.43.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Dec 2022 23:43:47 -0800 (PST)
Date:   Fri, 9 Dec 2022 23:43:44 -0800
From:   Noah Misch <noah@leadboat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: After block device error, FICLONE and sync_file_range() make
 NULs, unlike read()
Message-ID: <20221210074344.GA646514@rfd.leadboat.com>
References: <20221108172436.GA3613139@rfd.leadboat.com>
 <Y2vZk7Wg0V8SvwxW@magnolia>
 <20221110045452.GB3665013@rfd.leadboat.com>
 <Y3RVp74Qf58/Rh2y@magnolia>
 <20221120013412.GB4097405@rfd.leadboat.com>
 <Y4Vzk54RzjjEApOR@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4Vzk54RzjjEApOR@magnolia>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2022 at 06:50:59PM -0800, Darrick J. Wong wrote:
> On Sat, Nov 19, 2022 at 05:34:12PM -0800, Noah Misch wrote:
> > On Tue, Nov 15, 2022 at 07:14:47PM -0800, Darrick J. Wong wrote:
> > > On Wed, Nov 09, 2022 at 08:54:52PM -0800, Noah Misch wrote:
> > > > Subject line has my typo: s/sync_file_range/copy_file_range/

> > > Another dumb thing about how the pagecache tracks errors is that it sets
> > > a single state bit for the whole mapping, which means that we can't
> > > actually /tell/ userspace which part of their file is now busted.  We
> > > can't even tell if userspace has successfully rewrite()d all the regions
> > > where writeback failed, which leads me to...
> > > 
> > > Another another dumb thing about how the pagecache tracks errors is that
> > > any fsync-lik operation will test_and_clear_bit the EIO state, which
> > > means that if we find a past EIO, we'll clear that state and return the
> > > EIO to userspace.
> > > 
> > > We /could/ change FICLONE to flush the dirty pagecache, sample the EIO
> > > status *without* clearing it, and return EIO if it's set.  That's
> > > probably the most unabsurd way to deal with this, but it's unsettling
> > > that even cp ignores errno returns now.  The manpage for FICLONE doesn't
> > > explicitly mention any fsync behaviors, so perhaps "flush and retain
> > > EIO" is the right choice here.
> > 
> > That reminds me of
> > https://postgr.es/m//20180427222842.in2e4mibx45zdth5@alap3.anarazel.de.  Its
> > summary of a LSF/MM 2018 discussion mentioned NFS writeback errors detected
> > and cleared at close(), which I find similar.  I might favor a uniform policy,
> > one of:
> > 
> > a. Any syscall with a file descriptor argument might return EIO.  If it does,
> >    it clears the EIO.
> > b. Any syscall with a file descriptor argument might return EIO.  Only a
> >    specific list of syscalls, having writeback-oriented names, clear EIO:
> >    fsync(), syncfs(), [...].  Others report EIO without clearing it.
> > 
> > One argument for (b) is that, on EIO from FICLONE or copy_file_range(), the
> > caller can't know whether the broken file is the source or the destination.  A
> > cautious caller should assume both are broken.  What other considerations
> > should influence the decision?
> 
> That's a very good point you've raised -- userspace can't associate an
> EIO return value with either of the fds in use.  It can't even tell if
> the filesystem itself hit some metadata error somewhere else (e.g.
> refcount data), and that's the real reason why EIO got thrown back to
> userspace.
> 
> On those grounds, I think FICLONE/FIEDEDUPE need to preserve the
> AS_EIO/AS_ENOSPC state in the address_space so that actual fsync (or
> syncfs, or any of the known 'persist me now' calls) can also return the
> status.
> 
> I'll try to push that for 6.3.

That sounds good.  Thank you.  Please CC me on any threads you create for
this, if not inconvenient.
