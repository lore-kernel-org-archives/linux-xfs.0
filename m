Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 00:47:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3U7lHlb018004
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 00:47:25 -0700
Received: from e28smtp02.in.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C653310D187
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 00:47:52 -0700 (PDT)
Received: from e28smtp02.in.ibm.com (e28smtp02.in.ibm.com [59.145.155.2]) by cuda.sgi.com with ESMTP id jcZI6CFpfqN59gJs for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 00:47:52 -0700 (PDT)
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m3U7lmTI021624
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 13:17:48 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3U7lfUe1171552
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 13:17:41 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m3U7llNO024142
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 07:47:48 GMT
Date: Wed, 30 Apr 2008 13:17:38 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: correct use of vmtruncate()?
Message-ID: <20080430074738.GC7791@skywalker>
References: <20080429100601.GO108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429100601.GO108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 29, 2008 at 08:06:01PM +1000, David Chinner wrote:
> Folks,
> 
> It appears to me that vmtruncate() is not used correctly in
> block_write_begin() and friends. The short summary is that it
> appears that the usage in these functions implies that vmtruncate()
> should cause truncation of blocks on disk but no filesystem
> appears to do this, nor does the documentation imply they should.

Looking at ext*_truncate, I see we are freeing blocks as a part of vmtruncate.
Or did I miss something ?

-aneesh
