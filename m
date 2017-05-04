Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755103AbdEDOQO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 10:16:14 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170504133417.GD17222@lst.de>
References: <20170504133417.GD17222@lst.de> <1493904383-2187-1-git-send-email-amir73il@gmail.com> <1493904383-2187-3-git-send-email-amir73il@gmail.com>
Subject: Re: [PATCH v2 2/8] xfs: re-define uuid_t as common struct uuid_v1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23807.1493907370.1@warthog.procyon.org.uk>
Date: Thu, 04 May 2017 15:16:10 +0100
Message-ID: <23808.1493907370@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> I'm not sure this really is a good idea.  uuid_v1 currently is only
> used by afs.  I'd much rather switch both afs and xfs to use the
> uuid_be type (which might as well grow the standard uuid_t name while
> we're at it), and use accessors that do the byte-array access for
> the very few places that care about the interpretation.

Leave struct uuid_v1 as is please.  The AFS protocol XDR encodes the fields as
delineated in the struct:

		r->time_low			= b[0];
		r->time_mid			= htons(ntohl(b[1]));
		r->time_hi_and_version		= htons(ntohl(b[2]));
		r->clock_seq_hi_and_reserved 	= ntohl(b[3]);
		r->clock_seq_low		= ntohl(b[4]);

		for (loop = 0; loop < 6; loop++)
			r->node[loop] = ntohl(b[loop + 5]);

Yeah, I know it's crazy to do it like this on the wire rather than just encode
it as a 16-byte blob, but that's what someone defined it as...  Trying to use
the uuid_be struct instead just makes things more messy.

David
