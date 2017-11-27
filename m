Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57192 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752584AbdK0Vrr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 16:47:47 -0500
Subject: Re: [PATCH 08/12] libfrog: move conversion factors out of libxcmd
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
 <151094966001.29763.1497519664885559784.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <90de8f72-f2af-7a1d-92a1-6e42759174c8@sandeen.net>
Date: Mon, 27 Nov 2017 15:47:46 -0600
MIME-Version: 1.0
In-Reply-To: <151094966001.29763.1497519664885559784.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 11/17/17 2:14 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move all the conversion functions out of libxcmd since they'll be used
> by scrub, which doesn't have a commandline.

This doesn't actually move anything, it just duplicates it?

-Eric


