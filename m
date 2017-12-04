Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41850 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751980AbdLDXoD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Dec 2017 18:44:03 -0500
Subject: Re: [PATCH 00/12] xfsprogs-4.15: common library for misc. routines
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f36a3258-600d-cc29-a944-f1ab8432de4f@sandeen.net>
Date: Mon, 4 Dec 2017 17:44:01 -0600
MIME-Version: 1.0
In-Reply-To: <151094960522.29763.11622891165765932168.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Ok, for latest versions of all this:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

On 11/17/17 2:13 PM, Darrick J. Wong wrote:
> Hi all,
> 
> This patch series refactors miscellaneous data structures and runtime
> support code out of libxfs and libxcmd into a new library to contain all
> of the funny random other gunk ("libfrog") that doesn't fit anywhere
> else.  Initially, libfrog will contain routines for bit manipulation,
> device topology, threaded workqueues, an avl tree, and file path
> detection.  Existing programs are modified to pull from libfrog; the
> future xfs_scrub program will also take advantage of it.
> 
> This whole mess sits atop the libxfs-4.15-sync branch; see the
> djwong-devel branch in my repo[1] for something pullable.
> 
> --D
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
