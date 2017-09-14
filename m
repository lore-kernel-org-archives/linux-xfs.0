Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751131AbdINNOd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Sep 2017 09:14:33 -0400
Date: Thu, 14 Sep 2017 15:14:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 4/4] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170914131431.GA26021@quack2.suse.cz>
References: <20170914095047.23935-1-agruenba@redhat.com>
 <20170914095047.23935-5-agruenba@redhat.com>
 <20170914120229.GA22886@quack2.suse.cz>
 <CAHpGcMJY2PZJYLzUS5ejcnfSVkeO-GKL7z1fRONs1AUdyiaULg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHpGcMJY2PZJYLzUS5ejcnfSVkeO-GKL7z1fRONs1AUdyiaULg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu 14-09-17 14:47:28, Andreas Grünbacher wrote:
> 2017-09-14 14:02 GMT+02:00 Jan Kara <jack@suse.cz>:
> > On Thu 14-09-17 11:50:47, Andreas Gruenbacher wrote:
> >> @@ -3422,9 +3422,38 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
> >>       map.m_lblk = first_block;
> >>       map.m_len = last_block - first_block + 1;
> >>
> >> -     if (!(flags & IOMAP_WRITE)) {
> >> +     if (flags & IOMAP_REPORT) {
> >>               ret = ext4_map_blocks(NULL, inode, &map, 0);
> >> -     } else {
> >> +             if (ret < 0)
> >> +                     return ret;
> >> +
> >> +             if (ret == 0) {
> >> +                     ext4_lblk_t end = map.m_lblk + map.m_len - 1;
> >> +                     struct extent_status es;
> >> +
> >> +                     ext4_es_find_delayed_extent_range(inode, map.m_lblk, end, &es);
> >> +
> >> +                     if (!es.es_len || es.es_lblk > end) {
> >> +                             /* entire range is a hole */
> >> +                     } else if (es.es_lblk > map.m_lblk) {
> >> +                             /* range starts with a hole */
> >> +                             map.m_len = es.es_lblk - map.m_lblk;
> >> +                     } else {
> >> +                             ext4_lblk_t offs = 0;
> >> +
> >> +                             if (es.es_lblk < map.m_lblk)
> >> +                                     offs = map.m_lblk - es.es_lblk;
> >> +                             map.m_lblk = es.es_lblk + offs;
> >> +                             map.m_pblk = ext4_es_pblock(&es) + offs;
> >> +                             map.m_len = es.es_len - offs;
> >> +                             if (ext4_es_is_unwritten(&es))
> >> +                                     map.m_flags |= EXT4_MAP_UNWRITTEN;
> >
> > This is not possible. If there is unwritten extent at map->m_lblk, then
> > ext4_map_blocks() could not have possibly returned 0. So just delete this
> > condition and set map.m_pblk to 0 since delalloc extent has no physical
> > position.
> >
> >> +                             if (ext4_es_is_delayed(&es))
> >> +                                     delalloc = true;
> >
> > Also ext4_es_is_delayed(&es) is guaranteed to be true since you've looked
> > it up by ext4_es_find_delayed_extent_range(). So just set delalloc = true
> > unconditionally.
> 
> Since map.m_pblk is never used in the delalloc case, we can leave it
> undefined above as well.

Yeah, that's fine by me as well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
