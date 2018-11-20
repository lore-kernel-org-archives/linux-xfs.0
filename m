Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40468 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbeKTMyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 07:54:50 -0500
Date: Mon, 19 Nov 2018 18:27:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] fsx: add clone range
Message-ID: <20181120022755.GA6783@magnolia>
References: <154215237717.21151.11976488103599724788.stgit@magnolia>
 <154215238338.21151.852724936803809717.stgit@magnolia>
 <20181116192626.GA9387@magnolia>
 <20181118135108.GE3889@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181118135108.GE3889@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Nov 18, 2018 at 09:51:08PM +0800, Eryu Guan wrote:
> On Fri, Nov 16, 2018 at 11:26:26AM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 13, 2018 at 03:39:43PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Add support for FICLONERANGE to fsx.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  ltp/fsx.c |  182 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
> > >  1 file changed, 158 insertions(+), 24 deletions(-)
> > > 
> > > 
> > > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > > index b0157ba3..2b0a2b28 100644
> > > --- a/ltp/fsx.c
> > > +++ b/ltp/fsx.c
> > > @@ -88,25 +88,28 @@ int			logcount = 0;	/* total ops */
> > >   * mode being run.
> > >   */
> > >  
> > > -/* common operations */
> > > -#define	OP_READ		0
> > > -#define OP_WRITE	1
> > > -#define OP_MAPREAD	2
> > > -#define OP_MAPWRITE	3
> > > -#define OP_MAX_LITE	4
> > > -
> > > -/* !lite operations */
> > > -#define OP_TRUNCATE		4
> > > -#define OP_FALLOCATE		5
> > > -#define OP_PUNCH_HOLE		6
> > > -#define OP_ZERO_RANGE		7
> > > -#define OP_COLLAPSE_RANGE	8
> > > -#define OP_INSERT_RANGE	9
> > > -#define OP_MAX_FULL		10
> > > -
> > > -/* integrity operations */
> > > -#define OP_FSYNC		10
> > > -#define OP_MAX_INTEGRITY	11
> > > +enum {
> > > +	/* common operations */
> > > +	OP_READ = 0,
> > > +	OP_WRITE,
> > > +	OP_MAPREAD,
> > > +	OP_MAPWRITE,
> > > +	OP_MAX_LITE,
> > > +
> > > +	/* !lite operations */
> > > +	OP_TRUNCATE = OP_MAX_LITE,
> > > +	OP_FALLOCATE,
> > > +	OP_PUNCH_HOLE,
> > > +	OP_ZERO_RANGE,
> > > +	OP_COLLAPSE_RANGE,
> > > +	OP_INSERT_RANGE,
> > > +	OP_CLONE_RANGE,
> > > +	OP_MAX_FULL,
> > > +
> > > +	/* integrity operations */
> > > +	OP_FSYNC = OP_MAX_FULL,
> > > +	OP_MAX_INTEGRITY,
> > > +};
> > >  
> > >  #undef PAGE_SIZE
> > >  #define PAGE_SIZE       getpagesize()
> > > @@ -160,6 +163,7 @@ int     punch_hole_calls = 1;           /* -H flag disables */
> > >  int     zero_range_calls = 1;           /* -z flag disables */
> > >  int	collapse_range_calls = 1;	/* -C flag disables */
> > >  int	insert_range_calls = 1;		/* -I flag disables */
> > > +int	remap_calls = 1;		/* -J flag disables */
> > >  int 	mapped_reads = 1;		/* -R flag disables it */
> > >  int	integrity = 0;			/* -i flag */
> > >  int	fsxgoodfd = 0;
> > > @@ -254,6 +258,7 @@ static const char *op_names[] = {
> > >  	[OP_ZERO_RANGE] = "zero_range",
> > >  	[OP_COLLAPSE_RANGE] = "collapse_range",
> > >  	[OP_INSERT_RANGE] = "insert_range",
> > > +	[OP_CLONE_RANGE] = "clone_range",
> > >  	[OP_FSYNC] = "fsync",
> > >  };
> > >  
> > > @@ -275,6 +280,25 @@ static int op_code(const char *name)
> > >  	return -1;
> > >  }
> > >  
> > > +void
> > > +log5(int operation, int arg0, int arg1, int arg2, enum opflags flags)
> > > +{
> > > +	struct log_entry *le;
> > > +
> > > +	le = &oplog[logptr];
> > > +	le->operation = operation;
> > > +	if (closeopen)
> > > +		flags |= FL_CLOSE_OPEN;
> > > +	le->args[0] = arg0;
> > > +	le->args[1] = arg1;
> > > +	le->args[2] = arg2;
> > 
> > I would like to withdraw this patch so that I can add a fourth args[]
> > slot so that we can maintain the convention of printing the
> > pre-operation file size after the other operation arguments.  This will
> > make tracking the location of EOF through an fsxops file easier.
> 
> I'll wait for the new version of the whole patchset then, that gives me
> extra time to look at & test them :)

I also added separate command line arguments to disable each of {clone,
dedupe, copy} range, and fixed the "does this overlap with the bad
range" reporting.  I also added a new mode where you can ask fsx to
reread the entire file after every operation to look for corruption
problems.  Will send patches shortly.

--D

> Thanks,
> Eryu
> 
> > 
> > --D
> > 
> > > +	le->flags = flags;
> > > +	logptr++;
> > > +	logcount++;
> > > +	if (logptr >= LOGSIZE)
> > > +		logptr = 0;
> > > +}
> > > +
> > >  void
> > >  log4(int operation, int arg0, int arg1, enum opflags flags)
> > >  {
> > > @@ -294,7 +318,6 @@ log4(int operation, int arg0, int arg1, enum opflags flags)
> > >  		logptr = 0;
> > >  }
> > >  
> > > -
> > >  void
> > >  logdump(void)
> > >  {
> > > @@ -418,6 +441,13 @@ logdump(void)
> > >  			if (overlap)
> > >  				prt("\t******IIII");
> > >  			break;
> > > +		case OP_CLONE_RANGE:
> > > +			prt("CLONE 0x%x thru 0x%x\t(0x%x bytes) to 0x%x",
> > > +			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> > > +			    lp->args[1], lp->args[2]);
> > > +			if (overlap)
> > > +				prt("\t******IIII");
> > > +			break;
> > >  		case OP_FSYNC:
> > >  			prt("FSYNC");
> > >  			break;
> > > @@ -1218,6 +1248,73 @@ do_insert_range(unsigned offset, unsigned length)
> > >  }
> > >  #endif
> > >  
> > > +#ifdef FICLONERANGE
> > > +void
> > > +do_clone_range(unsigned offset, unsigned length, unsigned dest)
> > > +{
> > > +	struct file_clone_range	fcr;
> > > +
> > > +	if (length == 0) {
> > > +		if (!quiet && testcalls > simulatedopcount)
> > > +			prt("skipping zero length clone range\n");
> > > +		log5(OP_CLONE_RANGE, offset, length, dest, FL_SKIPPED);
> > > +		return;
> > > +	}
> > > +
> > > +	if ((loff_t)offset >= file_size) {
> > > +		if (!quiet && testcalls > simulatedopcount)
> > > +			prt("skipping clone range behind EOF\n");
> > > +		log5(OP_CLONE_RANGE, offset, length, dest, FL_SKIPPED);
> > > +		return;
> > > +	}
> > > +
> > > +	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
> > > +
> > > +	if (testcalls <= simulatedopcount)
> > > +		return;
> > > +
> > > +	if ((progressinterval && testcalls % progressinterval == 0) ||
> > > +	    (debug && (monitorstart == -1 || monitorend == -1 ||
> > > +		       dest <= monitorstart || dest + length <= monitorend))) {
> > > +		prt("%lu clone\tfrom 0x%x to 0x%x, (0x%x bytes) at 0x%x\n",
> > > +			testcalls, offset, offset+length, length, dest);
> > > +	}
> > > +
> > > +	fcr.src_fd = fd;
> > > +	fcr.src_offset = offset;
> > > +	fcr.src_length = length;
> > > +	fcr.dest_offset = dest;
> > > +
> > > +	if (ioctl(fd, FICLONERANGE, &fcr) == -1) {
> > > +		if (errno == EOPNOTSUPP || errno == ENOTTY) {
> > > +			if (!quiet && testcalls > simulatedopcount)
> > > +				prt("skipping unsupported clone range\n");
> > > +			logptr--;
> > > +			log5(OP_CLONE_RANGE, offset, length, dest, FL_SKIPPED);
> > > +			return;
> > > +		}
> > > +
> > > +		prt("clone range: 0x%x to 0x%x at 0x%x\n", offset,
> > > +				offset + length, dest);
> > > +		prterr("do_clone_range: FICLONERANGE");
> > > +		report_failure(161);
> > > +	}
> > > +
> > > +	memcpy(good_buf + dest, good_buf + offset, length);
> > > +	if (dest > file_size)
> > > +		memset(good_buf + file_size, '\0', dest - file_size);
> > > +	if (dest + length > file_size)
> > > +		file_size = dest + length;
> > > +}
> > > +
> > > +#else
> > > +void
> > > +do_clone_range(unsigned offset, unsigned length, unsigned dest)
> > > +{
> > > +	return;
> > > +}
> > > +#endif
> > > +
> > >  #ifdef HAVE_LINUX_FALLOC_H
> > >  /* fallocate is basically a no-op unless extending, then a lot like a truncate */
> > >  void
> > > @@ -1374,6 +1471,7 @@ cleanup(int sig)
> > >  static int
> > >  read_op(struct log_entry *log_entry)
> > >  {
> > > +	char *end;
> > >  	char line[256];
> > >  
> > >  	memset(log_entry, 0, sizeof(*log_entry));
> > > @@ -1404,8 +1502,6 @@ read_op(struct log_entry *log_entry)
> > >  		if (log_entry->operation == -1)
> > >  			goto fail;
> > >  		for (i = 0; i < 3; i++) {
> > > -			char *end;
> > > -
> > >  			str = strtok(NULL, " \t\n");
> > >  			if (!str)
> > >  				goto fail;
> > > @@ -1438,7 +1534,7 @@ read_op(struct log_entry *log_entry)
> > >  int
> > >  test(void)
> > >  {
> > > -	unsigned long	offset;
> > > +	unsigned long	offset, offset2;
> > >  	unsigned long	size;
> > >  	unsigned long	rv;
> > >  	unsigned long	op;
> > > @@ -1469,6 +1565,7 @@ test(void)
> > >  			op = log_entry.operation;
> > >  			offset = log_entry.args[0];
> > >  			size = log_entry.args[1];
> > > +			offset2 = log_entry.args[2];
> > >  			closeopen = !!(log_entry.flags & FL_CLOSE_OPEN);
> > >  			keep_size = !!(log_entry.flags & FL_KEEP_SIZE);
> > >  			goto have_op;
> > > @@ -1481,6 +1578,7 @@ test(void)
> > >  		closeopen = (rv >> 3) < (1 << 28) / closeprob;
> > >  
> > >  	offset = random();
> > > +	offset2 = 0;
> > >  	size = maxoplen;
> > >  	if (randomoplen)
> > >  		size = random() % (maxoplen + 1);
> > > @@ -1506,6 +1604,17 @@ test(void)
> > >  		if (zero_range_calls && size && keep_size_calls)
> > >  			keep_size = random() % 2;
> > >  		break;
> > > +	case OP_CLONE_RANGE:
> > > +		TRIM_OFF_LEN(offset, size, file_size);
> > > +		offset = offset & ~(block_size - 1);
> > > +		size = size & ~(block_size - 1);
> > > +		do {
> > > +			offset2 = random();
> > > +			TRIM_OFF(offset2, maxfilelen);
> > > +			offset2 = offset2 & ~(block_size - 1);
> > > +		} while (llabs(offset2 - offset) < size ||
> > > +			 offset2 + size > maxfilelen);
> > > +		break;
> > >  	}
> > >  
> > >  have_op:
> > > @@ -1549,6 +1658,12 @@ test(void)
> > >  			goto out;
> > >  		}
> > >  		break;
> > > +	case OP_CLONE_RANGE:
> > > +		if (!remap_calls) {
> > > +			log5(op, offset, size, offset2, FL_SKIPPED);
> > > +			goto out;
> > > +		}
> > > +		break;
> > >  	}
> > >  
> > >  	switch (op) {
> > > @@ -1615,6 +1730,18 @@ test(void)
> > >  
> > >  		do_insert_range(offset, size);
> > >  		break;
> > > +	case OP_CLONE_RANGE:
> > > +		if (size == 0) {
> > > +			log5(OP_CLONE_RANGE, offset, size, offset2, FL_SKIPPED);
> > > +			goto out;
> > > +		}
> > > +		if (offset2 + size > maxfilelen) {
> > > +			log5(OP_CLONE_RANGE, offset, size, offset2, FL_SKIPPED);
> > > +			goto out;
> > > +		}
> > > +
> > > +		do_clone_range(offset, size, offset2);
> > > +		break;
> > >  	case OP_FSYNC:
> > >  		dofsync();
> > >  		break;
> > > @@ -1637,7 +1764,7 @@ void
> > >  usage(void)
> > >  {
> > >  	fprintf(stdout, "usage: %s",
> > > -		"fsx [-dknqxAFLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
> > > +		"fsx [-dknqxAFJLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
> > >  	-b opnum: beginning operation number (default 1)\n\
> > >  	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
> > >  	-d: debug output for all operations\n\
> > > @@ -1678,6 +1805,10 @@ usage(void)
> > >  #ifdef FALLOC_FL_INSERT_RANGE
> > >  "	-I: Do not use insert range calls\n"
> > >  #endif
> > > +#if defined(FICLONERANGE) || defined(FIDEDUPERANGE) || \
> > > +    defined(HAVE_COPY_FILE_RANGE)
> > > +"	-J: Do not use clone/dedupe/copy range calls\n"
> > > +#endif
> > >  "	-L: fsxLite - no file creations & no file size changes\n\
> > >  	-N numops: total # operations to do (default infinity)\n\
> > >  	-O: use oplen (see -o flag) for every op (default random)\n\
> > > @@ -2010,6 +2141,9 @@ main(int argc, char **argv)
> > >  		case 'I':
> > >  			insert_range_calls = 0;
> > >  			break;
> > > +		case 'J':
> > > +			remap_calls = 0;
> > > +			break;
> > >  		case 'L':
> > >  		        lite = 1;
> > >  			o_flags &= ~(O_CREAT|O_TRUNC);
> > > 
