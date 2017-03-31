Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932566AbdCaLLX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 07:11:23 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxinpkfwbGY_JGOkZrSLu+fg9gv=A=6tUU-G0z4584_5FA@mail.gmail.com>
References: <CAOQ4uxinpkfwbGY_JGOkZrSLu+fg9gv=A=6tUU-G0z4584_5FA@mail.gmail.com> <10727.1490953667@warthog.procyon.org.uk>
Subject: Re: [PATCH] xfstests: Add first statx test [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12212.1490958679.1@warthog.procyon.org.uk>
Date: Fri, 31 Mar 2017 12:11:19 +0100
Message-ID: <12213.1490958679@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Amir Goldstein <amir73il@gmail.com> wrote:

> > +              ts=B,b
> > +              ts=M,m
> ...
> Very cool :-)
> Suggest to add an explicit comment here to mention this relies on the order
> of creation of files by this test being: dir => file => sock => link

Bah...  Forgot some backslashes.  The problem is that the shell doesn't notice
because it thinks that I'm just setting variables.

David
