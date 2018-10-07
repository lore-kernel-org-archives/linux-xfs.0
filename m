Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbeJGX3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Oct 2018 19:29:20 -0400
Date: Sun, 7 Oct 2018 09:21:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/1] xfs_metadump: Zap more stale data
Message-ID: <20181007162127.GE28243@magnolia>
References: <20181004205749.2042-1-stefanrin@gmail.com>
 <20181004205749.2042-2-stefanrin@gmail.com>
 <CAAxjCEw0prn7P3dn-OuuxbmMTgzs2HydpZsgkwH8RVBkedQXOA@mail.gmail.com>
 <20181005204057.GB19324@magnolia>
 <CAAxjCEzGykBJLp7mssn7f3MJoS3nx6DmsXSuiNn+T7qGSYPk4w@mail.gmail.com>
 <CAAxjCEx1LemxZPSE5h2ZreNmfOuh09FQBJ=ZoPXJLr=2PTW=SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAxjCEx1LemxZPSE5h2ZreNmfOuh09FQBJ=ZoPXJLr=2PTW=SA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 07, 2018 at 01:57:10PM +0200, Stefan Ring wrote:
> On Sun, Oct 7, 2018 at 11:43 AM Stefan Ring <stefanrin@gmail.com> wrote:
> >
> > Interestingly my file system has dirblklog = 0. I guess I'll have to
> > start creating some toy file system images for experimentation.
> 
> Ok, I've found out how to create one with dirblklog > 0, but the
> default seems to be, and have been for a very long time, zero
> (directory blocks are the same size as file system blocks). I'm afraid
> of uncovering all kinds of nastiness going this untrodden path…

Nothing is ever simple in xfs, sadly. :/

That said, I think the "recommended" ceph configuration still has
multiblock directories, so I think those code paths are somewhat
frequently used by some of the users.

(I guess you could temporarily change the patch to memset(buf, 'a', ...)
to make sure it only ever touches the empty parts of the dir block buffer.)

--D
