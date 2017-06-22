Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751842AbdFVUeh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 16:34:37 -0400
Date: Thu, 22 Jun 2017 15:34:34 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_db: update sector size when type is set
Message-ID: <20170622203434.GC22273@redhat.com>
References: <20170622193352.22346-1-billodo@redhat.com>
 <20170622194723.GV4733@birch.djwong.org>
 <1e03a345-bb6c-7f13-4860-0506b368b987@sandeen.net>
 <20170622203108.GB22273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170622203108.GB22273@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Jun 22, 2017 at 03:31:08PM -0500, Bill O'Donnell wrote:
> On Thu, Jun 22, 2017 at 03:16:27PM -0500, Eric Sandeen wrote:
> > 
> > 
> > On 6/22/17 2:47 PM, Darrick J. Wong wrote:
> > > On Thu, Jun 22, 2017 at 02:33:52PM -0500, Bill O'Donnell wrote:
> > >> xfs_db doesn't take sector size into account when setting type.
> > >> This can result in an errant crc. For example, with a sector size
> > >> of 4096:
> > >>
> > >> xfs_db> agi 0
> > >> xfs_db> p crc
> > >> crc = 0xab85043e (correct)
> > >> xfs_db> daddr
> > >> current daddr is 16
> > >> xfs_db> daddr 42
> > >> xfs_db> daddr 16
> > >> xfs_db> type agi
> > >> Metadata CRC error detected at xfs_agi block 0x10/0x200
> > >> xfs_db> p crc
> > >> crc = 0xab85043e (bad)
> > >>
> > >> When xfs_db sets the new daddr in daddr_f, it does so with one
> > >> BBSIZE sector (512). Changing the type doesn't change the size
> > >> of the current buffer in iocur_top, so the checksum is calculated
> > >> on the wrong length for the type (when the actual sector size > BBSIZE (512).
> > >>
> > >> For types with fields, reread the buffer to pick up the correct size for
> > >> the new type when it gets set. Facilitate the reread by setting the cursor
> > >> with set_cur().
> > >>
> > >> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > >> ---
> > >>  db/io.c | 6 ++++++
> > >>  1 file changed, 6 insertions(+)
> > >>
> > >> diff --git a/db/io.c b/db/io.c
> > >> index 9918a51..7e6d330 100644
> > >> --- a/db/io.c
> > >> +++ b/db/io.c
> > >> @@ -616,6 +616,12 @@ set_iocur_type(
> > >>  {
> > >>  	struct xfs_buf	*bp = iocur_top->bp;
> > >>  
> > 
> > a comment about why only this "if" case is there would be good.
> 
> agreed.
> 
> > 
> > >> +	if (t->fields)
> > >> +		set_cur(t,
> > >> +			iocur_top->bb,
> > >> +			fsize(t->fields, iocur_top->data,
> > >> +			      0, 0) / mp->m_sb.sb_blocksize,
> > > 
> > > I thought the third parameter to set_cur (which is fed as the third
> > > parameter to libxfs_readbuf) was expressed in units of basic blocks
> > > (i.e. 512 bytes)?  fsize returns the size of the field in bytes (I
> > > think?), 
> > 
> > nope, bits :)
> > 
> > > so dividing by sb_blocksize renders units of fs blocks, not
> > > basic blocks.
> > 
> > As Darrick just pointed out to me, you treated bits as bytes and
> > daddr as fsblock so for 4k blocks, 8/8 came out right ;)
> 
> Yeah. Doh! I tested with sector sizes 512 and 4096 and it all just worked,
> since mp->m_sb.sb_blocksize returned 1 and 8, respectively.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Correction: _dividing by mp->m_sb.sb_blocksize_ gave 1 and 8, respectively.                         


> 
> > 
> > I think what you want for the size is something like:
> > 
> > BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));
> > 
> > It might be a little nicer to stash that in a temp var so you
> > don't have all that gunk in the call to set_cur.
> 
> Yep.
> 
> 
> > > <shrug> the naming isn't helpful at all:
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
> > 
> > yup isn't xfs_db fun?
> > 
> > > 
> > > --D
> > > 
> > >> +			DB_RING_IGN, NULL);
> > >>  	iocur_top->typ = t;
> > >>  
> > >>  	/* verify the buffer if the type has one. */
> > >> -- 
> > >> 2.9.4
> > >>
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
