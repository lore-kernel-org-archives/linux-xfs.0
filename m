Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4J1gfDC008796 for <xfs@oss.sgi.com>; Wed, 18 May 2011 20:42:49 -0500
Received: from ZenIV.linux.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4F10CE4E83
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 18:42:40 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id TUSfq7UOqCIGCSG1 for
	<xfs@oss.sgi.com>; Wed, 18 May 2011 18:42:40 -0700 (PDT)
Date: Wed, 18 May 2011 18:41:51 -0700
From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch
	Hole Test Routines
Message-ID: <20110519014149.GA11278@noexit.corp.google.com>
References: <4DD43300.6010908@linux.vnet.ibm.com>
	<20110519013144.GF32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110519013144.GF32466@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>, Allison Henderson <achender@linux.vnet.ibm.com>

On Thu, May 19, 2011 at 11:31:44AM +1000, Dave Chinner wrote:
> > +#
> > +# This test is successful when the following conditions are met:
> > +#  - ls shows that the number of blocks occupied by the file
> > +#    has decreased by the number of blocks punched out.
> 
> There's no guarantee that a filesystem will punch the number of
> blocks you expect.

	Cluster allocated filesystems like ocfs2 are certainly going to
punch some multiple of clusters, not exact blocks.  Eg if the hole is
punched in the middle of a cluster.

Joel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

			http://www.jlbec.org/
			jlbec@evilplan.org

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
