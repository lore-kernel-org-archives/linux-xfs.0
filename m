Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56464 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933359AbdCaRYU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:24:20 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170331171917.GA28069@infradead.org>
References: <20170331171917.GA28069@infradead.org> <20170331162723.GA1693@infradead.org> <149097291264.20089.7010494679305716312.stgit@warthog.procyon.org.uk> <5899.1490978897@warthog.procyon.org.uk>
Subject: Re: [PATCH 1/2] xfstests: Add first statx test
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18360.1490981057.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Fri, 31 Mar 2017 18:24:17 +0100
Message-ID: <18361.1490981057@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> > I don't see any of these.  gcc is actually wrong about this.  What gcc are you
> > using?
> 
> gcc version 4.9.2 (Debian 4.9.2-10) 

Yeah - more recent gccs appear to get this right.  I guess I can either
preclear the variables or maybe I should just split the function.

David
