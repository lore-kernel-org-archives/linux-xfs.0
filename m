Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54040 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932973AbdDFHel (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 03:34:41 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170406071156.GH22845@eguan.usersys.redhat.com>
References: <20170406071156.GH22845@eguan.usersys.redhat.com> <149140993804.27340.4198614944626347024.stgit@warthog.procyon.org.uk> <149140994519.27340.14163779092377117357.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test [ver #7]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11972.1491464077.1@warthog.procyon.org.uk>
Date: Thu, 06 Apr 2017 08:34:37 +0100
Message-ID: <11973.1491464077@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Eryu Guan <eguan@redhat.com> wrote:

> So I think check_earlier() needs a fix.

Yeah.  Good point.  The nsec check needs to be conditional on the tv_sec
values being the same.

David
