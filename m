Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598F6EB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 22:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjGKW2N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 18:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGKW2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 18:28:12 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3CF10F2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 15:28:08 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 75CFE5C00B2;
        Tue, 11 Jul 2023 18:28:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 11 Jul 2023 18:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1689114487; x=1689200887; bh=WZ
        esWgVJVaXauh1QGvGSvaLFHAuFU92MpTYmlCjVzUA=; b=Qn8vWSveexrQqZsk6a
        /bhUmgzQW6b/pghFg9SRLE+65vc2CJ76FdNGK4Apx4x+TumGS5TkEQZPkWSVPLdt
        RATPEQwnBJtxKCcuEoOfao5KOS4lgN5/GsMAZvXiO9CYuzOpBn4IzzMB1pGkTPTn
        2a77xXTW8U4OpAaL8n19Oe+KnsXVSlvOqIN83DgUQ5wkMX1XjSPjoii/gSPBMMGg
        2n7v9qYnd9mcrsc6xZqI5oza4n8xQ5W92lTEDMb0H+yZqrg6mNRV85ci8zyxjNP5
        M2InyMRAw9pZcd9zMdox9L3OZWr/5OjX/KQ0Gk8ayqyofbLXfFKH37cLisHtM2vZ
        si3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1689114487; x=1689200887; bh=WZesWgVJVaXau
        h1QGvGSvaLFHAuFU92MpTYmlCjVzUA=; b=ChJ2DAiu1cY4qeONYj3MD6C1P+h/J
        rpv6XyQBkGgGp/uyxxlv+BP5HeKEpL764XvkzLNgTwyrab3hsnFl4pOphfx6yz/O
        EZGiimBDEvs8hwyUmTfBPz7aGlKiDMPDU6Xjb4op2qHt3+I7xbTMzp4DQeIPhIjW
        yyMu1qDDeEobEo8VMbStcLPy6vxectKhsckgQtln+iTyyfCgTj5bB7INM8ovP+iV
        jV+WWKXosPZDfWRvWafmCWP+6Pl3GJGq4vi91kdOaqRkf243S0DChMO+iVdB1if9
        xRPF2YUTlGMk4yI53kFTKZ7H7HThD/G+mO5WN2mfGy92WCXhgiItrfUkg==
X-ME-Sender: <xms:d9etZJAu5sqPlXupxw6guBeOAdxHhDQ_u8eNVvorMNjUl5lLzNR0nA>
    <xme:d9etZHhPjUa2wzBTmj2Tj12D-OIBTsfair9Kx-i7pY8NjudhylfN_q0o10ss4T5hu
    S0_ZbNtHc_ScmHA-A>
X-ME-Received: <xmr:d9etZEn-kEmfF93Nj0jaLs4k-31CGwEt-es6CPL6m2QTJdSp2LZ2TjTU3TLBJI1JLWKe17uQklP_HJdHz37OU-PJC2CZgNOlfe8Sg3d7zp9yjROpyeztCzWaY7cN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrfedugddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteevudei
    tedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:d9etZDxHYZUuR3ACEqNSIPpUv4di4KscXgyrDmX6y34RxbgW3raYXw>
    <xmx:d9etZOQA_--pVZO8VUeCBz3-Z8JvrEVd8nk9zib31MU3QYqcLIBogw>
    <xmx:d9etZGbVdlWzJ7O5Pj1CXbQn61wq3yjHL358X6QKmt6gfk1DzPyqdg>
    <xmx:d9etZBJ-y1fNa38mdqscWEM7MlCu4mNIeNyXmU9hlZW_uVNADgwBwg>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Jul 2023 18:28:06 -0400 (EDT)
Date:   Tue, 11 Jul 2023 15:28:05 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Masahiko Sawada <sawada.mshk@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
Message-ID: <20230711222805.atv6r3tubtws4wfu@awork3.anarazel.de>
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJTrrwirZqykiVxn@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On 2023-06-23 10:47:43 +1000, Dave Chinner wrote:
> On Thu, Jun 22, 2023 at 02:34:18PM +0900, Masahiko Sawada wrote:
> > Hi all,
> >
> > When testing PostgreSQL, I found a performance degradation. After some
> > investigation, it ultimately reached the attached simple C program and
> > turned out that the performance degradation happens on only the xfs
> > filesystem (doesn't happen on neither ext3 nor ext4). In short, the
> > program alternately does two things to extend a file (1) call
> > posix_fallocate() to extend by 8192 bytes
>
> This is a well known anti-pattern - it always causes problems. Do
> not do this.

Postgres' actual behaviour is more complicated than what Sawada-san's test.
We either fallocate() multiple pages or we use use pwritev() to extend by
fewer pages.

I think Sawada-san wrote it when trying to narrow down a performance issue to
the "problematic" interaction, perhaps simplifying the real workload too much.


> As it is, using fallocate/pwrite like test does is a well known
> anti-pattern:
>
> 	error = fallocate(fd, off, len);
> 	if (error == ENOSPC) {
> 		/* abort write!!! */
> 	}
> 	error = pwrite(fd, off, len);
> 	ASSERT(error != ENOSPC);
> 	if (error) {
> 		/* handle error */
> 	}
>
> Why does the code need a call to fallocate() here it prevent ENOSPC in the
> pwrite() call?

The reason we do need either fallocate or pwrite is to ensure we can later
write out the page from postgres' buffer pool without hitting ENOSPC (of
course that's still not reliable for all filesystems...).  We don't want to
use *write() for larger amounts of data, because that ends up with the kernel
actually needing to write out those pages. There never is any content in those
extended pages.

So for small file extensions we use writes, and when it's more bulk work, we
use fallocate.

Having a dirty page in our buffer pool is, that we can't write out due to
ENOSPC, is bad, as that prevents our checkpoints from ever succeeding. Thus we
either need to "crash" and replay the journal, or we can't checkpoint, with
all the issues that entails.


The performance issue at hand came to be because of the workload flipping
between extending by fallocate() and extending by write(), as part of the
heuristic is the contention on the lock protecting file extensions.

Greetings,

Andres Freund
