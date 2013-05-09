Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B417429DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 02:30:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A8F730404E
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 00:30:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KirNd7aCkSQNN1Dn for
	<xfs@oss.sgi.com>; Thu, 09 May 2013 00:30:01 -0700 (PDT)
Date: Thu, 9 May 2013 09:29:55 +0200
From: Karel Zak <kzak@redhat.com>
Subject: Re: Mount probing not silent. Internal error xfs_sb_read_verify at
	line 726
Message-ID: <20130509072955.GA17527@x2.net.home>
References: <5187E290.8090109@sandeen.net> <20130506183020.GA513@x4>
	<51880121.8000001@sandeen.net> <20130506192629.GA503@x4>
	<5188074F.2090500@sandeen.net> <20130506195521.GB503@x4>
	<51881750.3090309@sandeen.net> <51882537.6070904@sandeen.net>
	<20130507002314.GM19978@dastard> <20130507052430.GA508@x4>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130507052430.GA508@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, util-linux@vger.kernel.org, xfs@oss.sgi.com

On Tue, May 07, 2013 at 07:24:30AM +0200, Markus Trippelsdorf wrote:
> On 2013.05.07 at 10:23 +1000, Dave Chinner wrote:
> > On Mon, May 06, 2013 at 04:48:39PM -0500, Eric Sandeen wrote:
> > I think that mount needs fixing, not XFS. mount needs to be doing
> > silent mounts when doing this brute forcing, not noisy, explicit
> > mounts that we expect to throw errors if there is a problem.

 Good idea. Fixed.

> > BTW, strace indicates that MS_SILENT is not being used during brute
> > force mounts:
> > 
> > # strace -vx mount /dev/vdb /mnt/scratch/ 2>&1 |grep ^mount
> > mount("/dev/vdb", "/mnt/scratch/", "reiserfs", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> > mount("/dev/vdb", "/mnt/scratch/", "ext3", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> > mount("/dev/vdb", "/mnt/scratch/", "ext2", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> > mount("/dev/vdb", "/mnt/scratch/", "ext4", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> > ....
> > 
> > So this really looks like a bug in mount, not the filesystem handling
> > of slient mounts...
> 
> So, lets CC util-linux...

 Thanks.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
