Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4I3TPpi213860 for <xfs@oss.sgi.com>; Tue, 17 May 2011 22:29:25 -0500
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D2F71B8B800
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 20:29:23 -0700 (PDT)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	lPegsOKTTOBWwEWd for <xfs@oss.sgi.com>;
	Tue, 17 May 2011 20:29:23 -0700 (PDT)
Received: by vxb39 with SMTP id 39so906061vxb.26
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 20:29:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=ra8eKxqstqFqDWHYsQpVx66c8BQ@mail.gmail.com>
References: <BANLkTi=ra8eKxqstqFqDWHYsQpVx66c8BQ@mail.gmail.com>
Date: Wed, 18 May 2011 11:29:23 +0800
Message-ID: <BANLkTinQFrAEFy1Lc=D88F6AF9+POnoevA@mail.gmail.com>
Subject: Re: [PATCH] xfstests:Make 225 compare map and fiemap at each block.
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

Hi Eric,

Could you have a look at this patch?

On Sat, May 14, 2011 at 11:47 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wr=
ote:
> Hi All,
>
> Due to my carelessness, I induced a ugly patch to ext4's fiemap, but
> 225 could not find it. =A0So I looked into the 225 and could not figure o=
ut
> logic in compare_map_and_fiemap(), which seemed to mixed extents with
> blocks. =A0Then I made 225 compare map and fiemap at each block, the new
> 225 can find another bug in ext4's fiemap.
>
> The new 225 works well on ext3 and ext4 with both 1K and 4K block. Howeve=
r,
> it report fiemap error on xfs with 4K block. =A0My working tree is 2.6.39=
-rc3
> pulled from Ted's tree. The error message is as follows.
>
> =A0QA output created by 225
> =A0fiemap run without preallocation, with sync
> +map is 'DDHDHHDHHDHDDHDDHDDHHDHDDHDDDDDDHHDDDHHHHDH
> DDDDDDDDHDDHHHDDDHDDHHDDDDDDHHHHHHDDHHHHHDHDHDHDD
> DHDDHD'
> +logical: [ =A0 =A0 =A0 0.. =A0 =A0 =A015] phys: =A0 =A0 =A0 12.. =A0 =A0=
 =A027 flags: 0x000 tot: 16
> +logical: [ =A0 =A0 =A017.. =A0 =A0 =A031] phys: =A0 =A0 =A0 29.. =A0 =A0=
 =A043 flags: 0x000 tot: 15
> +logical: [ =A0 =A0 =A034.. =A0 =A0 =A063] phys: =A0 =A0 =A0 46.. =A0 =A0=
 =A075 flags: 0x000 tot: 30
> +logical: [ =A0 =A0 =A065.. =A0 =A0 =A095] phys: =A0 =A0 =A0 77.. =A0 =A0=
 107 flags: 0x001 tot: 31
> +Problem comparing fiemap and map
> =A0fiemap run without preallocation or sync
> +map is 'DDHDHHDHHDHDDHDDHDDHHDHDDHDDDDDDHHDDDHHHHDH
> DDDDDDDDHDDHHHDDDHDDHHDDDDDDHHHHHHDDHHHHHDHDHDHDD
> DHDDHD'
> +logical: [ =A0 =A0 =A0 0.. =A0 =A0 =A015] phys: =A0 =A0 =A0 =A00.. =A0 =
=A0 =A015 flags: 0x006 tot: 16
> +Problem comparing fiemap and map
> Ran: 225
> Failures: 225
> Failed 1 of 1 tests
>
> I am not sure this is a bug in new 225 or xfs.
>
> Yongqiang.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0src/fiemap-tester.c | =A0223 ++++++++++++++++++++++++++++-------------=
---------
> =A01 files changed, 125 insertions(+), 98 deletions(-)
>
> diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
> index 1663f84..99bb5ce 100644
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
> @@ -80,7 +83,8 @@ generate_file_mapping(int blocks, int prealloc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_block++;
> =A0 =A0 =A0 =A0}
> -
> +
> + =A0 =A0 =A0 map[blocks] =3D 0;
> =A0 =A0 =A0 =A0return map;
> =A0}
>
> @@ -247,55 +251,36 @@ check_flags(struct fiemap *fiemap, int blocksize)
> =A0}
>
> =A0static int
> -check_data(struct fiemap *fiemap, __u64 logical_offset, int blocksize,
> +check_data(struct fiemap_extent * extent , =A0__u64 logical_offset, int
> blocksize,
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
> -
> +
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
> @@ -370,37 +355,26 @@ check_weird_fs_hole(int fd, __u64
> logical_offset, int blocksize)
> =A0}
>
> =A0static int
> -check_hole(struct fiemap *fiemap, int fd, __u64 logical_offset, int bloc=
ksize)
> +check_hole(struct fiemap_extent *extent, int fd, __u64
> logical_offset, int blocksize)
> =A0{
> - =A0 =A0 =A0 struct fiemap_extent *extent;
> - =A0 =A0 =A0 int c;
> + =A0 =A0 =A0 __u64 start, end;
>
> - =A0 =A0 =A0 for (c =3D 0; c < fiemap->fm_mapped_extents; c++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 start, end;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 extent =3D &fiemap->fm_extents[c];
> + =A0 =A0 =A0 start =3D extent->fe_logical;
> + =A0 =A0 =A0 end =3D extent->fe_logical + extent->fe_length;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D extent->fe_logical;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D extent->fe_logical + extent->fe_len=
gth;
> + =A0 =A0 =A0 if (logical_offset >=3D start &&
> + =A0 =A0 =A0 =A0 =A0 logical_offset < end) {
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset > end)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset + blocksize < start)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_weird_fs_hole(fd, logical_offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 blocksize) =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (logical_offset >=3D start &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical_offset < end) {
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_weird_fs_hole(fd,=
 logical_offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 blocksize) =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> -
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)(start /=
 blocksize));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> =A0 =A0 =A0 =A0}
> -
> +
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> @@ -423,9 +397,11 @@ compare_fiemap_and_map(int fd, char *map, int
> blocks, int blocksize, int syncfil
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
> @@ -451,8 +427,11 @@ compare_fiemap_and_map(int fd, char *map, int
> blocks, int blocksize, int syncfil
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
> @@ -465,45 +444,93 @@ compare_fiemap_and_map(int fd, char *map, int
> blocks, int blocksize, int syncfil
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (check_flags(fiemap, blocksize))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D cur_extent, c =3D 1; i < blocks;=
 i++, c++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 logical_offset =3D i =
* blocksize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_extents =3D fiemap->fm_mapped_extents;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nr_extents =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int block =3D cur_block + (=
map_length - 1)/ blocksize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; cur_block <=3D block=
 && cur_block < blocks; cur_block++) {
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (c > fiemap->fm_mapped_e=
xtents) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (c =3D 0; c < nr_extents; c++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int block;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct fiemap_extent *exten=
t;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (last_found) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERR=
OR: there is extent after"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0"the last extent\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (map[i]) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'D':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_d=
ata(fiemap, logical_offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0blocksize, last_data =3D=3D i, 0))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto error;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'H':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_h=
ole(fiemap, fd, logical_offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0blocksize))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto error;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'P':
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (check_d=
ata(fiemap, logical_offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0blocksize, last_data =3D=3D i, 1))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extent =3D &fiemap->fm_exte=
nts[c];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D extent->fe_logic=
al;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D offset / blocksiz=
e;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check hole. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; cur_block < block; c=
ur_block++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map[cur=
_block] !=3D 'H') {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 printf("ERROR: map[%d] should not be "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0"a hole\n", cur_block);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0goto error;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERR=
OR: weird value in map: %c\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0map[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D extent->fe_logic=
al + extent->fe_length;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D offset / blocksiz=
e;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (block > blocks) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("ERR=
OR: there are extents beyond EOF\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check data */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; cur_block < block; c=
ur_block++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D =
(__u64)cur_block * blocksize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 last_found =
=3D (last_data =3D=3D cur_block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (map=
[cur_block]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'D':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (check_data(extent, offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocksize, last_found, 0))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'H':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (check_hole(extent, fd, offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocksize));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'P':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (check_data(extent, offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocksize, last_found, 1))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 printf("ERROR: weird value in map: %c\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0map[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
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
> --
> 1.7.5.1
>
> --
> Best Wishes
> Yongqiang Yang
>



-- =

Best Wishes
Yongqiang Yang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
