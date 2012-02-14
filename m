Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1E1Ln0P056384 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 19:21:49 -0600
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id YSz5zHOeoqjMRLwj for
	<xfs@oss.sgi.com>; Mon, 13 Feb 2012 17:21:47 -0800 (PST)
Message-ID: <4F39B6C0.4090606@cn.fujitsu.com>
Date: Tue, 14 Feb 2012 09:20:00 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3 v2] xfstests: add btrfs online defragments QA test
References: <1328766034-1324-1-git-send-email-liubo2009@cn.fujitsu.com>
	<20120213175344.GA15040@infradead.org>
In-Reply-To: <20120213175344.GA15040@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 02/14/2012 01:53 AM, Christoph Hellwig wrote:
> This still needs a bit more work:
> 
>> +test_path="`pwd`"
>> +progs_dir="$test_path/src/btrfs_online_defragment/"
> 
> this isn't actually used.
> 
> 
>> +tmp=tmp/$$
>> +defrag_args="$test_path/${seq}.args"
> 
> Just hardcode the arguments, preferably without the args file
> indirection.
> 
>> +_create_file()
>> +{
>> +	CNT=11999
>> +	FILESIZE=48000
>> +	if [ "$DEFRAG_TARGET" = "1" ];then
>> +		for i in `seq $CNT -1 0`; do
>> +			dd if=/dev/zero of=$SCRATCH_MNT/tmp_file bs=4k count=1 \
>> +			 conv=notrunc seek=$i oflag=sync &>/dev/null
>> +		done
>> +		# get md5sum
>> +		md5sum $SCRATCH_MNT/tmp_file > /tmp/checksum
>> +	elif [ "$DEFRAG_TARGET" = "2" ];then
>> +		mkdir $SCRATCH_MNT/tmp_dir
>> +		for i in `seq $CNT -1 0`; do
>> +			dd if=/dev/zero of=$SCRATCH_MNT/tmp_dir/tmp_file bs=4k \
>> +			count=1 conv=notrunc seek=$i oflag=sync &>/dev/null
>> +		done
>> +		# get md5sum
>> +		md5sum $SCRATCH_MNT/tmp_dir/tmp_file > /tmp/checksum
>> +	elif [ "$DEFRAG_TARGET" = "3" ];then
>> +		for i in `seq $CNT -1 0`; do
>> +			dd if=/dev/zero of=$SCRATCH_MNT/tmp_file bs=4k count=1 \
>> +			conv=notrunc seek=$i oflag=sync &>/dev/null
>> +		done
>> +		# get md5sum
>> +		md5sum $SCRATCH_MNT/tmp_file > /tmp/checksum
>> +	fi
>> +}
> 
> It seems like each of these cases should be a different function.
> 
>> +_btrfs_online_defrag()
>> +{
>> +	str=""
>> +	if [ "$FILE_RANGE" = "2" ];then
>> +		str="$str -s -1 -l $((FILESIZE / 2)) "
>> +	elif [ "$FILE_RANGE" = "3" ];then
>> +		str="$str -s $((FILESIZE + 1)) -l $((FILESIZE / 2)) "
>> +		HAVE_DEFRAG=1
>> +	elif [ "$FILE_RANGE" = "4" ];then
>> +		str="$str -l -1 "
>> +	elif [ "$FILE_RANGE" = "5" ];then
>> +		str="$str -l $((FILESIZE + 1)) "
>> +	elif [ "$FILE_RANGE" = "6" ];then
>> +		str="$str -l $((FILESIZE / 2)) "
>> +	fi
>> +
>> +	if [ "$DEFRAG_COMPRESS" = "2" ];then
>> +		str="$str -c "
>> +	fi
>> +
>> +	if [ "$FLUSH" = "2" ];then
>> +		str="$str -f "
>> +	fi
>> +
>> +	if [ "$THRESH" = "2" ];then
>> +		str="$str -t -1 "
>> +	elif [ "$THRESH" = "3" ];then
>> +		str="$str -t $PAGESIZE "
>> +	fi
>> +
>> +	if [ "$str" != "" ]; then
>> +		btrfs filesystem defragment $str $SCRATCH_MNT/tmp_file
>> +	else
>> +		if [ "$DEFRAG_TARGET" = "1" ];then
>> +			btrfs filesystem defragment $SCRATCH_MNT/tmp_file
>> +		elif [ "$DEFRAG_TARGET" = "2" ];then
>> +			btrfs filesystem defragment $SCRATCH_MNT/tmp_dir
>> +		elif [ "$DEFRAG_TARGET" = "3" ];then
>> +			btrfs filesystem defragment $SCRATCH_MNT
>> +		fi
>> +	fi
>> +	ret_val=$?
>> +	sync
>> +	if [ $ret_val -ne 20 ];then
>> +		echo "btrfs filesystem defragment failed! err is $ret_val"
>> +	fi
>> +}
> 
>> +_fsck()
>> +{
>> +	btrfsck $SCRATCH_DEV > /dev/null 2>&1
>> +	ret_val=$?
>> +	if [ $ret_val -ne 0 ]; then
>> +		echo "btrfsck _FAIL_! err is $ret_val"
>> +	fi
>> +}
> 
> This should use the generic xfstests fsck invocation wrappers.
> 
>> +_parse_options()
> 
> Please don't use an option parser but just call the low-level file
> creation functions directly.
> 
>> +_cleanup_defrag()
>> +{
>> +	rm -fr $SCRATCH_MNT/*
>> +	umount $SCRATCH_MNT > /dev/null 2>&1
>> +}
> 
> No need to remove everything as the scratch filesystem gets recreated
> every time.
> 
> 

OK, I'll update this more carefully ;)
and thanks for your time!

thanks,
liubo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
