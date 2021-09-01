Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF4CC4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 23:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75DC661053
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 23:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhIAXht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 19:37:49 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:60011 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229989AbhIAXhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 19:37:48 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id F412B1143DB4;
        Thu,  2 Sep 2021 09:36:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLZmh-007dCQ-Ri; Thu, 02 Sep 2021 09:36:47 +1000
Date:   Thu, 2 Sep 2021 09:36:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xfstests: Add Log Attribute Replay test
Message-ID: <20210901233647.GC1756565@dread.disaster.area>
References: <20210901221006.125888-1-catherine.hoang@oracle.com>
 <20210901221006.125888-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901221006.125888-2-catherine.hoang@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=XTtZIqhqPKlHEzoNpasA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 01, 2021 at 10:10:06PM +0000, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds a test to exercise the log attribute error
> inject and log replay.  Attributes are added in increaseing
> sizes up to 64k, and the error inject is used to replay them
> from the log
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
> V2: Updated attr sizes
>    Added attr16k test
>    Removed rm -f $seqres.full
>    Added filtering for SCRATCH_MNT
....
> +_test_attr_replay()
> +{
> +	attr_name=$1
> +	attr_value=$2
> +	touch $testfile.1
> +
> +	echo "Inject error"
> +	_scratch_inject_error "larp"
> +
> +	echo "Set attribute"
> +	echo "$attr_value" | ${ATTR_PROG} -s "$attr_name" $testfile.1 2>&1 | \
> +			    _filter_scratch
> +
> +	echo "FS should be shut down, touch will fail"
> +	touch $testfile.1 2>&1 | _filter_scratch
> +
> +	echo "Remount to replay log"
> +	_scratch_inject_logprint >> $seqres.full

Huh. That function name has nothing to do with remount or dumping
the log. _scratch_remount_dump_log() would at least describe what it
does (indeed, it is just scratch_unmount; scratch_dump_log;
scratch_mount). Can you follow this up with another patch to
rename _scratch_inject_logprint() to _scratch_remount_dump_log()
and also do the same for the equivalent _test_inject_logprint()
function? They should probably move to common/xfs from
common/inject, too...

> +
> +	echo "FS should be online, touch should succeed"
> +	touch $testfile.1
> +
> +	echo "Verify attr recovery"
> +	_getfattr --absolute-names $testfile.1 | _filter_scratch
> +	$ATTR_PROG -g $attr_name $testfile.1 | md5sum
> +
> +	echo ""
> +}

Ok, so this tests just the "set" operation.

FWIW, there is no need to echo test beahviour descriptions to the
output file. Each of the "echo" statements here should just be
comments.

> +
> +
> +# real QA test starts here
> +_supported_fs xfs
> +
> +_require_scratch
> +_require_attrs
> +_require_xfs_io_error_injection "larp"
> +_require_xfs_sysfs debug/larp
> +
> +# turn on log attributes
> +echo 1 > /sys/fs/xfs/debug/larp
> +
> +_scratch_unmount >/dev/null 2>&1
> +
> +#attributes of increaseing sizes
> +attr16="0123456789ABCDEF"
> +attr64="$attr16$attr16$attr16$attr16"
> +attr256="$attr64$attr64$attr64$attr64"
> +attr1k="$attr256$attr256$attr256$attr256"
> +attr4k="$attr1k$attr1k$attr1k$attr1k"
> +attr8k="$attr4k$attr4k"
> +attr16k="$attr8k$attr8k"
> +attr32k="$attr16k$attr16k"
> +attr64k="$attr32k$attr32k"
> +
> +echo "*** mkfs"
> +_scratch_mkfs_xfs >/dev/null
> +
> +echo "*** mount FS"
> +_scratch_mount
> +
> +testfile=$SCRATCH_MNT/testfile
> +echo "*** make test file 1"
> +
> +_test_attr_replay "attr_name1" $attr16
> +_test_attr_replay "attr_name2" $attr64
> +_test_attr_replay "attr_name3" $attr256
> +_test_attr_replay "attr_name4" $attr1k
> +_test_attr_replay "attr_name5" $attr4k
> +_test_attr_replay "attr_name6" $attr8k
> +_test_attr_replay "attr_name7" $attr16k
> +_test_attr_replay "attr_name8" $attr32k
> +_test_attr_replay "attr_name9" $attr64k

Hmmm - all attributes have different names, so this only tests
the "create new attribute" operation, not the "replace attribute"
or "remove attribute" operations. 

Also, why were the given sizes chosen? It seems to me like we should
be selecting the attribute sizes based on the different operations
they trigger.

For an empty 512 byte inode on 4kB block size fs, we have ~300 bytes
available for local attr storage. Hence both attr16 and attr64 will
be stored inline.  attr256 will trigger sf-to-leaf transition with
existing entries.  attr1k will do a leaf internal addition. attr4k
will be stored externally as a remote attr, as will all the
remaining larger attrs.

Hence this doesn't test the following cases:
- empty to leaf transition on first attr insert
- remote xattr insertion when empty
- leaf split/addition due to filling a leaf block
- extent format to btree format transistion (i.e. tree level
  increase)

IOWs, for a 512 byte inode and 4kB block size fs, the tests really
need to be:

- empty, add inline attr	(64 bytes)
- empty, add internal attr	(1kB)
- empty, add remote attr	(64kB)
- inline, add inline attr	(64 bytes)
- inline, add internal attr	(1kB)
- inline, add remote attr	(64kB)
- extent, add internal attr	(1kB)
- extent, add multiple internal attr (inject error on split operation)
- extent, add multiple internal attr (inject error on fork
				  transition to btree format operation)
- extent, add remote attr	(64kB)
- btree, add multiple internal	(1kB)
- btree, add remote attr	(64kB)

This covers all the different attr fork storage forms and
transitions between the different forms.

We then need to cover the same cases but in reverse for attr removal
(e.g. recovery of leaf merge operations, btree to extent form
conversion, etc).

We also need to have coverage of attr overwrite recovery of all the
attr formats (shortform, leaf internal and remote) because these
both add and remove attributes of the same name. We probably want
different points of error injection for these so that we can force
it to recover from different points in the replace operation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
