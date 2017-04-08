Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751475AbdDHVH5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Apr 2017 17:07:57 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170408150812.GX22845@eguan.usersys.redhat.com>
References: <20170408150812.GX22845@eguan.usersys.redhat.com> <149146774821.12770.3592235770964461857.stgit@warthog.procyon.org.uk> <149146775556.12770.11943651470996193921.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test [ver #10]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9329.1491685675.1@warthog.procyon.org.uk>
Date: Sat, 08 Apr 2017 22:07:55 +0100
Message-ID: <9330.1491685675@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Eryu Guan <eguan@redhat.com> wrote:

> Perhaps we should add a new autoconf rule in configure.ac and define
> HAVE_STATX if there's statx support, like what src/renameat2.c does?

The problem with that is that statx doesn't yet exist in glibc, so the tests
are going to be skipped.  I can define __NR_statx only on arches for which we
have a number and make xfstests_statx() give ENOSYS if __NR_statx isn't
defined.

David
