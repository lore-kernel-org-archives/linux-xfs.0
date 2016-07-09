Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D6027CBE
	for <xfs@oss.sgi.com>; Sat,  9 Jul 2016 07:27:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 706198F8035
	for <xfs@oss.sgi.com>; Sat,  9 Jul 2016 05:27:06 -0700 (PDT)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
	[209.85.192.194]) by cuda.sgi.com with ESMTP id
	C1Z9tKclO0ZFJv5v (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 09 Jul 2016 05:27:00 -0700 (PDT)
Received: by mail-pf0-f194.google.com with SMTP id i123so10175852pfg.3
	for <xfs@oss.sgi.com>; Sat, 09 Jul 2016 05:27:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGeO4WMjuPs3Ze8U=vgWtY2_QqDnxAHH-dBUzAdRqdcSGPevkQ@mail.gmail.com>
References: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
	<CAGeO4WMjuPs3Ze8U=vgWtY2_QqDnxAHH-dBUzAdRqdcSGPevkQ@mail.gmail.com>
From: Kaho Ng <ngkaho1234@gmail.com>
Date: Sat, 9 Jul 2016 20:26:59 +0800
Message-ID: <CAGeO4WMd3iLriUCtPatdjNvJwY3NqiPDRNSE--VuxcUJY_RuVg@mail.gmail.com>
Subject: Re: [QUESTION] about the freelist allocator in XFS
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

if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno1, nflen1, &i)))
        return error;
XFS_WANT_CORRUPTED_RETURN(mp, i == 0);
if ((error = xfs_btree_insert(cnt_cur, &i)))
        return error;
XFS_WANT_CORRUPTED_RETURN(mp, i == 1);

The code is extracted from xfs_alloc_fixup_trees(). When the layout of
the leaf in the by-size tree is like this:
+------------------------------+-------------------------------+----
| blkcnt: 5, startblk: xxxx  | blkcnt: 7, startblk: yyyyy  | ...
+------------------------------+-------------------------------+----
which is full of items with blkcnt == 7 in the remaining space, if the
freelist refilling process requires 6 blocks to be allocated, wouldn't
a tree split is required for the insertion to proceed in case the
siblings are also full?

On Sat, Jul 9, 2016 at 3:17 AM, Kaho Ng <ngkaho1234@gmail.com> wrote:
> Maybe i should clarify my inquiries first... It is about whether
> freelist refilling will trigger any tree splits or even tree growths
> in by-size freespace tree.
>
> When reading the source code of XFS(xfs_alloc.c) to find information
> about freelist refilling in xfs_free_extent(), I found that insertion
> to by-block B+ Tree is not possible to happen since there is only
> record updates in this tree. That sounds clear to me.
> But insertion to by-size B+ Tree may happen in xfs_alloc_fixup_trees()
> after removing an record from the tree.
>
> Thus I come up with a doubt. Is tree split or tree growth in by-size
> B+ Tree possible in the above case?
>
> On Thu, Jul 7, 2016 at 7:01 PM, Kaho Ng <ngkaho1234@gmail.com> wrote:
>> I am trying to investigate how freelist allocator in xfs interacts
>> with freespace B+Tree allocator.
>> First I prepared a patch
>> <https://gist.github.com/22ffca35929e67c08759b057779b7566> on
>> linux-source/fs/xfs/libxfs/xfs_alloc.c to print debugging messages
>> (The kernel version used is linux-3.10.0-327.22.2.el7).
>> Then, I wrote a simple utility
>> <https://gist.github.com/992364ceca984d3f14099ec94aaacd9d> to make
>> TONS of
>> holes in a filesystem by calling fallocate() to punch holes in a file
>> that is almost as large as the volume size.
>>
>> I created an XFS filesystem image by the following steps:
>> 1. fallocate -l 80G /mnt/disk2/xfs
>> 2. mkfs.xfs -f -d agcount=1 /mnt/disk2/xfs
>>
>> Then I created a large file by fallocate:
>> fallocate -l 85823746048 /mnt/test/abc
>>
>> which left only 4 blocks available in the volume finally:
>> /dev/loop0      20961280 20961276         4 100% /mnt/test
>>
>> The result of xfs_bmap against /mnt/test/abc:
>> /mnt/test/abc:
>>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET              TOTAL FLAGS
>>    0: [0..167624503]:  83000..167707503  0 (83000..167707503) 167624504 10000
>>
>> After that, I used the hole-punching utility above to create holes on
>> the files, and captured the output of kmsg.
>>
>> When reading the log output
>> <https://gist.github.com/890076405e1c13c0a952a579e25e6afe> , I
>> realised that there is no B+Tree split
>> triggered by xfs_alloc_fix_freelist() when calling xfs_free_extent().
>> Isn't B+Tree split possible in by-size B+Tree even when truncating a
>> longer freespace record to shorter one? But what I found in the log is
>> only a few tree shrinks... And when reading the source code of
>> freespace allocator I found that a B+Tree growth in this case is
>> impossible at least...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
