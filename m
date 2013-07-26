Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A070C29E1D
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 11:26:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6A2168F8035
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 09:26:03 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id xSp5KBBhgThLxKsu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 09:26:02 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id F015E7C069D
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 10:26:01 -0600 (MDT)
Date: Fri, 26 Jul 2013 12:25:58 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests: exit out if _scratch_mount fails
Message-ID: <20130726162558.GB24583@localhost.localdomain>
References: <1373396847-7975-1-git-send-email-jbacik@fusionio.com>
	<20130726161235.GK3111@sgi.com> <51F2A091.3010407@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F2A091.3010407@sandeen.net>
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
Cc: linxu-btrfs@vger.kernel.org, Ben Myers <bpm@sgi.com>, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Fri, Jul 26, 2013 at 11:15:13AM -0500, Eric Sandeen wrote:
> On 7/26/13 11:12 AM, Ben Myers wrote:
> > Hey Josef,
> > 
> > On Tue, Jul 09, 2013 at 03:07:27PM -0400, Josef Bacik wrote:
> >> I test some of the different mkfs options for btrfs, one set doesn't work
> >> properly with small file systems, so the fs won't mount.  This is fine from a
> >> btrfs point of view, but tests that fail to mount the scratch fs will run
> >> anyway, so if it's a "fill the fs" sort of test this will wreak havoc.  To fix
> >> this just error out of _scratch_mount fails.  Thanks,
> >>
> >> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > 
> > I noticed that this change causes dmapi tests to try to be run on systems that
> > don't have dmapi supported, and they fail.  Have you seen this?
> > 
> > Thanks,
> > 	Ben
> 
> I haven't tested either way, but does:
> 
>      _mount -t $FSTYP `_scratch_mount_options $*` || _fail "Scratch mount failed"
> 
> work any better?

Well thats cleaner but I'm not sure why this patch is making that happen.  I
don't have dmapi on my main box (at least afaik) and I've not had that sort of
issue running with this patch.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
