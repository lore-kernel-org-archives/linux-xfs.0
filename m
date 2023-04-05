Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A94C7619A
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 22:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjDEW0w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 18:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDEW0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 18:26:51 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88B25599
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 15:26:50 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id x37so22686825pga.1
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 15:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1680733610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XK91TzLV+BuNFfVuafZ92bpnVCXIC7GzKLzoDgloMhQ=;
        b=phPcb/SN25q2kw/FZ/aTqEL2YPFWV1/ZElIAli3MXwfTv+tjVLKBBur9WuCBaHCACZ
         D0ju4+GcM15ciS601Xut6OQO62IcxpBJTZB44/j8jsTfzgxzPHi6TdM4MY4h6EyEny7j
         BbdxTD7Y3B8eY3yR5kJLlHPTG42T+G04/g6dTuxR8Njnk2FYDl45LZH1iZ4SC7iVdwTL
         tTVNywDojFuzLzWPQMIgKhwVwu6aApOhjuoSmwEpixB3aP31p9E2vZt7xOTDI/JRk5fv
         sCNqzrkqiBz4QGhA8yapRr2so2J+w7D3gNKPhFHxFD9sZSe0S5qmiAchEhtJIawjKa7P
         E+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680733610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XK91TzLV+BuNFfVuafZ92bpnVCXIC7GzKLzoDgloMhQ=;
        b=CyBxxvQUTLhUuu21LhuvfEZAcvwRYTNEoR0rUG+1DSC72eGDw2GdvLoDm3OAFjd5Kp
         ZTyfcFs2B/YY8Z9uLy0grce0xKC5zvMVx/F8711sIo0RlX16O3PgQdkzQ7IvLFv/BfPR
         si9JYdhNheyldAu5SJG6EHNJDC8xWZQrxUBURTNVHhhswXAdxb+rCcW5dydcFqi/aWdu
         Oouax6uq1nTBFRAmN6PHmNlLAtDLRD3rLcoKzk49viIK7ukO/AeeP0LYfTUxL1OR3YXh
         MaoFDlgYxCB/rlyxtvItXxyYzeXeGIWQFabaulMkVjE0XQYA4s5U9/X1P/zbS0YKLfRn
         LvyA==
X-Gm-Message-State: AAQBX9eAhDmOUqUHkYxqaR8N5PUsaNQ/WbJ+OXai580hf6QrA1JJS8ZF
        DimAls5cQHpOiqhYCA6z8cqxOw==
X-Google-Smtp-Source: AKy350ZizTU3q/Uc2TiZy7crqeJ4jvK0CtSZoX/AzNtdP+Y2QHldAbm030UMhCShfo2v0Sb07Y+LGg==
X-Received: by 2002:a62:1d8f:0:b0:627:e577:4326 with SMTP id d137-20020a621d8f000000b00627e5774326mr6595721pfd.17.1680733610237;
        Wed, 05 Apr 2023 15:26:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id 2-20020aa79142000000b0062c0cfbb264sm11493110pfi.93.2023.04.05.15.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:26:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pkBaY-00HUjN-NL; Thu, 06 Apr 2023 08:26:46 +1000
Date:   Thu, 6 Apr 2023 08:26:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Andrey Albershteyn <aalbersh@redhat.com>, dchinner@redhat.com,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev, rpeterso@redhat.com, agruenba@redhat.com,
        xiang@kernel.org, chao@kernel.org,
        damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com
Subject: Re: [PATCH v2 21/23] xfs: handle merkle tree block size != fs
 blocksize != PAGE_SIZE
Message-ID: <20230405222646.GR3223426@dread.disaster.area>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404145319.2057051-22-aalbersh@redhat.com>
 <20230404163602.GC109974@frogsfrogsfrogs>
 <20230405160221.he76fb5b45dud6du@aalbersh.remote.csb>
 <20230405163847.GG303486@frogsfrogsfrogs>
 <ZC264FSkDQidOQ4N@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC264FSkDQidOQ4N@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 05, 2023 at 06:16:00PM +0000, Eric Biggers wrote:
> On Wed, Apr 05, 2023 at 09:38:47AM -0700, Darrick J. Wong wrote:
> > > The merkle tree pages are dropped after verification. When page is
> > > dropped xfs_buf is marked as verified. If fs-verity wants to
> > > verify again it will get the same verified buffer. If buffer is
> > > evicted it won't have verified state.
> > > 
> > > So, with enough memory pressure buffers will be dropped and need to
> > > be reverified.
> > 
> > Please excuse me if this was discussed and rejected long ago, but
> > perhaps fsverity should try to hang on to the merkle tree pages that
> > this function returns for as long as possible until reclaim comes for
> > them?
> > 
> > With the merkle tree page lifetimes extended, you then don't need to
> > attach the xfs_buf to page->private, nor does xfs have to extend the
> > buffer cache to stash XBF_VERITY_CHECKED.
> 
> Well, all the other filesystems that support fsverity (ext4, f2fs, and btrfs)
> just cache the Merkle tree pages in the inode's page cache.  It's an approach
> that I know some people aren't a fan of, but it's efficient and it works.

Which puts pages beyond EOF in the page cache. Given that XFS also
allows persistent block allocation beyond EOF, having both data in the page
cache and blocks beyond EOF that contain unrelated information is a
Real Bad Idea.

Just because putting metadata in the file data address space works
for one filesystem, it doesn't me it's a good idea or that it works
for every filesystem.

> We could certainly think about moving to a design where fs/verity/ asks the
> filesystem to just *read* a Merkle tree block, without adding it to a cache, and
> then fs/verity/ implements the caching itself.  That would require some large
> changes to each filesystem, though, unless we were to double-cache the Merkle
> tree blocks which would be inefficient.

No, that's unnecessary.

All we need if for fsverity to require filesystems to pass it byte
addressable data buffers that are externally reference counted. The
filesystem can take a page reference before mapping the page and
passing the kaddr to fsverity, then unmap and drop the reference
when the merkle tree walk is done as per Andrey's new drop callout.

fsverity doesn't need to care what the buffer is made from, how it
is cached, what it's life cycle is, etc. The caching mechanism and
reference counting is entirely controlled by the filesystem callout
implementations, and fsverity only needs to deal with memory buffers
that are guaranteed to live for the entire walk of the merkle
tree....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
