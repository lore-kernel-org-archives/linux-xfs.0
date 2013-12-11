Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 87D2629DF8
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 05:00:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 618A6304075
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 03:00:59 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3QZnGUpfGxnGn4sD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 03:00:58 -0800 (PST)
Message-ID: <52A845C6.2080109@oracle.com>
Date: Wed, 11 Dec 2013 15:00:22 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] nfsd: revoking of suid/sgid bits after chown() in a
	consistent way
References: <20131206204747.GB12613@fieldses.org>
	<1386756996-28083-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <1386756996-28083-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
To: linux-nfs@vger.kernel.org
Cc: vasily.isaenko@oracle.com, hch@infradead.org, sprabhu@redhat.com, bfields@fieldses.org, xfs@oss.sgi.com



On 12/11/2013 02:16 PM, Stanislav Kholmanskikh wrote:
[cut off]
>
> This patch makes NFS to behave like local file systems.
>
[cut off]

This patch allows to run generic/193 without any issues with NFSv3.

With NFSv4 generic/193 fails (but with the other issues, which existed 
even before the patch).

generic/193 expects that suid/sgid bits are cleared after the file 
truncation:

touch file
chown fsgqa:fsgqa file
chmod u+s file
echo 'xyz' > file
ls -l file
su fsgqa -c 'echo > file'
ls -l file

With ext4 (for example), we have expectable results:
-rwSr--r-- 1 fsgqa fsgqa 4 Dec 11 05:21 file
-rw-r--r-- 1 fsgqa fsgqa 1 Dec 11 05:22 file

With NFSv3 as well:
-rwSr--r-- 1 fsgqa fsgqa 4 Dec 11 05:24 file
-rw-r--r-- 1 fsgqa fsgqa 1 Dec 11 05:25 file

But with NFSv4 the bits are not cleared:
-rwSr--r-- 1 fsgqa fsgqa 1 Dec 11 05:19 file
-rwSr--r-- 1 fsgqa fsgqa 1 Dec 11 05:21 file

'echo > file' issues:

open("file", O_WRONLY|O_CREAT|O_TRUNC, 0666)

Can it be because of design differences between NFSv3 and NFSv4?

Thank you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
