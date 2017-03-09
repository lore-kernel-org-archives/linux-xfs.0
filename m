Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53849 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754789AbdCIOBc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2017 09:01:32 -0500
Date: Thu, 9 Mar 2017 06:01:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: statx manpage
Message-ID: <20170309140128.GA23399@infradead.org>
References: <20170308034500.GY14226@eguan.usersys.redhat.com>
 <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
 <21188.1489042008@warthog.procyon.org.uk>
 <20170309065949.GI5281@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170309065949.GI5281@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: David Howells <dhowells@redhat.com>, Eryu Guan <eguan@redhat.com>, Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 08, 2017 at 10:59:49PM -0800, Darrick J. Wong wrote:
> Probably best to place a program in src/ so that xfstests can make the
> raw syscalls early while we wait for glibc to invent a wrapper.

Іn general don't invent new programs if we can avoid it and add a statx
command to xfs_io, that all the tests can be built around.
