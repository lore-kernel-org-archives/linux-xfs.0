Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 09D747F67
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 23:50:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA2DA8F8035
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 21:50:16 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id 8ZEAwJnx3Ggn2yW8 (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 21:50:15 -0800 (PST)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NHS003CQLJQL1B0@mailout4.samsung.com> for
	xfs@oss.sgi.com; Wed, 07 Jan 2015 14:50:14 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <004701d02670$73dcb0a0$5b9611e0$@samsung.com>
	<20150106191010.GJ5874@bfoster.bfoster>
In-reply-to: <20150106191010.GJ5874@bfoster.bfoster>
Subject: RE: [PATCH v7 9/11] xfstests: generic/043: Test multiple fallocate
	insert/collapse range calls
Date: Wed, 07 Jan 2015 14:50:13 +0900
Message-id: <001a01d02a3d$ce7462d0$6b5d2870$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Brian Foster' <bfoster@redhat.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>

> > +
> > +for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
> > +
> > +	length=$(($BLOCKS * $BSIZE))
> > +	case $FSTYP in
> > +	xfs)
> > +	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
> > +	;;
> > +	ext4)
> > +	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
> > +	;;
> > +	esac
> 
> I think we typically try to define things like blocksize in the test
> configuration. The MKFS_OPTIONS env. var. can be defined with the
> correct options for the associated fs being tested. That eliminates the
> need to loop and for the fs-specific _scratch_mkfs calls above.
Okay, I will change.
> 
> > +	_scratch_mount >> $seqres.full 2>&1
> > +
> > +	# Write file
> > +	$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
> > +
> > +
> > +	# Insert alternate blocks
> 
> Trailing space in the above comment.
> 
> > +	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +		offset=$((($j*$BSIZE)*2))
> > +		$XFS_IO_PROG -c "finsert $offset $BSIZE" $testfile > /dev/null
> > +	done
> > +
> > +	# Check if 100 extents are present
> > +	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
> > +
> > +	_check_scratch_fs
> > +	if [ $? -ne 0 ]; then
> > +		status=1
> > +		exit
> > +	fi
> > +
> > +	# Collapse alternate blocks
> 
> ... and here as well.
Okay, I wil fix both points.
> 
> > +	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +		offset=$((($j*$BSIZE)))
> > +		$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
> > +	done
> > +
> > +	# Check if 1 extents are present
> > +	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
> > +
> > +	_check_scratch_fs
> > +	if [ $? -ne 0 ]; then
> > +		status=1
> > +		exit
> > +	fi
> > +
> 
> Maybe create a copy of the original file before we run through the
> insert and collapse sequence and cmp the files here as a last step?
Good idea. I will add your point.

Thanks for your review!
> 
> Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
