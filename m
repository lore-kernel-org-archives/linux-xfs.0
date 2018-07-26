Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49392 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbeGZCag (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 22:30:36 -0400
Subject: Re: [PATCH 08/10] xfs_scrub: only retry non-permanent repair failures
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <153006772140.20121.17551661183487526760.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c2b7af0b-8f6e-b7d0-8972-0aec156f5707@sandeen.net>
Date: Wed, 25 Jul 2018 18:16:15 -0700
MIME-Version: 1.0
In-Reply-To: <153006772140.20121.17551661183487526760.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/26/18 7:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a repair fails, we want to retry the repair if the error was a
> transient one, such as ENOMEM.  For "permanent" ones (shutdown fs,
> repair not supported by kernel, readonly fs) there's no point to
> retrying them so just error out immediately.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Is there something that stops infinite retries?
(I need to get this all applied for context I guess)

But anyway,
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

