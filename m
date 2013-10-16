Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6ED6F7F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 11:11:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C0B2AC002
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 09:11:54 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id hzpmzrzFYL5KUGdC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 09:11:52 -0700 (PDT)
Date: Wed, 16 Oct 2013 09:11:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add specific test for default ACL inheritance
Message-ID: <20131016161150.GA12895@infradead.org>
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: jbacik@fusionio.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Oct 16, 2013 at 03:04:56PM +0100, Filipe David Borba Manana wrote:
> This test is motivated by an issue found by a btrfs user, addressed
> and described by the following GNU/Linux kernel patch:

Might be a little too nipicky, but there's no "GNU/Linux" kernel, it's
just Linux.

As for the test: thanks a lot for sending it a long here, but can you
please create a new testcase for the specific inheritance bug instead
of adding it to an existing test case?

>  # real QA test starts here
> -_supported_fs xfs udf
> +_supported_fs xfs udf btrfs

Of course enabling the existing tests for btrfs is still fine (although
it should be a second patch)

> -chacl $acl3 largeaclfile
> +if [ "$FSTYP" != "btrfs" ]; then
> +	chacl $acl3 largeaclfile
> +else
> +	echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
> +fi

Does btrfs support unlimited ACLs?  If not we should test one above the
limit here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
