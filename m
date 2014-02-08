Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 390A67F55
	for <xfs@oss.sgi.com>; Sat,  8 Feb 2014 02:31:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4348AC006
	for <xfs@oss.sgi.com>; Sat,  8 Feb 2014 00:30:57 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id bkNe1ImcTEEBVHu5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Feb 2014 00:30:56 -0800 (PST)
Message-ID: <52F5EB3B.5030902@oracle.com>
Date: Sat, 08 Feb 2014 09:30:51 +0100
From: Koen De Wit <koen.de.wit@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Btrfs: add test for large metadata blocks
References: <1391793285-935-1-git-send-email-koen.de.wit@oracle.com>
	<20140207224934.GH13647@dastard>
In-Reply-To: <20140207224934.GH13647@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Thanks for the review, Dave!
Comments inline.

On 02/07/2014 11:49 PM, Dave Chinner wrote:
> On Fri, Feb 07, 2014 at 06:14:45PM +0100, Koen De Wit wrote:
>> Tests Btrfs filesystems with all possible metadata block sizes, by
>> setting large extended attributes on files.
>>
>> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
> There's a few things here that need fixing.
>
>> +pagesize=`$here/src/feature -s`
>> +pagesize_kb=`expr $pagesize / 1024`
>> +
>> +# Test all valid leafsizes
>> +for leafsize in `seq $pagesize_kb $pagesize_kb 64`; do
>> +    _scratch_unmount >/dev/null 2>&1
> Indentation are tabs, and tabs are 8 spaces in size, please.

OK, I fixed this in v2.

>> +    _scratch_mkfs -l ${leafsize}K >/dev/null
>> +    _scratch_mount
> No need to use _scratch_unmount here - you should be doing a
> _check_scratch_fs at the end of the loop.

Fixed in v2 too.

>> +    # Calculate the xattr size, but leave 512 bytes for other metadata.
>> +    xattr_size=`expr $leafsize \* 1024 - 512`
>> +
>> +    touch $SCRATCH_MNT/emptyfile
>> +    # smallfile will be inlined, bigfile not.
>> +    $XFS_IO_PROG -f -c "pwrite 0 100" $SCRATCH_MNT/smallfile >/dev/null
>> +    $XFS_IO_PROG -f -c "pwrite 0 9000" $SCRATCH_MNT/bigfile >/dev/null
>> +    ln -s $SCRATCH_MNT/bigfile $SCRATCH_MNT/bigfile_softlink
>> +
>> +    files=(emptyfile smallfile bigfile bigfile_softlink)
>> +    chars=(a b c d)
>> +    for i in `seq 0 1 3`; do
>> +        char=${chars[$i]}
>> +        file=$SCRATCH_MNT/${files[$i]}
>> +        lnkfile=${file}_hardlink
>> +        ln $file $lnkfile
>> +        xattr_value=`head -c $xattr_size < /dev/zero | tr '\0' $char`
>> +
>> +        set_md5=`echo -n "$xattr_value" | md5sum`
> Just dump the md5sum to the output file.
>
>> +        ${ATTR_PROG} -Lq -s attr_$char -V $xattr_value $file
>> +        get_md5=`${ATTR_PROG} -Lq -g attr_$char $file | md5sum`
>> +        get_ln_md5=`${ATTR_PROG} -Lq -g attr_$char $lnkfile | md5sum`
> And dump these to the output file, too. Then the golden image
> matching when the test is finish will tell you if it passed or not.
> i.e:
>
> 	echo -n "$xattr_value" | md5sum
> 	${ATTR_PROG} -Lq -s attr_$char -V $xattr_value $file
> 	${ATTR_PROG} -Lq -g attr_$char $file | md5sum
> 	${ATTR_PROG} -Lq -g attr_$char $lnkfile | md5sum
>
> is all that neds to be done here.

The problem with this is that the length of the output will depend on the page size. The code above runs for every valid leafsize, which can be any multiple of the page size up to 64KB, as defined in the loop initialization:
     for leafsize in `seq $pagesize_kb $pagesize_kb 64`; do

>> +    # Test attributes with a size larger than the leafsize.
>> +    # Should result in an error.
>> +    if [ "$leafsize" -lt "64" ]; then
>> +        # Bash command lines cannot be larger than 64K characters, so we
>> +        # do not test attribute values with a size >64KB.
>> +        xattr_size=`expr $leafsize \* 1024 + 512`
>> +        xattr_value=`head -c $xattr_size < /dev/zero | tr '\0' x`
>> +        ${ATTR_PROG} -q -s attr_toobig -V $xattr_value \
>> +            $SCRATCH_MNT/emptyfile >> $seqres.full 2>&1
>> +        if [ "$?" -eq "0" ]; then
>> +            echo "Expected error, xattr_size is bigger than ${leafsize}K"
>> +        fi
> What you are doing is redirecting the error to $seqres.full
> so that it doesn't end up in the output file, then detecting the
> absence of an error and dumping a message to the output file to make
> the test fail.
>
> IOWs, the ATTR_PROG failure message should be in the golden output
> file and you don't have to do anything else to detect a pass/fail
> condition.

Same here: the bigger the page size, the less this code will be executed. If the page size is 64KB, this code isn't executed at all.
To make sure the golden output does not depend on the page size, I chose to suppress all output as long as the test is successful. Is there a better way to accomplish this?

>> +_scratch_unmount
>> +
>> +# Some illegal leafsizes
>> +
>> +_scratch_mkfs -l 0 2>> $seqres.full
>> +echo $?
> Same again - you are dumping the error output into a different file,
> then detecting the error manually. pass the output of _scratch_mkfs
> through a filter, and let errors cause golden output mismatches.

I did this to make the golden output not depend on the output of mkfs.btrfs, inspired by http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=commit;h=fd7a8e885732475c17488e28b569ac1530c8eb59 and http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=commit;h=78d86b996c9c431542fdbac11fa08764b16ceb7d
However, in my opinion the test should simply be updated if the output of mkfs.btrfs changes, so I agree with you and I fixed this in v2.

Thanks,
Koen.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
