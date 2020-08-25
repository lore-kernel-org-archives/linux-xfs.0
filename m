Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04B9C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 00:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71F952074D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 00:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IAKt72yL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHYAkB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 20:40:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYAkA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 20:40:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07P0a2tD168933;
        Tue, 25 Aug 2020 00:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0EUSFg2llWZjClj6oBxOKJIAMD8HhcKJkh7uLcUiswo=;
 b=IAKt72yLj2/1b1xTfPOyIwbkiexo/lroNdNY+u39S3xzYAKdBzxmSo2XXPUMdsZF1P7D
 VYI2oeIDAwiqzwB8I4TfP4lw7ju3aiAEq5RqYHwSzCBSsJv/ec8Zob4SiEA3a4+SW8nJ
 yV1l/QqoxgsdCcMe9WIG5J99KOxm6Hll4pzBcxr7HvsLm/gYcWyQeZzFRtrnxJPY2ZyV
 fF27Lte2QPN2I//92b0/4NH6XlT+mTNyiufAasPPSUBHcLIgLp91TrixqeHMx04Rmwo+
 5lxkLzC15V87HCh1WJz7WFQvFhUXp1Nogq1bTAYkAXxXeY2GdRb4UzxVzLia0aHorCWh 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 333cshymhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 00:39:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07P0aZHW005514;
        Tue, 25 Aug 2020 00:39:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 333rtx5x1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 00:39:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07P0dkFN010805;
        Tue, 25 Aug 2020 00:39:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Aug 2020 17:39:46 -0700
Date:   Mon, 24 Aug 2020 17:39:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200825003945.GA6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797594159.965217.2504039364311840477.stgit@magnolia>
 <20200822073319.GH1629@infradead.org>
 <20200824024341.GT6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824024341.GT6096@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=1 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 23, 2020 at 07:43:41PM -0700, Darrick J. Wong wrote:
> On Sat, Aug 22, 2020 at 08:33:19AM +0100, Christoph Hellwig wrote:
> > >   * in the AGI header so that we can skip the finobt walk at mount time when
> > > @@ -855,12 +862,18 @@ struct xfs_agfl {
> > >   *
> > >   * Inode timestamps consist of signed 32-bit counters for seconds and
> > >   * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
> > > + *
> > > + * When bigtime is enabled, timestamps become an unsigned 64-bit nanoseconds
> > > + * counter.  Time zero is the start of the classic timestamp range.
> > >   */
> > >  union xfs_timestamp {
> > >  	struct {
> > >  		__be32		t_sec;		/* timestamp seconds */
> > >  		__be32		t_nsec;		/* timestamp nanoseconds */
> > >  	};
> > > +
> > > +	/* Nanoseconds since the bigtime epoch. */
> > > +	__be64			t_bigtime;
> > >  };
> > 
> > So do we really need the union here?  What about:
> > 
> >  (1) keep the typedef instead of removing it
> >  (2) switch the typedef to be just a __be64, and use trivial helpers
> >      to extract the two separate legacy sec/nsec field
> >  (3) PROFIT!!!
> 
> Been there, done that.  Dave suggested some replacement code (which
> corrupted the values), then I modified that into a correct version,
> which then made smatch angry because it doesn't like code that does bit
> shifts on __be64 values.

Backing up here, I've realized that my own analysis of Dave's pseudocode
was incorrect.

On a little endian machine, we'll start with the following.  A is the
LSB of seconds; D is the MSB of seconds; E is the LSB of nsec, and H is
the MSB of nsec.

  sec  nsec (incore)
  l  m l  m
  ABCD EFGH

Now we encode that with an old kernel, which calls cpu_to_be32 to turn
that into:

  sec  nsec (ondisk)
  m  l m  l
  DCBA HGFE

Move over to a new kernel, and that becomes:

  tstamp (ondisk)
  m      l
  DCBAHGFE

Next we decode with be64_to_cpu:

  tstamp (incore)
  l      m
  EFGHABCD

Now we extract nsec from (tstamp & -1U) and sec from (tstamp >> 32):

  sec  nsec
  l  m l  m
  ABCD EFGH

So yes, masking and shifting /after/ the endian conversion works just
fine and doesn't throw any sparse/smatch errors.

Now on a big endian machine:

  sec  nsec (incore)
  m  l m  l
  DCBA HGFE

Now we encode that with an old kernel, which calls cpu_to_be32 (a nop)
to turn that into:

  sec  nsec (ondisk)
  m  l m  l
  DCBA HGFE

Move over to a new kernel, and that becomes:

  tstamp (ondisk)
  m      l
  DCBAHGFE

Next we decode with be64_to_cpu (a nop):

  tstamp (incore)
  m      l
  DCBAHGFE

Now we extract nsec from (tstamp & -1U) and sec from (tstamp >> 32):

  sec  nsec
  m  l m  l
  DCBA HGFE

Works fine here too.

Now the /truly/ nasty case here is xfs_ictimestamp, since we log the
inode core in host endian format.  If we start with this the vfs
timestamp on a new kernel:

  sec  nsec (incore)
  l  m l  m
  ABCD EFGH

We need to encode that as:

  tstamp (ondisk)
  l      m
  ABCDEFGH

The only way to do this is: (nsec << 32) | (sec & -1U).  That makes the
log timestamp encoding is the opposite of what we do for the ondisk
inodes, because log formats don't use cpu_to_be64.

At least for a big endian machine, log timestamp coding is easy:

  sec  nsec (incore)
  m  l m  l
  DCBA HGFE

We need to encode that as:

  tstamp (ondisk)
  m      l
  DCBAHGFE

And the only way to get there is (sec << 32) | (nsec & -1U), which is
what the ondisk inode timestamp coding does.

I still think this is grody, but at least now now I have a new fstest to
make sure that log recovery doesn't trip over this.  So, you were
technically right and I was wrong.  We'll see how you like the new
stuff. ;)

--D

> > > +/* Convert an ondisk timestamp into the 64-bit safe incore format. */
> > >  void
> > >  xfs_inode_from_disk_timestamp(
> > > +	struct xfs_dinode		*dip,
> > >  	struct timespec64		*tv,
> > >  	const union xfs_timestamp	*ts)
> > 
> > I think passing ts by value might lead to somewhat better code
> > generation on modern ABIs (and older ABIs just fall back to pass
> > by reference transparently).
> 
> Hm, ok.  I did not know that. :)
> 
> > >  {
> > > +	if (dip->di_version >= 3 &&
> > > +	    (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) {
> > 
> > Do we want a helper for this condition?
> 
> Yes, yes we do.  Will add.
> 
> > > +		uint64_t		t = be64_to_cpu(ts->t_bigtime);
> > > +		uint64_t		s;
> > > +		uint32_t		n;
> > > +
> > > +		s = div_u64_rem(t, NSEC_PER_SEC, &n);
> > > +		tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
> > > +		tv->tv_nsec = n;
> > > +		return;
> > > +	}
> > > +
> > >  	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
> > >  	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
> > 
> > Nit: for these kinds of symmetric conditions and if/else feels a little
> > more natural.
> > 
> > > +		xfs_log_dinode_to_disk_ts(from, &to->di_crtime, &from->di_crtime);
> > 
> > This adds a > 80 char line.
> 
> Do we care now that checkpatch has been changed to allow up to 100
> columns?
> 
> > > +	if (from->di_flags2 & XFS_DIFLAG2_BIGTIME) {
> > > +		uint64_t		t;
> > > +
> > > +		t = (uint64_t)(ts->tv_sec + XFS_INO_BIGTIME_EPOCH);
> > > +		t *= NSEC_PER_SEC;
> > > +		its->t_bigtime = t + ts->tv_nsec;
> > 
> > This calculation is dupliated in two places, might be worth
> > adding a little helper (which will need to get the sec/nsec values
> > passed separately due to the different structures).
> > 
> > > +		xfs_inode_to_log_dinode_ts(from, &to->di_crtime, &from->di_crtime);
> > 
> > Another line over 8 characters here.
> > 
> > > +	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
> > > +		sb->s_time_min = XFS_INO_BIGTIME_MIN;
> > > +		sb->s_time_max = XFS_INO_BIGTIME_MAX;
> > > +	} else {
> > > +		sb->s_time_min = XFS_INO_TIME_MIN;
> > > +		sb->s_time_max = XFS_INO_TIME_MAX;
> > > +	}
> > 
> > This is really a comment on the earlier patch, but maybe we should
> > name the old constants with "OLD" or "LEGACY" or "SMALL" in the name?
> 
> Yes, good suggestion!
> 
> > > @@ -1494,6 +1499,10 @@ xfs_fc_fill_super(
> > >  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
> > >  		sb->s_flags |= SB_I_VERSION;
> > >  
> > > +	if (xfs_sb_version_hasbigtime(&mp->m_sb))
> > > +		xfs_warn(mp,
> > > + "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
> > > +
> > 
> > Is there any good reason to mark this experimental?
> 
> As you and Dave have both pointed out, there are plenty of stupid bugs
> still in this.  I think I'd like to have at least one EXPERIMENTAL cycle
> to make sure I didn't commit anything pathologically stupid in here.
> 
> <cough> ext4 34-bit sign extension bug <cough>.
> 
> --D
