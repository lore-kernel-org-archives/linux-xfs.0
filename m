Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A856B7F4E
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:47:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AEF030407B
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:47:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id upPLBD6ITY6WzfSv for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 11:47:23 -0700 (PDT)
Message-ID: <52618239.2090502@sandeen.net>
Date: Fri, 18 Oct 2013 13:47:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
References: <20131011041911.238407600@sgi.com>
	<20131011042007.923283516@sgi.com> <526180B4.1030903@sandeen.net>
In-Reply-To: <526180B4.1030903@sandeen.net>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On 10/18/13 1:40 PM, Eric Sandeen wrote:
> On 10/10/13 11:19 PM, rjohnston@sgi.com wrote:
>> Verify extended attributes are not lost after multi-stream
>> xfsdump/xfsrestore of wholly-sparse files.  The restore succeeds,
>> however the extended attributes for that file are lost.
>>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>>
>> diff --git a/tests/xfs/350 b/tests/xfs/350
>> new file mode 100755
>> index 0000000..88943e4
>> --- /dev/null
>> +++ b/tests/xfs/350
>> @@ -0,0 +1,72 @@
>> +#! /bin/bash
>> +# FS QA Test No. 350
>> +#
>> +# Verify multi-stream xfsdump/restore preserves extended attributes
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
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
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/dump
>> +. ./common/attr
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs xfs
>> +_supported_os Linux
>> +_require_scratch
>> +
>> +# Extended attributes
>> +attr_name=attrname
>> +attr_value=1234
>> +
>> +rm -f $seqres.full
>> +
>> +_create_dumpdir_fill_ea 2>&1 >> $seqres.full

whoops here too.  Tho I think _create_dumpdir_fill_ea already
does all the redirect you need.

Was going to say you need a scratch_mkfs & mount too, but 
_create_dumpdir_fill_ea() does all that under the covers?  Bleah!
Comment to that effect wouldn't hurt.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
