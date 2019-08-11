Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45982 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726212AbfHKBCr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Aug 2019 21:02:47 -0400
Date: Sun, 11 Aug 2019 11:01:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: allocate xattr buffer on demand
Message-ID: <20190811010136.GD7777@dread.disaster.area>
References: <20190724045911.GU7689@dread.disaster.area>
 <403e606b-1b7b-5983-d8e5-a7fecee84702@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <403e606b-1b7b-5983-d8e5-a7fecee84702@applied-asynchrony.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Aug 10, 2019 at 11:45:35PM +0200, Holger Hoffstätte wrote:
> 
> Hi Dave -
> 
> great patch but I found something that seems off in xfs_attr3_leaf_getvalue:

It's not a "great patch" if there's something wrong with it. :/

> > @@ -2378,31 +2403,23 @@ xfs_attr3_leaf_getvalue((..snip..)
> > +	if (args->flags & ATTR_KERNOVAL) {
> >   		args->valuelen = args->rmtvaluelen;
> > +		return 0;
> >   	}
> > -	return 0;
> > +	return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);
> 
> With gcc9 I get:
> 
>   CC      fs/xfs/libxfs/xfs_attr_leaf.o
> In function 'xfs_attr_copy_value',
>     inlined from 'xfs_attr3_leaf_getvalue' at fs/xfs/libxfs/xfs_attr_leaf.c:2425:9:
> fs/xfs/libxfs/xfs_attr_leaf.c:421:2: warning: argument 2 null where non-null expected [-Wnonnull]
>   421 |  memcpy(args->value, value, valuelen);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from ./arch/x86/include/asm/string.h:5,
>                  from ./include/linux/string.h:20,
>                  from ./include/linux/uuid.h:12,
>                  from ./fs/xfs/xfs_linux.h:10,
>                  from ./fs/xfs/xfs.h:22,
>                  from fs/xfs/libxfs/xfs_attr_leaf.c:7:
> fs/xfs/libxfs/xfs_attr_leaf.c: In function 'xfs_attr3_leaf_getvalue':
> ./arch/x86/include/asm/string_64.h:14:14: note: in a call to function 'memcpy' declared here
>    14 | extern void *memcpy(void *to, const void *from, size_t len);
>       |              ^~~~~~
> 
> and sure enough, the NULL "value" arg is and passed as-is to memcpy in
> xfs_attr_copy_value.

"sure enough", eh?

> Maybe you meant to sanitize the value when it's NULL?

Nope - look at the code:

        args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
>>>>    args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
        args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
                                               args->rmtvaluelen);
        if (args->flags & ATTR_KERNOVAL) {
                args->valuelen = args->rmtvaluelen;
                return 0;
        }
        return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);
}

And the relevant code in xfs_attr_copy_value() does:

        /* remote block xattr requires IO for copy-in */
>>>>    if (args->rmtblkno)
>>>>            return xfs_attr_rmtval_get(args);

        memcpy(args->value, value, valuelen);
        return 0;
}

The memcpy() is never reached in this case. Hence the compiler
warning is a false positive and the code is not going to crash here.

Regardless, I'm going to have to change the code because I doubt gcc
will ever be smart enough to understand the code flow as it stands.
We have to do this every so often to avoid false positive
uninitialised variable warnings, so it's not like working around
compiler issues is something new.

I'll post an updated version tomorrow....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
