Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752760AbdDJNfe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 09:35:34 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170410080127.GD22845@eguan.usersys.redhat.com>
References: <20170410080127.GD22845@eguan.usersys.redhat.com> <149168615504.10019.12886002807349389794.stgit@warthog.procyon.org.uk> <149168617693.10019.12322515006388694205.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr [ver #12]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15417.1491831330.1@warthog.procyon.org.uk>
Date: Mon, 10 Apr 2017 14:35:30 +0100
Message-ID: <15418.1491831330@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Eryu Guan <eguan@redhat.com> wrote:

> How about including <sys/syscall.h> to get __NR_statx definition first
> and define our own syscall number only if it's not yet defined?

Done that and posted #13.  I also moved the statx.h changes in patch #4 to
patch #2.

David
