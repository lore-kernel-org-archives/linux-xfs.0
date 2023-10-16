Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B783BCDB465
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Oct 2023 12:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjJPM6N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 08:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbjJPM6M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 08:58:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E756CEB;
        Mon, 16 Oct 2023 05:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ObD2Urf5JwLy9ruZZLszt1TmvHtSWk9zNtD+iNIfaDI=; b=BP/wvO6CMNaMg6+OIiTW400rru
        FhQc7v9sEmZhj7p05vM0fC6kXz2vt9OxNEATzqE0FEmrdNczON81+IjCom+tWMRwWXj2TjpgvaVFC
        fu9A7A4RoWM1vwuR6JUfeU+SGW9EXigyMQ8DMbHojhOo+tdt3yhoyFhujfznhGDlE9C2KhBFhyrtL
        ijx64YH4cvArCxoR8VL71e2s7w3on4m1+Fpi9aqoaJr1d4ZQ9OBju/fCq8p2tVDTQ+/WFEVX7KFC+
        IQC9GWReNcX4ZukIkN1ySX3DPIDo44EHNOVq9enIQSa+JEPESyfd9th3lebXIRsj5lM1/wurDQCM2
        rbbr27vg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsNAd-009fBL-2U;
        Mon, 16 Oct 2023 12:58:07 +0000
Date:   Mon, 16 Oct 2023 05:58:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev,
        djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 11/28] iomap: pass readpage operation to read path
Message-ID: <ZS0zX7BxxeZnKl05@infradead.org>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-12-aalbersh@redhat.com>
 <ZSz/FLK+tNIQzOA/@infradead.org>
 <xic2dogypvli45ku7nasuuszslvv55tadj6etpl7r3gubvw2o6@hms55yjiqsiq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xic2dogypvli45ku7nasuuszslvv55tadj6etpl7r3gubvw2o6@hms55yjiqsiq>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2023 at 02:32:25PM +0200, Andrey Albershteyn wrote:
> >From the discussion in v2 [1] I understood that btrfs would like to
> have this bio_set/submit_io interface for iomap transition;

For btrfs it would not be a transitional thing, but forever as it has
it's own equivalent of a device mapper at this level.  But now that
the fsverity interfaces work so that we don't have other file system
dependencies I would not want to design around it.  If/when btrfs
migrates to iomap for the buffer read path we can easily hook this
into the existing code.

> and any
> other filesystem deferrals would also be possible. Is it no more the
> case with btrfs? Would fs-verity verification in iomap_read_end_io
> combine both solutions (fs-verity verification in iomap +
> submit_io/bio_set interface).

btrfs does also need to do I/O completion from a workqueue, but it
needs it's own.  fsverity OTOH is a pretty generic feature.

