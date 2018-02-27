Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbeB0A0b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 19:26:31 -0500
Date: Mon, 26 Feb 2018 16:25:50 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] mkfs config file bikeshed now!
Message-ID: <20180227002550.GH19312@magnolia>
References: <20180226224224.GE19312@magnolia>
 <20180227000122.GR14069@wotan.suse.de>
 <3e239e61-bc79-c594-c1fd-44fa3efe779d@sandeen.net>
 <CAB=NE6U+7hmRhrkkd1v=rEKrcY+NNf61jL9B4nm=kDbTPvy--w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6U+7hmRhrkkd1v=rEKrcY+NNf61jL9B4nm=kDbTPvy--w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Tso Ted <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 26, 2018 at 04:15:06PM -0800, Luis R. Rodriguez wrote:
> On Mon, Feb 26, 2018 at 4:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> >
> > On 2/26/18 6:01 PM, Luis R. Rodriguez wrote:
> >>  IIRC with e2fsprogs profile parsers we could end up with something
> >> like:
> >>
> >> [defaults]
> >> foo=0
> >> bar=0
> >> [stuff]
> >>       some_release =  {
> >>               foo=1
> >>               bar=2
> >>       }
> >>       new_release = {
> >>               foo=2
> >>       }
> >
> > I can't tell what that means.  What's "stuff?"  Why would we need this sort of
> > nesting?
> 
> I'll leave the crafty examples to Darrick as he had some complex ideas
> in mind. On my part I was happy to not have to deal with the namespace
> stuff -- however I realized some may want it, so I had to mention both
> libraries libini_config and e2fsprogs profile parser do support it,
> just in different ways.

Well I /did/ have an even stupider parser in mind if segmented config
files got shot down...

/etc/xfs/mkfs/uek5.conf:
data.agcount 32
metadata.reflink 0

# mkfs.xfs -t uek5 /dev/sda

open("/etc/xfs/mkfs/${t_optarg}.conf")...

Then we can parse it with a simple fgets/strtok loop to tokenize the
input lines and feed them to the geometry arg parser.  But I'll go read
your paper all the way through first before I scribble more. :)

--D

>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
