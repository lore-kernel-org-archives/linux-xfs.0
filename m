Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B7B7A7F4E
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 10:52:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9042730406B
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:52:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P3qTRfSJCfFLnjss for
	<xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:52:02 -0800 (PST)
Date: Fri, 28 Feb 2014 17:51:57 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/8] xfstests: Create single function for testing xfs_io
	commands
In-Reply-To: <5310BC1B.4010700@sandeen.net>
Message-ID: <alpine.LFD.2.00.1402281750520.2231@localhost.localdomain>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
	<5310BC1B.4010700@sandeen.net>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Fri, 28 Feb 2014, Eric Sandeen wrote:

> Date: Fri, 28 Feb 2014 10:40:59 -0600
> From: Eric Sandeen <sandeen@sandeen.net>
> To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 1/8] xfstests: Create single function for testing xfs_io
>     commands
> 
> On 2/28/14, 10:10 AM, Lukas Czerner wrote:
> > Currently there are several function testing various xfs_io commands.
> > This commit creates _require_xfs_io_command() to test any xfs_command.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Nice, 
> 
> So to be clear, is the difference here that the explicitly listed commands
> also ensure that the running kernel supports it, whereas the default simply
> makes sure that xfs_io accepts it?  I suppose it's self-explanatory.

The only command where we only tested xfs_io support was zero. Now
we test both xfs_io and kernel support with every command.


> 
> Looks good to me,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks!
-Lukas

> 
> 
> 
> > ---
> >  common/rc | 72 +++++++++++++++++++++++++++++++++------------------------------
> >  1 file changed, 38 insertions(+), 34 deletions(-)
> > 
> > diff --git a/common/rc b/common/rc
> > index f2c3c3a..7f530d0 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -1296,12 +1296,43 @@ _user_do()
> >      fi
> >  }
> >  
> > +_require_xfs_io_command()
> > +{
> > +	if [ $# -ne 1 ]
> > +	then
> > +		echo "Usage: _require_xfs_io_command command" 1>&2
> > +		exit 1
> > +	fi
> > +	command=$1
> > +
> > +	testfile=$TEST_DIR/$$.xfs_io
> > +	case $command in
> > +	"falloc" )
> > +		testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
> > +		;;
> > +	"fpunch" | "fcollapse" | "zero" )
> > +		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> > +			-c "$command 4k 8k" $testfile 2>&1`
> > +		;;
> > +	"fiemap")
> > +		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> > +			-c "fiemap -v" $testfile 2>&1`
> > +		;;
> > +	*)
> > +		testio=`$XFS_IO_PROG -c "$command help" 2>&1`
> > +	esac
> > +
> > +	rm -f $testfile 2>&1 > /dev/null
> > +	echo $testio | grep -q "not found" && \
> > +		_notrun "xfs_io $command support is missing"
> > +	echo $testio | grep -q "Operation not supported" && \
> > +		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
> > +}
> > +
> >  # check that xfs_io, kernel, and filesystem all support zero
> >  _require_xfs_io_zero()
> >  {
> > -	testio=`$XFS_IO_PROG -c "zero help" 2>&1`
> > -	echo $testio | grep -q 'command "zero" not found' && \
> > -		_notrun "zero command not supported"
> > +	_require_xfs_io_command "zero"
> >  }
> 
> Nice, so now this actually *does* test the 2nd and 3rd items.  :)
> 
> >  # check that xfs_io, glibc, kernel, and filesystem all (!) support
> > @@ -1309,54 +1340,27 @@ _require_xfs_io_zero()
> >  #
> >  _require_xfs_io_falloc()
> >  {
> > -	testfile=$TEST_DIR/$$.falloc
> > -	testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
> > -	rm -f $testfile 2>&1 > /dev/null
> > -	echo $testio | grep -q "not found" && \
> > -		_notrun "xfs_io fallocate support is missing"
> > -	echo $testio | grep -q "Operation not supported" && \
> > -		_notrun "xfs_io fallocate command failed (old kernel/wrong fs?)"
> > +	_require_xfs_io_command "falloc"
> >  }
> >  
> >  # check that xfs_io, kernel and filesystem all support fallocate with hole
> >  # punching
> >  _require_xfs_io_falloc_punch()
> >  {
> > -	testfile=$TEST_DIR/$$.falloc
> > -	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> > -		-c "fpunch 4k 8k" $testfile 2>&1`
> > -	rm -f $testfile 2>&1 > /dev/null
> > -	echo $testio | grep -q "not found" && \
> > -		_notrun "xfs_io fallocate punch support is missing"
> > -	echo $testio | grep -q "Operation not supported" && \
> > -		_notrun "xfs_io fallocate punch command failed (no fs support?)"
> > +	_require_xfs_io_command "fpunch"
> >  }
> >  
> >  # check that xfs_io, kernel and filesystem all support fallocate with collapse
> >  # range
> >  _require_xfs_io_falloc_collapse()
> >  {
> > -	testfile=$TEST_DIR/$$.falloc
> > -	testio=`$XFS_IO_PROG -f -c "pwrite 0 20k" -c "fsync" \
> > -		-c "fcollapse 4k 8k" $testfile 2>&1`
> > -	rm -f $testfile 2>&1 > /dev/null
> > -	echo $testio | grep -q "not found" && \
> > -		_notrun "xfs_io fallocate collapse range support is missing"
> > -	echo $testio | grep -q "Operation not supported" && \
> > -		_notrun "xfs_io fallocate collapse range failed (no fs support?)"
> > +	_require_xfs_io_command "fcollapse"
> >  }
> >  
> >  # check that xfs_io, kernel and filesystem support fiemap
> >  _require_xfs_io_fiemap()
> >  {
> > -	testfile=$TEST_DIR/$$.fiemap
> > -	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> > -		-c "fiemap -v" $testfile 2>&1`
> > -	rm -f $testfile 2>&1 > /dev/null
> > -	echo $testio | grep -q "not found" && \
> > -		_notrun "xfs_io fiemap support is missing"
> > -	echo $testio | grep -q "Operation not supported" && \
> > -		_notrun "xfs_io fiemap command failed (no fs support?)"
> > +	_require_xfs_io_command "fiemap"
> >  }
> >  
> >  # Check that a fs has enough free space (in 1024b blocks)
> > 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
