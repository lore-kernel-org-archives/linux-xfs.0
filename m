Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARN1rWN104084 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 17:01:53 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S2n59M7uOFU0vJv0 for
	<xfs@oss.sgi.com>; Tue, 27 Nov 2012 15:04:10 -0800 (PST)
Message-ID: <50B53A3D.8060501@redhat.com>
Date: Tue, 27 Nov 2012 16:10:05 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: test EROFS vs. EEXIST when creating on an RO
	filesystem
References: <50B52DB7.3030506@redhat.com> <20121127220803.GO6434@dastard>
In-Reply-To: <20121127220803.GO6434@dastard>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 11/27/12 4:08 PM, Dave Chinner wrote:
> On Tue, Nov 27, 2012 at 03:16:39PM -0600, Eric Sandeen wrote:
>> TBH, I don't know if this is posix-specified, but I found out the
>> hard way that when trying to re-create existing files on a readonly 
>> filesystem, some apps expect/handle EEXIST, but fail on EROFS.
>>
>> This will test mkdir, mknod, and symlinks for that behavior.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> Note:  Think the command output is fixed enough, or should I
>> be grepping for keywords?
> 
> Command output is good enough at this point.
> 
>>
>> diff --git a/292 b/292
>> new file mode 100755
>> index 0000000..a14bb7f
>> --- /dev/null
>> +++ b/292
>> @@ -0,0 +1,73 @@
>> +#! /bin/bash
>> +# FS QA Test No. 292
>> +#
>> +# Tests for EEXIST (not EROFS) for inode creations, if
>> +# we ask to create an already-existing entity on an RO filesystem
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#-----------------------------------------------------------------------
>> +#
>> +# creator
>> +owner=sandeen@redhat.com
>> +
>> +seq=`basename $0`
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    cd /
>> +    rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common.rc
>> +. ./common.filter
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_scratch
>> +
>> +THIS_TEST_DIR=$SCRATCH_MNT/$seq.test
> 
> Confusing. $TEST_DIR is test filesystem mount point. This points
> something very similarly names at the scratch filesystem....

Meh, ok.  $FOZZIE_BEAR_DIR or something; I'll change it.

>> +_create_files()
>> +{
>> +	mknod $THIS_TEST_DIR/testnode c 1 3
>> +	mkdir $THIS_TEST_DIR/testdir
>> +	touch $THIS_TEST_DIR/testtarget
>> +	ln -s $THIS_TEST_DIR/testtarget $THIS_TEST_DIR/testlink
>> +}
>> +
>> +_scratch_mount

Sigh, right.  I started w/ the test dev but I'm not sure there's
a simple helper to remount it ro, so I was lazy.  Then forgot to
add this.

> You need to mkfs the scratch device before using it. There is no
> guarantee that it is inmountable shape, or even contains the right
> filesytsem type when the test starts.
> 
>> +
>> +rm -rf $THIS_TEST_DIR
>> +mkdir $THIS_TEST_DIR || _fail "Could not create dir for test"
> 
> The error will dump into the output file and fail the golden output
> match. Using _fail means there's no .out.bad file for analysis of
> the failure.

>> +
>> +_create_files 2>&1 | _filter_scratch
>> +_scratch_mount -o remount,ro || _fail "Could not remount scratch readonly"
> 
> Ditto.

OK.

Thanks,
-Eric
 
> Otherwise looks OK.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
