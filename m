Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751133AbdHCRSU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 13:18:20 -0400
Subject: Re: [PATCH 9/7] xfs_db: btdump should avoid eval for push and pop of
 cursor
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <20170803170404.GU4477@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <2204b549-db2d-1631-598d-129ef9f214d3@redhat.com>
Date: Thu, 3 Aug 2017 12:18:19 -0500
MIME-Version: 1.0
In-Reply-To: <20170803170404.GU4477@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 8/3/17 12:04 PM, Darrick J. Wong wrote:
> We can call the cursor push and pop functions directly from btdump,
> so skip all the eval overhead.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

