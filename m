Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C388A7F37
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 01:00:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2ED94AC001
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 23:00:44 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id sHblwE2jp0L3aYmC for
	<xfs@oss.sgi.com>; Mon, 25 Nov 2013 23:00:42 -0800 (PST)
Message-ID: <5294475A.3000703@cn.fujitsu.com>
Date: Tue, 26 Nov 2013 15:01:46 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests,btrfs: add wrong compress type regression test
References: <20131125210055.GG8803@dastard>
	<1385445677-27762-1-git-send-email-miaox@cn.fujitsu.com>
	<20131126064107.GN8803@dastard>
In-Reply-To: <20131126064107.GN8803@dastard>
Reply-To: miaox@cn.fujitsu.com
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
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On tue, 26 Nov 2013 17:41:07 +1100, Dave Chinner wrote:
> On Tue, Nov 26, 2013 at 02:01:17PM +0800, Miao Xie wrote:
>> Btrfs would crash when the users wrote some data into a file with compress
>> flag but the compression of the fs was disabled. This test case is to check
>> this bug still happen or not.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>> Changlog v1 -> v2:
>> - address the commit from Dave Chinner.
> 
> Testing every change before posting them for review is a good habit
> to develop. This:
> 
>> +	$XFS_IO_PROG -f -c "pwrite 0 1M" -c sync $work_file | _filter_xfs_io
> 
> will dump this:
> 
> wrote 1048576/1048576 bytes at offset 0
> XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> command "sync" not found
> 
> into the output file and hence the test will fail as the golden
> image file in the patch was not updated to match the new test output.
> 
> It also points out that "-c sync" command is invalid - the
> command to fsync a file is "-c fsync".

Sorry for my miss, please review the 3th one.

Thanks
Miao

> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
