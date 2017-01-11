Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42916 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751518AbdAKOvb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 09:51:31 -0500
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
References: <20170110194249.GK14038@birch.djwong.org>
 <CAOQ4uxggOoFJ_KR40XX2hU+bSr9zqXu9y_7HWqVxTfQ6ETC4hA@mail.gmail.com>
 <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com>
 <1dec16e5-66ea-1876-1105-2219b6f1c17c@sandeen.net>
 <CAOQ4uxh2WZ4XQKEu6Rb82XSu5MuH+Yt7bCEwRZy48TQAM8Y_WA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <69316d29-c016-2dc3-8a10-f2261e1d4c1d@sandeen.net>
Date: Wed, 11 Jan 2017 08:51:01 -0600
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxh2WZ4XQKEu6Rb82XSu5MuH+Yt7bCEwRZy48TQAM8Y_WA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On 1/11/17 8:28 AM, Amir Goldstein wrote:
> Is there a standard configure/make way to install the xfsprogs debug binaries?

I almost always go through packaging, even on my test systems, and
then install the -debuginfo rpms.

I /think/ a make install will keep the (default, AFAIK) debug binaries
intact too.

For obtaining glibc debug info, it'd be distro-specific ...

-Eric
