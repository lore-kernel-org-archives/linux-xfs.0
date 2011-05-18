Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4ID5O6n239005 for <xfs@oss.sgi.com>; Wed, 18 May 2011 08:05:24 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12B371E2E20E
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 06:05:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NCMo7KCjvUFUKshK for
	<xfs@oss.sgi.com>; Wed, 18 May 2011 06:05:23 -0700 (PDT)
Message-ID: <4DD3C40F.1040808@redhat.com>
Date: Wed, 18 May 2011 09:05:19 -0400
From: Josef Bacik <josef@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests:Make 225 compare map and fiemap at each block.
References: <BANLkTi=ra8eKxqstqFqDWHYsQpVx66c8BQ@mail.gmail.com>
In-Reply-To: <BANLkTi=ra8eKxqstqFqDWHYsQpVx66c8BQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 05/13/2011 11:47 PM, Yongqiang Yang wrote:
> Hi All,
>
> Due to my carelessness, I induced a ugly patch to ext4's fiemap, but
> 225 could not find it.  So I looked into the 225 and could not figure out
> logic in compare_map_and_fiemap(), which seemed to mixed extents with
> blocks.  Then I made 225 compare map and fiemap at each block, the new
> 225 can find another bug in ext4's fiemap.
>
> The new 225 works well on ext3 and ext4 with both 1K and 4K block. However,
> it report fiemap error on xfs with 4K block.  My working tree is 2.6.39-rc3
> pulled from Ted's tree. The error message is as follows.
>
>   QA output created by 225
>   fiemap run without preallocation, with sync
> +map is 'DDHDHHDHHDHDDHDDHDDHHDHDDHDDDDDDHHDDDHHHHDH
> DDDDDDDDHDDHHHDDDHDDHHDDDDDDHHHHHHDDHHHHHDHDHDHDD
> DHDDHD'
> +logical: [       0..      15] phys:       12..      27 flags: 0x000 tot: 16
> +logical: [      17..      31] phys:       29..      43 flags: 0x000 tot: 15
> +logical: [      34..      63] phys:       46..      75 flags: 0x000 tot: 30
> +logical: [      65..      95] phys:       77..     107 flags: 0x001 tot: 31
> +Problem comparing fiemap and map
>   fiemap run without preallocation or sync
> +map is 'DDHDHHDHHDHDDHDDHDDHHDHDDHDDDDDDHHDDDHHHHDH
> DDDDDDDDHDDHHHDDDHDDHHDDDDDDHHHHHHDDHHHHHDHDHDHDD
> DHDDHD'
> +logical: [       0..      15] phys:        0..      15 flags: 0x006 tot: 16
> +Problem comparing fiemap and map
> Ran: 225
> Failures: 225
> Failed 1 of 1 tests
>
> I am not sure this is a bug in new 225 or xfs.
>
> Yongqiang.
>
> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
> ---
>   src/fiemap-tester.c |  223 ++++++++++++++++++++++++++++----------------------
>   1 files changed, 125 insertions(+), 98 deletions(-)
>
> diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
> index 1663f84..99bb5ce 100644
> --- a/src/fiemap-tester.c
> +++ b/src/fiemap-tester.c
> @@ -14,6 +14,9 @@
>    * You should have received a copy of the GNU General Public License
>    * along with this program; if not, write the Free Software Foundation,
>    * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Compare map and fiemap at each block,
> + * Yongqiang Yang<xiaoqiangnk@gmail.com>, 2011
>    */
>
>   #include<stdio.h>
> @@ -57,7 +60,7 @@ generate_file_mapping(int blocks, int prealloc)
>   	int num_types = 2, cur_block = 0;
>   	int i = 0;
>
> -	map = malloc(sizeof(char) * blocks);
> +	map = malloc(sizeof(char) * (blocks + 1));
>   	if (!map)
>   		return NULL;
>
> @@ -80,7 +83,8 @@ generate_file_mapping(int blocks, int prealloc)
>   		}
>   		cur_block++;
>   	}
> -
> +	
> +	map[blocks] = 0;
>   	return map;
>   }
>
> @@ -247,55 +251,36 @@ check_flags(struct fiemap *fiemap, int blocksize)
>   }
>
>   static int
> -check_data(struct fiemap *fiemap, __u64 logical_offset, int blocksize,
> +check_data(struct fiemap_extent * extent ,  __u64 logical_offset, int
> blocksize,
>   	   int last, int prealloc)
>   {

This chunk is messed up, it's failing to apply.  Overall it looks good, 
but could you clean this up and resend so I can apply it and test it 
more thoroughly?  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
