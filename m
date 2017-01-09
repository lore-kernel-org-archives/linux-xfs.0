Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31168 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941389AbdAIVSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 16:18:31 -0500
Date: Mon, 9 Jan 2017 13:17:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6 1/3] xfs: fix the size of xfs_mode_to_ftype table
Message-ID: <20170109211749.GC14038@birch.djwong.org>
References: <1483967189-27313-1-git-send-email-amir73il@gmail.com>
 <1483967189-27313-2-git-send-email-amir73il@gmail.com>
 <20170109155158.GA19396@infradead.org>
 <CAOQ4uxi4AWSN89MtZH6f0B9aC_AMmC6bxbUCAh9LMU4G+Z9U1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi4AWSN89MtZH6f0B9aC_AMmC6bxbUCAh9LMU4G+Z9U1A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 09, 2017 at 07:21:25PM +0200, Amir Goldstein wrote:
> On Mon, Jan 9, 2017 at 5:51 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, Jan 09, 2017 at 03:06:27PM +0200, Amir Goldstein wrote:
> >> Fix the size of the xfs_mode_to_ftype conversion table,
> >> which was too small to handle an invalid value of mode=S_IFMT.
> >>
> >> Use a convenience macro S_DT(mode) to convert from
> >> mode to dirent file type and change the name of the table
> >> to xfs_dtype_to_ftype to correctly describe its index values.
> >
> > This looks like an awful lot of magic.  Would a switch statement
> > generate so much worse code?
> 
> I doubt it really matters that much, so it's down to a matter of taste.
> I personally like the existing map table better than switch if anyone cares ;-)
> but I think that the strongest argument in favor of the existing code
> is that it works, so no reason to change it.
> IMHO, this minor fix and cleanup do not justify switching the code over to
> switch statement.

I can't feed a garbage index to a switch statement and have it fly
off the end of an array; plus we can throw asserts in a default: case.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
