Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59032 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbeG1EJp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 28 Jul 2018 00:09:45 -0400
Subject: Re: [PATCH ] misc: clean up MIN/MAX in the utilities
References: <153273073460.1594.8379497525888711422.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bb65d98a-26a2-cf56-38ea-096218715c88@sandeen.net>
Date: Fri, 27 Jul 2018 19:45:02 -0700
MIME-Version: 1.0
In-Reply-To: <153273073460.1594.8379497525888711422.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 7/27/18 3:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Get rid of the MIN/MAX macros and just use the native min/max macros
> directly in the XFS code, just like we did for libxfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This is just s/MIN/min/g etc right?

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

