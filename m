Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9270E8005
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 17:19:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68A0F8F8037
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 15:19:34 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	MyqKyEl8AvkxZHyB for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 15:19:29 -0800 (PST)
Date: Tue, 4 Feb 2014 10:17:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 5/10] xfstest: shared/001: Standard collapse range
	tests
Message-ID: <20140203231737.GV13997@dastard>
References: <1391319958-3275-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391319958-3275-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, mtk.manpages@gmail.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk

On Sun, Feb 02, 2014 at 02:45:58PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This testcase(001) tries to test various corner cases
> for fcollapse range functionality over different type of extents.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Couple of things:

>  			-c "$map_cmd -v" $testfile | $filter_cmd
>  		[ $? -ne 0 ] && die_now
>  		_md5_checksum $testfile
> @@ -415,10 +425,10 @@ _test_generic_punch()
>  		if [ "$remove_testfile" ]; then
>  			rm -f $testfile
>  		fi
> -		$XFS_IO_PROG -f -c "truncate 20k" \
> -			-c "$alloc_cmd 0 8k" \
> -			-c "pwrite 8k 8k" $sync_cmd \
> -			-c "$zero_cmd 4k 8k" \
> +		$XFS_IO_PROG -f -c "truncate $(($multiple * 20))k" \
> +			-c "$alloc_cmd 0 $(($multiple * 8))k" \
> +			-c "pwrite $(($multiple * 8))k $(($multiple * 8))k" $sync_cmd \
> +			-c "$zero_cmd $(($multiple * 4))k $(($multiple * 8))k" \
>  			-c "$map_cmd -v" $testfile | $filter_cmd

This is unreadable, and therefore I'd consider that these changes
render _test_generic_punch unmaintainable.

Either it needs tobe factored to be more readable, or we need a more
readable way of representing the offsets and sizes if we want them
to be variable. For example:

_4k="$((multiple * 4))k"
_8k="$((multiple * 8))k"
_20k="$((multiple * 20))k"

leads to:

		$XFS_IO_PROG -f -c "truncate $_20k" \
			-c "$alloc_cmd 0 $_8k" \
			-c "pwrite $_8k $_8k" $sync_cmd \
			-c "$zero_cmd $_4k $_8k" \
			-c "$map_cmd -v" $testfile | $filter_cmd

which is still readable and allows us to arbitrarily scale the
parameters. It even allows us to handle different filesystem block
sizes if we really want to....

>  		-c "$map_cmd -v" $testfile | $filter_cmd
>  	[ $? -ne 0 ] && die_now
>  	_md5_checksum $testfile
>  
> +	# If zero_cmd is fcollpase, don't check unaligned offsets
> +	if [ "$zero_cmd" == "fcollapse" ]; then
> +		if [ "$remove_testfile" ]; then
> +			rm -f $testfile
> +			rm -f $testfile.2
> +		fi
> +		return
> +	fi

No need to remove the test files here - we remove them at
test startup to ensure we have a known initial state....

> +0: [0..63]: extent
> +bb7df04e1b0a2570657527a7e108ae23
> +	13. data -> unwritten -> data
> +0: [0..63]: extent
> +0f0151cbed83e4bf6e5bde26e82ab115
> +	14. data -> hole @ EOF
> +fallocate: Invalid argument
> +0: [0..159]: extent

This error appears in all the golden outputs. If it's correct, then
perhaps it should be filtered out or commented somewhere to explain
why it is expected.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
