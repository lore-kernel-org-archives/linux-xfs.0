Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65CCB7F54
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 10:12:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56677304062
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 08:12:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vq8iqkTog7ilKX3H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 08:12:27 -0700 (PDT)
Date: Wed, 19 Aug 2015 08:12:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/10] xfs_db: trash the block at the top of the cursor
	stack
Message-ID: <20150819151218.GQ10043@birch.djwong.org>
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
	<20150815014436.1839.74362.stgit@birch.djwong.org>
	<55D38EA0.6030701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55D38EA0.6030701@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Aug 18, 2015 at 02:59:28PM -0500, Eric Sandeen wrote:
> On 8/14/15 8:44 PM, Darrick J. Wong wrote:
> > Add a new -z option to blocktrash to make it trash the block that's at
> > the top of the stack, so that we can perform targeted fuzzing.  While
> > we're at it, prevent fuzzing off the end of the buffer and add a -o
> > parameter so that we can specify an offset to start fuzzing from.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/check.c        |   81 +++++++++++++++++++++++++++++++++++++++++------------
> >  man/man8/xfs_db.8 |   15 +++++++++-
> >  2 files changed, 77 insertions(+), 19 deletions(-)
> > 
> > 
> > diff --git a/db/check.c b/db/check.c
> > index 965d0f5..7c11b0b 100644
> > --- a/db/check.c
> > +++ b/db/check.c
> > @@ -930,8 +930,7 @@ typedef struct ltab {
> >  
> >  static void
> >  blocktrash_b(
> > -	xfs_agnumber_t	agno,
> > -	xfs_agblock_t	agbno,
> > +	int		offset,
> 
> a comment about "offset into what?" might be nice
> 
> >  	dbm_t		type,
> >  	ltab_t		*ltabp,
> >  	int		mode)
> > @@ -943,23 +942,36 @@ blocktrash_b(
> >  	int		len;
> >  	int		mask;
> >  	int		newbit;
> > -	int		offset;
> >  	const struct xfs_buf_ops *stashed_ops;
> >  	static char	*modestr[] = {
> >  		N_("zeroed"), N_("set"), N_("flipped"), N_("randomized")
> >  	};
> > +	xfs_agnumber_t	agno;
> > +	xfs_agblock_t	agbno;
> >  
> > +	agno = XFS_FSB_TO_AGNO(mp, XFS_DADDR_TO_FSB(mp, iocur_top->bb));
> > +	agbno = XFS_FSB_TO_AGBNO(mp, XFS_DADDR_TO_FSB(mp, iocur_top->bb));
> > +	if (iocur_top->len == 0) {
> > +		dbprintf(_("zero-length block %u/%u buffer to trash??\n"),
> > +				agno, agbno);
> > +		return;
> > +	}
> >  	len = (int)((random() % (ltabp->max - ltabp->min + 1)) + ltabp->min);
> > -	offset = (int)(random() % (int)(mp->m_sb.sb_blocksize * NBBY));
> > +	/*
> > +	 * offset >= 0: start fuzzing at this exact offset.
> 
> "this exact bit offset"
> 
> > +	 * offset < 0: pick an offset at least as high at -(offset + 1).
> 
> "a bit offset ..."
> 
> (units would be nice, in the comments.  I had assumed bytes, even though you have NBBY)

Ok.

> Ow, my brain.  ;)
> 
> Your manpage says:
> 
> > If the value is preceded by a '+', the
> > +trashing will start at a randomly chosen offset that is larger than the value
> > +supplied.
> 
> which seems sane.
> 
> If we supply +10,
> 
> +			if (relative)
> +				offset = -offset - 1;
> 
> so now offset = -10 - 1, and we get -11.
> Then:
> 
> > +	 */
> > +	if (offset < 0) {
> > +		offset = -(offset + 1);
> 
> now offset = -(-11 + 1) = -(-10) = 10.  Okay... so 10 or higher.
> 
> What's w/ the +/- 1?  

It's to distinguish "start fuzzing at exactly zero" from "pick anywhere
(at least as high as bit offset zero) to start fuzzing".

> 
> Why not just:
> 
> if (relative)
> 	offset = -offset;	/* i.e. -10 */
> 
> ...
> 
> if (offset < 0) {
> 	offset = -offset;	/* i.e. 10 */
> 	offset = offset + (int)(random() % (int)((iocur_top->len - offset) * NBBY)); ...
> 
> 
> > +		offset = offset + (int)(random() % (int)((iocur_top->len - offset) * NBBY));
> > +	}
> > +	if (offset + len >= iocur_top->len * NBBY)
> > +		len = (iocur_top->len * NBBY) - offset;
> >  	newbit = 0;
> > -	push_cur();
> > -	set_cur(NULL,
> > -		XFS_AGB_TO_DADDR(mp, agno, agbno), blkbb, DB_RING_IGN, NULL);
> >  	stashed_ops = iocur_top->bp->b_ops;
> >  	iocur_top->bp->b_ops = NULL;
> >  	if ((buf = iocur_top->data) == NULL) {
> >  		dbprintf(_("can't read block %u/%u for trashing\n"), agno, agbno);
> > -		pop_cur();
> >  		return;
> >  	}
> >  	for (bitno = 0; bitno < len; bitno++) {
> > @@ -988,7 +1000,6 @@ blocktrash_b(
> >  	}
> >  	write_cur();
> >  	iocur_top->bp->b_ops = stashed_ops;
> > -	pop_cur();
> >  	printf(_("blocktrash: %u/%u %s block %d bit%s starting %d:%d %s\n"),
> >  		agno, agbno, typename[type], len, len == 1 ? "" : "s",
> >  		offset / NBBY, offset % NBBY, modestr[mode]);
> > @@ -1019,11 +1030,9 @@ blocktrash_f(
> >  	uint		seed;
> >  	int		sopt;
> >  	int		tmask;
> > +	bool		this_block = false;
> > +	int		offset = -1;
> >  
> > -	if (!dbmap) {
> > -		dbprintf(_("must run blockget first\n"));
> > -		return 0;
> > -	}
> >  	optind = 0;
> >  	count = 1;
> >  	min = 1;
> > @@ -1050,7 +1059,7 @@ blocktrash_f(
> >  		   (1 << DBM_RTSUM) |
> >  		   (1 << DBM_SYMLINK) |
> >  		   (1 << DBM_SB);
> > -	while ((c = getopt(argc, argv, "0123n:s:t:x:y:")) != EOF) {
> > +	while ((c = getopt(argc, argv, "0123n:o:s:t:x:y:z")) != EOF) {
> >  		switch (c) {
> >  		case '0':
> >  			mode = 0;
> > @@ -1071,6 +1080,21 @@ blocktrash_f(
> >  				return 0;
> >  			}
> >  			break;
> > +		case 'o': {
> > +			int relative = 0;
> > +			if (optarg[0] == '+') {
> > +				optarg++;
> > +				relative = 1;
> > +			}
> > +			offset = (int)strtol(optarg, &p, 0);
> > +			if (*p != '\0' || offset < 0) {
> > +				dbprintf(_("bad blocktrash offset %s\n"), optarg);
> > +				return 0;
> > +			}
> > +			if (relative)
> > +				offset = -offset - 1;
> > +			break;
> > +		}
> >  		case 's':
> >  			seed = (uint)strtoul(optarg, &p, 0);
> >  			sopt = 1;
> > @@ -1102,11 +1126,22 @@ blocktrash_f(
> >  				return 0;
> >  			}
> >  			break;
> > +		case 'z':
> > +			this_block = true;
> > +			break;
> 
> is there any mnemonic for 'z'?  Maybe 'c' for Current, or 'b' for (this one) Block?
> 
> Not that big a deal, just wondering.

-z for "Corrupt 'zis block, pleaze". :)

I was hoping it is less confusing than "-t" for "select eligible block types"
and "-T" for "corrupt this exact block"?

> 
> >  		default:
> >  			dbprintf(_("bad option for blocktrash command\n"));
> >  			return 0;
> >  		}
> >  	}
> > +	if (!this_block && !dbmap) {
> > +		dbprintf(_("must run blockget first\n"));
> > +		return 0;
> > +	}
> > +	if (this_block && iocur_sp == 0) {
> > +		dbprintf(_("nothing on stack\n"));
> > +		return 0;
> > +	}
> >  	if (min > max) {
> >  		dbprintf(_("bad min/max for blocktrash command\n"));
> >  		return 0;
> > @@ -1125,6 +1160,14 @@ blocktrash_f(
> >  		} else
> >  			lentab[lentablen - 1].max = i;
> >  	}
> > +	if (!sopt)
> > +		dbprintf(_("blocktrash: seed %u\n"), seed);
> 
> does this extra output break any xfstests?
> 
> # grep -r blocktrash common/ tests/xfs
> # 
> 
> maybe not!

<shrug> I made the same observation.

--D

> 
> > +	srandom(seed);
> > +	if (this_block) {
> > +		blocktrash_b(offset, DBM_UNKNOWN, &lentab[random() % lentablen],
> > +				mode);
> > +		goto out;
> > +	}
> >  	for (blocks = 0, agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> >  		for (agbno = 0, p = dbmap[agno];
> >  		     agbno < mp->m_sb.sb_agblocks;
> > @@ -1137,9 +1180,6 @@ blocktrash_f(
> >  		dbprintf(_("blocktrash: no matching blocks\n"));
> >  		goto out;
> >  	}
> > -	if (!sopt)
> > -		dbprintf(_("blocktrash: seed %u\n"), seed);
> > -	srandom(seed);
> >  	for (i = 0; i < count; i++) {
> >  		randb = (xfs_rfsblock_t)((((__int64_t)random() << 32) |
> >  					 random()) % blocks);
> > @@ -1153,8 +1193,13 @@ blocktrash_f(
> >  					continue;
> >  				if (bi++ < randb)
> >  					continue;
> > -				blocktrash_b(agno, agbno, (dbm_t)*p,
> > +				push_cur();
> > +				set_cur(NULL,
> > +					XFS_AGB_TO_DADDR(mp, agno, agbno),
> > +					blkbb, DB_RING_IGN, NULL);
> > +				blocktrash_b(offset, (dbm_t)*p,
> >  					&lentab[random() % lentablen], mode);
> > +				pop_cur();
> >  				done = 1;
> >  				break;
> >  			}
> > diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> > index df54bb7..681efc4 100644
> > --- a/man/man8/xfs_db.8
> > +++ b/man/man8/xfs_db.8
> > @@ -232,7 +232,7 @@ enables verbose output. Messages will be printed for every block and
> >  inode processed.
> >  .RE
> >  .TP
> > -.BI "blocktrash [\-n " count "] [\-x " min "] [\-y " max "] [\-s " seed "] [\-0|1|2|3] [\-t " type "] ..."
> > +.BI "blocktrash [-z] [\-o " offset "] [\-n " count "] [\-x " min "] [\-y " max "] [\-s " seed "] [\-0|1|2|3] [\-t " type "] ..."
> >  Trash randomly selected filesystem metadata blocks.
> >  Trashing occurs to randomly selected bits in the chosen blocks.
> >  This command is available only in debugging versions of
> > @@ -259,6 +259,13 @@ supplies the
> >  .I count
> >  of block-trashings to perform (default 1).
> >  .TP
> > +.B \-o
> > +supplies the bit
> > +.I offset
> > +at which to start trashing the block.  If the value is preceded by a '+', the
> > +trashing will start at a randomly chosen offset that is larger than the value
> > +supplied.  The default is to randomly choose an offset anywhere in the block.
> > +.TP
> >  .B \-s
> >  supplies a
> >  .I seed
> > @@ -282,6 +289,12 @@ size of bit range to be trashed. The default value is 1.
> >  sets the
> >  .I maximum
> >  size of bit range to be trashed. The default value is 1024.
> > +.TP
> > +.B \-z
> > +trashes the block at the top of the stack.  It is not necessary to
> > +run
> > +.BI blockget
> > +if this option is supplied.
> >  .RE
> >  .TP
> >  .BI "blockuse [\-n] [\-c " count ]
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
