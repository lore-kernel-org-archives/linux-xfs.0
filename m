Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 73B387F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 17:09:10 -0500 (CDT)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9DDA78F8033
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 15:08:55 -0700 (PDT)
Message-ID: <52605FF8.2000301@sgi.com>
Date: Thu, 17 Oct 2013 17:08:56 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/4] xfsprogs: v4 inode type in directory
References: <20131017152804.204045257@sgi.com>
In-Reply-To: <20131017152804.204045257@sgi.com>
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
To: xfs@oss.sgi.com

On 10/17/13 10:28, Mark Tinguely wrote:
> Here are the patches that enable the inode in the directory
> feature in v4 superblocks.
>
> Unchanged
>   patch 1: add the entries to xfs_sb.h (sync with kernel)
>   patch 2: add the XFS_FSOP_GEOM_FLAGS_FTYPE to xfs_fs.h (sync with kernel)
> 	  add the entry to repair so that xfs_info reports the feature
> New
>   patch 3: add feature to the xfs_db version command.
>
> Fixed
>   patch 4: add the feature to mkfs.xfs and manual page.
>            note: this new feature is ignored for superblock v5
> 		automatically turns on this feature.

FYI.

I saw the request for adding the filetype entry to block/leaf after posting.

I have it displaying unconditionally, but am trying to figure out how to 
make it display only for filesytems that support the ftype feature. I am 
missing something in the field.count().

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
