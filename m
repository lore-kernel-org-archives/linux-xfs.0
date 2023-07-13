Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CACCC001DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 05:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbjGMFyg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 01:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbjGMFyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 01:54:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B521BF0;
        Wed, 12 Jul 2023 22:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cx451C8YKqMMcpXJiANmMAvSZURBkWx0tS8TcO3/I+M=; b=Dp9FtIjSOTeyEFMliyUwDNDzYH
        iSCC8B/CdOVuQKpLswEBq7YIe1fgPJA4bCJQX31xgK/WAXU1UaMWeX71MrD1R0HMFV6UCAXGox7Ee
        q7ZZOZ3mEaAPIc3QLgtqqQgWolhfCokYOw89lBsoErV7n4LHfIhNO4VnrR48lWENCuAAnan9KcRAy
        dfmXEZMpKHAS4rB15OgZfRgyW8UwdR7bMRgJ/FCh9WuFf3dFQBX7VTOOKzq6hTifqWyDF2NVOTh5f
        IDqs/MJzxwsycqj7taqWQbfghoDCzUYRK+HcQpsPLso1ZSaRyVY5FPIL6/LNxqTqXe/E2lnzmnPef
        rKg4pSqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qJpHd-00230M-1k;
        Thu, 13 Jul 2023 05:54:33 +0000
Date:   Wed, 12 Jul 2023 22:54:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Carlos Maiolino <cem@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Jeff Layton <jlayton@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] libxfs: Redefine 1-element arrays as flexible arrays
Message-ID: <ZK+Rmc0fBpJ3tVRN@infradead.org>
References: <20230711222025.never.220-kees@kernel.org>
 <20230712053738.GD108251@frogsfrogsfrogs>
 <ZK6mC1npjONMoGMD@infradead.org>
 <20230713054450.GQ108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713054450.GQ108251@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 10:44:50PM -0700, Darrick J. Wong wrote:
> /*
>  * List the names and sizes of the values of all the attributes of an object.
>  * "Cursor" must be allocated and zeroed before the first call, it is used
>  * to maintain context between system calls if all the attribute names won't
>  * fit into the buffer on the first system call.
>  * The return value is -1 on error (w/errno set appropriately), 0 on success.
>  */
> extern int attr_list(const char *__path, char *__buffer, const int __buffersize,
> 		int __flags, attrlist_cursor_t *__cursor)
> 	__attribute__ ((deprecated ("Use listxattr or llistxattr instead")));
> extern int attr_listf(int __fd, char *__buffer, const int __buffersize,
> 		int __flags, attrlist_cursor_t *__cursor)
> 	__attribute__ ((deprecated ("Use flistxattr instead")));
> 
> I take that as a sign that they could drop all these xfs-specific APIs
> one day, which means we ought to keep them in xfs_fs.h.

Well...

These APIs you quoted are in fact internally mapped to the normal
xattr syscalls by libattr, and have been since the Linux xattr syscalls
were created.  The only thing that actually uses the definitions in
Linux is the magic attrlist by handle ioctl that exists only in
XFS and which is exported through libhandle in xfsprogs.  But the
libhandle API is based on the attrlist_cursor from libattr and
doesn't use the xfs_ kernel definitions.

(that struct attrlist/attrlist_ent in libattr have the same 1-sized
array problem, but fortunately we don't need to solve that here..)
