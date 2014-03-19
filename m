Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 864AB7F76
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2014 20:47:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D6FFAC00D
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2014 18:47:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2Do54yEnyBnYLMnP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Mar 2014 18:47:08 -0700 (PDT)
Message-ID: <5328F715.8060502@oracle.com>
Date: Wed, 19 Mar 2014 09:47:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: avoid segfault when report -h on non-existent
	path
References: <1395160746-26654-1-git-send-email-eguan@redhat.com>
	<53287D1E.2010409@redhat.com>
In-Reply-To: <53287D1E.2010409@redhat.com>
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
To: sandeen@redhat.com
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com


On 03/19 2014 01:06 AM, Eric Sandeen wrote:
> On 3/18/14, 11:39 AM, Eryu Guan wrote:
>> Command xfs_quota -xc "report -h" /nosuchdir would get segfault, fix
>> that by checking fs_path first before dereferencing it.
>>
>> Cc: Eric Sandeen <esandeen@redhat.com>
>> Signed-off-by: Eryu Guan <eguan@redhat.com>
>> ---
>>  quota/report.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/quota/report.c b/quota/report.c
>> index 70894a2..d486524 100644
>> --- a/quota/report.c
>> +++ b/quota/report.c
>> @@ -624,7 +624,7 @@ report_f(
>>  		if (flags & ALL_MOUNTS_FLAG)
>>  			report_any_type(fp, form, type, NULL,
>>  					lower, upper, flags);
>> -		else if (fs_path->fs_flags & FS_MOUNT_POINT)
>> +		else if (fs_path && fs_path->fs_flags & FS_MOUNT_POINT)
>>  			report_any_type(fp, form, type, fs_path->fs_dir,
>>  					lower, upper, flags);
>>  	} else while (argc > optind) {
>>
> 
> I think this is ok; state_f does the same thing.
> 
> but others don't; enable_f, disable_f, off_f etc.
> 
> Also this seems to be a slight regression since v3.1.8 or so, let me double
> check that and see if we need to fix something more general.

I once posted a same patch a few months ago, Christoph pointed out a general
solution at below link:
http://www.spinics.net/lists/xfs/msg23777.html


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
