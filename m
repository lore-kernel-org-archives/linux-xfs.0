Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752075AbdFVUrH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 16:47:07 -0400
Date: Thu, 22 Jun 2017 15:46:54 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_db: update sector size when type is set
Message-ID: <20170622204654.GD22273@redhat.com>
References: <20170622193352.22346-1-billodo@redhat.com>
 <20170622194723.GV4733@birch.djwong.org>
 <20170622202322.GA22273@redhat.com>
 <20170622203941.GW4733@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170622203941.GW4733@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Jun 22, 2017 at 01:39:41PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 22, 2017 at 03:23:22PM -0500, Bill O'Donnell wrote:
> > On Thu, Jun 22, 2017 at 12:47:23PM -0700, Darrick J. Wong wrote:
> > > On Thu, Jun 22, 2017 at 02:33:52PM -0500, Bill O'Donnell wrote:
> > > > xfs_db doesn't take sector size into account when setting type.
> > > > This can result in an errant crc. For example, with a sector size
> > > > of 4096:
> > > > 
> > > > xfs_db> agi 0
> > > > xfs_db> p crc
> > > > crc = 0xab85043e (correct)
> > > > xfs_db> daddr
> > > > current daddr is 16
> > > > xfs_db> daddr 42
> > > > xfs_db> daddr 16
> > > > xfs_db> type agi
> > > > Metadata CRC error detected at xfs_agi block 0x10/0x200
> > > > xfs_db> p crc
> > > > crc = 0xab85043e (bad)
> > > > 
> > > > When xfs_db sets the new daddr in daddr_f, it does so with one
> > > > BBSIZE sector (512). Changing the type doesn't change the size
> > > > of the current buffer in iocur_top, so the checksum is calculated
> > > > on the wrong length for the type (when the actual sector size > BBSIZE (512).
> > > > 
> > > > For types with fields, reread the buffer to pick up the correct size for
> > > > the new type when it gets set. Facilitate the reread by setting the cursor
> > > > with set_cur().
> > > > 
> > > > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > > > ---
> > > >  db/io.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > > 
> > > > diff --git a/db/io.c b/db/io.c
> > > > index 9918a51..7e6d330 100644
> > > > --- a/db/io.c
> > > > +++ b/db/io.c
> > > > @@ -616,6 +616,12 @@ set_iocur_type(
> > > >  {
> > > >  	struct xfs_buf	*bp = iocur_top->bp;
> > > >  
> > > > +	if (t->fields)
> > > > +		set_cur(t,
> > > > +			iocur_top->bb,
> > > > +			fsize(t->fields, iocur_top->data,
> > > > +			      0, 0) / mp->m_sb.sb_blocksize,
> > > 
> > > I thought the third parameter to set_cur (which is fed as the third
> > > parameter to libxfs_readbuf) was expressed in units of basic blocks
> > > (i.e. 512 bytes)?  fsize returns the size of the field in bytes (I
> > > think?), so dividing by sb_blocksize renders units of fs blocks, not
> > > basic blocks.
> > > 
> > 
> > fsize returns the field size in bits. Dividing by sb_blocksize gives basic blocks.
> 
> Yes, the subtlety that fsize() returns bits and sb_blocksize is usually
> 4096 / 512 == 8 means that the conversion works for the default case,
> but that leaves us open to bugs.  Consider if sb_blocksize == 65536.
> 
> There are so many different unit types in XFS that it is crucial for
> auditing to make analyzing unit conversions as easy as possible.  That
> means that we must show all intermediate steps in converting from one
> unit system to another, and we must not short circuit those hops.  This
> helps the reviewers find bugs.
> 
> For example, consider Eric's suggested replacement for the third parameter:
> 
> BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));
> 
> We know that the units of the third parameter are in basic blocks from
> flailing around in the set_cur code due to unhelpful parameter names.
> BTOBB converts bytes to basic blocks, so we theorize that the input must
> be in units of bytes.  We can then unpack the next level:
> 
> byteize(fsize(...))
> 
> Starting from the premise that this expression is in units of bytes, we
> apply the knowledge that byteize converts bit counts to byte counts, so
> we now also theorize that the input must be in units of bits.  Unpack
> the next level:
> 
> fsize(...)
> 
> To finish checking the expression value, we simply have to confirm that
> fsize() returns units of bits.  Therefore, the expression is correct.
> The unit analysis is straightforward and does not require knowledge of
> subtleties.

Excellent analysis, thanks!
Eric suggested I come up with a (robust) test case, and as you point out,
the need is fairly obvious. 

Thanks-
Bill

> 
> --D
> 
> > 
> > > <shrug> the naming isn't helpful at all:
> > 
> > I also found the naming through the call stack to be terrible and damned
> > confusing (c, d ? really??), but left that battle for another day, another
> > patch. ;)
> > 
> > Thanks-
> > Bill
> > 
> > > 
> > > void
> > > set_cur(
> > > 	const typ_t	*t,
> > > 	int64_t		d,
> > > 	int		c,
> > > ...
> > > 	iocur_top->len = BBTOB(c);
> > > 
> > > <codeconfused>
> > > 
> > > --D
> > > 
> > > > +			DB_RING_IGN, NULL);
> > > >  	iocur_top->typ = t;
> > > >  
> > > >  	/* verify the buffer if the type has one. */
> > > > -- 
> > > > 2.9.4
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
