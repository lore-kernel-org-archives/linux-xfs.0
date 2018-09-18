Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729586AbeIRP55 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 11:57:57 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8IAJDaE027263
        for <linux-xfs@vger.kernel.org>; Tue, 18 Sep 2018 06:26:00 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mjxx6stu1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Sep 2018 06:26:00 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 18 Sep 2018 11:25:58 +0100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 01/19] Fix xfs/009 to work with 64k block size
Date: Tue, 18 Sep 2018 11:32:12 +0530
In-Reply-To: <20180917225925.GE4635@magnolia>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com> <20180912062626.14349-2-chandan@linux.vnet.ibm.com> <20180917225925.GE4635@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <5182088.PSLVip6Wn9@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org

On Tuesday, September 18, 2018 4:29:25 AM IST Darrick J. Wong wrote:
> On Wed, Sep 12, 2018 at 11:56:08AM +0530, Chandan Rajendra wrote:
> > xfs_alloc_file_space() rounds up allocation requests by the filesystem
> > block size. Hence this commit changes the test to work with block size
> > units rather than with a multiple of 4096 bytes.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> >  tests/xfs/009     | 92 ++++++++++++++++++++++++++++++++++++++++++++++---------
> >  tests/xfs/009.out | 66 +++++++++++++++++++--------------------
> >  2 files changed, 110 insertions(+), 48 deletions(-)
> > 
> > diff --git a/tests/xfs/009 b/tests/xfs/009
> > index 68f6379..70717eb 100755
> > --- a/tests/xfs/009
> > +++ b/tests/xfs/009
> > @@ -14,9 +14,6 @@ here=`pwd`
> >  tmp=/tmp/$$
> >  status=1	# failure is the default!
> >  trap "_cleanup; exit \$status" 0 1 2 3 15
> > -# This isn't really related to fs block size, it's just what
> > -# alloc uses for the "block" unit in it's input parameters...
> > -bsize=4096
> >  
> >  _cleanup()
> >  {
> > @@ -24,13 +21,6 @@ _cleanup()
> >      _scratch_unmount
> >  }
> >  
> > -_block_filter()
> > -{
> > -   sed \
> > -	-e 's/[0-9][0-9]*\.\.[0-9][0-9]*/BLOCKRANGE/g' \
> > -	-e "s/blocksize $bsize/blocksize BSIZE/g"
> > -}
> > -
> >  _init()
> >  {
> >      echo "*** mkfs"
> > @@ -49,11 +39,6 @@ _init()
> >      fi
> >  }
> >  
> > -_filesize()
> > -{
> > -    ls -l $1 | $AWK_PROG '{print "filesize = " $5}'
> > -}
> > -
> >  # get standard environment, filters and checks
> >  . ./common/rc
> >  . ./common/filter
> > @@ -64,9 +49,86 @@ _supported_os Linux
> >  
> >  _require_scratch
> >  
> > +_filesize()
> > +{
> > +    ls -l $1 | $AWK_PROG -v bsize="$bsize" '{print "filesize = " $5 / bsize}'
> > +}
> > +
> > +_block_filter()
> > +{
> > +	$AWK_PROG -v bsize="$bsize" '
> > +	/blocksize/ {
> > +		printf("    blocksize BSIZE\n")
> > +
> > +		next
> > +	}
> > +
> > +	/CMD/ {
> > +		split($3, off, "=")
> > +		offset = strtonum(off[2])
> > +		if (offset != -1)
> > +			offset = offset / bsize
> > +
> > +		split($4, len, "=")
> > +		nr_blocks = strtonum(len[2])
> > +		if (nr_blocks != -1)
> > +			nr_blocks = nr_blocks / bsize
> > +
> > +		printf("    %s %s off=%s, len=%d\n", $1, $2, offset, nr_blocks)
> > +
> > +		next
> > +	}
> > +
> > +	/MAP/ {
> > +		split($2, off, "=")
> > +		offset = strtonum(off[2])
> > +		if (offset != -1)
> > +			offset = offset / bsize
> > +
> > +		split($3, len, "=")
> > +
> > +		nr_blocks = strtonum(len[2])
> > +
> > +		if (nr_blocks != -1)
> > +			nr_blocks = nr_blocks / bsize
> > +
> > +		printf("    %s off=%s, len=%d %s\n", $1, offset, nr_blocks, $4)
> > +
> > +		next
> > +	}
> > +
> > +	/TRUNCATE/ {
> > +		split($2, off, "=")
> > +		offset = strtonum(off[2]) / bsize
> > +
> > +		printf("    %s off=%s\n", $1, offset)
> > +
> > +		next
> > +	}
> > +
> > +	/\[[0-9]+,[0-9]+\]:/ {
> > +		printf("        %s BLOCKRANGE\n", $1)
> > +
> > +		next
> > +	}
> > +
> > +	{
> > +		print
> > +
> > +		next
> > +	}
> > +	'
> > +}
> > +
> >  _init
> >  out=$SCRATCH_MNT/$$.tmp
> >  
> > +# This isn't really related to fs block size, it's just what
> > +# alloc uses for the "block" unit in it's input parameters...
> > +# However, xfs_alloc_file_space() rounds up allocation
> > +# request by the filesystem's block size.
> > +bsize=$(_get_block_size $SCRATCH_MNT)
> 
> [Sorry for the extremely long delay, I've been on leave...]
> 
> Hm.  Certain filesystems draw a distinction between the fundamental
> block size and the minimum file block mapping size.  ocfs2 supports
> having a file cluster size (mkfs.ocfs2 -C) that is greater than the fs
> block size, and (I think) xfs can achieve something similar for files on
> a realtime device via the mkfs.xfs -r extsize= option.
> 
> If you're dealing with writing things into a file for a test, I think
> you have to use _get_file_block_size to make sure that you don't fall
> afoul of the cluster/block difference.  I don't know if you've checked
> that for this patch series...?

Thanks for pointing that out. I didn't know about the existance of 
_get_file_block_size. I will go through the patchset once again
and figure out which one of _get_block_size v/s _get_file_block_size to use?

-- 
chandan
