Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2VKBk5Q235376 for <xfs@oss.sgi.com>; Sat, 31 Mar 2012 15:11:49 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qJa435Hznh1ngino (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 31 Mar 2012 13:11:44 -0700 (PDT)
Date: Sat, 31 Mar 2012 16:11:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] 020: make this xattr test generic
Message-ID: <20120331201142.GA18556@infradead.org>
References: <4ECD4579.4080706@redhat.com>
	<20111128110158.GB13766@infradead.org>
	<4F22EE37.6080306@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F22EE37.6080306@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

I've applied this one.

On Fri, Jan 27, 2012 at 12:34:31PM -0600, Eric Sandeen wrote:
> 020 can be made generic by limiting the total attribute space
> used in the tests as appropriate.  Unless we know we have a
> large-xattr-capable fs, limit total space to a bit under one
> fs block.
> 
> Now passes for me on ext3, ext4, btrfs, as well as xfs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Move max attr definitions to common.attr, and change
> their names a bit.
> 
> Index: xfstests-dev/020
> ===================================================================
> --- xfstests-dev.orig/020	2010-10-21 19:57:08.000000000 +0000
> +++ xfstests-dev/020	2012-03-31 16:09:53.000000000 +0000
> @@ -80,7 +80,7 @@ _attr_list()
>  
>  
>  # real QA test starts here
> -_supported_fs xfs udf
> +_supported_fs generic
>  _supported_os Linux
>  
>  _require_attrs
> @@ -119,9 +119,10 @@ _attr_list $testfile
>  
>  echo "*** add lots of attributes"
>  v=0
> -while [ $v -lt 1000 ]
> +
> +while [ $v -lt $MAX_ATTRS ]
>  do
> -    echo "value_$v" | attr -s "attribute_$v" $testfile >>$seq.full
> +    echo -n "value_$v" | attr -s "attribute_$v" $testfile >>$seq.full
>      if [ $? -ne 0 ]
>      then
>          echo "!!! failed to add \"attribute_$v\""
> @@ -139,11 +140,12 @@ getfattr --absolute-names $testfile \
>      	/^#/ { next }
>  	/^[ 	]*$/ { next }
>          { l++ } 
> -	END {print "   *** " (l - 1) " attribute(s)" }'
> +	END {print "   *** " (l - 1) " attribute(s)" }' \
> +    | sed s/$MAX_ATTRS/MAX_ATTRS/
>  
>  echo "*** remove lots of attributes"
>  v=0
> -while [ $v -lt 1000 ]
> +while [ $v -lt $MAX_ATTRS ]
>  do
>      if ! $ATTR_PROG -r "attribute_$v" $testfile >>$seq.full
>      then
> @@ -157,10 +159,11 @@ done
>  _attr_list $testfile
>  
>  echo "*** really long value"
> -dd if=/dev/zero bs=1024 count=100 2>/dev/null \
> +dd if=/dev/zero bs=1 count=$MAX_ATTRVAL_SIZE 2>/dev/null \
>      | _attr -s "long_attr" $testfile >/dev/null
> -    
> -_attr -g "long_attr" $testfile | tail -n +2 | od -t x1
> +
> +OCTAL_SIZE=`echo "obase=8; $MAX_ATTRVAL_SIZE" | bc`
> +_attr -q -g "long_attr" $testfile | od -t x1 | sed -e "s/^0*$OCTAL_SIZE$/ATTRSIZE/"    
>  _attr -r "long_attr" $testfile >/dev/null
>  
>  
> Index: xfstests-dev/020.out
> ===================================================================
> --- xfstests-dev.orig/020.out	2009-05-10 16:48:46.000000000 +0000
> +++ xfstests-dev/020.out	2012-03-31 16:09:53.000000000 +0000
> @@ -40,7 +40,7 @@ user.snrub="fish2\012"
>  
>  *** add lots of attributes
>  *** check
> -   *** 1000 attribute(s)
> +   *** MAX_ATTRS attribute(s)
>  *** remove lots of attributes
>     *** print attributes
>  # file: <TESTFILE>
> @@ -49,8 +49,7 @@ user.snrub="fish2\012"
>  *** really long value
>  0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  *
> -0200000 0a
> -0200001
> +ATTRSIZE
>  *** set/get/remove really long names (expect failure)
>  attr_set: Invalid argument
>  Could not set "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" for <TESTFILE>
> Index: xfstests-dev/common.attr
> ===================================================================
> --- xfstests-dev.orig/common.attr	2012-02-13 17:59:51.000000000 +0000
> +++ xfstests-dev/common.attr	2012-03-31 16:09:53.000000000 +0000
> @@ -183,5 +183,26 @@ _sort_getfattr_output()
>      awk '{a[FNR]=$0}END{n = asort(a); for(i=1; i <= n; i++) print a[i]"\n"}' RS=''
>  }
>  
> +# set maximum total attr space based on fs type
> +if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" ]; then
> +	MAX_ATTRS=1000
> +else # Assume max ~1 block of attrs
> +	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	# user.attribute_XXX="value.XXX" is about 32 bytes; leave some overhead
> +	let MAX_ATTRS=$BLOCK_SIZE/40
> +fi
> +
> +export MAX_ATTRS
> +
> +# Set max attr value size based on fs type
> +if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" -o "$FSTYP" == "btrfs" ]; then
> +	MAX_ATTRVAL_SIZE=64
> +else # Assume max ~1 block of attrs
> +	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	# leave a little overhead
> +	let MAX_ATTRVAL_SIZE=$BLOCK_SIZE-256
> +fi
> +
> +export MAX_ATTRVAL_SIZE
>  # make sure this script returns success
>  /bin/true
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
