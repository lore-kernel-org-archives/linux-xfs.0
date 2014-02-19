Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 845E37FE9
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 06:42:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77A478F8039
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 04:42:54 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id daKHTPaGcJbt35Jq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 04:42:49 -0800 (PST)
Message-ID: <5304A6BD.8070605@oracle.com>
Date: Wed, 19 Feb 2014 20:42:37 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 8/9] xfs: print useful caller information in
	xfs_error_report
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1392767549-25574-9-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com


On 02/19 2014 07:52 AM, Eric Sandeen wrote:
> xfs_error_report used to just print the hex address of the caller;
> %pF will give us something more human-readable.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_error.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 8733c59..04d8e65 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -156,7 +156,7 @@ xfs_error_report(
>  {
>  	if (level <= xfs_error_level) {
>  		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> -		"Internal error %s at line %d of file %s.  Caller 0x%p",
> +		"Internal error %s at line %d of file %s.  Caller %pF",
>  			    tag, linenum, filename, ra);
>  
>  		xfs_stack_trace();

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

In comparison with the hex code, this is obviously more readable as below.

Patched:
-------
XFS (sda7): Internal error xfs_sb_read_verify at line 630 of file fs/xfs/xfs_sb.c.  Caller xfs_buf_iodone_work+0xa5/0xd0 [xfs]
<snip>
Call Trace:
[<ffffffff81741f15>] dump_stack+0x45/0x56
[<ffffffffa07a5a0b>] xfs_error_report+0x3b/0x40 [xfs]
[<ffffffffa07a26b5>] ? xfs_buf_iodone_work+0xa5/0xd0 [xfs]
[<ffffffffa07a5a65>] xfs_corruption_error+0x55/0x80 [xfs]
[<ffffffffa080bf23>] xfs_sb_read_verify+0x143/0x150 [xfs]
[<ffffffffa07a26b5>] ? xfs_buf_iodone_work+0xa5/0xd0 [xfs]
[<ffffffff8108744f>] ? process_one_work+0x1af/0x540
[<ffffffffa07a26b5>] xfs_buf_iodone_work+0xa5/0xd0 [xfs]
<snip>


Old:
----
[  235.506754] XFS (sda7): Internal error xfs_sb_read_verify at line 630 of file fs/xfs/xfs_sb.c.  Caller 0xffffffffa08aa6b5
<snip>
[  235.506796] Call Trace:
[  235.506802]  [<ffffffff81741f15>] dump_stack+0x45/0x56
[  235.506818]  [<ffffffffa08ada0b>] xfs_error_report+0x3b/0x40 [xfs]
[  235.506832]  [<ffffffffa08aa6b5>] ? xfs_buf_iodone_work+0xa5/0xd0 [xfs]
[  235.506845]  [<ffffffffa08ada65>] xfs_corruption_error+0x55/0x80 [xfs]
[  235.506871]  [<ffffffffa0913f23>] xfs_sb_read_verify+0x143/0x150 [xfs]
[  235.506885]  [<ffffffffa08aa6b5>] ? xfs_buf_iodone_work+0xa5/0xd0 [xfs]
[  235.506890]  [<ffffffff8108744f>] ? process_one_work+0x1af/0x540
[  235.506903]  [<ffffffffa08aa6b5>] xfs_buf_iodone_work+0xa5/0xd0 [xfs]
<snip>


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
