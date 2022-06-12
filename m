Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB15C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 19:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbiFLTwn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 15:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiFLTwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 15:52:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC7857136;
        Sun, 12 Jun 2022 12:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xeAFWOF6B2EJpKnlrt3i4hrJP/u9VGwLnbVCf7fZWAw=; b=isOephP5+k8v5pRjwVIAWVR6cY
        lEHA7FqygtEzTp1JU5OZ6b6e6+XOXm9c/ZVhUCXr4O9dhM5f9gt6O4URae1rodXItRKjaLOpy/C4F
        jaBQEtS1oHVnWFuseT81gCwAHdPR1lEzAIHyWy950S1ow1JPFFyh7eZ2rlWz2pHMre/8C6+5+8Sm/
        y25hyGtR1yK9WRN+GRjgdGSv/4gVRH+701FmaOvVruFQPZa4yNtdHMGr2NG354d235F5hrfj4E6yu
        NuZV1qSU+hq9oyOn6UoCsI8EkOtUb+FSfdYqLbppJnySUwycftHYPX1EYSe4b+NSo3FM2b8UFRg9Q
        KwsfOYkQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0TdP-00GEYG-Qh; Sun, 12 Jun 2022 19:52:31 +0000
Date:   Sun, 12 Jun 2022 20:52:31 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Uladzislau Rezki <urezki@gmail.com>, Zorro Lang <zlang@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n o area'
 (offset 0, size 1)!
Message-ID: <YqZD/5sUmeJJMonT@casper.infradead.org>
References: <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
 <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220612044230.murerhsa765akogj@zlang-mailbox>
 <YqXU+oU7wayOcmCe@casper.infradead.org>
 <YqXkGMY9xtUvPR5D@pc638.lan>
 <YqYh0xyJvoNsSOpy@casper.infradead.org>
 <CAOUHufbBkcjChkMfF8exh3=6=JM09-GCU71KXhUGmz4UdOhUmg@mail.gmail.com>
 <YqYq846zFUInllTw@casper.infradead.org>
 <CAOUHufan8+uombVMSSrKra-8Cu5pSJj80LVa6QrGbFzBmUQHxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOUHufan8+uombVMSSrKra-8Cu5pSJj80LVa6QrGbFzBmUQHxg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 12:43:45PM -0600, Yu Zhao wrote:
> On Sun, Jun 12, 2022 at 12:05 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Sun, Jun 12, 2022 at 11:59:58AM -0600, Yu Zhao wrote:
> > > Please let me know if there is something we want to test -- I can
> > > reproduce the problem reliably:
> > >
> > > ------------[ cut here ]------------
> > > kernel BUG at mm/usercopy.c:101!
> >
> > The line right before cut here would have been nice ;-)
> 
> Right.
> 
> $ grep usercopy:
> usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> 2882303761517129920, size 11)!
> usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> 8574853690513436864, size 11)!
> usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> 7998392938210013376, size 11)!

That's a different problem.  And, er, what?  How on earth do we have
an offset that big?!

                struct vm_struct *area = find_vm_area(ptr);
                offset = ptr - area->addr;
                if (offset + n > get_vm_area_size(area))
                        usercopy_abort("vmalloc", NULL, to_user, offset, n);

That first offset is 0x2800'0000'0000'30C0

You said it was easy to replicate; can you add:

			printk("addr:%px ptr:%px\n", area->addr, ptr);

so that we can start to understand how we end up with such a bogus
offset?
