Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792508036;
	b=f5ZhU1Zby4A19J4+hUpXgyd73lLTBkwN8wlN1SuQEFKtxqmAb9bS5JU+ogGe4SEvzrc2
	 Mvf7L01Iad55N1r9x5eZChZc9IkrxnedXE3xG/4sJ0BtLTXpa/8g7Xp2FRVF+J1FIIkGu
	 Mvr+ddszbRUr+13nWVIhZrRooRwFFcfEZs8oY3lOd7RTo4UQ9iedP5zOwpuvDpMDBNg5a
	 0Jx5uPOnYVf2tj4OpE4MxxyNbBnEX1aFER/CExmrkGNeebwiMBtFLJkIDoCkCvFysWEhT
	 jWh6KC+0LItR3O1nuKGw+H5f8Qd8kL9AZb9gnqFSUqrx2/TstIsa5CxJrhpgtZocrmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792508036;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/bwYNsuvdLOeGIvvyV7lXuTJEpgdy2xoAlb1KPVe2eU=;
	b=kvGvn/yBRpq3pajMQq3GvJg6WTxWOpiWP+TIO49xEc2VKKZEV6ORne7hwamwk4JjIZiy
	 /PDK7sGurlRcXU1l3fduhyn/FEdzKjDgME3CDeczbj6WzsT3xD/SEgGfWRioZPymQGw+s
	 vi0LNy4menNgzDuRXO9O0pUAT8YQ8swM7ydHE18avHZ2g3EjBZ+X0EJgKcdLxQDQNfrKV
	 gJXP+nAltnQiBJu7IUqC3S9sbnnGZRmI9jaaomBqLFd2NTkdnqkMAOEa/1zaQZQNgFUy5
	 ybqtHiNo7+VZkZjwE3Vc3dvCx5Ob6XAdamaDzjR4CLNVG+r1/5ablyrTHfQySu5WilA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+nClr50;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9377C606A324;
	Tue, 20 Oct 2026 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+nClr50
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC0B1F000C4;
	Tue, 20 Oct 2026 14:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792508035;
	bh=/bwYNsuvdLOeGIvvyV7lXuTJEpgdy2xoAlb1KPVe2eU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j+nClr509Ip2YmEn7/caQLmG/4tBtyXZnslPC9cLou/c2WF5cUyD8vV0z4nB9Tev2
	 plhyZAe/DFKunvOqX8v/oXRElPiP3zxk2HziYyB5Fx7bPGt0t29G9UDf+1rfbuTFys
	 26EzMGskCjKKCcH4vAuqOv+1PYrBjiQnY9DVI9Dr4fSEZ8yAk0LnKIRmk7JwU0k+tW
	 rl99vZagqlR6jXNFfVasyDMk1PxV7oE6nRO/s1kciIZkWvnPgB1U5HfkO6NzVlXd9L
	 pR5YKf1B76wv3ukXrumON6Rbv57+rbThp5bo1tebJ6WrsH6Sye8PXipcbNZHIwrAzz
	 YGHmJPYOdgplw==
Date: Tue, 20 Oct 2026 16:53:45 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 20/28] gfs2: wait for a pending withdraw before
 remounting read-only
Message-ID: <20261020-steinbock-sprachen-charmant-e4fd6d840395@brauner>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-20-60743a3dc326@kernel.org>
 <CAHc6FU5bdAjABRm=bnH68b2f66TZTDZ8sPdatLB2fS7-55U=yw@mail.gmail.com>
 <20261018-ungemacht-sodbrennen-hausordnung-42d33a4f7098@brauner>
 <wauqpgtmmf2beg3pc2kqlbizrigd4ew26do4zqch5ilwdjy4cd@brolwbx25sem>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <wauqpgtmmf2beg3pc2kqlbizrigd4ew26do4zqch5ilwdjy4cd@brolwbx25sem>

On Mon, Oct 19, 2026 at 11:52:25AM +0200, Jan Kara wrote:
> On Sun 18-10-26 17:48:34, Christian Brauner wrote:
> ...
> > On Fri, Oct 16, 2026 at 02:32:01AM +0200, Andreas Gruenbacher wrote:
> > > > diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
> > > > index 83b8bb6446e5..1535ce2b7aa8 100644
> > > > --- a/fs/gfs2/util.c
> > > > +++ b/fs/gfs2/util.c
> > > > @@ -122,7 +122,7 @@ static void do_withdraw(struct gfs2_sbd *sdp)
> > > >                 up_write(&sdp->sd_log_flush_lock);
> > > >                 return;
> > > >         }
> > > > -       clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> > > > +       clear_and_wake_up_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> > > >         gfs2_ail_drain(sdp); /* frees all transactions */
> > > >         up_write(&sdp->sd_log_flush_lock);
> > > >
> > > >
> > > > --
> > > > 2.53.0
> > > >
> > > 
> > > this looks good all around, thank you very much. Can I add it to my gfs2 queue?
> > 
> > I was planning to just provide a stable branch for everyone to pull post
> > -rc1. Then you can just pull that in?
> 
> On a related topic: I didn't find any branch with this work in vfs.git - I
> wanted to check how all the things come together after adding the generic
> emergency RO bit. So if you can push some inofficial branch for now it
> would help me... Thanks!

Absolutely:

vfs-7.5.super.ro
