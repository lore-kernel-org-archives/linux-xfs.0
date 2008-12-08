Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB85mCwa003769 for <xfs@oss.sgi.com>; Sun, 7 Dec 2008 23:48:12 -0600
Message-ID: <493CB518.7000001@sgi.com>
Date: Mon, 08 Dec 2008 16:48:08 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: add testcase for ->setattr permission checking
References: <20081202142039.GA25155@infradead.org>
In-Reply-To: <20081202142039.GA25155@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs@oss.sgi.com

I'd like to check this in.
I can do the uid/gid test allocation later.

There are a few things below that
I want to check with you...

Christoph Hellwig wrote:
> Index: xfs-cmds-git/xfstests/192
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs-cmds-git/xfstests/192	2008-12-02 14:16:12.000000000 +0000
> @@ -0,0 +1,177 @@
> +#! /bin/sh
> +# FS QA Test No. 192
> +#
> +# Test permission checks in ->setattr
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2008 Christoph Hellwig.
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=hch@lst.de
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup_files; exit \$status" 0 1 2 3 15
> +tag="added by qa $seq"
> +
> +#
> +# For some tests we need a secondary group for the qa_user.  Currently
> +# that's not available in the framework, so the tests using it are
> +# commented out.
> +#
> +#group2=foo
> +
> +#
> +# Create two files, one owned by root, one by the qa_user
> +#
> +_create_files()
> +{
> +	touch test.root
> +	touch test.${qa_user}
> +	chown ${qa_user}:${qa_user} test.${qa_user}
> +}
> +
> +#
> +# Remove our files again
> +#
> +_cleanup_files()
> +{
> +	rm -f test.${qa_user}
> +	rm -f test.root
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs xfs nfs udf
> +_supported_os Linux
> +
> +_require_user
> +_need_to_be_root
> +
> +
> +#
> +# make sure we have a normal umask set
> +#
> +umask 022
> +
> +
> +#
> +# Test the ATTR_UID case
> +#
> +echo
> +echo "testing ATTR_UID"
> +echo
> +
> +_create_files
> +

1.
> +echo "user: chown root owned file to qa_user (should fail)"
> +su ${qa_user} -c "chown root test.${qa_user}"
> +
I think the description and command above don't match.
I think we have a swap with subtest 4 below.
Need to either swap descriptions or commands.

2.
> +echo "user: chown root owned file to root (should fail)"
> +su ${qa_user} -c "chown root test.root"
> +

3.
> +echo "user: chown qa_user owned file to qa_user (should succeed)"
> +su ${qa_user} -c "chown ${qa_user} test.${qa_user}"
> +

4.
> +# this would work without _POSIX_CHOWN_RESTRICTED
> +echo "user: chown qa_user owned file to root (should fail)"
> +su ${qa_user} -c "chown ${qa_user} test.root"
> +



> +#
> +# Setup a file owned by the qa_user and with the suid bit set.
> +# A chown by root should not clean the suid bit.
> +#

Typos:
s/clean/clear/

s/suceed/succeed/ in a couple of places.

* It looks like you test the clearing of suid/sgid bits
for setting the mode permission bits and not
for setting ownership as the description suggests;
i.e. you test with chmod instead of chown for clearing of suid/sgid bits


Ideally in the future it would be good to test a few other things too:
* CAP_FOWNER
* CAP_FSETID
* CAP_CHOWN

--Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
