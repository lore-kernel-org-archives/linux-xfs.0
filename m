Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GE74No216283 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 09:07:04 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id nHtxPGfmFJGWIxpe for <xfs@oss.sgi.com>;
	Mon, 16 Apr 2012 07:07:00 -0700 (PDT)
Message-ID: <4F8C2783.5050809@sandeen.net>
Date: Mon, 16 Apr 2012 09:06:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfstests 062: fix support for ext4 and SELinux
References: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
	<4F8B881E.2040806@sandeen.net>
	<alpine.LFD.2.00.1204160858540.11313@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1204160858540.11313@dhcp-27-109.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: tmarek@redhat.com, dchinner@redhat.com, xfs@oss.sgi.com

On 4/16/12 2:03 AM, Lukas Czerner wrote:
> On Sun, 15 Apr 2012, Eric Sandeen wrote:
> 
>> On 4/13/12 4:49 AM, tmarek@redhat.com wrote:
>>> From: Tom Marek <tmarek@redhat.com>
>>>
>>> Tests number 062 was supposed to work with ext4 fs but there were some
>>> problems in it - Tests haven't considered existence of lost+found directory in
>>> ext4. Also when scratch was mounted with SELinux context test failed because
>>> fgetattr returns SELinux extended attributes. And when fgetattr is run with
>>> recursive flag it's output might change between file systems due to different
>>> file ordering. Fix this by sorting the output manually. Also all lines
>>> containing SELinux and lost+found were removed from output.
>>>
>>> Signed-off-by: Tom Marek <tmarek@redhat.com>
>>
>> Have you run the latest xfstests?  This looks a lot like:
>>
>> commit 2fb1c931a6090f646afa44e4ce3f1f9815af9067
>> Author: Eric Sandeen <sandeen@sandeen.net>
>> Date:   Fri Jan 27 12:28:20 2012 -0600

...

> Hi Eric,
> 
> I have latest xfstests from git://oss.sgi.com/xfs/cmds/xfstests which I
> found here http://xfs.org/index.php/Getting_the_latest_source_code but
> your commit is not there. I can see it on the list though, so this patch
> can be dropped.

git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

usually contains the latest.  Looks like SGI hasn't pulled from there since Thu, 10 Nov 2011.

Ben, can you get oss up to date?

-Eric

> Thanks!
> -Lukas
> 
>>
>>> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
>>> ---
>>>  062     |   50 ++++++++++++++++++++++++++---------
>>>  062.out |   90 +++++++++++++++++++++++++++++++-------------------------------
>>>  2 files changed, 82 insertions(+), 58 deletions(-)
>>>
>>> diff --git a/062 b/062
>>> index f666e1b..116296b 100755
>>> --- a/062
>>> +++ b/062
>>> @@ -46,6 +46,30 @@ _cleanup()
>>>  }
>>>  trap "_cleanup; exit \$status" 0 1 2 3 15
>>>  
>>> +# remove "security.selinux=..." because it is not installed on all systems
>>> +# and it not relevant to this test
>>> +_remove_selinux(){
>>> +	egrep -v '^(selinux|security\.selinux)'
>>> +}
>>> +
>>> +# sort getfattr output and remove entries containing only selinux attributes
>>> +_sort_getfattr(){
>>> +	awk '
>>> +	BEGIN{
>>> +		RS=""
>>> +	}
>>> +	{
>>> +		a[FNR]=$0
>>> +	}
>>> +	END{
>>> +		n = asort(a);
>>> +		for(i = 1; i <= n; ++i){
>>> +			if (a[i] ~ /# file: SCRATCH_MNT[^\n]*\nsecurity.selinux[^\n]*\n/)
>>> +				print a[i] "\n"
>>> +		}
>>> +	}'
>>> +}
>>> +
>>>  getfattr()
>>>  {
>>>      $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch
>>> @@ -67,7 +91,7 @@ _create_test_bed()
>>>  	mknod $SCRATCH_MNT/dev/c c 0 0
>>>  	mknod $SCRATCH_MNT/dev/p p
>>>  	# sanity check
>>> -	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch
>>> +	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch | grep -v "lost+found"
>>>  }
>>>  
>>>  # real QA test starts here
>>> @@ -102,7 +126,7 @@ for nsp in $ATTR_MODES; do
>>>  		echo "*** set/get one initially empty attribute"
>>>      
>>>  		setfattr -h -n $nsp.name $SCRATCH_MNT/$inode
>>> -		getfattr -m $nsp $SCRATCH_MNT/$inode
>>> +		getfattr -m $nsp $SCRATCH_MNT/$inode | _remove_selinux
>>>  
>>>  		echo "*** overwrite empty, set several new attributes"
>>>  		setfattr -h -n $nsp.name -v 0xbabe $SCRATCH_MNT/$inode
>>> @@ -110,33 +134,33 @@ for nsp in $ATTR_MODES; do
>>>  		setfattr -h -n $nsp.name3 -v 0xdeface $SCRATCH_MNT/$inode
>>>  
>>>  		echo "*** fetch several attribute names and values (hex)"
>>> -		getfattr -m $nsp -e hex $SCRATCH_MNT/$inode
>>> +		getfattr -m $nsp -e hex $SCRATCH_MNT/$inode | _remove_selinux
>>>  
>>>  		echo "*** fetch several attribute names and values (base64)"
>>> -		getfattr -m $nsp -e base64 $SCRATCH_MNT/$inode
>>> +		getfattr -m $nsp -e base64 $SCRATCH_MNT/$inode | _remove_selinux
>>>  		
>>>  		echo "*** shrink value of an existing attribute"
>>>  		setfattr -h -n $nsp.name2 -v 0xdeaf $SCRATCH_MNT/$inode
>>> -		getfattr -m $nsp -e hex $SCRATCH_MNT/$inode
>>> +		getfattr -m $nsp -e hex $SCRATCH_MNT/$inode | _remove_selinux
>>>  
>>>  		echo "*** grow value of existing attribute"
>>>  		setfattr -h -n $nsp.name2 -v 0xdecade $SCRATCH_MNT/$inode
>>> -		getfattr -m $nsp -e hex $SCRATCH_MNT/$inode
>>> +		getfattr -m $nsp -e hex $SCRATCH_MNT/$inode | _remove_selinux
>>>  		
>>>  		echo "*** set an empty value for second attribute"
>>>  		setfattr -h -n $nsp.name2 $SCRATCH_MNT/$inode
>>> -		getfattr -m $nsp -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
>>> +		getfattr -m $nsp -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter | _remove_selinux
>>>  
>>>  		echo "*** overwrite empty value"
>>>  		setfattr -h -n $nsp.name2 -v 0xcafe $SCRATCH_MNT/$inode
>>> -		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
>>> +		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter | _remove_selinux
>>>  
>>>  		echo "*** remove attribute"
>>>  		setfattr -h -x $nsp.name2 $SCRATCH_MNT/$inode
>>> -		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
>>> +		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter | _remove_selinux
>>>  
>>>  		echo "*** final list (strings, type=$inode, nsp=$nsp)"
>>> -		getfattr -m '.' -e hex $SCRATCH_MNT/$inode
>>> +		getfattr -m '.' -e hex $SCRATCH_MNT/$inode | _sort_getfattr | _remove_selinux
>>>  	
>>>  	done
>>>  done
>>> @@ -160,18 +184,18 @@ _extend_test_bed()
>>>  	# whack a symlink in the middle, just to be difficult
>>>  	ln -s $SCRATCH_MNT/here/up $SCRATCH_MNT/descend/and
>>>  	# dump out our new starting point
>>> -	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch
>>> +	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch | grep -v "lost+found"
>>>  }
>>>  
>>>  _extend_test_bed
>>>  
>>>  echo
>>>  echo "*** directory descent with us following symlinks"
>>> -getfattr -h -L -R -m '.' -e hex $SCRATCH_MNT
>>> +getfattr -h -L -R -m '.' -e hex $SCRATCH_MNT | _sort_getfattr | _remove_selinux
>>>  
>>>  echo
>>>  echo "*** directory descent without following symlinks"
>>> -getfattr -h -P -R -m '.' -e hex $SCRATCH_MNT
>>> +getfattr -h -P -R -m '.' -e hex $SCRATCH_MNT | _sort_getfattr | _remove_selinux
>>>  
>>>  
>>>  # 
>>> diff --git a/062.out b/062.out
>>> index 699254a..8cc3c65 100644
>>> --- a/062.out
>>> +++ b/062.out
>>> @@ -508,21 +508,21 @@ SCRATCH_MNT/lnk
>>>  SCRATCH_MNT/reg
>>>  
>>>  *** directory descent with us following symlinks
>>> -# file: SCRATCH_MNT/reg
>>> -trusted.name=0xbabe
>>> -trusted.name3=0xdeface
>>> -user.name=0xbabe
>>> -user.name3=0xdeface
>>> +# file: SCRATCH_MNT/descend
>>> +user.1=0x3233
>>> +user.x=0x797a
>>>  
>>> -# file: SCRATCH_MNT/dir
>>> -trusted.name=0xbabe
>>> -trusted.name3=0xdeface
>>> -user.name=0xbabe
>>> -user.name3=0xdeface
>>> +# file: SCRATCH_MNT/descend/and/ascend
>>> +trusted.9=0x3837
>>> +trusted.a=0x6263
>>>  
>>> -# file: SCRATCH_MNT/lnk
>>> -trusted.name=0xbabe
>>> -trusted.name3=0xdeface
>>> +# file: SCRATCH_MNT/descend/down
>>> +user.1=0x3233
>>> +user.x=0x797a
>>> +
>>> +# file: SCRATCH_MNT/descend/down/here
>>> +user.1=0x3233
>>> +user.x=0x797a
>>>  
>>>  # file: SCRATCH_MNT/dev/b
>>>  trusted.name=0xbabe
>>> @@ -536,6 +536,12 @@ trusted.name3=0xdeface
>>>  trusted.name=0xbabe
>>>  trusted.name3=0xdeface
>>>  
>>> +# file: SCRATCH_MNT/dir
>>> +trusted.name=0xbabe
>>> +trusted.name3=0xdeface
>>> +user.name=0xbabe
>>> +user.name3=0xdeface
>>> +
>>>  # file: SCRATCH_MNT/here
>>>  trusted.9=0x3837
>>>  trusted.a=0x6263
>>> @@ -548,6 +554,18 @@ trusted.a=0x6263
>>>  trusted.9=0x3837
>>>  trusted.a=0x6263
>>>  
>>> +# file: SCRATCH_MNT/lnk
>>> +trusted.name=0xbabe
>>> +trusted.name3=0xdeface
>>> +
>>> +# file: SCRATCH_MNT/reg
>>> +trusted.name=0xbabe
>>> +trusted.name3=0xdeface
>>> +user.name=0xbabe
>>> +user.name3=0xdeface
>>> +
>>> +
>>> +*** directory descent without following symlinks
>>>  # file: SCRATCH_MNT/descend
>>>  user.1=0x3233
>>>  user.x=0x797a
>>> @@ -560,28 +578,6 @@ user.x=0x797a
>>>  user.1=0x3233
>>>  user.x=0x797a
>>>  
>>> -# file: SCRATCH_MNT/descend/and/ascend
>>> -trusted.9=0x3837
>>> -trusted.a=0x6263
>>> -
>>> -
>>> -*** directory descent without following symlinks
>>> -# file: SCRATCH_MNT/reg
>>> -trusted.name=0xbabe
>>> -trusted.name3=0xdeface
>>> -user.name=0xbabe
>>> -user.name3=0xdeface
>>> -
>>> -# file: SCRATCH_MNT/dir
>>> -trusted.name=0xbabe
>>> -trusted.name3=0xdeface
>>> -user.name=0xbabe
>>> -user.name3=0xdeface
>>> -
>>> -# file: SCRATCH_MNT/lnk
>>> -trusted.name=0xbabe
>>> -trusted.name3=0xdeface
>>> -
>>>  # file: SCRATCH_MNT/dev/b
>>>  trusted.name=0xbabe
>>>  trusted.name3=0xdeface
>>> @@ -594,6 +590,12 @@ trusted.name3=0xdeface
>>>  trusted.name=0xbabe
>>>  trusted.name3=0xdeface
>>>  
>>> +# file: SCRATCH_MNT/dir
>>> +trusted.name=0xbabe
>>> +trusted.name3=0xdeface
>>> +user.name=0xbabe
>>> +user.name3=0xdeface
>>> +
>>>  # file: SCRATCH_MNT/here
>>>  trusted.9=0x3837
>>>  trusted.a=0x6263
>>> @@ -606,17 +608,15 @@ trusted.a=0x6263
>>>  trusted.9=0x3837
>>>  trusted.a=0x6263
>>>  
>>> -# file: SCRATCH_MNT/descend
>>> -user.1=0x3233
>>> -user.x=0x797a
>>> -
>>> -# file: SCRATCH_MNT/descend/down
>>> -user.1=0x3233
>>> -user.x=0x797a
>>> +# file: SCRATCH_MNT/lnk
>>> +trusted.name=0xbabe
>>> +trusted.name3=0xdeface
>>>  
>>> -# file: SCRATCH_MNT/descend/down/here
>>> -user.1=0x3233
>>> -user.x=0x797a
>>> +# file: SCRATCH_MNT/reg
>>> +trusted.name=0xbabe
>>> +trusted.name3=0xdeface
>>> +user.name=0xbabe
>>> +user.name3=0xdeface
>>>  
>>>  
>>>  
>>
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
