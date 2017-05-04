Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755013AbdEDOhM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 10:37:12 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170504141802.GA18428@lst.de>
References: <20170504141802.GA18428@lst.de> <20170504133417.GD17222@lst.de> <1493904383-2187-1-git-send-email-amir73il@gmail.com> <1493904383-2187-3-git-send-email-amir73il@gmail.com> <23808.1493907370@warthog.procyon.org.uk>
Subject: Re: [PATCH v2 2/8] xfs: re-define uuid_t as common struct uuid_v1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24910.1493908618.1@warthog.procyon.org.uk>
Date: Thu, 04 May 2017 15:36:58 +0100
Message-ID: <24911.1493908618@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> > Leave struct uuid_v1 as is please.  The AFS protocol XDR encodes the
> > fields as delineated in the struct:
> 
> No.  Use direct decoding of the fields

No.  Structured types exist in C for a reason.  It makes the code easier to
read.  If it really gets your goat, I can move the uuid_v1 struct definition
into AFS code.

David
