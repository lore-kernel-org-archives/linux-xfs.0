Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13B527F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:39:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA78A8F8049
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 19:39:06 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id Edv2veOVGDPtuMd0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 19:39:05 -0800 (PST)
Date: Wed, 11 Dec 2013 22:38:59 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] nfsd: revoking of suid/sgid bits after chown() in a
	consistent way
Message-ID: <20131212033859.GA5978@fieldses.org>
References: <20131206204747.GB12613@fieldses.org>
	<1386756996-28083-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<52A845C6.2080109@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A845C6.2080109@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: vasily.isaenko@oracle.com, hch@infradead.org, linux-nfs@vger.kernel.org, sprabhu@redhat.com, xfs@oss.sgi.com

On Wed, Dec 11, 2013 at 03:00:22PM +0400, Stanislav Kholmanskikh wrote:
> 
> 
> On 12/11/2013 02:16 PM, Stanislav Kholmanskikh wrote:
> [cut off]
> >
> >This patch makes NFS to behave like local file systems.
> >
> [cut off]
> 
> This patch allows to run generic/193 without any issues with NFSv3.
> 
> With NFSv4 generic/193 fails (but with the other issues, which
> existed even before the patch).
> 
> generic/193 expects that suid/sgid bits are cleared after the file
> truncation:
> 
> touch file
> chown fsgqa:fsgqa file
> chmod u+s file
> echo 'xyz' > file
> ls -l file
> su fsgqa -c 'echo > file'
> ls -l file
> 
> With ext4 (for example), we have expectable results:
> -rwSr--r-- 1 fsgqa fsgqa 4 Dec 11 05:21 file
> -rw-r--r-- 1 fsgqa fsgqa 1 Dec 11 05:22 file
> 
> With NFSv3 as well:
> -rwSr--r-- 1 fsgqa fsgqa 4 Dec 11 05:24 file
> -rw-r--r-- 1 fsgqa fsgqa 1 Dec 11 05:25 file
> 
> But with NFSv4 the bits are not cleared:
> -rwSr--r-- 1 fsgqa fsgqa 1 Dec 11 05:19 file
> -rwSr--r-- 1 fsgqa fsgqa 1 Dec 11 05:21 file
> 
> 'echo > file' issues:
> 
> open("file", O_WRONLY|O_CREAT|O_TRUNC, 0666)
> 
> Can it be because of design differences between NFSv3 and NFSv4?

In the v3 case I'd expect the open O_TRUNC to result in a SETATTR rpc,
in the v4 case an OPEN rpc.  Both result in a call to nfsd_setattr,
though I only see nfsd_setattr turning off the SUID/SGID bits in the
chown case.  Are you sure it isn't the subsequent write that clears
those bits?

But looks to me like nfsd_vfs_write (used in both v3 & v4 cases) clears
suid & guid, so I still don't see it.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
