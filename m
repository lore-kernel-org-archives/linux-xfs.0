Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF0FC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Nov 2022 01:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiKTBeT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Nov 2022 20:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKTBeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Nov 2022 20:34:18 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A34B4828
        for <linux-xfs@vger.kernel.org>; Sat, 19 Nov 2022 17:34:16 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id z1so6005131qkl.9
        for <linux-xfs@vger.kernel.org>; Sat, 19 Nov 2022 17:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leadboat.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E4V98Og6F3tBlStqIghJF0vQIYlZk+TgCdxEQ/T9UEM=;
        b=UusC32F5BTQSv4DrQDjilNOOTaJKF65eF2Yt5be90f+8cYuIWll3oMY2Y+81KEOOrY
         fJmyF62lQaEP4Tuw7Cc13nsJ7M5hW0I9w4CFu65KiQorywRYUWC8hzi4/WkOXA9szdN2
         myRKYLRJ0Q0rZRl8oAGODqAdompafQ6dW+dWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E4V98Og6F3tBlStqIghJF0vQIYlZk+TgCdxEQ/T9UEM=;
        b=4VRYGHYLnOVUX0LUfJgfFWwRX3+CC8bzYKCrH5v8dEXDWq5U021JWOEaAVRF/6uYyA
         rHEN7f7x99mK+Rm6kXrRDf/8jTwEmvgEKIhOGq9On6V/PfQLpcloUHxjVqxkJvF5W1KZ
         DVsHByBxhltjfLSWFDHf7NCct1+CGHH/ritC7Re9IJhPrgWPlaEuzzcfkcDthSVVUMLL
         cUtKfT/ugn4CEOoiWcDBIv8EtZFNRueROAP2KPhOcLUkVjiVWZ6aW7zMAsGH2C+SN3lu
         ypk1IDxukZ/UkKrSBGhK4GsZcWsOo/vVqxQQLevsg+EuZwoFp7Er3c4Jx25R+h0fXUqV
         y/ZQ==
X-Gm-Message-State: ANoB5pkE4HWEXVqClWCl3/6fO2jhz6aB6pYZTpO1U28cmxLvo1nSb5ma
        AUvMJrxMekAjXvIGFS05zd03Kg==
X-Google-Smtp-Source: AA0mqf65YkZMjCHMj/LaP63NAWn4dKMyGKgmodKPXxku92lCJCrNGEbB9h3j2WU08hIZbhI0BtwArA==
X-Received: by 2002:a05:620a:268a:b0:6fa:2c8d:d6c7 with SMTP id c10-20020a05620a268a00b006fa2c8dd6c7mr11244737qkp.441.1668908055653;
        Sat, 19 Nov 2022 17:34:15 -0800 (PST)
Received: from rfd.leadboat.com ([2600:1702:a20:5750::2e])
        by smtp.gmail.com with ESMTPSA id k7-20020ac80747000000b003a4d5fed8c3sm4435223qth.85.2022.11.19.17.34.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Nov 2022 17:34:14 -0800 (PST)
Date:   Sat, 19 Nov 2022 17:34:12 -0800
From:   Noah Misch <noah@leadboat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: After block device error, FICLONE and sync_file_range() make
 NULs, unlike read()
Message-ID: <20221120013412.GB4097405@rfd.leadboat.com>
References: <20221108172436.GA3613139@rfd.leadboat.com>
 <Y2vZk7Wg0V8SvwxW@magnolia>
 <20221110045452.GB3665013@rfd.leadboat.com>
 <Y3RVp74Qf58/Rh2y@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3RVp74Qf58/Rh2y@magnolia>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2022 at 07:14:47PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 09, 2022 at 08:54:52PM -0800, Noah Misch wrote:
> > Subject line has my typo: s/sync_file_range/copy_file_range/
> > 
> > On Wed, Nov 09, 2022 at 08:47:15AM -0800, Darrick J. Wong wrote:
> > > On Tue, Nov 08, 2022 at 09:24:36AM -0800, Noah Misch wrote:

> > > So I guess the question now is, what do we do about it?  The pagecache
> > > maintainers have never been receptive to redirtying pages after a

For other readers, here are some references on that:
https://www.kernel.org/doc/Documentation/filesystems/vfs.txt section "Handling errors during writeback"
https://lwn.net/Articles/752105/ gives rationale

> > > writeback failure; cp should really pass that EIO out to userspace
> > > instead of silently eating it; and maaaybe FICLONE should detect EIOs
> > > recorded in the file's pagecache and return that, but it won't fix the
> > 
> > I'd favor having both FICLONE and copy_file_range() "detect EIOs recorded in
> > the file's pagecache and return that".  That way, they never silently make a
> > bad clone when read() could have provided the bytes constituting a good clone.
> 
> So would I, but the longstanding behavior of FICLONE is that it's an
> implied fsync, so it's *vital* that calling programs do not drop the EIO
> on the floor like cp does.

Having thought about that more, I agree.  While read() gave the intended file
contents in my example, there's no guarantee the pages weren't already
evicted.  If the user wants to trust read(), the user can opt to retry with
--reflink=never.  "cp" shouldn't make that choice on the user's behalf.  "cp"
can still fallback to copy_file_range() or read() after EBADF, EINVAL,
EOPNOTSUPP, ETXTBSY, and EXDEV.  I don't know which is better, "halt on EIO
only" or "halt on all errno except the five known-okay ones".

> Another dumb thing about how the pagecache tracks errors is that it sets
> a single state bit for the whole mapping, which means that we can't
> actually /tell/ userspace which part of their file is now busted.  We
> can't even tell if userspace has successfully rewrite()d all the regions
> where writeback failed, which leads me to...
> 
> Another another dumb thing about how the pagecache tracks errors is that
> any fsync-lik operation will test_and_clear_bit the EIO state, which
> means that if we find a past EIO, we'll clear that state and return the
> EIO to userspace.
> 
> We /could/ change FICLONE to flush the dirty pagecache, sample the EIO
> status *without* clearing it, and return EIO if it's set.  That's
> probably the most unabsurd way to deal with this, but it's unsettling
> that even cp ignores errno returns now.  The manpage for FICLONE doesn't
> explicitly mention any fsync behaviors, so perhaps "flush and retain
> EIO" is the right choice here.

That reminds me of
https://postgr.es/m//20180427222842.in2e4mibx45zdth5@alap3.anarazel.de.  Its
summary of a LSF/MM 2018 discussion mentioned NFS writeback errors detected
and cleared at close(), which I find similar.  I might favor a uniform policy,
one of:

a. Any syscall with a file descriptor argument might return EIO.  If it does,
   it clears the EIO.
b. Any syscall with a file descriptor argument might return EIO.  Only a
   specific list of syscalls, having writeback-oriented names, clear EIO:
   fsync(), syncfs(), [...].  Others report EIO without clearing it.

One argument for (b) is that, on EIO from FICLONE or copy_file_range(), the
caller can't know whether the broken file is the source or the destination.  A
cautious caller should assume both are broken.  What other considerations
should influence the decision?

> > > underlying problem, which is that the cache thinks its clean after an
> > > EIO, and the pagecache forgets about recorded EIOs after reporting them
> > > via fsync/syncfs.
> > 
> > True.
