Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F19C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 14:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiK3OWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 09:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiK3OWo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 09:22:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1924E2F
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 06:22:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E4AEB81B60
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 14:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353BBC433C1;
        Wed, 30 Nov 2022 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669818153;
        bh=ba9cOuEwR0L0woYbg2XumDL7fSXYqhVxK/LE4HgAQds=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=sooPC+TFnRvOGPBhhFl4IBkBbebWSINEO1SyhJslN+Z9xZQyoSA7eXujHOjdoZW7g
         8VxvuNm3ScFu/jxtSC03/29N+BuEI7PUuM9EQbTmFp79hpF69EdrB6qV/LcSGydbfI
         7wtqF4UiXB+ZF6xwVhoFIWtt1wcT161xExV15JRE/cab1gnpXNXeZSMZZaG6YEE9IL
         80FcRu4Pb1LsCidMFKXzXEWoFsOOTyxda9bYCRtwegRg84cNXF5yq1EPkK4FGlMaca
         4V+x4r+hkst5Iota148YHnXZhAwDwg0CxJvyhSLXjokxJ9INwaU4zD6/yIDnxigiTm
         Lb1vojTB5ToWQ==
Date:   Wed, 30 Nov 2022 15:22:28 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Message-ID: <20221130142228.s3taflpvaj5bfia3@andromeda>
References: <20221128131434.21496-1-cem@kernel.org>
 <20221128131434.21496-2-cem@kernel.org>
 <0NyqEHx7QX5M7O3PkRWy9sATHt9hJPj8dbnNIMJyNpqeq9aoBrZvkghW9BWkoENYiKkmi-Yg3IBf-l_G4jUy8w==@protonmail.internalid>
 <Y4UxpPgxbmOi/T9/@magnolia>
 <KPMLSPXiDKono7p55z3gbfWueVu9cMSWxiXEtLwYLP8iiFwccJfklgds0T-ARwMz5Ca6x-5l9GYTgsgalM7W6Q==@protonmail.internalid>
 <20221129141821.4goi2odggvztefhq@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129141821.4goi2odggvztefhq@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > > +err_loop:
> > > +	libxfs_btree_del_cursor(bt_cur, error);
> > > +err_bt_cur:
> > > +	libxfs_buf_relse(agbp);
> > > +err_pag:
> > > +	libxfs_perag_put(pag);
> >
> > So I see that you fixed one of the labels so that err_pag jumps to
> > releasing the perag pointer, but it's still the case that err_bt_cur
> > frees the AGF buffer, not the btree cursor; and that err_loop actually
> > frees the btree cursor.
> 
> Totally true. I focused on your comments regarding err_pag, and forgot to review
> the remaining labels. I'll fix it and send a V3.

Just to avoid unnecessary new versions :)
Are the fallowing names ok?

err_cur
err_agf
err_pag

Could be err_agbp too, but I'd rather be explicit this buffer belongs to the
agf.


> 
> Thanks for the review.
> 

-- 
Carlos Maiolino
