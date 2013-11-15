Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A70F17F50
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 19:42:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96D9D304059
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 17:42:37 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id QfAyPsoEl58pqTNT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 17:42:36 -0800 (PST)
Message-ID: <52857BEB.4010406@oracle.com>
Date: Fri, 15 Nov 2013 09:42:03 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs/quota: fix NULL pointer dereference in report_f
References: <52849CC5.10109@oracle.com> <20131114140916.GA13501@infradead.org>
In-Reply-To: <20131114140916.GA13501@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/14 2013 22:09 PM, Christoph Hellwig wrote:
> On Thu, Nov 14, 2013 at 05:49:57PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Run xfs_quota report against an invalid XFS path without desired quota
>> limitation is enabled will hit SEGSEGV as fs_path is uninitialized, e.g.
>>
>> # xfs_quota -xc 'report -up' /invalid_path
>> xfs_quota: cannot setup path for mount /invalid_path: No such file or directory
>> Segmentation fault (core dumped)
>>
>> (gdb) r -xc 'report -up' /invalid_path
>> xfs_quota: cannot setup path for mount /invalid_path: No such file or directory
>>
>> Program received signal SIGSEGV, Segmentation fault.
>> 0x0000000000408b4d in report_f (argc=2, argv=0x105ea70) at report.c:627
>> 627			else if (fs_path->fs_flags & FS_MOUNT_POINT)
>>
>> This patch fix report_f() to only do report if the fs_path is initialized.
> 
> quot_f in quot.c and various functions in state.c seem to have the same
> issue, and need fixing as well.
As per a rough tryout while fixing this problem, it seems that most of those
functions are just not be invoked since other precheck-ups were failed before
calling them.  We have another old fix for stat_f():

commit 04418c5901b846cf904d929210cb71dfba44e9a7
Author: Donald Douwsma <donaldd@sgi.com>
Date:   Mon Jul 23 04:14:27 2007 +0000

    Fix null pointer dereference in state_f.
    Merge of master-melb:xfs-cmds:29194a by kenmcd.

> I'd love to avoid having to expose fs_path as a global and just have a
> few safe accessors:
> 
> char *global_fsname(void)
> {
> 	return fs_path ? fs_path->fs_name : NULL;
> }
> 
> char *global_dir(void)
> {
> 	return fs_path ? fs_path->fs_dir : NULL;
> }
> 
> char *global_mountpoint(void)
> {
> 	if (fs_path && (fs_path->fs_flags & FS_MOUNT_POINT))
> 		return fs_path->fs_dir;
> 	return NULL;
> }
> 
> Together with moving a bit of code from quota/init.c to libxcmd/path.c
> that should allow mkaing fs_path and fs_table static there.
Sounds reasonable to me, thanks for your suggestion.
> 
> I'd also really love to see a regression test for xfstests.
I'll take care of it, let me double check all those sub-commands at first.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
