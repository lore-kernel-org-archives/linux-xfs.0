Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FC4B7F8E
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 07:53:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 823D3AC001
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 05:53:39 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	m3kRUoYQEr9ksBEb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 05:53:36 -0700 (PDT)
Received: by wiax7 with SMTP id x7so54679167wia.0
	for <xfs@oss.sgi.com>; Thu, 09 Apr 2015 05:53:35 -0700 (PDT)
Received: from sys953.ldn.framestore.com (firewall.framestore.com.
	[193.203.83.19])
	by mx.google.com with ESMTPSA id gj7sm7107778wib.4.2015.04.09.05.53.34
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 09 Apr 2015 05:53:34 -0700 (PDT)
Date: Thu, 9 Apr 2015 13:53:31 +0100 (BST)
From: Mark Hills <mark.hills@framestore.com>
Subject: Errors from basic open_by_handle operations
Message-ID: <1504091316590.18609@sys953.ldn.framestore.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

I am having troubles with elementary file handle functions in libhandle.

A basic open_by_handle is giving "Bad file descriptor".

But I am suspicious of a side effect; using path_to_fshandle earlier in 
the program changes these errors to "Operation not permitted".

Is there a basic mistake in my use of these calls, or a bug/unmaintained 
code?

I am on an XFS filesystem (otherwise the first call fails with 
'inappropriate ioctl'). The only documentation I can find is the man page; 
no mention about initialising the library, and I wasn't able to find any 
examples.

I'm on Scientific Linux 6.6 (like RedHat 6, kernel 2.6.32-504.1.3), and 
also tried updating to the latest xfsprogs from Git, with the same 
results.

Many thanks

-- 
Mark


$ ./test-xfs ~/scratch/tmp/xfs/file.c; echo $?
Handle 24 bytes: bd2c94ba959858e0000000870000000
readlink_by_handle: Bad file descriptor
open_by_handle: Bad file descriptor
0


$ ./test-xfs ~/scratch/tmp/xfs/file.c; echo $?
Handle 8 bytes: bd2c94ba959858
Handle 24 bytes: bd2c94ba959858e0000000870000000
readlink_by_handle: Operation not permitted
open_by_handle: Operation not permitted
0


/*
 * xfs file handle test
 *
 * compile with: gcc -o test-xfs test-xfs.c -lhandle -Wall
 */

#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <xfs/handle.h>

static void dump(FILE *f, void *m, size_t len)
{
	fprintf(f, "Handle %zu bytes: ", len);

	while (len--) {
		fprintf(f, "%hhx", *(unsigned char*)m);
		m++;
	}

	putchar('\n');
}

int main(int argc, char *argv[])
{
	int fd;
	char *pathname;
	void *hanp = NULL;
	size_t hlen;
	char buf[PATH_MAX];

	pathname = argv[1];

#if 0
	/*
	 * Switching this section on changes changes the
	 * errors from the later calls
	 */

	if (path_to_fshandle(pathname, &hanp, &hlen) == -1) {
		perror("path_to_fshandle");
		return -1;
	}

	dump(stderr, hanp, hlen);

	free_handle(hanp, hlen);
#endif

	if (path_to_handle(pathname, &hanp, &hlen) == -1) {
		perror("path_to_handle");
		return -1;
	}

	dump(stderr, hanp, hlen);

        /*
	 * The above calls were successful, but the next part always
	 * fails
	 */

	if (readlink_by_handle(hanp, hlen, buf, sizeof buf) == -1)
		perror("readlink_by_handle");
	else
		printf("Link: %s\n", buf);

	fd = open_by_handle(hanp, hlen, O_RDONLY);
	if (fd == -1) {
		perror("open_by_handle");
	} else {
		if (close(fd) == -1)
			abort();
	}

	free_handle(hanp, hlen);

	return 0;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
