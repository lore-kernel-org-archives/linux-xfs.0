Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6EBC004D4
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 18:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjASSdk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 13:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjASSdg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 13:33:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E6017CDB
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 10:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PtsWFZKjyf2wmTwydgS4XL8AP2EDa6GVaBmGKGhMQZ4=; b=VsL9Hz+PG0TqIy0Um9zxVnLulx
        jk3ct1j7Acyfr7gSQKxWjeTgmw9DLaZ8p9deFSy4VQqxG0XzEuKVWJZInvelxMW9E0t84KORJTJcO
        FmrAVaxf5gJdn00ntK8EnjEJUuMiQsVICmkWSvJuyH16CTjctyJzS/Xg0y29QpqkfIq1eK0kqMAQV
        SUR4R44ANTQeLQ8+4NyQmgtLyL5Aj3buH/GL6DCqlRxGmGtEERcj/DyRljqOGlrhh8NH3KEgyFBAT
        zE/OPagndrQiCyeuVOCYMYOzIplaJ1KmgtsgEPG2m7g3lnHPDaDybXrfKhiaD9V62w8jHT6qfQkuc
        tzG0oFjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIZj5-006aJ6-03; Thu, 19 Jan 2023 18:33:27 +0000
Date:   Thu, 19 Jan 2023 10:33:26 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't use BMBT btree split workers for IO completion
Message-ID: <Y8mM9rdRUU98+HEW@infradead.org>
References: <20230119010334.1982938-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119010334.1982938-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 12:03:34PM +1100, Dave Chinner wrote:
> The other place we can be called for a BMBT split without a
> preceeding allocation is __xfs_bunmapi() when punching out the
> center of an existing extent. We don't remove extents in the IO
> path, so these operations don't tend to be called with a lot of
> stack consumed. Hence we don't really need to ship the split off to
> a worker thread in these cases, either.

So I agree with the fix.  But the t_firstblock seems a bit opaque.
We do have a lot of comments, which is good but it still feels
a little fragile to me.  Is there a good reason we can't do an
explicit flag to document the intent better?
