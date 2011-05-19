Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4J7O38u023126 for <xfs@oss.sgi.com>; Thu, 19 May 2011 02:24:03 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BE824689B6
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 00:24:01 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id mFaD5jmEsyHNpq05
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 00:24:01 -0700 (PDT)
Received: by vws13 with SMTP id 13so1888742vws.26
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 00:24:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305789665-32743-1-git-send-email-xiaoqiangnk@gmail.com>
References: <1305789665-32743-1-git-send-email-xiaoqiangnk@gmail.com>
Date: Thu, 19 May 2011 15:24:01 +0800
Message-ID: <BANLkTi=g0L5qjoOiWXoZqE6V+_ueSRLCrg@mail.gmail.com>
Subject: Re: [PATCH v2] xfstests:Make 225 compare map and fiemap at each block.
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: josef@redhat.com
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Hi Josef,

I updated the patch, if you think it is ok now and 'Reviewed-by: Josef
<josef@redhat.com>' can be added, please throw a word to Eric.

Yongqiang.

On Thu, May 19, 2011 at 3:21 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wro=
te:
> Due to my carelessness, I induced a ugly patch to ext4's fiemap, but
> 225 could not find it. =A0So I looked into the 225 and could not figure o=
ut
> logic in compare_map_and_fiemap(), which seemed to mix extents with
> blocks. =A0Then I made 225 compare map and fiemap at each block, the new
> 225 can find another bug in ext4 with 1k block.
>
> The new 225 works well on ext3, ext4 and xfs with both 1K and 4K block.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> v1->v2:
> Josef <josef@redhat.com> reviewed the v1 patch and pointed out the bug wh=
ich
> made xfs not work and several coding styles.
>
> According to reply from Josef, I
> =A0fixed the bug which added ';' after an if statement.
> =A0removed the trailing whitespace.
>
> Apart from things above, I
> =A0made check_weird_fs_hole() verify bytes read by pread().
>
> =A0src/fiemap-tester.c | =A0251 ++++++++++++++++++++++++++++-------------=
----------
> =A01 files changed, 140 insertions(+), 111 deletions(-)
>
> diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
> index 1663f84..319a9bb 100644
> --- a/src/fiemap-tester.c
> +++ b/src/fiemap-tester.c
> @@ -14,6 +14,9 @@
> =A0* You should have received a copy of the GNU General Public License
> =A0* along with this program; if not, write the Free Software Foundation,
> =A0* Inc., =A051 Franklin St, Fifth Floor, Boston, MA =A002110-1301 =A0USA
> + *
> + * Compare map and fiemap at each block,
> + * Yongqiang Yang <xiaoqiangnk@gmail.com>, 2011
> =A0*/
>
> =A0#include <stdio.h>
> @@ -57,7 +60,7 @@ generate_file_mapping(int blocks, int prealloc)
> =A0 =A0 =A0 =A0int num_types =3D 2, cur_block =3D 0;
> =A0 =A0 =A0 =A0int i =3D 0;
>
> - =A0 =A0 =A0 map =3D malloc(sizeof(char) * blocks);
> + =A0 =A0 =A0 map =3D malloc(sizeof(char) * (blocks + 1));
> =A0 =A0 =A0 =A0if (!map)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;
>
> @@ -81,6 +84,7 @@ generate_file_mapping(int blocks, int prealloc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_block++;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 map[blocks] =3D 0;
> =A0 =A0 =A0 =A0return map;
> =A0}
>
> @@ -247,55 +251,36 @@ check_flags(struct fiemap *fiemap, int blocksize)
> =A0}
>
> =A0static int
> -check_data(struct fiemap *fiemap, __u64 logical_offset, int blocksize,
> +check_data(struct fiemap_extent *extent , =A0__u64 logical_offset, int b=
locksize,
> =A0 =A0 =A0 =A0 =A0 int last, int prealloc)
> =A0{
> - =A0 =A0 =A0 struct fiemap_extent *extent;
> - =A0 =A0 =A0 __u64 orig_offset =3D logical_offset;
> - =A0 =A0 =A0 int c, found =3D 0;
> -
> - =A0 =A0 =A0 for (c =3D 0; c < fiemap->fm_mapped_extents; c++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 start, end;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 extent =3D &fiemap->fm_extents[c];
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D extent->fe_logical;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D extent->fe_logical + extent->fe_len=
gth;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset > end)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset + blocksize < start)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset >=3D start &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical_offset < end) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (prealloc &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !(extent->fe_flags =
& FIEMAP_EXTENT_UNWRITTEN)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERR=
OR: preallocated extent is not "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0"marked with FIEMAP_EXTENT_UNWRITTEN: "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0"%llu\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0(unsigned long long)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0(start / blocksize));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset + blocks=
ize > end) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical_off=
set =3D end+1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 found =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 int found =3D 0;
> + =A0 =A0 =A0 __u64 start, end;
> +
> + =A0 =A0 =A0 start =3D extent->fe_logical;
> + =A0 =A0 =A0 end =3D extent->fe_logical + extent->fe_length;
> +
> + =A0 =A0 =A0 if (logical_offset >=3D start &&
> + =A0 =A0 =A0 =A0 =A0 logical_offset < end) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (prealloc &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !(extent->fe_flags & FIEMAP_EXTENT_=
UNWRITTEN)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERROR: preallocated=
 extent is not "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"marked with=
 FIEMAP_EXTENT_UNWRITTEN: "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"%llu\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned lo=
ng long)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(start / blo=
cksize));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 found =3D 1;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (!found) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("ERROR: couldn't find extent at %ll=
u\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)(orig_of=
fset / blocksize));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)(logical=
_offset / blocksize));
> =A0 =A0 =A0 =A0} else if (last &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!(fiemap->fm_extents[c].fe_flags & F=
IEMAP_EXTENT_LAST)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!(extent->fe_flags & FIEMAP_EXTENT_L=
AST)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("ERROR: last extent not marked as l=
ast: %llu\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)(orig_of=
fset / blocksize));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)(logical=
_offset / blocksize));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0found =3D 0;
> =A0 =A0 =A0 =A0}
>
> @@ -306,7 +291,7 @@ static int
> =A0check_weird_fs_hole(int fd, __u64 logical_offset, int blocksize)
> =A0{
> =A0 =A0 =A0 =A0static int warning_printed =3D 0;
> - =A0 =A0 =A0 int block, i;
> + =A0 =A0 =A0 int block, i, count;
> =A0 =A0 =A0 =A0size_t buf_len =3D sizeof(char) * blocksize;
> =A0 =A0 =A0 =A0char *buf;
>
> @@ -330,15 +315,16 @@ check_weird_fs_hole(int fd, __u64 logical_offset, i=
nt blocksize)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (pread(fd, buf, buf_len, (off_t)logical_offset) < 0) {
> + =A0 =A0 =A0 count =3D pread(fd, buf, buf_len, (off_t)logical_offset);
> + =A0 =A0 =A0 if (count < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror("Error reading from file");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free(buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 for (i =3D 0; i < buf_len; i++) {
> + =A0 =A0 =A0 for (i =3D 0; i < count; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (buf[i] !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERROR: FIEMAP claim=
ed there was data (%c) at "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERROR: FIEMAP claim=
ed there was data (%x) at "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "block %llu t=
hat should have been a hole, and "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "FIBMAP confi=
rmed that it was allocated, but "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "it should be=
 filled with 0's, but it was not "
> @@ -370,35 +356,25 @@ check_weird_fs_hole(int fd, __u64 logical_offset, i=
nt blocksize)
> =A0}
>
> =A0static int
> -check_hole(struct fiemap *fiemap, int fd, __u64 logical_offset, int bloc=
ksize)
> +check_hole(struct fiemap_extent *extent, int fd, __u64 logical_offset,
> + =A0 =A0 =A0 =A0 =A0int blocksize)
> =A0{
> - =A0 =A0 =A0 struct fiemap_extent *extent;
> - =A0 =A0 =A0 int c;
> + =A0 =A0 =A0 __u64 start, end;
>
> - =A0 =A0 =A0 for (c =3D 0; c < fiemap->fm_mapped_extents; c++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 start, end;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 extent =3D &fiemap->fm_extents[c];
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D extent->fe_logical;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D extent->fe_logical + extent->fe_len=
gth;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset > end)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset + blocksize < start)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 start =3D extent->fe_logical;
> + =A0 =A0 =A0 end =3D extent->fe_logical + extent->fe_length;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset >=3D start &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical_offset < end) {
> + =A0 =A0 =A0 if (logical_offset >=3D start &&
> + =A0 =A0 =A0 =A0 =A0 logical_offset < end) {
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_weird_fs_hole(fd,=
 logical_offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 blocksize) =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_weird_fs_hole(fd, logical_offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 blocksize) =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERROR: found an all=
ocated extent where a hole "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"should be: =
%llu\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned lo=
ng long)(start / blocksize));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERROR: found an allocated extent wh=
ere a hole "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"should be: %llu\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)(logical=
_offset / blocksize));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0return 0;
> @@ -423,9 +399,11 @@ compare_fiemap_and_map(int fd, char *map, int blocks=
, int blocksize, int syncfil
> =A0{
> =A0 =A0 =A0 =A0struct fiemap *fiemap;
> =A0 =A0 =A0 =A0char *fiebuf;
> - =A0 =A0 =A0 int blocks_to_map, ret, cur_extent =3D 0, last_data;
> + =A0 =A0 =A0 int blocks_to_map, ret, last_data =3D -1;
> =A0 =A0 =A0 =A0__u64 map_start, map_length;
> =A0 =A0 =A0 =A0int i, c;
> + =A0 =A0 =A0 int cur_block =3D 0;
> + =A0 =A0 =A0 int last_found =3D 0;
>
> =A0 =A0 =A0 =A0if (query_fiemap_count(fd, blocks, blocksize) < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
> @@ -451,8 +429,11 @@ compare_fiemap_and_map(int fd, char *map, int blocks=
, int blocksize, int syncfil
> =A0 =A0 =A0 =A0fiemap->fm_extent_count =3D blocks_to_map;
> =A0 =A0 =A0 =A0fiemap->fm_mapped_extents =3D 0;
>
> + =A0 =A0 =A0 /* check fiemap by looking at each block. */
> =A0 =A0 =A0 =A0do {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fiemap->fm_start =3D map_start;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int nr_extents;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fiemap->fm_start =3D cur_block * blocksize;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fiemap->fm_length =3D map_length;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ioctl(fd, FS_IOC_FIEMAP, (unsigned=
 long)fiemap);
> @@ -465,45 +446,93 @@ compare_fiemap_and_map(int fd, char *map, int block=
s, int blocksize, int syncfil
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (check_flags(fiemap, blocksize))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D cur_extent, c =3D 1; i < blocks;=
 i++, c++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 logical_offset =3D i =
* blocksize;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (c > fiemap->fm_mapped_e=
xtents) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_extents =3D fiemap->fm_mapped_extents;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nr_extents =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int block =3D cur_block + (=
map_length - 1) / blocksize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; cur_block <=3D block=
 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_block < =
blocks; cur_block++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check ho=
le */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map[cur=
_block] !=3D 'H') {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 printf("ERROR: map[%d] should not be "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0"a hole\n", cur_block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (map[i]) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'D':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_d=
ata(fiemap, logical_offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0blocksize, last_data =3D=3D i, 0))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (c =3D 0; c < nr_extents; c++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int block;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct fiemap_extent *exten=
t;
> +
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extent =3D &fiemap->fm_exte=
nts[c];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D extent->fe_logic=
al;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D offset / blocksiz=
e;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check hole. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; cur_block < block &&=
 cur_block < blocks;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_block++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map[cur=
_block] !=3D 'H') {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 printf("ERROR: map[%d] should not be "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0"a hole\n", cur_block);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0goto error;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'H':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_h=
ole(fiemap, fd, logical_offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0blocksize))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D extent->fe_logic=
al + extent->fe_length;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D offset / blocksiz=
e;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check data */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; cur_block < block &&=
 cur_block < blocks;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_block++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int last;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D =
(__u64)cur_block * blocksize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 last =3D (c=
ur_block =3D=3D last_data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 last_found =
=3D last_found ? last_found : last;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (map=
[cur_block]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'D':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (check_data(extent, offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocksize, last, 0))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'H':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (check_hole(extent, fd, offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocksize))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'P':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (check_data(extent, offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocksize, last, 1))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 printf("ERROR: weird value in "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0"map: %c\n", map[i]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0goto error;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'P':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_d=
ata(fiemap, logical_offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0blocksize, last_data =3D=3D i, 1))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; cur_block < block; c=
ur_block++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D =
(__u64)cur_block * blocksize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_h=
ole(extent, fd, offset, blocksize))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0goto error;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERR=
OR: weird value in map: %c\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0map[i]);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_extent =3D i;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 map_start =3D i * blocksize;
> - =A0 =A0 =A0 } while (cur_extent < blocks);
> + =A0 =A0 =A0 } while (cur_block < blocks);
>
> - =A0 =A0 =A0 ret =3D 0;
> - =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 if (!last_found && last_data !=3D -1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERROR: find no last extent\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 free(fiebuf);
> + =A0 =A0 =A0 return 0;
> =A0error:
> =A0 =A0 =A0 =A0printf("map is '%s'\n", map);
> =A0 =A0 =A0 =A0show_extents(fiemap, blocksize);
> + =A0 =A0 =A0 free(fiebuf);
> =A0 =A0 =A0 =A0return -1;
> =A0}
>
> @@ -605,6 +634,18 @@ main(int argc, char **argv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("Starting infinite run, if you don'=
t see any output "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "then its working properly.\n=
");
> =A0 =A0 =A0 =A0do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ftruncate(fd, 0)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 perror("Could not truncate =
file\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 close(fd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit(1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (lseek(fd, 0, SEEK_SET)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 perror("Could not seek set\=
n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 close(fd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit(1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!map) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocks =3D random() % maxb=
locks;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (blocks =3D=3D 0) {
> @@ -639,18 +680,6 @@ main(int argc, char **argv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free(map);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map =3D NULL;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ftruncate(fd, 0)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 perror("Could not truncate =
file\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 close(fd);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit(1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (lseek(fd, 0, SEEK_SET)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 perror("Could not seek set\=
n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 close(fd);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit(1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (runs) runs--;
> =A0 =A0 =A0 =A0} while (runs !=3D 0);
>
> --
> 1.7.5.1
>
>



-- =

Best Wishes
Yongqiang Yang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
