Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbeIRUJc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 16:09:32 -0400
Date: Tue, 18 Sep 2018 07:36:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V3 01/19] Fix xfs/009 to work with 64k block size
Message-ID: <20180918143629.GE20086@magnolia>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
 <20180912062626.14349-2-chandan@linux.vnet.ibm.com>
 <20180917225925.GE4635@magnolia>
 <5182088.PSLVip6Wn9@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182088.PSLVip6Wn9@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org

On Tue, Sep 18, 2018 at 11:32:12AM +0530, Chandan Rajendra wrote:
> On Tuesday, September 18, 2018 4:29:25 AM IST Darrick J. Wong wrote:
> > On Wed, Sep 12, 2018 at 11:56:08AM +0530, Chandan Rajendra wrote:
> > > xfs_alloc_file_space() rounds up allocation requests by the filesystem
> > > block size. Hence this commit changes the test to work with block size
> > > units rather than with a multiple of 4096 bytes.
> > > 
> > > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > > ---
> > >  tests/xfs/009     | 92 ++++++++++++++++++++++++++++++++++++++++++++++---------
> > >  tests/xfs/009.out | 66 +++++++++++++++++++--------------------
> > >  2 files changed, 110 insertions(+), 48 deletions(-)
> > > 
> > > diff --git a/tests/xfs/009 b/tests/xfs/009
> > > index 68f6379..70717eb 100755
> > > --- a/tests/xfs/009
> > > +++ b/tests/xfs/009
> > > @@ -14,9 +14,6 @@ here=`pwd`
> > >  tmp=/tmp/$$
> > >  status=1	# failure is the default!
> > >  trap "_cleanup; exit \$status" 0 1 2 3 15
> > > -# This isn't really related to fs block size, it's just what
> > > -# alloc uses for the "block" unit in it's input parameters...
> > > -bsize=4096
> > >  
> > >  _cleanup()
> > >  {
> > > @@ -24,13 +21,6 @@ _cleanup()
> > >      _scratch_unmount
> > >  }
> > >  
> > > -_block_filter()
> > > -{
> > > -   sed \
> > > -	-e 's/[0-9][0-9]*\.\.[0-9][0-9]*/BLOCKRANGE/g' \
> > > -	-e "s/blocksize $bsize/blocksize BSIZE/g"
> > > -}
> > > -
> > >  _init()
> > >  {
> > >      echo "*** mkfs"
> > > @@ -49,11 +39,6 @@ _init()
> > >      fi
> > >  }
> > >  
> > > -_filesize()
> > > -{
> > > -    ls -l $1 | $AWK_PROG '{print "filesize = " $5}'
> > > -}
> > > -
> > >  # get standard environment, filters and checks
> > >  . ./common/rc
> > >  . ./common/filter
> > > @@ -64,9 +49,86 @@ _supported_os Linux
> > >  
> > >  _require_scratch
> > >  
> > > +_filesize()
> > > +{
> > > +    ls -l $1 | $AWK_PROG -v bsize="$bsize" '{print "filesize = " $5 / bsize}'
> > > +}
> > > +
> > > +_block_filter()
> > > +{
> > > +	$AWK_PROG -v bsize="$bsize" '
> > > +	/blocksize/ {
> > > +		printf("    blocksize BSIZE\n")
> > > +
> > > +		next
> > > +	}
> > > +
> > > +	/CMD/ {
> > > +		split($3, off, "=")
> > > +		offset = strtonum(off[2])
> > > +		if (offset != -1)
> > > +			offset = offset / bsize
> > > +
> > > +		split($4, len, "=")
> > > +		nr_blocks = strtonum(len[2])
> > > +		if (nr_blocks != -1)
> > > +			nr_blocks = nr_blocks / bsize
> > > +
> > > +		printf("    %s %s off=%s, len=%d\n", $1, $2, offset, nr_blocks)
> > > +
> > > +		next
> > > +	}
> > > +
> > > +	/MAP/ {
> > > +		split($2, off, "=")
> > > +		offset = strtonum(off[2])
> > > +		if (offset != -1)
> > > +			offset = offset / bsize
> > > +
> > > +		split($3, len, "=")
> > > +
> > > +		nr_blocks = strtonum(len[2])
> > > +
> > > +		if (nr_blocks != -1)
> > > +			nr_blocks = nr_blocks / bsize
> > > +
> > > +		printf("    %s off=%s, len=%d %s\n", $1, offset, nr_blocks, $4)
> > > +
> > > +		next
> > > +	}
> > > +
> > > +	/TRUNCATE/ {
> > > +		split($2, off, "=")
> > > +		offset = strtonum(off[2]) / bsize
> > > +
> > > +		printf("    %s off=%s\n", $1, offset)
> > > +
> > > +		next
> > > +	}
> > > +
> > > +	/\[[0-9]+,[0-9]+\]:/ {
> > > +		printf("        %s BLOCKRANGE\n", $1)
> > > +
> > > +		next
> > > +	}
> > > +
> > > +	{
> > > +		print
> > > +
> > > +		next
> > > +	}
> > > +	'
> > > +}
> > > +
> > >  _init
> > >  out=$SCRATCH_MNT/$$.tmp
> > >  
> > > +# This isn't really related to fs block size, it's just what
> > > +# alloc uses for the "block" unit in it's input parameters...
> > > +# However, xfs_alloc_file_space() rounds up allocation
> > > +# request by the filesystem's block size.
> > > +bsize=$(_get_block_size $SCRATCH_MNT)
> > 
> > [Sorry for the extremely long delay, I've been on leave...]
> > 
> > Hm.  Certain filesystems draw a distinction between the fundamental
> > block size and the minimum file block mapping size.  ocfs2 supports
> > having a file cluster size (mkfs.ocfs2 -C) that is greater than the fs
> > block size, and (I think) xfs can achieve something similar for files on
> > a realtime device via the mkfs.xfs -r extsize= option.
> > 
> > If you're dealing with writing things into a file for a test, I think
> > you have to use _get_file_block_size to make sure that you don't fall
> > afoul of the cluster/block difference.  I don't know if you've checked
> > that for this patch series...?
> 
> Thanks for pointing that out. I didn't know about the existance of 
> _get_file_block_size. I will go through the patchset once again
> and figure out which one of _get_block_size v/s _get_file_block_size to use?

<nod>

_get_block_size is usually the appropriate tool when you're trying to
massage a filesystem into creating a particular metadata block (e.g.
fragmenting the free space just enough to force it to store free space
records in N separate metadata blocks).

_get_file_block_size is more appropriate for massaging a file into a
particular format (e.g. fragmenting a file just enough to force it to
store the file's extent records in N separate metadata blocks).

And mea culpa, the vast majority of tests (including the ones I wrote)
use _g_b_s when they probably mean _g_f_b_s...

--D

> 
> -- 
> chandan
> 
