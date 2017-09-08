Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60852 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756343AbdIHQlL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 12:41:11 -0400
Subject: Re: [PATCH 2/2] libxfs: remove getcwd/chdir dance from initialization
References: <20170904011806.GA4660@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0bed4e7c-9335-c0ac-3b3f-df2d177376f9@sandeen.net>
Date: Fri, 8 Sep 2017 11:41:10 -0500
MIME-Version: 1.0
In-Reply-To: <20170904011806.GA4660@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 9/3/17 8:18 PM, Darrick J. Wong wrote:
> Back in the old days of Irix, the library saved and restored chdir so
> that (I guess?) check_open can change directory without screwing up our
> ability to use relative paths.  However, there's nothing in Linux that
> actually does this, so just rip out the getcwd/chdir stuff since we
> absolute device paths work just fine without it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

