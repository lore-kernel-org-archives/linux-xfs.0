Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 66DF67F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 02:13:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01AD2AC002
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 00:13:39 -0700 (PDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	RWm53vS7pgP9vHRn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 00:13:39 -0700 (PDT)
Received: by mail-ie0-f179.google.com with SMTP id c13so2884728ieb.24
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 00:13:38 -0700 (PDT)
Message-ID: <51933585.80400@gmail.com>
Date: Wed, 15 May 2013 03:13:09 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: Rambling noise #2: Learning to use the v8 pquota/uquota patchset
References: <5191FB46.2080300@gmail.com> <519241A1.9050704@oracle.com>
In-Reply-To: <519241A1.9050704@oracle.com>
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
Cc: xfs@oss.sgi.com

On 05/14/2013 09:52 AM, Jeff Liu wrote:
> Hi Michael,
>
> Have you tried this patch set with the v2 user space changes?
>
> Looks this is the latest update from Chandra that I can searched from
> the mailing list:
> http://oss.sgi.com/archives/xfs/2012-07/msg00293.html
>
> Thanks,
> -Jeff

It looks like it's not patching very well in light of Dave's CRC 
userspace changes, and I botched the mkfs part of the merge.

For xfsprogs include/xfs_sb.h, Patch #1 has this:

+#define XFS_SB_VERSION2_NO_OQUOTA      0x00000100      /* sep prj quota 
inode */

However, in the current xfsprogs include/xfs_sb.h, there is this line:

#define XFS_SB_VERSION2_CRCBIT		0x00000100	/* metadata CRCs */

This overloaded meaning of 0x00000100 did not seem right, so after my 
failure with the finished mkfs.xfs, it was time to go back to the 
current git xfsprogs.  I'm sure that the userspace will be reworked 
before the kernel code is final.  I'll show some patience, and Dave's 
upcoming CRC code activation will probably force me to back Chandra's 
patchset out anyway.

Despite my bumbling through it all, the kernel gquota/pquota patchset 
shows promise.

Thanks!

Michael

P.S. - I applied your xfs_growfs_data_private patch, and all seems well 
so far.  In particular, there was no change in the test results from 
`./check -xfs -g growfs`.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
