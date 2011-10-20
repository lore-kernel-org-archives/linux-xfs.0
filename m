Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KFWVrT009647 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 10:32:31 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A0461DF63C
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:32:29 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id zokzb1lJlxD7Zzfu for
	<xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:32:29 -0700 (PDT)
Message-ID: <4EA03EEB.3020403@oracle.com>
Date: Thu, 20 Oct 2011 23:31:55 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] 264: Functional test case for the btrfs snapshot
References: <20111013005652.GM3159@dastard>
	<1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
	<1318919336-32206-2-git-send-email-Anand.Jain@oracle.com>
	<20111019094209.GB3083@infradead.org>
In-Reply-To: <20111019094209.GB3083@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com


comments in line.

On 19/10/2011 17:42, Christoph Hellwig wrote:
> On Tue, Oct 18, 2011 at 02:28:54PM +0800, Anand Jain wrote:
>> Create snapshots in various ways, modify the data around the block and
>> file boundaries and verify the data integrity.
> 
> The test itselt looks good enough, but I have some comments on the
> pool infrastructure changes.  I also think they should probably be
> a separate preparatory patch, or at least documented in the changelog
> as well.
> 
>> index 5367be6..7c135c7 100644
>> --- a/README
>> +++ b/README
>> @@ -36,12 +36,17 @@ Preparing system for tests (IRIX and Linux):
>>                not be run.
>>                
>>          (these must be two DIFFERENT partitions)
>> +
>> +    - for btrfs only: some tests would need 3 or more independent SCRATCH disks,
>> +      which should be setenv SCRATCH_DEV_POOL instead of SCRATCH_DEV
>> +              
>>                
>>      - setup your environment
>>          - setenv TEST_DEV "device containing TEST PARTITION"
>>          - setenv TEST_DIR "mount point of TEST PARTITION"   
>>         	- optionally:
>>               - setenv SCRATCH_DEV "device containing SCRATCH PARTITION"
>> +             - setenv SCRATCH_DEV_POOL "pool of SCRATCH disks for testing btrfs"
> 
> How does one find out what the pool name is?  You'll also need to
> document how to create the pool from disks.
> 

  agreed.

>> @@ -229,6 +229,20 @@ if [ ! -d "$TEST_DIR" ]; then
>>      exit 1
>>  fi
>>  
>> +# a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
>> +# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
>> +if [ "$HOSTOS" == "Linux" ]; then
>> +    FSTYP_tmp=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
>> +else
>> +    FSTYP_tmp=xfs
>> +fi
> 
> Why do we need a second FSTYP detection?  If the existing one isn't
> early enough make sure it's done early enough instead of duplicating
> it.

  looks like its ok not to have FSTYP checked here, it will follow the
  following logic..

   btrfs FS OR any FS
     SCRATCH_DEV_POOL is unset and SCRATCH_DEV is set
      . test-case with _require_scratch_dev_pool will not run
      . test-case without _require_scratch_dev_pool will run

     SCRATCH_DEV_POOL is set and SCRATCH_DEV is unset
      . test-case with _require_scratch_dev_pool
          - runs only if FSTYP=btrfs
      . test-case without _require_scratch_dev_pool will run using first
        dev in the SCRATCH_DEV_POOL as a SCRATCH_DEV
          - if FSTYP=btrfs it includes SCRATCH_DEV_POOL disks to the FS
          - if FSTYP=non-btrfs SCRATCH_DEV_POOL is ignored

     SCRATCH_DEV_POOL is set and SCRATCH_DEV is set
      . reports error in the config

     SCRATCH_DEV_POOL is unset and SCRATCH_DEV is unset
      . no change


>> --- a/common.rc
>> +++ b/common.rc
>> @@ -1498,7 +1498,11 @@ _nfiles()
>>                  file=f$f
>>                  echo > $file
>>                  if [ $size -gt 0 ]; then
>> -                    dd if=/dev/zero of=$file bs=1024 count=$size
>> +		    if [ $randomdata == false ]; then
>> +	                dd if=/dev/zero of=$file bs=1024 count=$size 2>&1 | _filter_dd
>> +		    else
>> +                    	dd if=/dev/urandom of=$file bs=1024 count=$size 2>&1 | _filter_dd
>> +		    fi
> 
> I'd rather see the randomdata flag passed down explicitly to _descend and
> _nfiles rather than setting a magic environment variable.

makes sense. added.


>> @@ -1508,7 +1512,11 @@ _nfiles()
>>  _descend()
>>  {
>>          dirname=$1; depth=$2
>> -        mkdir $dirname  || die "mkdir $dirname failed"
>> +	if [ -d $dirname ]; then
>> +		dirname=`mktemp -dq $dirname/dir.XXXXXX`
>> +	else
>> +	        mkdir $dirname  || die "mkdir $dirname failed"
>> +	fi
> 
> Why would the directory here already exist?  This at least needs
> very good documentation.  Also the indentation seems off compared
> to the surrounding code.

  Hmm. Changing this back to the original design - where calling
  function has to ensure a new directory name which does not exists.

>> @@ -1550,6 +1559,7 @@ _populate_fs()
>>          s)      size=$OPTARG;;
>>          v)      verbose=true;;
>>          r)      root=$OPTARG;;
>> +	x)	randomdata=true;;
> 
> indendation is off again.

oh! thks for pointing.

>> +# scratch_dev_pool should contain the disks pool for the btrfs raid
>> +_require_scratch_dev_pool()
>> +{
>> +	local i
>> +	case "$FSTYP" in
>> +	btrfs)
>> +		if [ -z "$SCRATCH_DEV_POOL" ]
>> +		then
> 
> For new code I'd generally prefer the more readable
> 
> 		if [ ... ]; then
> 
> although the above form unfortunately still is fairly common in
> xfsprogs.

got it.

>> +# We will check if the device is virtual (eg: loop device) since it does not
>> +# have the delete entry-point. Otherwise SCSI and USB devices are fine. 
>> +_require_deletable_scratch_dev_pool()
>> +{
>> +	local i
>> +	local x
>> +	for i in $SCRATCH_DEV_POOL; do
>> +		x=`echo $i | cut -d"/" -f 3`
>> +		ls -l /sys/class/block/${x} | grep -q "virtual" 
>> +		if [ $? == "0" ]; then
>> +			_notrun "$i is a virtual device which is not deletable"
>> +		fi
>> +	done
>> +}
>> +
>> +# arg 1 is dev to remove and is output of the below eg.
>> +# ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
>> +_devmgt_remove()
>> +{
>> +	echo 1 > /sys/class/scsi_device/${1}/device/delete || _fail "Remove disk failed"
>> +}
>> +
>> +# arg 1 is dev to add and is output of the below eg.
>> +# ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
>> +_devmgt_add()
>> +{
>> +	local h
>> +	local tdl
>> +	# arg 1 will be in h:t:d:l format now in the h and "t d l" format
>> +	h=`echo ${1} | cut -d":" -f 1`
>> +	tdl=`echo ${1} | cut -d":" -f 2-|sed 's/:/ /g'`
>> +
>> +	echo ${tdl} >  /sys/class/scsi_host/host${h}/scan || _fail "Add disk failed"
>> +}
> 
> This code looks a bit fragile to me, but I think we can fix it on the go
> if we encouter issues.

  ok.

>> diff --git a/group b/group
>> index 2a8970c..cfbae8c 100644
>> --- a/group
>> +++ b/group
>> @@ -377,3 +377,4 @@ deprecated
>>  261 auto quick quota
>>  262 auto quick quota
>>  263 rw auto quick
>> +264 auto quick
> 
> It might be worth to add pool or snaphot groups if you add more
> tests like this.

  this can be considered when appropriate I think, as of now there is
  one test case in each of them.
Thanks

Anand

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
