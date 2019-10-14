Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF56C4360C
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 01:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A88192067B
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 01:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="gcTRnHjE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="B7xNypeG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfJNB2l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Oct 2019 21:28:41 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50265 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729359AbfJNB2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Oct 2019 21:28:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A7815442;
        Sun, 13 Oct 2019 21:28:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 13 Oct 2019 21:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        FhIZTBkmwUTH/xOPJliUV/6UHyr4ER8WK+HcyIhx/pU=; b=gcTRnHjEDA0976jy
        8LDsmGyPK8EFwjJLnmL+Fwbhte4TwCnxusAKtrauVfo7VWkUDBfVrMLby2/XTJEt
        0GsnDyMLFlPH0FBjYtWSLai8UMjH8zx+23tOG++WJ70ltm2TFVESc+HZOdBgc+Dc
        0kJSVtUopQh5FCsQP8oElC9ExGfWhnzVpe44ID9IgI0ikel7E3UO0xRFXvvyjevG
        hQVgovNeaSeRpgLUtQxWm+UQoKXgPrb0ZtdxVvaFrgcEh/sbqbg23AevGXQtza4u
        WhsBMsNWAF4OUdoi+BXRY3eaqHQNxOutoI1TaG75IaqJI93qY1FIyUHLJfyySTBz
        YiFO1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=FhIZTBkmwUTH/xOPJliUV/6UHyr4ER8WK+HcyIhx/
        pU=; b=B7xNypeGNcPIq7+v1MSlyweDlzkQZPs+IdTca2OxX8enF7mz8TD5bZMmU
        +agkI+ihsL5DSV9J0qDU5LJa26pWkwWixKPOBwMTnrH/eBzcldcJFKLK3lBiFdyk
        sM83Vrs0JsMGc+WkdOqlCajLrOfkNwZa4W+Czp9Zm5zG7Y5P3E9+G/WsUTpltLQJ
        0EkJYftuu8gjfY9zEf/iZQKOOV4c2i8rRxMjPTyQu2TpsD8OD4iahjySbhyOCm5r
        rF/FCAsU7yAnqaLpW/9QoiGlPZhzMzR3kcjADz1zlRaec+BM5j6OeupIArfMcTYz
        BGYdduFn25cXzFWXZ+ZQRy/44XJQg==
X-ME-Sender: <xms:Rs-jXTlBXD4Cc5D2HocJ1RbF3VQ5DQKscnFLPAvAIKhp6ZzMF5MgIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedtgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Rs-jXY2QcO4nkPgNnr3RclfITF8dRwmoayXQMZhHnG9QwXbnhzDdOQ>
    <xmx:Rs-jXd4kK9Ij7Hf8zEu3qRikwenGsNa9T4OA9pz3VWDaiGrWqJ1GOQ>
    <xmx:Rs-jXWjsp1HC6pgs5IZfuh540-qzEI1TL_ezD8KcSRnhsaHLz71avg>
    <xmx:R8-jXdltqDmPdaAdDpMctcwTP_zeTb57WspjANUQYsl2sEEi5h_Z5g>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4E818005A;
        Sun, 13 Oct 2019 21:28:35 -0400 (EDT)
Message-ID: <800047ff79f844080e9a7ffd697cd0cf63001a7e.camel@themaw.net>
Subject: Re: [PATCH v5 00/17] xfs: mount API patch series
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon, 14 Oct 2019 09:28:32 +0800
In-Reply-To: <20191009145222.GC10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <20191009145222.GC10349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-09 at 07:52 -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 07:30:10PM +0800, Ian Kent wrote:
> >  fs/super.c                 |   97 +++++
> >  fs/xfs/xfs_super.c         |  926 +++++++++++++++++++++++---------
> > ------------
> >  include/linux/fs_context.h |    5 
> >  3 files changed, 587 insertions(+), 441 deletions(-)
> 
> I am a little worried about the diffstat.  A few more lines of code
> more for a more abstract API seems fine, but +150 lines for no new
> functionality is worrisome.
> 

Right, that's an obvious and sensible sanity check.

But don't forget the first two patches are there for people
to use so they can test the series since they were not in
the xfs-linux tree at the time.

The first patch, to create the get_tree_bdev() function, has
been dropped because it's now been merged and the xfs-linux
tree has been updated.

There's also the bug fix to that patch which Al has now
pushed to Linus but is not yet in xfs-linux, so it's still
present in the series.

Without that first patch the diffstat is a bit better.

 fs/super.c         |    5 
 fs/xfs/xfs_super.c |  926 +++++++++++++++++++++++++++-------------------------
 2 files changed, 489 insertions(+), 442 deletions(-)

at 47 lines and once the bug fix patch makes its way to
xfs-linux this will be under 45 which might be ok since
overall I think there's an additional function.

Ian

