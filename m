Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E355E7CA1
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 03:14:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B2CC2304032
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 01:14:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zdhdgYtymygoyB6k (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Aug 2016 01:14:23 -0700 (PDT)
Date: Fri, 5 Aug 2016 16:14:21 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic: test accurate shared extent reporting
Message-ID: <20160805081421.GX27776@eguan.usersys.redhat.com>
References: <20160805072147.GG25565@birch.djwong.org>
	<20160805074607.GW27776@eguan.usersys.redhat.com>
	<20160805080212.GH25565@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160805080212.GH25565@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mfasheh@suse.de, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, dedekind1@gmail.com

On Fri, Aug 05, 2016 at 01:02:12AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 05, 2016 at 03:46:07PM +0800, Eryu Guan wrote:
> > On Fri, Aug 05, 2016 at 12:21:47AM -0700, Darrick J. Wong wrote:

> > > +_count_holes $testdir/file2
> > > +echo "file1 shared extents"
> > > +$XFS_IO_PROG -c 'fiemap -v' $testdir/file1 | awk '{print $5}' | grep '0x.*[2367aAbBfF]...$' -c
> > 
> > Missing a command at the end?
> 
> Nope, it echoes the number of shared extents (that's what that awk and grep
> globule does), which /should/ be exactly 2.
> 
> (Unless I'm missing something?)

Ah, thanks! I saw "-c" at the end and thought it was part of xfs_io
command without looking at it carefully.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
