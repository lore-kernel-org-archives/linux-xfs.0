Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCE3CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 02:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C89FB217F5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 02:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="Ia+DrRDU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QldcSlHY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfKECsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 21:48:06 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35805 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728351AbfKECsG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 21:48:06 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F0F621FE5;
        Mon,  4 Nov 2019 21:48:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 Nov 2019 21:48:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        qQ3C1R2j55iHWjmzRCSCninXKgallIlyntUAdm6kx5Y=; b=Ia+DrRDUp0mQ3KU4
        i1tHV9EZXHVT/xOL/nxeuf7P5FuyGIaOfx/0mTQ3w74tBRf8iS5rNI28LgxvHNfs
        e/8BCCeHEWPickX9E1am20dnDrJyY0K/Od6dWaYpfgSBWcaLV3KS6TTkyDg2ogcE
        jIxrtoDumdcg9EVreB8MbVzEIN2KPcJrkRjiuSmwiJ1hUHdEayEJEJkQUWA7GqQY
        eVTT77IoJAI5ZZbIjdZLLAQtSzl0HV1TmIQWxoYcDkbB2foxUcOzLC+hbfx8XDFY
        e6eUdu2EN1mzH0XQGSDczDaVYgdrfxnr31LH4Le/LoMQw71ghmt7IqRzpYmA2eKB
        gVtwpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=qQ3C1R2j55iHWjmzRCSCninXKgallIlyntUAdm6kx
        5Y=; b=QldcSlHYhw0TNZIj2KmIEEBfG/WqzMP1/OUa6Po8EB6seeeHE8HnLidmx
        zIpqVAgeKcrTn6tMhrrY90j7QpHthsL+P8vuTqAWEBb8mwpOLKiGZ9765HhJevb2
        9cRWQ1/9YzQcHZ0FshxKXPJUPg0ayAVw3DkyK6qm0fEFqFX1vlXBn7arnXJoot/N
        umG2pXnApmnaDPFcC9I3kTVZ8k5sIM/4fBCPewnvPj2wjzJeo2OzR8KM1EX3eilA
        WTZo159I/2jYwIflJ04zJqMCLQ/GOu9d9D+cP2a8hGrrXSGpsAKTuoMeMGkwMlbj
        4QPdNNIhjVii6SkTSaKF+CrBsN+Kg==
X-ME-Sender: <xms:5OLAXRoH30YmpuElRPzSo_EEeCGl986Djshdlv9RuapeohAhZt2pVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddugedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekledrudeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:5OLAXbcdoMM0OBX6n0otxf_rZTL81bhWbZamHC13NFlyFhw6kA00bw>
    <xmx:5OLAXZmp16bZgBCUi3yjBebVK3cvrnLdZiVsB_RbSjsqT0MYhhgjdg>
    <xmx:5OLAXWsEA_4IzTO4G_J8JLmK7impKwkoTcWXokwLZPqG7OyODkD1mw>
    <xmx:5eLAXW1eirk3tD-TtFRPnTcz9ZNrgNS2EGhXUEz2f5CgYYNZ9xr0Pg>
Received: from mickey.themaw.net (unknown [118.208.189.18])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2D6C80060;
        Mon,  4 Nov 2019 21:48:00 -0500 (EST)
Message-ID: <193f1fa8f5c93779aba1b52259215581f7e81637.camel@themaw.net>
Subject: Re: [PATCH v8 12/16] xfs: dont set sb in xfs_mount_alloc()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Tue, 05 Nov 2019 10:47:56 +0800
In-Reply-To: <20191104211205.GL4153244@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
         <157259466607.28278.4456308072088112584.stgit@fedora-28>
         <20191101201536.GG15222@magnolia>
         <ae8c1a5f4c357c6c9060f09b374bad472b422ebf.camel@themaw.net>
         <20191104211205.GL4153244@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-11-04 at 13:12 -0800, Darrick J. Wong wrote:
> On Sat, Nov 02, 2019 at 12:41:39PM +0800, Ian Kent wrote:
> > On Fri, 2019-11-01 at 13:15 -0700, Darrick J. Wong wrote:
> > > On Fri, Nov 01, 2019 at 03:51:06PM +0800, Ian Kent wrote:
> > > > When changing to use the new mount api the super block won't be
> > > > available when the xfs_mount struct is allocated so move
> > > > setting
> > > > the
> > > > super block in xfs_mount to xfs_fs_fill_super().
> > > > 
> > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_super.c |    7 +++----
> > > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > index 4b570ba3456a..62dfc678c415 100644
> > > > --- a/fs/xfs/xfs_super.c
> > > > +++ b/fs/xfs/xfs_super.c
> > > > @@ -1560,8 +1560,7 @@ xfs_destroy_percpu_counters(
> > > >  }
> > > >  
> > > >  static struct xfs_mount *
> > > > -xfs_mount_alloc(
> > > > -	struct super_block	*sb)
> > > > +xfs_mount_alloc(void)
> > > >  {
> > > >  	struct xfs_mount	*mp;
> > > >  
> > > > @@ -1569,7 +1568,6 @@ xfs_mount_alloc(
> > > >  	if (!mp)
> > > >  		return NULL;
> > > >  
> > > > -	mp->m_super = sb;
> > > 
> > > Just out of curiosity, is there any place where we need m_super
> > > in
> > > between here...
> > > 
> > > >  	spin_lock_init(&mp->m_sb_lock);
> > > >  	spin_lock_init(&mp->m_agirotor_lock);
> > > >  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> > > > @@ -1605,9 +1603,10 @@ xfs_fs_fill_super(
> > > >  	 * allocate mp and do all low-level struct
> > > > initializations
> > > > before we
> > > >  	 * attach it to the super
> > > >  	 */
> > > > -	mp = xfs_mount_alloc(sb);
> > > > +	mp = xfs_mount_alloc();
> > > >  	if (!mp)
> > > >  		goto out;
> > > > +	mp->m_super = sb;
> > > 
> > > ...and here?  For example, logging errors?  AFAICT the only thing
> > > that
> > > goes on between these two points is option parsing, right?  (And
> > > the
> > > parsing has its own prefixed logging, etc.)
> > 
> > Yes, only option parsing is going on between these two points.
> > 
> > And, for now, the error reporting is caught by the VFS.
> > 
> > There is one location in xfs_fc_parse_param() where an xfs log
> > message could be emitted although it's never reached (because of
> > the return if the fs_parse() call fails).
> > 
> > If log messages were issued in between these two points the
> > consequence
> > is a missing block device name in the message. You remember, a
> > check on
> > mp->m_super was added to __xfs_printk() to cover this case when
> > struct
> > xfs_mount field m_fsname was eliminated.
> 
> It's true that (AFAICT) this is the only place where xfs might need
> mp->m_super but it doesn't yet have one, but you'd agree that this is
> a
> significant change to the scoping rules, right?  In the past there
> was
> never a place in xfs where we'd have to check mp->m_super == NULL,
> but
> now we have to keep that possibility in mind, at least for any
> function
> that can be called before get_tree_bdev.

Yes, it is, but that is forced on file systems by the VFS.

I'm not certain this design is needed to support the new
fsopen()/fsconfig()/fsmount() system calls though I think it is
due to the way in which they are called.

For example I don't think the VFS has enough information to obtain
the super block at the time fsconfig() is being called so it must
be deferred until fsmount() and fsconfig() is about parameter parsing.

> 
> > This potential lack of device name in log messages is a problem I
> > can't
> > fix because the block device isn't obtained until after parameter
> > parsing, just before the super block is acquired. Changing that in
> > the
> > VFS would be quite significant so I'm stuck!
> 
> Um, we used to obtain the block device and the superblock before we
> started option parsing.  I guess the worst that happens is that
> anything
> trying to dereference mp->m_super is just going to crash...

Yes, but the xfs logging is probably the most important thing that
would be needed prior to calling get_tree_bdev() and that's currently
ok except for the missing block device name.

There may be ways to change this but I'm pretty sure they would cause
fairly significant challenges for the overall design and support of
those new system calls and that's one of the key elements of the new
mount-api.

Ian

