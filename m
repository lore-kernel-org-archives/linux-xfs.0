Return-Path: <SRS0=bIZx=BU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162D0C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 11:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBCCB206E9
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 11:17:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OCNWmeSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgHJLRF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 07:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgHJLRB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Aug 2020 07:17:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C8EC061756;
        Mon, 10 Aug 2020 04:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=LF7J00zPGvE5+TvNb+kSZ/mLnQ6lmd1ykbbcKN0G5P0=; b=OCNWmeSiZDDpjF5Hgiofx6N6ON
        mkqo524ZrkTmjYeAH/LOzFSErW1eK+WyzkAZsFnVA34VOuSVBXoSGM7MZ+/9KklSyZN05mfuOyT0s
        2YhgWUkFXY+JSuAnnaw4NmrKz7wA57V3jBIlZHPNkZdhVqDXFnmhvk2JKjby9cP7BlVaWDfAzs53N
        lkQLlrm4o/LDXG8+jPi57WYiSsbgy1qMRGEEL8mYfBJh/Cz0n3tZebBXT9ZPwoMDjAhbgQ2MQPDaJ
        U4AvMZQcyGTR2UWCtkSXx4VKMEPJLjTvF5HALWCUljf51bkVR9AU8RSTIPChGPGHGBS0dNqkiVmpQ
        /ZGi0Vig==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k55nV-0002Ra-ET; Mon, 10 Aug 2020 11:16:57 +0000
Date:   Mon, 10 Aug 2020 12:16:57 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        dan.j.williams@intel.com, david@fromorbit.com, hch@lst.de,
        rgoldwyn@suse.de, qi.fuli@fujitsu.com, y-goto@fujitsu.com
Subject: Re: [RFC PATCH 0/8] fsdax: introduce FS query interface to support
 reflink
Message-ID: <20200810111657.GL17456@casper.infradead.org>
References: <20200807131336.318774-1-ruansy.fnst@cn.fujitsu.com>
 <20200807133857.GC17456@casper.infradead.org>
 <9673ed3c-9e42-3d01-000b-b01cda9832ce@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9673ed3c-9e42-3d01-000b-b01cda9832ce@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 10, 2020 at 04:15:50PM +0800, Ruan Shiyang wrote:
> 
> 
> On 2020/8/7 下午9:38, Matthew Wilcox wrote:
> > On Fri, Aug 07, 2020 at 09:13:28PM +0800, Shiyang Ruan wrote:
> > > This patchset is a try to resolve the problem of tracking shared page
> > > for fsdax.
> > > 
> > > Instead of per-page tracking method, this patchset introduces a query
> > > interface: get_shared_files(), which is implemented by each FS, to
> > > obtain the owners of a shared page.  It returns an owner list of this
> > > shared page.  Then, the memory-failure() iterates the list to be able
> > > to notify each process using files that sharing this page.
> > > 
> > > The design of the tracking method is as follow:
> > > 1. dax_assocaite_entry() associates the owner's info to this page
> > 
> > I think that's the first problem with this design.  dax_associate_entry is
> > a horrendous idea which needs to be ripped out, not made more important.
> > It's all part of the general problem of trying to do something on a
> > per-page basis instead of per-extent basis.
> > 
> 
> The memory-failure needs to track owners info from a dax page, so I should
> associate the owner with this page.  In this version, I associate the block
> device to the dax page, so that the memory-failure is able to iterate the
> owners by the query interface provided by filesystem.

No, it doesn't need to track owner info from a DAX page.  What it needs to
do is ask the filesystem.
