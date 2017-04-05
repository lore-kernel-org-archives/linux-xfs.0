Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932958AbdDEKmH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 06:42:07 -0400
Date: Wed, 5 Apr 2017 18:42:05 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/4] xfstests: Partially expand the documentation [ver #5]
Message-ID: <20170405104205.GZ22845@eguan.usersys.redhat.com>
References: <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk>
 <149132132595.18980.156040870381065105.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149132132595.18980.156040870381065105.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Apr 04, 2017 at 04:55:25PM +0100, David Howells wrote:
> Partially expand the documentation available in xfstests to include
> requirements checking and auxiliary programs for testing.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> 
>  doc/auxiliary-programs.txt   |   56 ++++++++++++++++++++++++++++++++++
>  doc/requirement-checking.txt |   69 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 125 insertions(+)
>  create mode 100644 doc/auxiliary-programs.txt
>  create mode 100644 doc/requirement-checking.txt
> 
> diff --git a/doc/auxiliary-programs.txt b/doc/auxiliary-programs.txt
> new file mode 100644
> index 0000000..17797b0
> --- /dev/null
> +++ b/doc/auxiliary-programs.txt
> @@ -0,0 +1,56 @@
> +			==============================
> +			AUXILIARY PROGRAMS FOR TESTING
> +			==============================
> +
> +Not everything a test script can do is easily done within a test script;
> +sometimes it makes a lot more sense to write auxiliary program in C and have
> +the test script call them.  Auxiliary commands can be found in the src/
> +directory and in other packages.
> +
> +Tests wanting to use an auxiliary program found in the src/ directory should
> +note the dependency with:
> +
> +	_require_test_program "<program-name>"
> +
> +
> +Contents:
> +
> + - af_unix	-- Create an AF_UNIX socket
> + - stat_test	-- statx syscall exercise
> + - xfs_io	-- General I/O operation exercise
> +
> +
> +==================
> +QUICK DESCRIPTIONS
> +==================
> +
> +af_unix
> +
> +	The af_unix program creates an AF_UNIX socket at the given location.
> +
> +stat_test
> +
> +	The stat_test program is primarily designed to exercise the statx()
> +	system call.  It can check statx() against fstatat() and it can
> +	compare and check various file attributes.
> +
> +	See also:
> +		_require_statx
> +
> +
> +xfs_io
> +
> +	The xfs_io program can be found in the xfsprogs package and can be used
> +	to perform sequences of I/O commands, though it is limited to what it
> +	can do on open files.
> +
> +	xfs_io is a debugging tool that is aimed at examining regular file I/O
> +	paths rather than a raw XFS volume itself.  These code paths include
> +	not only the obvious read/write/mmap interfaces for manipulating files,
> +	but also cover all of the XFS extensions (such as space preallocation,
> +	additional inode flags, etc).
> +
> +	Most of its commands can also be used with other filesystems.
> +
> +	See also:
> +		_require_xfs_io_command
> diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
> new file mode 100644
> index 0000000..29f0b74
> --- /dev/null
> +++ b/doc/requirement-checking.txt
> @@ -0,0 +1,69 @@
> +		   ========================================
> +		   TESTING FOR REQUIREMENTS IN TEST SCRIPTS
> +		   ========================================
> +
> +Test scripts need to indicate to the infrastructure what sorts of requirements
> +they have.  This is done with _require_<xxx> macros, which may take parameters.
> +
> + (1) General requirements.
> +
> +	_require_command
> +	_require_test
> +	_require_test_program
> +	_require_xfs_io_command
> +
> + (2) System call requirements.
> +
> +	_require_statx
> +
> +
> +====================
> +GENERAL REQUIREMENTS
> +====================
> +
> +_require_command "$VAR" name
> +
> +     The test requires an external command, called 'name' be present on the
> +     system and that '$VAR' should be set with the path to that command.  $VAR
> +     should then be used to refer to the command when executing it.  For
> +     example:
> +
> +	_require_command "$NC_PROG" "nc"
> +
> +     to locate the netcat command and then:
> +
> +	$NC_PROG -U -l $TEST_DIR/$seq-sock

Hmm, NC_PROG is not defined/used anymore, perhaps it's not a good
example for document purpose. How about $KILLALL_PROG? It's often
forgotten and it could be a reminder in doc.

Thanks,
Eryu
