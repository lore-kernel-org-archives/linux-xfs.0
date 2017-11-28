Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43117 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752331AbdK1AbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Nov 2017 19:31:22 -0500
Date: Mon, 27 Nov 2017 16:31:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/12] libfrog: move conversion factors out of libxcmd
Message-ID: <20171128003115.GA21412@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
 <151094966001.29763.1497519664885559784.stgit@magnolia>
 <90de8f72-f2af-7a1d-92a1-6e42759174c8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90de8f72-f2af-7a1d-92a1-6e42759174c8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Nov 27, 2017 at 03:47:46PM -0600, Eric Sandeen wrote:
> On 11/17/17 2:14 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move all the conversion functions out of libxcmd since they'll be used
> > by scrub, which doesn't have a commandline.
> 
> This doesn't actually move anything, it just duplicates it?

rrrgh, the libxcmd/input.c changes fell off... :(

Lemme resend.

--D

> -Eric
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
