Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A9EA87F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 22:56:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92623304059
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 20:56:54 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2zPfCUvEEJxFPABB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 20:56:53 -0700 (PDT)
Message-ID: <5355E87F.8030906@oracle.com>
Date: Tue, 22 Apr 2014 11:56:47 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: generic/285: fix seek_sanity_test for generic
	SEEK_HOLE/DATA
References: <20140421164305.22404.92195.stgit@buzz>
In-Reply-To: <20140421164305.22404.92195.stgit@buzz>
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
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>, xfs@oss.sgi.com


On 04/22 2014 00:43 AM, Konstantin Khlebnikov wrote:
> Generic implementation of SEEK_HOLE/DATA reports whole file as data chunk with
> virtual hole at the end (generic_file_llseek, used by ext2/ext3/reiserfs/nfs).
> 
> Currently test prepares file smaller than expected for "huge file" testcases
> (testcases 10-12). This patch fixes test file layout, now second data chunk
> ends right at the expected end of file.
> 
> Plus it fixes type of 'filesz' argument, it should be off_t.

Am not verified against NFS, but the fix look good to me.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
