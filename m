Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 965B57CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 20:09:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04706AC003
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 18:09:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BeS8KKaTqrvrRIWD for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 18:09:15 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 278852B2D
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 20:09:15 -0500 (CDT)
Subject: Re: [PATCH v5 0/2] xfs_repair: improved secondary sb search
References: <1463006717-6104-1-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a051d607-5b72-36b0-e501-590586bebeee@sandeen.net>
Date: Wed, 11 May 2016 20:09:14 -0500
MIME-Version: 1.0
In-Reply-To: <1463006717-6104-1-git-send-email-billodo@redhat.com>
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
To: xfs@oss.sgi.com

Ok, just a rebase, and all the code moves match current upstream,
so for both patches:

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

On 5/11/16 5:45 PM, Bill O'Donnell wrote:
> 
> Hello -
> 
> New iteration (v5) of this series...
> 
> Current xfs_repair uses a brute force approach to find a valid
> secondary sb. This series optimizes the secondary sb search, using
> similar method to determine geometry as that of xfs_mkfs. If the
> faster method fails in its search, fall back to original brute force
> slower search.
> 
> version history:
> ----
> v1: http://oss.sgi.com/archives/xfs/2016-02/msg00304.html
> v2: patch 2 whitespace fixups
> v3: patch 2 correct functionality; style fixups
> v4: patch 1,2 properly see to style and whitespace fixups
> v5: patch 1 rebase to latest
> ----
> 
> patch 1 has some general infrastructure adjustments, moving general
> topology functions from mkfs to libxcmd.
> 
> patch 2 adds the new secondary superblock search method.
> 
> Questions, comments are welcome.
> 
> Thanks-
> Bill
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
