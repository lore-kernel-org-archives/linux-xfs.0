Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5E5qkbd024888 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 00:52:47 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB5F312AC3BE
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 22:58:48 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id sP4zlytfvxkNo9Wn for
	<xfs@oss.sgi.com>; Sun, 13 Jun 2010 22:58:48 -0700 (PDT)
Message-ID: <4C15C3C7.5090706@oracle.com>
Date: Mon, 14 Jun 2010 13:53:11 +0800
From: Tao Ma <tao.ma@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
References: <1276308495-14267-1-git-send-email-tao.ma@oracle.com>
	<20100614002705.GA6590@dastard>
In-Reply-To: <20100614002705.GA6590@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, "tao.ma" <tao.ma@oracle.com>



On 06/14/2010 08:27 AM, Dave Chinner wrote:
> On Sat, Jun 12, 2010 at 10:08:15AM +0800, Tao Ma wrote:
>> In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
>> to return fi_extent_max extents, but actually it won't work for
>> a sparse file.
>
> Define "won't work". i.e. what's the test case?  I just created a
> sparse file and checked it, and it reported all the extents in it:
>
> # xfs_bmap -vp testfile
> testfile:
>   EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>     0: [0..7]:          hole                                     8
>     1: [8..15]:         96..103           0 (96..103)            8 00000
>     2: [16..23]:        hole                                     8
>     3: [24..31]:        112..119          0 (112..119)           8 00000
>     4: [32..39]:        hole                                     8
>     5: [40..47]:        128..135          0 (128..135)           8 00000
>     6: [48..55]:        hole                                     8
>     7: [56..63]:        144..151          0 (144..151)           8 00000
>     8: [64..71]:        hole                                     8
>     9: [72..79]:        160..167          0 (160..167)           8 00000
>    10: [80..87]:        hole                                     8
>    11: [88..95]:        176..183          0 (176..183)           8 00000
>    12: [96..103]:       hole                                     8
>    13: [104..111]:      192..199          0 (192..199)           8 00000
>    14: [112..119]:      hole                                     8
>    15: [120..127]:      208..215          0 (208..215)           8 00000
ok, so let me explain it. In commit 
2d1ff3c75a4642062d314634290be6d8da4ffb03, I add the mode for extent 
query of fiemap for xfs. So with your test file, it will return that we 
have 8 extents(because in xfs_fiemap_format we don't return holes). So 
normally and naturally, a user begin to iterate all the extents by doing

fiemap = malloc(sizeof(fiemap) + 8 * sizeof(struct fiemap_extent));
fiemap->fm_extent_count = 8

But what will happen? He will only get 4 extent. So do you think it is 
acceptable for a user? We told him that we have 8 extents, he has 
allocated enough space, but he can't get what he wanted. And he need to
fiemap = malloc(sizeof(fiemap) + 16 * sizeof(struct fiemap_extent));
fiemap->fm_extent_count = 16
to get 8 extent for your test file.

> # filefrag -v testfile
> Filesystem type is: 58465342
> File size of testfile is 65536 (16 blocks, blocksize 4096)
>   ext logical physical expected length flags
>     0       1       12               1
>     1       3       14       12      1
>     2       5       16       14      1
>     3       7       18       16      1
>     4       9       20       18      1
>     5      11       22       20      1
>     6      13       24       22      1
>     7      15       26       24      1 eof
> testfile: 9 extents found
> #
>
> FWIW, filefrag seems busted - the file has 8 extents, not 9.
yeah, filefrag is really broken.
>
>> The reason is that in xfs_getbmap we will
>> calculate holes and set it in 'out', while out is malloced by
>> bmv_count(fi_extent_max+1) which didn't consider holes. So in the
>> worst case, if 'out' vector looks like
>> [hole, extent, hole, extent, hole, ... hole, extent, hole],
>> we will only return half of fi_extent_max extents.
>
> Right, it's not broken, we simply return less than fi_extent_mex
> extents when there are holes. I don't see that as a problem as
> applications have to handle that case anyway, and....
see my above test case. I guess we really don't want a userspace user to 
allocate num_extents * 2 + 1 fiemap_extent to get them.
>
>> So in xfs_vn_fiemap, we should consider this worst case. If the
>> user wants fi_extent_max extents, we need a 'out' with size of
>> 2 *fi_extent_max + 2(one more the header).
>
> That's rather dangerous, I think. It relies on other code to catch
> the buffer overrun that this sets up for fragmented, non-sparse
> files. Personally I'd much prefer to return fewer extents for sparse
> files than to add a landmine like this into the kernel code....
We just change the size of our 'out', we don't change fi_extent_max or 
anything related to the fiemap. So I think what we care is how to keep 
our 'out' in good shape and fiemap should handle and check their 
fi_extent_max if we pass it more extents.

btw, maybe there is a better solution for the problem I described above. 
If there is a good one, I am happy to accept it.

Regards,
Tao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
