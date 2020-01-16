Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DECC33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C751020748
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:05:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="fsNlBtGF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgAPGFM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 01:05:12 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45050 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729850AbgAPGFM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 01:05:12 -0500
Received: by mail-ot1-f67.google.com with SMTP id h9so18302785otj.11
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 22:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vKEanVLYKixbIE4jpjng52Wg/z0Mh1eAfP4hJSdIQE0=;
        b=fsNlBtGFziQY0A8zQejjqkkTuvqiwdIiAM7NACeEOxrAaoxzDd4fUjk9pwpqAIUvXJ
         cdDCKjUTJGaZHkHv0G5ee/JsbwsslnTNyPu9bqoswts39/75GIb/59yCbwuO1xPlgi3c
         f+VW6u6TSpKsnTkYP5lrw9eMUS+qyf9nS8llrLCzHtqnC0A8+9WP1s1jpoFVC48zw4nR
         NVsWjZ5qsu9jZPsaq387+XdtKQjAobHkTTamKsz9df6VShLY/jSMaIKhT//gj04wSyQB
         dgjbIZWVcmuv6zDtMtLARK6RBcjdJGnJuT7/m4Mi0K92sfnfQrOSyoSUt8DpH3L7o5oD
         9Oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vKEanVLYKixbIE4jpjng52Wg/z0Mh1eAfP4hJSdIQE0=;
        b=Zrgg2/tUloUG/+cgbj4OT3cIsHenUKO50xKi1HFtwRTFVL46MkNJjy4OrVtftBnSS/
         39cFpIQcE75qP8AVBZ477GuQJ86waPiQoO4UPgNUS4I15zS7Ya2+C9Dl8zjrJr3mRQ/x
         p7hGFu+rJXzVZJnNH7NnQzabGOm6xX02rxImCg0t6YDouMGFE/1UW1DOp2J5x823zZs9
         4C3y+o846ekAs6kH0Ge5gfn7kwMJal6/QT/EBW05aibj9HQt+MSaXfit8Iu20I+9uZl8
         GMVmqsvDuGoP7ir0FlCQWFpubCbSQ/5esf/qjFYL2tShIDFr1gkFro0A0LMRZvvZVHYq
         UPlg==
X-Gm-Message-State: APjAAAXV+5OduYqO16wm5vH5Fu16fQD0G2gXrgxIMumIcBFEJN/wLaGP
        niXrwV0GCsJMa+8jBlptWzeCYa8ny7z20GedefbVxQ==
X-Google-Smtp-Source: APXvYqzEy+pngv/HMRf0P3fZnf1I8EeAbKVY4SqM8e/rzz5VxvD8FVTh6UXXEgSv+bh5N1RhUnQGLNyaWJI9Xe8L7mc=
X-Received: by 2002:a9d:68d3:: with SMTP id i19mr740541oto.71.1579154711112;
 Wed, 15 Jan 2020 22:05:11 -0800 (PST)
MIME-Version: 1.0
References: <20200110192942.25021-1-ira.weiny@intel.com> <20200110192942.25021-2-ira.weiny@intel.com>
 <20200115113715.GB2595@quack2.suse.cz> <20200115173834.GD8247@magnolia>
 <20200115194512.GF23311@iweiny-DESK2.sc.intel.com> <CAPcyv4hwefzruFj02YHYiy8nOpHJFGLKksjiXoRUGpT3C2rDag@mail.gmail.com>
 <20200115223821.GG23311@iweiny-DESK2.sc.intel.com> <20200116053935.GB8235@magnolia>
In-Reply-To: <20200116053935.GB8235@magnolia>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 15 Jan 2020 22:05:00 -0800
Message-ID: <CAPcyv4jDMsPj_vZwDOgPkfHLELZWqeJugKgKNVKbpiZ9th683g@mail.gmail.com>
Subject: Re: [RFC PATCH V2 01/12] fs/stat: Define DAX statx attribute
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 9:39 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
[..]
> >         attempts to minimize software cache effects for both I/O and
> >         memory mappings of this file.  It requires a file system which
> >         has been configured to support DAX.
> >
> >         DAX generally assumes all accesses are via cpu load / store
> >         instructions which can minimize overhead for small accesses, but
> >         may adversely affect cpu utilization for large transfers.
> >
> >         File I/O is done directly to/from user-space buffers and memory
> >         mapped I/O may be performed with direct memory mappings that
> >         bypass kernel page cache.
> >
> >         While the DAX property tends to result in data being transferred
> >         synchronously, it does not give the same guarantees of
> >         synchronous I/O where data and the necessary metadata are
> >         transferred together.
>
> (I'm frankly not sure that synchronous I/O actually guarantees that the
> metadata has hit stable storage...)

Oh? That text was motivated by the open(2) man page description of O_SYNC.
