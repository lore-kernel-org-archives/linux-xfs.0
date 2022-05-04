Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4801DC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  4 May 2022 08:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346009AbiEDIGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 04:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345990AbiEDIGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 04:06:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAF7F1FCE3
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 01:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651651376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QXs2GF6sBKWIeqbf7WfMBsD5HrZduvaTKSVFb36kok4=;
        b=Y9yxr+rr4Z7Uw0ylgMBHwKPvhZNZJ48QBWoc5F2bXzZ149r5GXYkLbueIScbXV9IamTLw9
        G2R+FnslngMvz8njuGBtxFr8MK4QLGJrDZqW+sf4vRvTAdMO4mERw99T3Dx23WWgqjNm04
        Xy1kgyLCZ6g1M9N13Qqf6Nd6rLHfGLc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-0V3H3fvjPUW3j_FiCAgx_w-1; Wed, 04 May 2022 04:02:55 -0400
X-MC-Unique: 0V3H3fvjPUW3j_FiCAgx_w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15CB88039D7;
        Wed,  4 May 2022 08:02:55 +0000 (UTC)
Received: from max.localdomain (unknown [10.40.194.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA750463E16;
        Wed,  4 May 2022 08:02:53 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] iomap: iomap_write_end cleanup
Date:   Wed,  4 May 2022 10:02:52 +0200
Message-Id: <20220504080252.3299512-1-agruenba@redhat.com>
In-Reply-To: <YnHIeHuAXr6WCk7M@casper.infradead.org>
References: <YnHIeHuAXr6WCk7M@casper.infradead.org> <20220503213727.3273873-1-agruenba@redhat.com> <YnGkO9zpuzahiI0F@casper.infradead.org> <CAHc6FU5_JTi+RJxYwa+CLc9tx_3_CS8_r8DjkEiYRhyjUvbFww@mail.gmail.com> <20220503230226.GK8265@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 4, 2022 at 2:27 AM Matthew Wilcox <willy@infradead.org> wrote:=
=0D
> On Tue, May 03, 2022 at 04:02:26PM -0700, Darrick J. Wong wrote:=0D
> > On Wed, May 04, 2022 at 12:15:45AM +0200, Andreas Gruenbacher wrote:=0D
> > > On Tue, May 3, 2022 at 11:53 PM Matthew Wilcox <willy@infradead.org> =
wrote:=0D
> > > > On Tue, May 03, 2022 at 11:37:27PM +0200, Andreas Gruenbacher wrote=
:=0D
> > > > > In iomap_write_end(), only call iomap_write_failed() on the byte =
range=0D
> > > > > that has failed.  This should improve code readability, but doesn=
't fix=0D
> > > > > an actual bug because iomap_write_failed() is called after updati=
ng the=0D
> > > > > file size here and it only affects the memory beyond the end of t=
he=0D
> > > > > file.=0D
> > > >=0D
> > > > I can't find a way to set 'ret' to anything other than 0 or len.  I=
 know=0D
> > > > the code is written to make it look like we can return a short writ=
e,=0D
> > > > but I can't see a way to do it.=0D
> > >=0D
> > > Good point, but that doesn't make the code any less confusing in my e=
yes.=0D
> >=0D
> > Not to mention it leaves a logic bomb if we ever /do/ start returning=0D
> > 0 < ret < len.=0D
>=0D
> This is one of the things I noticed when folioising iomap and didn't=0D
> get round to cleaning up, but I feel like we should change the calling=0D
> convention here to bool (true =3D success, false =3D fail).  Changing=0D
> block_write_end() might not be on the cards, unless someone's really=0D
> motivated, but we can at least change iomap_write_end() to not have this=
=0D
> stupid calling convention.=0D
>=0D
> I mean, I won't NAK this patch, it is somewhat better with it than withou=
t=0D
> it, but it perpetuates the myth that this is in some way ever going to=0D
> happen, and the code could be a lot simpler if we stopped pretending.=0D
=0D
Hmm, I don't really see how this would make things significantly=0D
simpler.  Trying it out made me notice the following problem, though.=0D
Any thoughts?=0D
=0D
Of course this was copied from generic_write_end(), and so we have the same=
=0D
issue there as well as in nobh_write_end().=0D
=0D
Thanks,=0D
Andreas=0D
=0D
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c=0D
index 8fb9b2797fc5..1938dbbda1c0 100644=0D
--- a/fs/iomap/buffered-io.c=0D
+++ b/fs/iomap/buffered-io.c=0D
@@ -721,13 +721,13 @@ static size_t iomap_write_end(struct iomap_iter *iter=
, loff_t pos, size_t len,=0D
 	 * cache.  It's up to the file system to write the updated size to disk,=
=0D
 	 * preferably after I/O completion so that no stale data is exposed.=0D
 	 */=0D
-	if (pos + ret > old_size) {=0D
+	if (ret && pos + ret > old_size) {=0D
 		i_size_write(iter->inode, pos + ret);=0D
 		iter->iomap.flags |=3D IOMAP_F_SIZE_CHANGED;=0D
 	}=0D
 	folio_unlock(folio);=0D
=0D
-	if (old_size < pos)=0D
+	if (ret && old_size < pos)=0D
 		pagecache_isize_extended(iter->inode, old_size, pos);=0D
 	if (page_ops && page_ops->page_done)=0D
 		page_ops->page_done(iter->inode, pos, ret, &folio->page);=0D

