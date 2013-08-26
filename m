Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D5DA7F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 15:26:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB731AC00B
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 13:26:41 -0700 (PDT)
Received: from mail-ve0-f178.google.com (mail-ve0-f178.google.com
	[209.85.128.178]) by cuda.sgi.com with ESMTP id
	VzWx6g1ThL81Dlg6 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Aug 2013 13:26:37 -0700 (PDT)
Received: by mail-ve0-f178.google.com with SMTP id ox1so2607933veb.9
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 13:26:37 -0700 (PDT)
Message-ID: <521BB9F5.9040007@gmail.com>
Date: Mon, 26 Aug 2013 16:26:29 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
References: <52165830.8050006@redhat.com> <20130826041330.GU6023@dastard>
In-Reply-To: <20130826041330.GU6023@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 08/26/2013 12:13 AM, Dave Chinner wrote:
> On Thu, Aug 22, 2013 at 02:28:00PM -0400, Brian Foster wrote:
>> Hi all,
>>
>> I hit an assert on a debug kernel while beating on some finobt work and
>> eventually reproduced it on unmodified/TOT xfs/xfsprogs as of today. I
>> hit it through a couple different paths, first while running fsstress on
>> a CRC enabled filesystem (with otherwise default mkfs options):
>>
>> (These tests are running on a 4p, 4GB VM against a 100GB virtio disk,
>> hosted on a single spindle desktop box).
>>
>> crc=1
>> fsstress -z -fsymlink=1 -n99999999 -p4 -d /mnt/test
>>
>> XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length),
> 
> Directory buffer overrun.
> 
>>  [<ffffffffa031d549>] xfs_trans_log_buf+0x89/0x1b0 [xfs]
>>  [<ffffffffa02e7c1c>] xfs_da3_node_add+0x11c/0x210 [xfs]
>>  [<ffffffffa02ea703>] xfs_da3_node_split+0xc3/0x230 [xfs]
>>  [<ffffffffa02eaa18>] xfs_da3_split+0x1a8/0x410 [xfs]
>>  [<ffffffffa02f743f>] xfs_dir2_node_addname+0x47f/0xde0 [xfs]
> 
> During a split.
> 
> Easily reproduced with "seq 200000 | xargs touch" as Michael Semon
> reported last week.
> 
> The fix demonstrates my concerns about modifying directory code -
> the CRC changes missed a *fundamental* directory format definition,
> and we've only just tripped over it....

Don't fret too much over it.  This test was part of coreutils, which 
is something that I rebuild after a glibc upgrade.  Had glibc-2.18 
been released six weeks ago, then I would have stumbled onto this 
XFS issue six weeks ago.

>> rm -rf /mnt/test
>>
>> XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length),
> 
> Directory buffer overrun.
> 
>>  [<ffffffffa032b549>] xfs_trans_log_buf+0x89/0x1b0 [xfs]
>>  [<ffffffffa02f61ff>] xfs_da3_node_unbalance+0xef/0x1d0 [xfs]
>>  [<ffffffffa02f98b0>] xfs_da3_join+0x240/0x290 [xfs]
>>  [<ffffffffa030659b>] xfs_dir2_node_removename+0x69b/0x8b0 [xfs]
> 
> During a merge. Not sure why that is happening on a v4 filesystem.
> V5 filesystem, yes, due to the above bug but v4 should not be
> affected.
> 
> Cheers,
> 
> Dave.

Your patch looks good, and I even applied it to vanilla 3.10.9, 
along with Jeff Liu's MAX_LFS_FILESIZE patch.  [Murphy's Law states 
that if I didn't use Jeff's patch, then I would run xfstests 
generic/308 on accident, leading to a hung umount.  Happens every 
single time.]  Both patches applied cleanly to kernels on a 2.8 GHz 
i686 Pentium 4 PC that was running Slackware 14.0 Linux.

Naturally, `seq 200000 | xargs touch` was run for v5 and v4 XFS 
file systems.  All was okay.  The removal of the populated directory 
went fine as well.

The v5 file systems were tested using a 3.11-rc7+ git kernel.  
xfstests was run from the start of generic/ through generic/127; 
and that went fine.  Some of the xfs/* series was run but merely 
scanned because the v5-output-cleanup patches were not readily 
available.

The v4 file systems were tested with a patched vanilla 3.10.9 kernel, 
and some of generic was run, with patched and unpatched kernels showing 
the same good results, very little difference in timing overall.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
