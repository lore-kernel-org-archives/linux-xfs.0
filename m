Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 232497F78
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 01:37:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 027C88F8052
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 23:37:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EI0YKONloj2Tg16o for <xfs@oss.sgi.com>;
	Tue, 02 Jul 2013 23:37:50 -0700 (PDT)
Date: Wed, 3 Jul 2013 16:37:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests: btrfs/316: cross-subvolume sparse copy
Message-ID: <20130703063724.GK14996@dastard>
References: <51D29D17.3050000@oracle.com> <20130702101539.GC14996@dastard>
	<51D2E33B.1080402@oracle.com>
	<6B93E4A6-D1C9-4170-8E1C-B94D24F601BB@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6B93E4A6-D1C9-4170-8E1C-B94D24F601BB@redhat.com>
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
To: Eric Sandeen <esandeen@redhat.com>
Cc: Koen De Wit <koen.de.wit@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

On Tue, Jul 02, 2013 at 11:51:21AM -0400, Eric Sandeen wrote:
> On Jul 2, 2013, at 10:28 AM, Koen De Wit <koen.de.wit@oracle.com>
> wrote:
> 
> > Dave,
> > 
> > Thanks for the review. I will clean up the commit message and do
> > a full mail-to-myself-and-test-patch round trip to avoid errors
> > like the wrong test numbers in the golden output. I'm sorry for
> > this.
> > 
> > About cutting out file names from the output. I did this in the
> > first version of the patch:
> > 
> >       md5sum $TESTDIR1/$F | $AWK_PROG 'END {print $1}'
> > 
> > but Eric Sandeen suggested to include them in order to provide
> > more context in the output. (See
> > http://oss.sgi.com/archives/xfs/2013-03/msg00231.html and
> > http://oss.sgi.com/archives/xfs/2013-03/msg00220.html) That
> > sounds like a good idea to me, it makes debugging failures
> > easier. Whose opinion should I follow?
> > 
> Heh sorry.  IMHO maybe a middle ground; not bare md5sum but show
> only the base name?  In the end up to you; it seems Dave and I
> have different opinions on this.  :)

I was just going by current xfstests convention. i.e, in common/rc:

# Prints the md5 checksum of a given file
_md5_checksum()
{
        md5sum $1 | cut -d ' ' -f1
}

Which is used by all the hole punch tests and generic/311.

Make of that what you will, but I'd prefer to see consistency of
implementation across tests... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
