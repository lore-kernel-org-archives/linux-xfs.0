Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA4EC7F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 14:31:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA69630407B
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 12:31:35 -0700 (PDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	bD6r7IeEHV8OnnRw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 12:31:32 -0700 (PDT)
Received: by mail-ie0-f179.google.com with SMTP id c13so10032134ieb.38
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 12:31:31 -0700 (PDT)
Message-ID: <51968577.2070603@gmail.com>
Date: Fri, 17 May 2013 15:31:03 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 7/8] xfs: Add xfs_log_rlimit.[c|h]
References: <5195C279.3060502@oracle.com> <5195EC13.2060502@gmail.com>
	<5195FB1B.9000803@oracle.com>
In-Reply-To: <5195FB1B.9000803@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/17/2013 05:40 AM, Jeff Liu wrote:
> Hi Michael,
>
> Are you compiling kernel on 32-bit system?

Yes, this is a 32-bit Pentium 4 system.

> Looks this issue is regarding 64-bit division at roundup() on 32-bit if so.
>
> Could you please try below fix?
>
> diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
> index 3e84d46..49a88cc 100644
> --- a/fs/xfs/xfs_log_rlimit.c
> +++ b/fs/xfs/xfs_log_rlimit.c
> @@ -127,7 +127,7 @@ xfs_log_validate_logspace(
>           * Also, the log size should be a multiple of the log stripe unit, round
>           * it up to lsunit boundary if lsunit is specified.
>           */
> -       minlblks = lsunit ? (roundup(BTOBB(maxlres), lsunit) + 2 * lsunit) * 2 :
> +       minlblks = lsunit ? (roundup((int)BTOBB(maxlres), lsunit) + 2 * lsunit) * 2 :
>                              BTOBB(maxlres) * 2;
>
>          if (log->l_logBBsize < minlblks) {
>
>
> Thanks,
> -Jeff

This code works, and my sysadmin-hack use of "const" was not needed 
after all.  If you use Dave's suggestion to use roundup_64(), I'll be 
happy to apply another patch.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
