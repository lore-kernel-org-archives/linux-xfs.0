Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A54C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 18:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 443472065F
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 18:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598294883;
	bh=LrBvL/lvgaw9oM+bfag92o0XOBwU/bnJJbi2/vNaqgM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=T9MrhUo8+UVBIJju+o2oZqd0ZFI2BkHovxo1J3H3JElkPTIZ1HBrSZzBcAxjG0OGC
	 XmYTvrkmiFJKZEDi0v8xv9qgZRn3EIVl3JhPwgXgooLnpwMNj2wRZIO2hxFNZmAF/i
	 X4ui5nV9wc6/ZtAy8Ffn+YoLImgijy4pkr3GuTS8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgHXSr6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 14:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgHXSrz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 14:47:55 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8884820738;
        Mon, 24 Aug 2020 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598294875;
        bh=LrBvL/lvgaw9oM+bfag92o0XOBwU/bnJJbi2/vNaqgM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g/kN+3NBLlEe62ILTawYQsb0fceIegB6ymJBDZCBntruwEFQRK1siflzwOcb/gOEG
         /nEKc2+l1vOKTSplNt0BHG2F/NZ40meo3/Uwzzs5IA59tYV2Ufft7g9d3jgtSy/opH
         8I8uNUIft0ianKn10BsEc5P2U8TQOOztH6aGJnBk=
Message-ID: <af70d334271913a6b09bfd818bc3d81eef5a19b2.camel@kernel.org>
Subject: Re: [PATCH 5/5] fs/ceph: use pipe_get_pages_alloc() for pipe
From:   Jeff Layton <jlayton@kernel.org>
To:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Mon, 24 Aug 2020 14:47:53 -0400
In-Reply-To: <c943337b-1c1e-9c85-4ded-39931986c6a3@nvidia.com>
References: <20200822042059.1805541-1-jhubbard@nvidia.com>
         <20200822042059.1805541-6-jhubbard@nvidia.com>
         <048e78f2b440820d936eb67358495cc45ba579c3.camel@kernel.org>
         <c943337b-1c1e-9c85-4ded-39931986c6a3@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2020-08-24 at 10:54 -0700, John Hubbard wrote:
> On 8/24/20 3:53 AM, Jeff Layton wrote:
> > This looks fine to me. Let me know if you need this merged via the ceph
> > tree. Thanks!
> > 
> > Acked-by: Jeff Layton <jlayton@kernel.org>
> > 
> 
> Yes, please! It will get proper testing that way, and it doesn't have
> any prerequisites, despite being part of this series. So it would be
> great to go in via the ceph tree.
> 
> For the main series here, I'll send a v2 with only patches 1-3, once
> enough feedback has happened.
> 

Ok, I'll plan to pick it up providing no one has issues with exporting that symbol.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

