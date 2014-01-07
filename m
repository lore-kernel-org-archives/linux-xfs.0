Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A15687F37
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 01:02:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC036AC006
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 23:02:17 -0800 (PST)
Message-ID: <52CBA673.2090102@oracle.com>
Date: Tue, 07 Jan 2014 15:02:11 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix off-by-one error in xfs_attr3_rmt_verify
References: <52C3FBC3.3050304@oracle.com> <52CABFD1.70100@sgi.com>
In-Reply-To: <52CABFD1.70100@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 01/06 2014 22:38 PM, Mark Tinguely wrote:
> On 01/01/14 05:28, Jeff Liu wrote:
>> From: Jie Liu<jeff.liu@oracle.com>
>>
>> With CRC check is enabled, if trying to set an attributes value just
>> equal to the maximum size of XATTR_SIZE_MAX would cause the v3 remote
>> attr write verification procedure failure, which would yield the back
>> trace like below:
>>
>> <snip>
>> XFS (sda7): Internal error xfs_attr3_rmt_write_verify at line 191 of
>> file fs/xfs/xfs_attr_remote.c
>> <snip>
>> Call Trace:
<snip>
>>
>> Tests:
>>      setfattr -n user.longxattr -v `perl -e 'print "A"x65536'` testfile
>>
>> This patch fix it to check the remote EA size is greater than the
>> XATTR_SIZE_MAX rather than more than or equal to it, because it's
>> valid if the specified EA value size is equal to the limitation as
>> per VFS setxattr interface.
>>
>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>> ---
> 
> Good catch. Are you making an edge case xfstest?

I plan to introduce a particular test case into generic subclass.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
