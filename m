Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35890 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751697AbeB0AKL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 19:10:11 -0500
Subject: Re: [RFC] mkfs config file bikeshed now!
References: <20180226224224.GE19312@magnolia>
 <20180227000122.GR14069@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3e239e61-bc79-c594-c1fd-44fa3efe779d@sandeen.net>
Date: Mon, 26 Feb 2018 18:10:09 -0600
MIME-Version: 1.0
In-Reply-To: <20180227000122.GR14069@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Tso Ted <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 2/26/18 6:01 PM, Luis R. Rodriguez wrote:
>  IIRC with e2fsprogs profile parsers we could end up with something
> like:
> 
> [defaults]
> foo=0
> bar=0
> [stuff]
> 	some_release =  {
> 		foo=1
> 		bar=2
> 	}
> 	new_release = {
> 		foo=2
> 	}

I can't tell what that means.  What's "stuff?"  Why would we need this sort of
nesting?

I /really/ want to adhere to the KISS principle here as much as possible.

The last thing I want is for the config file structure to make it difficult
for admins to understand, and easy to mis-write, resulting in unexpected
configs deployed...

There are all kinds of clever things we could do (see previous question about
inheritance) but config files are going to be write-once-use-many for the most
part, and I really think that complexity would be a net negative here.  I'd
much rather have explicit cut and paste in each section than confusing nesting
of option specifications.

-Eric
