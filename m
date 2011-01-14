Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ENnUVO114021 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 17:49:30 -0600
Date: Fri, 14 Jan 2011 17:50:56 -0600
From: bpm@sgi.com
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110114235056.GP28274@sgi.com>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110114214334.GN28274@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 14, 2011 at 03:43:34PM -0600, bpm@sgi.com wrote:
> On Fri, Jan 14, 2011 at 11:29:00AM +1100, Dave Chinner wrote:
> > I've noticed a few suspicious things trying to reproduce the
> > allocate-in-the-middle-of-a-delalloc-extent,
> ...
> > Secondly, I think we have the same expose-the-entire-delalloc-extent
> > -to-stale-data-exposure problem in ->writepage. This onnne, however,
> > is due to using BMAPI_ENTIRE to allocate the entire delalloc extent
> > the first time any part of it is written to. Even if we are only
> > writing a single page (i.e. wbc->nr_to_write = 1) and the delalloc
> > extent covers gigabytes. So, same problem when we crash.
> >
> > Finally, I think the extsize based problem exposed by test 229 is a
> > also a result of allocating space we have no pages covering in the
> > page cache (triggered by BMAPI_ENTIRE allocation) so the allocated
> > space is never zeroed and hence exposes stale data.
> 
> This is precisely the bug I was going after when I hit the
> allocate-in-the-middle-of-a-delalloc-extent bug.  This is a race between
> block_prepare_write/__xfs_get_blocks and writepage/xfs_page_state
> convert.  When xfs_page_state_convert allocates a real extent for a page
> toward the beginning of a delalloc extent, XFS_BMAPI converts the entire
> delalloc extent.  Any subsequent writes into the page cache toward the
> end of this freshly allocated extent will see a written extent instead
> of delalloc and read the block from disk into the page before writing
> over it.  If the write does not cover the entire page garbage from disk
> will be exposed into the page cache.

Here is a test case to reproduce the corruption.  I have only been able
to reproduce it by writing the file on an nfs client served from xfs
that is allocating large delalloc extents.

-Ben

*** the writer

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int
main(int argc, char *argv[]) {

	char *filename = argv[1];
	off_t	seekdist = 3071;	/* less than a page, nice and odd */
	off_t	max_offset = 1024 * 1024 * 1024; /* 1 gig */
	off_t 	current_offset = 0;
	char	buf[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n";
	int	fd;

	printf("writing to %s\n", filename);
	printf("strlen is %d\n", strlen(buf));

	fd = open(filename, O_RDWR|O_CREAT, 0644);
	if (fd == -1) {
		perror(filename);
		return -1;
	}

	while ((current_offset = lseek(fd, seekdist, SEEK_END)) > 0
			&& current_offset < max_offset) {
		if (write(fd, &buf, strlen(buf)) < strlen(buf)) {
			perror("write 'a'");
			return -1;
		}
	}

	close(fd);
}

*** the reader

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int
main(int argc, char *argv[]) {

	char *filename = argv[1];
	off_t	seekdist = 3071;	/* less than a page, nice and odd */
	off_t	max_offset = 1024 * 1024 * 1024; /* 1 gig */
	off_t 	current_offset = 0;
	char	buf[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n";
	char	readbuf[4096];
	int	fd, i;

	printf("reading from %s\n", filename);

	fd = open(filename, O_RDONLY, 0644);
	if (fd == -1) {
		perror(filename);
		return -1;
	}
	
	while (current_offset < max_offset) {
		ssize_t nread = read(fd, &readbuf, seekdist);
		if (nread != seekdist) {
			perror("read nulls");
			return -1;
		}
		for (i=0; i < seekdist; i++) {
			if (readbuf[i] != '\0') {
				printf("foudn non-null at %d\n%s\n",
						current_offset + i,
						&readbuf[i]);
				break;
//				return -1;
			}
		}
		
		current_offset += nread;

		nread = read(fd, &readbuf, strlen(buf));
		if (nread != strlen(buf)) {
			perror("read a");
			return -1;
		}

		if (strncmp(readbuf, buf, strlen(buf))) {
			printf("didn't match at %d\n%s\n",
					current_offset + nread,
					readbuf);
//			return -1;
		}

		current_offset += nread;
	}	

	close(fd);
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
