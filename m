Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37190 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725842AbfBYS5z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Feb 2019 13:57:55 -0500
Subject: Re: [PATCH 4/3] generic: posix acl extended attribute memory
 corruption test
References: <154993784038.1948.7502664832930298472.stgit@magnolia>
 <20190213204814.GB6477@magnolia>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <ac4a3f51-150f-e089-52bb-9adea57dc731@suse.com>
Date: Mon, 25 Feb 2019 13:57:51 -0500
MIME-Version: 1.0
In-Reply-To: <20190213204814.GB6477@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 2/13/19 3:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> XFS had a use-after-free bug when xfs_xattr_put_listent runs out of
> listxattr buffer space while trying to store the name
> "system.posix_acl_access" and then corrupts memory by not checking the
> seen_enough state and then trying to shove "trusted.SGI_ACL_FILE" into
> the buffer as well.
> 
> In order to tickle the bug in a user visible way we must have already
> put a name in the buffer, so we take advantage of the fact that
> "security.evm" sorts before "system.posix_acl_access" to make sure this
> happens.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

[...]

> +
> +int main(int argc, char *argv[])
> +{
> +	struct myacl acl = {
> +		.d = 2,
> +		.e = {
> +			{1, 0, 0},
> +			{4, 0, 0},
> +			{0x10, 0, 0},
> +			{0x20, 0, 0},
> +		},
> +	};
> +	char buf[64];
> +	ssize_t sz;
> +	int fd;
> +	int ret;
> +
> +	if (argc > 1) {
> +		ret = chdir(argv[1]);
> +		if (ret)
> +			die(argv[1]);
> +	}
> +
> +	fd = creat("file0", 0644);
> +	if (fd < 0)
> +		die("create");
> +
> +	ret = fsetxattr(fd, "system.posix_acl_access", &acl, sizeof(acl), 0);
> +	if (ret)
> +		die("set posix acl");
> +
> +	ret = fsetxattr(fd, "security.evm", buf, 1, 1);
> +	if (ret)
> +		die("set evm");

How is this working on your test system?  The EVM xattr is a formatted
structure and this is passing it an uninitialized buffer.  It *should*
return EPERM and on our test systems it is.

Using security.capability will sort before system.posix_acl_access and
accepts unformatted contents.

-Jeff

> +	sz = flistxattr(fd, buf, 30);
> +	if (sz < 0)
> +		die("list attr");
> +
> +	printf("%s\n", buf);
> +
> +	return 0;
> +
> +#if 0
> +	/* original syzkaller reproducer */
> +
> +	syscall(__NR_mmap, 0x20000000, 0x1000000, 3, 0x32, -1, 0);
> +
> +	memcpy((void*)0x20000180, "./file0", 8);
> +	syscall(__NR_creat, 0x20000180, 0);
> +	memcpy((void*)0x20000000, "./file0", 8);
> +	memcpy((void*)0x20000040, "system.posix_acl_access", 24);
> +	*(uint32_t*)0x20000680 = 2;
> +	*(uint16_t*)0x20000684 = 1;
> +	*(uint16_t*)0x20000686 = 0;
> +	*(uint32_t*)0x20000688 = 0;
> +	*(uint16_t*)0x2000068c = 4;
> +	*(uint16_t*)0x2000068e = 0;
> +	*(uint32_t*)0x20000690 = 0;
> +	*(uint16_t*)0x20000694 = 0x10;
> +	*(uint16_t*)0x20000696 = 0;
> +	*(uint32_t*)0x20000698 = 0;
> +	*(uint16_t*)0x2000069c = 0x20;
> +	*(uint16_t*)0x2000069e = 0;
> +	*(uint32_t*)0x200006a0 = 0;
> +	syscall(__NR_setxattr, 0x20000000, 0x20000040, 0x20000680, 0x24, 0);
> +	memcpy((void*)0x20000080, "./file0", 8);
> +	memcpy((void*)0x200000c0, "security.evm", 13);
> +	memcpy((void*)0x20000100, "\x03\x00\x00\x00\x57", 5);
> +	syscall(__NR_lsetxattr, 0x20000080, 0x200000c0, 0x20000100, 1, 1);
> +	memcpy((void*)0x20000300, "./file0", 8);
> +	syscall(__NR_listxattr, 0x20000300, 0x200002c0, 0x1e);
> +	return 0;
> +#endif
> +}



-- 
Jeff Mahoney
SUSE Labs
