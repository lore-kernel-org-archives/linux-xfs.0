Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF6BB7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 13:38:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5CE8EAC002
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 11:38:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 16xBieNYQSGgICCL for
	<xfs@oss.sgi.com>; Mon, 15 Jul 2013 11:38:47 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6FIckX9005251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 14:38:46 -0400
Date: Mon, 15 Jul 2013 11:38:45 -0700
From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH] xfsprogs/io: add getdents command
Message-ID: <20130715183845.GS25414@lenny.home.zabbo.net>
References: <1373567034-7534-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373567034-7534-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

> +ifeq ($(PKG_PLATFORM),linux)
> +CFILES += getdents.c
> +endif

I'd make a real test for getdents() rather than tying it to Linux.  Just
copy what's done for sync_file_range :). 

> +struct linux_dirent {
> +	unsigned long	d_ino;     /* Inode number */
> +	unsigned long	d_off;     /* Offset to next linux_dirent */
> +	unsigned short	d_reclen;  /* Length of this linux_dirent */
> +	char		d_name[];  /* Filename (null-terminated) */
> +};

If we're only going to use one syscall interface, I'd use getdents64().

struct linux_dirent64 {
        u64             d_ino;
        s64             d_off;
        unsigned short  d_reclen;
        unsigned char   d_type;
        char            d_name[0];
};      

But it could also be useful to see the native 'long' interface for 32bit
apps, though, say if you're trying to debug ext4 htree d_off values
which are magically truncated for 32bit compat tasks.

> +static void
> +dump_dir_buffer(
> +	struct linux_dirent *dirp,
> +	long long offset,
> +	long long length)
> +{
> +	while (length > 0) {
> +		printf("%08llx: 0x%lx (%s)\n",
> +			offset, dirp->d_ino, dirp->d_name);
> +
> +		offset = dirp->d_off;
> +		length -= dirp->d_reclen;
> +
> +		dirp = (struct linux_dirent *) ((char *) dirp + dirp->d_reclen);
> +	}
> +}

You could also print out d_type.  In getdents64() it's a proper struct
member, in the bad old 'long' interface it's hidden in padding after the
null in d_name.

It'd be nice to see d_off for the last entry.  btrfs, for example, sets
it to CRAZY and that can be good to know.  In the past it has caused
32bit glibc to return -EOVERFLOW when reading entries from getdents64()
whose d_off overflowed 32bit off_t.

Interestingly, notice that with getdents() you don't know what the
offset of the first entry is.  You just know the offset that you started
reading from and the offset of the next entry.

- z
(*throws another bag of nickels in the readdir-design-disaster jar*)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
