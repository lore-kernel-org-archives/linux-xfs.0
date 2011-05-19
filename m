Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4JBCC55031631 for <xfs@oss.sgi.com>; Thu, 19 May 2011 06:12:12 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1785469342
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 04:12:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bIN61C3ddq5bL93P for <xfs@oss.sgi.com>;
	Thu, 19 May 2011 04:12:09 -0700 (PDT)
Date: Thu, 19 May 2011 21:12:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests:Make 225 compare map and fiemap at each block.
Message-ID: <20110519111205.GI32466@dastard>
References: <1305789665-32743-1-git-send-email-xiaoqiangnk@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1305789665-32743-1-git-send-email-xiaoqiangnk@gmail.com>
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
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org, josef@redhat.com, xfs@oss.sgi.com

On Thu, May 19, 2011 at 03:21:05PM +0800, Yongqiang Yang wrote:
> Due to my carelessness, I induced a ugly patch to ext4's fiemap, but
> 225 could not find it.  So I looked into the 225 and could not figure out
> logic in compare_map_and_fiemap(), which seemed to mix extents with
> blocks.  Then I made 225 compare map and fiemap at each block, the new
> 225 can find another bug in ext4 with 1k block.
> 
> The new 225 works well on ext3, ext4 and xfs with both 1K and 4K block.

The change log could do with some work. What cases did 225 not
cover, what new cases does it cover, what are the impacts of the
change, what bugs were fixed, etc. "I didn't understand the existing
code so I rewrote it" isn't very useful to someone trying to
understand why the changes were made in a couple of years time....

> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> v1->v2:
> Josef <josef@redhat.com> reviewed the v1 patch and pointed out the bug which
> made xfs not work and several coding styles.
> 
> According to reply from Josef, I
>  fixed the bug which added ';' after an if statement.
>  removed the trailing whitespace.
> 
> Apart from things above, I
>  made check_weird_fs_hole() verify bytes read by pread().
> 
>  src/fiemap-tester.c |  251 ++++++++++++++++++++++++++++-----------------------
>  1 files changed, 140 insertions(+), 111 deletions(-)
> 
> diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
> index 1663f84..319a9bb 100644
> --- a/src/fiemap-tester.c
> +++ b/src/fiemap-tester.c
> @@ -14,6 +14,9 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program; if not, write the Free Software Foundation,
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Compare map and fiemap at each block,
> + * Yongqiang Yang <xiaoqiangnk@gmail.com>, 2011
>   */

Changelogs belong in the repository commit message, not the code.

>  #include <stdio.h>
> @@ -57,7 +60,7 @@ generate_file_mapping(int blocks, int prealloc)
>  	int num_types = 2, cur_block = 0;
>  	int i = 0;
>  
> -	map = malloc(sizeof(char) * blocks);
> +	map = malloc(sizeof(char) * (blocks + 1));

What is the bug this is fixing? Nothing in the change log tells me
why this is being done....

>  	if (!map)
>  		return NULL;
>  
> @@ -81,6 +84,7 @@ generate_file_mapping(int blocks, int prealloc)
>  		cur_block++;
>  	}
>  
> +	map[blocks] = 0;

Why is this necessary?

>  	return map;
>  }
>  
> @@ -247,55 +251,36 @@ check_flags(struct fiemap *fiemap, int blocksize)
>  }
>  
>  static int
> -check_data(struct fiemap *fiemap, __u64 logical_offset, int blocksize,
> +check_data(struct fiemap_extent *extent ,  __u64 logical_offset, int blocksize,
>  	   int last, int prealloc)

Perhaps adding a comment explaing what the function is actually
checking is in order seeing as you just changed it...

....
> @@ -306,7 +291,7 @@ static int
>  check_weird_fs_hole(int fd, __u64 logical_offset, int blocksize)
>  {
>  	static int warning_printed = 0;
> -	int block, i;
> +	int block, i, count;
>  	size_t buf_len = sizeof(char) * blocksize;
>  	char *buf;
>  
> @@ -330,15 +315,16 @@ check_weird_fs_hole(int fd, __u64 logical_offset, int blocksize)
>  		return -1;
>  	}
>  
> -	if (pread(fd, buf, buf_len, (off_t)logical_offset) < 0) {
> +	count = pread(fd, buf, buf_len, (off_t)logical_offset);
> +	if (count < 0) {
>  		perror("Error reading from file");
>  		free(buf);
>  		return -1;
>  	}
>  
> -	for (i = 0; i < buf_len; i++) {
> +	for (i = 0; i < count; i++) {

What bug in the test is this fixing?  Surely a short read indicates
a filesystem problem? Only checking the bytes returned instead of
the entire hole region will hide the fact that the read didn't cover
the range that was asked for and so we haven't validated the entire
region we were supposed to...

> @@ -370,35 +356,25 @@ check_weird_fs_hole(int fd, __u64 logical_offset, int blocksize)
>  }
>  
>  static int
> -check_hole(struct fiemap *fiemap, int fd, __u64 logical_offset, int blocksize)
> +check_hole(struct fiemap_extent *extent, int fd, __u64 logical_offset,
> +	   int blocksize)
>  {

Same issue with adding a comment explaining what is being
checked....

> -	struct fiemap_extent *extent;
> -	int c;
> +	__u64 start, end;
>  
> -	for (c = 0; c < fiemap->fm_mapped_extents; c++) {
> -		__u64 start, end;
> -		extent = &fiemap->fm_extents[c];
> -
> -		start = extent->fe_logical;
> -		end = extent->fe_logical + extent->fe_length;
> -
> -		if (logical_offset > end)
> -			continue;
> -		if (logical_offset + blocksize < start)
> -			break;
> +	start = extent->fe_logical;
> +	end = extent->fe_logical + extent->fe_length;
>  
> -		if (logical_offset >= start &&
> -		    logical_offset < end) {
> +	if (logical_offset >= start &&
> +	    logical_offset < end) {
>  
> -			if (check_weird_fs_hole(fd, logical_offset,
> -						blocksize) == 0)
> -				break;
> +		if (check_weird_fs_hole(fd, logical_offset,
> +					blocksize) == 0)
> +			return 0;

		error = check_weird_fs_hole(fd, logical_offset,
						blocksize);
		if (error == 0)
			return 0;

> @@ -423,9 +399,11 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
>  {
>  	struct fiemap *fiemap;
>  	char *fiebuf;
> -	int blocks_to_map, ret, cur_extent = 0, last_data;
> +	int blocks_to_map, ret, last_data = -1;
>  	__u64 map_start, map_length;
>  	int i, c;
> +	int cur_block = 0;
> +	int last_found = 0;
>  
>  	if (query_fiemap_count(fd, blocks, blocksize) < 0)
>  		return -1;
> @@ -451,8 +429,11 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
>  	fiemap->fm_extent_count = blocks_to_map;
>  	fiemap->fm_mapped_extents = 0;
>  
> +	/* check fiemap by looking at each block. */
>  	do {
> -		fiemap->fm_start = map_start;
> +		int nr_extents;
> +
> +		fiemap->fm_start = cur_block * blocksize;
>  		fiemap->fm_length = map_length;
>  
>  		ret = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> @@ -465,45 +446,93 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
>  		if (check_flags(fiemap, blocksize))
>  			goto error;
>  
> -		for (i = cur_extent, c = 1; i < blocks; i++, c++) {
> -			__u64 logical_offset = i * blocksize;
> -
> -			if (c > fiemap->fm_mapped_extents) {
> -				i++;
> -				break;
> +		nr_extents = fiemap->fm_mapped_extents;
> +		if (nr_extents == 0) {
> +			int block = cur_block + (map_length - 1) / blocksize;
> +			for (; cur_block <= block &&
> +			       cur_block < blocks; cur_block++) {
> +				/* check hole */
> +				if (map[cur_block] != 'H') {
> +					printf("ERROR: map[%d] should not be "
> +					       "a hole\n", cur_block);
> +					goto error;
> +				}
>  			}
> +			continue;
> +		}
>  
> -			switch (map[i]) {
> -			case 'D':
> -				if (check_data(fiemap, logical_offset,
> -					       blocksize, last_data == i, 0))
> +		for (c = 0; c < nr_extents; c++) {
> +			__u64 offset;
> +			int block;
> +			struct fiemap_extent *extent;
> +
> +
> +			extent = &fiemap->fm_extents[c];
> +			offset = extent->fe_logical;
> +			block = offset / blocksize;
> +
> +			/* check hole. */
> +			for (; cur_block < block && cur_block < blocks;
> +			     cur_block++) {
> +				if (map[cur_block] != 'H') {
> +					printf("ERROR: map[%d] should not be "
> +					       "a hole\n", cur_block);
>  					goto error;
> -				break;
> -			case 'H':
> -				if (check_hole(fiemap, fd, logical_offset,
> -					       blocksize))
> +				}
> +			}
> +
> +			offset = extent->fe_logical + extent->fe_length;
> +			block = offset / blocksize;
> +			/* check data */
> +			for (; cur_block < block && cur_block < blocks;
> +			     cur_block++) {
> +				int last;
> +				offset = (__u64)cur_block * blocksize;
> +				last = (cur_block == last_data);
> +				last_found = last_found ? last_found : last;
> +				switch (map[cur_block]) {
> +				case 'D':
> +					if (check_data(extent, offset,
> +						       blocksize, last, 0))
> +						goto error;
> +					break;
> +				case 'H':
> +					if (check_hole(extent, fd, offset,
> +						       blocksize))
> +						goto error;
> +					break;
> +
> +				case 'P':
> +					if (check_data(extent, offset,
> +						       blocksize, last, 1))
> +						goto error;
> +					break;
> +				default:
> +					printf("ERROR: weird value in "
> +					       "map: %c\n", map[i]);
>  					goto error;
> -				break;
> -			case 'P':
> -				if (check_data(fiemap, logical_offset,
> -					       blocksize, last_data == i, 1))
> +				}
> +			}
> +
> +			for (; cur_block < block; cur_block++) {
> +				offset = (__u64)cur_block * blocksize;
> +				if (check_hole(extent, fd, offset, blocksize))
>  					goto error;
> -				break;
> -			default:
> -				printf("ERROR: weird value in map: %c\n",
> -				       map[i]);
> -				goto error;
>  			}
>  		}
> -		cur_extent = i;
> -		map_start = i * blocksize;
> -	} while (cur_extent < blocks);
> +	} while (cur_block < blocks);
>  
> -	ret = 0;
> -	return ret;
> +	if (!last_found && last_data != -1) {
> +		printf("ERROR: find no last extent\n");
> +		goto error;
> +	}
> +
> +	free(fiebuf);
> +	return 0;
>  error:
>  	printf("map is '%s'\n", map);
>  	show_extents(fiemap, blocksize);
> +	free(fiebuf);
>  	return -1;
>  }

I can't say I like this - the previous way of iterating the map and
checking that the overlapping fiemap extent is of the correct type
seems much simpler to me.

Your code now has to special case fiemaps with nr_extents == 0, has
to handle holes separately both before and after data extents and
adds a bunch of duplicated code. I find it much harder to follow,
and I don't see how rewriting the code like this makes the test
better. Especially as it doesn't tell me what the problems with the
original code were that you've supposedly fixed...

>  
> @@ -605,6 +634,18 @@ main(int argc, char **argv)
>  		printf("Starting infinite run, if you don't see any output "
>  		       "then its working properly.\n");
>  	do {
> +		if (ftruncate(fd, 0)) {
> +			perror("Could not truncate file\n");
> +			close(fd);
> +			exit(1);
> +		}
> +
> +		if (lseek(fd, 0, SEEK_SET)) {
> +			perror("Could not seek set\n");
> +			close(fd);
> +			exit(1);
> +		}
> +
>  		if (!map) {
>  			blocks = random() % maxblocks;
>  			if (blocks == 0) {
> @@ -639,18 +680,6 @@ main(int argc, char **argv)
>  		free(map);
>  		map = NULL;
>  
> -		if (ftruncate(fd, 0)) {
> -			perror("Could not truncate file\n");
> -			close(fd);
> -			exit(1);
> -		}
> -
> -		if (lseek(fd, 0, SEEK_SET)) {
> -			perror("Could not seek set\n");
> -			close(fd);
> -			exit(1);
> -		}
> -
>  		if (runs) runs--;
>  	} while (runs != 0);

What bug is this fixing? There's Nothing in the changelog....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
