Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 20BB27CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 17:55:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8947CAC008
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 15:55:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id x8aisyuVt42CrkCT for <xfs@oss.sgi.com>;
	Thu, 17 Mar 2016 15:55:53 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E5A2A19120
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 17:55:48 -0500 (CDT)
Subject: Re: xfs_growfs causing "Metadata corruption detected at
	xfs_agf_read_verify"
References: <20160317224803.GA8856@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56EB35F8.1030601@sandeen.net>
Date: Thu, 17 Mar 2016 17:55:52 -0500
MIME-Version: 1.0
In-Reply-To: <20160317224803.GA8856@redhat.com>
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

On 3/17/16 5:48 PM, Richard W.M. Jones wrote:
> 
> With recent kernels (or maybe xfsprogs?) we've noticed strange
> filesystem corruption after using xfs_growfs.
> 
> Examples:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1315895 (on aarch64)
> https://www.redhat.com/archives/libguestfs/2016-March/msg00113.html (x86_64)
> https://rwmj.wordpress.com/2015/11/04/virt-builder-fedora-23-image/#comment-15668 (x86_64)
> 
> Do these errors look familiar?  I don't yet have a simple test case,
> still working on that.

try:
http://oss.sgi.com/pipermail/xfs/2016-March/047683.html

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
